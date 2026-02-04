const { Pool } = require('pg');
const { MongoClient } = require('mongodb');

// PostgreSQL configuration
const pgConfig = {
  host: process.env.DB_HOST || 'postgres',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || '3chan',
  password: process.env.DB_PASSWORD || 'Scott122001&&',
  database: process.env.DB_NAME || 'lemon_korean'
};

// MongoDB configuration
const mongoUrl = process.env.MONGO_URL || 'mongodb://3chan:Scott122001&&@mongo:27017/lemon_korean?authSource=admin';
const mongoDbName = 'lemon_korean';

async function generateLessonContent() {
  const pgClient = new Pool(pgConfig);
  let mongoClient;

  try {
    console.log('Connecting to PostgreSQL...');
    await pgClient.query('SELECT 1');
    console.log('PostgreSQL connected');

    console.log('Connecting to MongoDB...');
    mongoClient = await MongoClient.connect(mongoUrl);
    const db = mongoClient.db(mongoDbName);
    const lessonsContentCollection = db.collection('lessons_content');
    console.log('MongoDB connected');

    // Get all published lessons
    const lessonsResult = await pgClient.query(`
      SELECT id, title_ko, description_ko
      FROM lessons
      WHERE status = 'published'
      ORDER BY id
    `);

    console.log(`Found ${lessonsResult.rows.length} published lessons`);

    for (const lesson of lessonsResult.rows) {
      const lessonId = lesson.id;
      console.log(`\nProcessing Lesson ${lessonId}: ${lesson.title_ko}`);

      // Check if content already exists
      const existing = await lessonsContentCollection.findOne({ lesson_id: lessonId });
      if (existing) {
        console.log(`  ✓ Content already exists, skipping`);
        continue;
      }

      // Get vocabulary for this lesson
      const vocabResult = await pgClient.query(`
        SELECT v.id, v.korean, v.part_of_speech, v.hanja,
               vt_zh.translation as text_zh,
               vt_en.translation as text_en,
               vt_ja.translation as text_ja,
               vt_es.translation as text_es,
               vt_zh_tw.translation as text_zh_tw
        FROM lesson_vocabulary lv
        JOIN vocabulary v ON lv.vocab_id = v.id
        LEFT JOIN vocabulary_translations vt_zh ON v.id = vt_zh.vocabulary_id AND vt_zh.language_code = 'zh'
        LEFT JOIN vocabulary_translations vt_en ON v.id = vt_en.vocabulary_id AND vt_en.language_code = 'en'
        LEFT JOIN vocabulary_translations vt_ja ON v.id = vt_ja.vocabulary_id AND vt_ja.language_code = 'ja'
        LEFT JOIN vocabulary_translations vt_es ON v.id = vt_es.vocabulary_id AND vt_es.language_code = 'es'
        LEFT JOIN vocabulary_translations vt_zh_tw ON v.id = vt_zh_tw.vocabulary_id AND vt_zh_tw.language_code = 'zh_TW'
        WHERE lv.lesson_id = $1
        ORDER BY lv.display_order
      `, [lessonId]);

      console.log(`  Found ${vocabResult.rows.length} vocabulary words`);

      // Build vocabulary words array
      const words = vocabResult.rows.map(v => ({
        korean: v.korean,
        chinese: v.text_zh || v.korean,
        english: v.text_en || null,
        japanese: v.text_ja || null,
        spanish: v.text_es || null,
        traditional_chinese: v.text_zh_tw || null,
        pinyin: null, // Not available in current schema
        hanja: v.hanja || null,
        image_url: null,
        audio_url: null,
        part_of_speech: v.part_of_speech || 'noun'
      }));

      // Generate timestamp for stage IDs
      const timestamp = Date.now();

      // Create 7-stage content structure
      const content = {
        lesson_id: lessonId,
        version: "2.0.0",
        content: {
          stages: [
            // Stage 0: Intro
            {
              id: `stage_${timestamp}_0`,
              type: "intro",
              order: 0,
              data: {
                title: lesson.title_ko,
                description: lesson.description_ko || `${lesson.title_ko}를 배워봅시다.`,
                image_url: null,
                audio_url: null
              }
            },
            // Stage 1: Vocabulary
            {
              id: `stage_${timestamp}_1`,
              type: "vocabulary",
              order: 1,
              data: {
                words: words
              }
            },
            // Stage 2: Grammar (empty for now since grammar_rules table is empty)
            {
              id: `stage_${timestamp}_2`,
              type: "grammar",
              order: 2,
              data: {
                rules: []
              }
            },
            // Stage 3: Practice (basic fill-in-the-blank exercises)
            {
              id: `stage_${timestamp}_3`,
              type: "practice",
              order: 3,
              data: {
                exercises: words.length >= 2 ? [
                  {
                    question: `'${words[0].korean}'의 뜻은 무엇입니까?`,
                    options: [
                      words[0].chinese,
                      words[1] ? words[1].chinese : "선택지 2",
                      words[2] ? words[2].chinese : "선택지 3",
                      "모르겠습니다"
                    ],
                    correct_answer: 0
                  },
                  {
                    question: words[1] ? `'${words[1].korean}'의 뜻은 무엇입니까?` : "연습 문제",
                    options: [
                      "선택지 1",
                      words[1] ? words[1].chinese : "정답",
                      words[0] ? words[0].chinese : "선택지 3",
                      "모르겠습니다"
                    ],
                    correct_answer: 1
                  }
                ] : []
              }
            },
            // Stage 4: Dialogue (simple 2-person conversation)
            {
              id: `stage_${timestamp}_4`,
              type: "dialogue",
              order: 4,
              data: {
                dialogues: words.length >= 1 ? [
                  {
                    speaker: "A",
                    text_ko: words[0] ? `${words[0].korean}은(는) 무엇입니까?` : "안녕하세요?",
                    text_zh: words[0] ? `${words[0].chinese}是什么？` : "你好。",
                    audio_url: null
                  },
                  {
                    speaker: "B",
                    text_ko: words[0] ? `${words[0].korean}입니다.` : "안녕하세요. 만나서 반갑습니다.",
                    text_zh: words[0] ? `是${words[0].chinese}。` : "你好。很高兴见到你。",
                    audio_url: null
                  }
                ] : [
                  {
                    speaker: "A",
                    text_ko: "안녕하세요?",
                    text_zh: "你好。",
                    audio_url: null
                  },
                  {
                    speaker: "B",
                    text_ko: "안녕하세요. 만나서 반갑습니다.",
                    text_zh: "你好。很高兴见到你。",
                    audio_url: null
                  }
                ]
              }
            },
            // Stage 5: Quiz (vocabulary quiz)
            {
              id: `stage_${timestamp}_5`,
              type: "quiz",
              order: 5,
              data: {
                questions: words.length >= 3 ? [
                  {
                    question: `'${words[0].korean}'의 중국어는?`,
                    options: [
                      words[0].chinese,
                      words[1] ? words[1].chinese : "선택지 2",
                      words[2] ? words[2].chinese : "선택지 3",
                      "모르겠습니다"
                    ],
                    correct_answer: 0
                  },
                  {
                    question: `'${words[1] ? words[1].chinese : "단어"}'의 한국어는?`,
                    options: [
                      words[0] ? words[0].korean : "선택지 1",
                      words[1] ? words[1].korean : "정답",
                      words[2] ? words[2].korean : "선택지 3",
                      "모르겠습니다"
                    ],
                    correct_answer: 1
                  },
                  {
                    question: words[2] ? `다음 중 '${words[2].chinese}'은(는)?` : "퀴즈 3",
                    options: [
                      words[0] ? words[0].korean : "선택지 1",
                      words[1] ? words[1].korean : "선택지 2",
                      words[2] ? words[2].korean : "정답",
                      "모르겠습니다"
                    ],
                    correct_answer: 2
                  }
                ] : []
              }
            },
            // Stage 6: Summary
            {
              id: `stage_${timestamp}_6`,
              type: "summary",
              order: 6,
              data: {
                summary_text: `이번 레슨에서는 "${lesson.title_ko}"에 관한 ${words.length}개의 단어를 배웠습니다.`,
                review_points: [
                  `${words.length}개의 새로운 단어`,
                  "기본 회화 표현",
                  "연습 문제"
                ]
              }
            }
          ]
        },
        updated_at: new Date()
      };

      // Insert into MongoDB
      await lessonsContentCollection.insertOne(content);
      console.log(`  ✓ Content created with ${words.length} words`);
    }

    // Summary
    const totalCount = await lessonsContentCollection.countDocuments();
    console.log(`\n${'='.repeat(70)}`);
    console.log(`MongoDB Lesson Content Generation Complete`);
    console.log(`Total lessons with content: ${totalCount}`);
    console.log(`${'='.repeat(70)}`);

  } catch (error) {
    console.error('Error:', error);
    throw error;
  } finally {
    await pgClient.end();
    if (mongoClient) {
      await mongoClient.close();
    }
  }
}

// Run the script
generateLessonContent()
  .then(() => {
    console.log('\n✓ Script completed successfully');
    process.exit(0);
  })
  .catch(error => {
    console.error('\n✗ Script failed:', error);
    process.exit(1);
  });
