// ==================== Dialogue Seed Script for MongoDB ====================
// Version: 1.0
// Date: 2026-02-04
// Description: Seed lesson dialogue content with multi-language translations
// Run with: mongosh lemonkorean 08_dialogue_seed.js
// ==================================================================================

// Connect to the database (if not already connected)
// use lemonkorean;

// ==================== Lesson 1: Basic Greetings Dialogue ====================
db.lesson_contents.updateOne(
  { lesson_id: 1 },
  {
    $set: {
      lesson_id: 1,
      version: "2.0.0",
      updated_at: new Date(),
      stages: {
        stage2_vocabulary: {
          words: [
            {
              id: 1,
              korean: "안녕하세요",
              translation: { zh: "您好", en: "Hello", ja: "こんにちは", es: "Hola" },
              pronunciation: { zh: "nín hǎo", en: "həˈloʊ", ja: "konnichiwa", es: "ola" },
              audio_url: "/media/audio/vocabulary/hello.mp3",
              image_url: "/media/images/vocabulary/hello.jpg"
            },
            {
              id: 2,
              korean: "감사합니다",
              translation: { zh: "谢谢", en: "Thank you", ja: "ありがとうございます", es: "Gracias" },
              pronunciation: { zh: "xièxie", en: "θæŋk juː", ja: "arigatou gozaimasu", es: "grasjas" },
              audio_url: "/media/audio/vocabulary/thank_you.mp3",
              image_url: "/media/images/vocabulary/thank_you.jpg"
            },
            {
              id: 3,
              korean: "죄송합니다",
              translation: { zh: "对不起", en: "I'm sorry", ja: "すみません", es: "Lo siento" },
              pronunciation: { zh: "duìbuqǐ", en: "aɪm ˈsɒri", ja: "sumimasen", es: "lo sjento" },
              audio_url: "/media/audio/vocabulary/sorry.mp3",
              image_url: "/media/images/vocabulary/sorry.jpg"
            }
          ]
        },
        stage3_grammar: {
          grammar_points: [
            {
              id: 1,
              title: { ko: "은/는", zh: "主题助词", en: "Topic Particle", ja: "主題助詞", es: "Partícula de tema" },
              explanation: {
                zh: "用于标记句子的主题。辅音后用은，元音后用는。",
                en: "Marks the topic of a sentence. Use 은 after consonants, 는 after vowels.",
                ja: "文の主題を表す。子音の後は은、母音の後は는を使う。",
                es: "Marca el tema de una oración. Usa 은 después de consonantes, 는 después de vocales."
              },
              examples: [
                {
                  korean: "저는 학생입니다",
                  translation: { zh: "我是学生", en: "I am a student", ja: "私は学生です", es: "Soy estudiante" },
                  highlight: "는"
                },
                {
                  korean: "책은 재미있어요",
                  translation: { zh: "书很有趣", en: "The book is interesting", ja: "本は面白いです", es: "El libro es interesante" },
                  highlight: "은"
                }
              ]
            }
          ]
        },
        stage4_practice: {
          exercises: [
            {
              type: "multiple_choice",
              question: {
                zh: "选择正确翻译：안녕하세요",
                en: "Choose the correct translation: 안녕하세요",
                ja: "正しい翻訳を選んでください：안녕하세요",
                es: "Elige la traducción correcta: 안녕하세요"
              },
              options: {
                zh: ["您好", "谢谢", "再见", "对不起"],
                en: ["Hello", "Thank you", "Goodbye", "Sorry"],
                ja: ["こんにちは", "ありがとう", "さようなら", "すみません"],
                es: ["Hola", "Gracias", "Adiós", "Lo siento"]
              },
              correct_answer: 0
            },
            {
              type: "fill_blank",
              question: {
                zh: "填空：저___ 학생입니다（我是学生）",
                en: "Fill in the blank: 저___ 학생입니다 (I am a student)",
                ja: "空欄を埋めてください：저___ 학생입니다（私は学生です）",
                es: "Rellena el espacio: 저___ 학생입니다 (Soy estudiante)"
              },
              options: ["은", "는", "이", "가"],
              correct_answer: 1
            }
          ]
        },
        stage5_dialogue: {
          dialogues: [
            {
              id: 1,
              title: { ko: "첫 만남", zh: "初次见面", en: "First Meeting", ja: "初めての出会い", es: "Primer encuentro" },
              speakerA: { name: { zh: "小明", en: "Minho", ja: "ミンホ", es: "Minho" } },
              speakerB: { name: { zh: "小红", en: "Suyeon", ja: "スヨン", es: "Suyeon" } },
              lines: [
                {
                  speaker: "A",
                  korean: "안녕하세요",
                  translation: { zh: "你好", en: "Hello", ja: "こんにちは", es: "Hola" },
                  pronunciation: { zh: "nǐ hǎo", en: "həˈloʊ", ja: "konnichiwa", es: "ola" },
                  audio_url: "/media/audio/dialogue/line1.mp3"
                },
                {
                  speaker: "B",
                  korean: "안녕하세요",
                  translation: { zh: "你好", en: "Hello", ja: "こんにちは", es: "Hola" },
                  pronunciation: { zh: "nǐ hǎo", en: "həˈloʊ", ja: "konnichiwa", es: "ola" },
                  audio_url: "/media/audio/dialogue/line2.mp3"
                },
                {
                  speaker: "A",
                  korean: "저는 민호입니다",
                  translation: { zh: "我叫民浩", en: "I am Minho", ja: "私はミンホです", es: "Soy Minho" },
                  pronunciation: { zh: "wǒ jiào mín hào", en: "aɪ æm ˈmɪnhoʊ", ja: "watashi wa minho desu", es: "soi mino" },
                  audio_url: "/media/audio/dialogue/line3.mp3"
                },
                {
                  speaker: "B",
                  korean: "저는 수연이에요",
                  translation: { zh: "我是秀妍", en: "I am Suyeon", ja: "私はスヨンです", es: "Soy Suyeon" },
                  pronunciation: { zh: "wǒ shì xiù yán", en: "aɪ æm suːˈjʌn", ja: "watashi wa suyon desu", es: "soi suion" },
                  audio_url: "/media/audio/dialogue/line4.mp3"
                },
                {
                  speaker: "A",
                  korean: "반갑습니다",
                  translation: { zh: "很高兴认识你", en: "Nice to meet you", ja: "はじめまして", es: "Encantado de conocerte" },
                  pronunciation: { zh: "hěn gāoxìng rènshi nǐ", en: "naɪs tuː miːt juː", ja: "hajimemashite", es: "enkantaðo de konoθerte" },
                  audio_url: "/media/audio/dialogue/line5.mp3"
                },
                {
                  speaker: "B",
                  korean: "반갑습니다",
                  translation: { zh: "很高兴认识你", en: "Nice to meet you", ja: "はじめまして", es: "Encantado de conocerte" },
                  pronunciation: { zh: "hěn gāoxìng rènshi nǐ", en: "naɪs tuː miːt juː", ja: "hajimemashite", es: "enkantaðo de konoθerte" },
                  audio_url: "/media/audio/dialogue/line6.mp3"
                }
              ]
            }
          ]
        },
        stage6_quiz: {
          questions: [
            {
              type: "vocabulary",
              vocabulary_id: 1,
              question: {
                zh: "选择正确翻译：안녕하세요",
                en: "Choose the correct translation: 안녕하세요",
                ja: "正しい翻訳を選んでください：안녕하세요",
                es: "Elige la traducción correcta: 안녕하세요"
              },
              options: {
                zh: ["您好", "谢谢", "再见", "对不起"],
                en: ["Hello", "Thank you", "Goodbye", "Sorry"],
                ja: ["こんにちは", "ありがとう", "さようなら", "すみません"],
                es: ["Hola", "Gracias", "Adiós", "Lo siento"]
              },
              correct_answer: 0
            },
            {
              type: "vocabulary",
              vocabulary_id: 2,
              question: {
                zh: "选择正确翻译：감사합니다",
                en: "Choose the correct translation: 감사합니다",
                ja: "正しい翻訳を選んでください：감사합니다",
                es: "Elige la traducción correcta: 감사합니다"
              },
              options: {
                zh: ["您好", "谢谢", "再见", "对不起"],
                en: ["Hello", "Thank you", "Goodbye", "Sorry"],
                ja: ["こんにちは", "ありがとう", "さようなら", "すみません"],
                es: ["Hola", "Gracias", "Adiós", "Lo siento"]
              },
              correct_answer: 1
            },
            {
              type: "grammar",
              question: {
                zh: "选择正确的助词：저___ 학생입니다",
                en: "Choose the correct particle: 저___ 학생입니다",
                ja: "正しい助詞を選んでください：저___ 학생입니다",
                es: "Elige la partícula correcta: 저___ 학생입니다"
              },
              options: ["은", "는", "이", "가"],
              correct_answer: 1
            },
            {
              type: "dialogue",
              question: {
                zh: "选择正确翻译：반갑습니다",
                en: "Choose the correct translation: 반갑습니다",
                ja: "正しい翻訳を選んでください：반갑습니다",
                es: "Elige la traducción correcta: 반갑습니다"
              },
              options: {
                zh: ["你好", "谢谢", "很高兴认识你", "对不起"],
                en: ["Hello", "Thank you", "Nice to meet you", "Sorry"],
                ja: ["こんにちは", "ありがとう", "はじめまして", "すみません"],
                es: ["Hola", "Gracias", "Encantado de conocerte", "Lo siento"]
              },
              correct_answer: 2
            }
          ]
        }
      }
    }
  },
  { upsert: true }
);

// ==================== Lesson 2: Self Introduction Dialogue ====================
db.lesson_contents.updateOne(
  { lesson_id: 2 },
  {
    $set: {
      lesson_id: 2,
      version: "2.0.0",
      updated_at: new Date(),
      stages: {
        stage5_dialogue: {
          dialogues: [
            {
              id: 2,
              title: { ko: "자기소개", zh: "自我介绍", en: "Self Introduction", ja: "自己紹介", es: "Autopresentación" },
              speakerA: { name: { zh: "老师", en: "Teacher", ja: "先生", es: "Profesor" } },
              speakerB: { name: { zh: "学生", en: "Student", ja: "学生", es: "Estudiante" } },
              lines: [
                {
                  speaker: "A",
                  korean: "이름이 뭐예요?",
                  translation: { zh: "你叫什么名字？", en: "What is your name?", ja: "お名前は何ですか？", es: "¿Cómo te llamas?" },
                  audio_url: "/media/audio/dialogue/lesson2_line1.mp3"
                },
                {
                  speaker: "B",
                  korean: "저는 민수예요",
                  translation: { zh: "我叫民秀", en: "I am Minsu", ja: "私はミンスです", es: "Soy Minsu" },
                  audio_url: "/media/audio/dialogue/lesson2_line2.mp3"
                },
                {
                  speaker: "A",
                  korean: "학생이에요?",
                  translation: { zh: "你是学生吗？", en: "Are you a student?", ja: "学生ですか？", es: "¿Eres estudiante?" },
                  audio_url: "/media/audio/dialogue/lesson2_line3.mp3"
                },
                {
                  speaker: "B",
                  korean: "네, 학생이에요",
                  translation: { zh: "是的，我是学生", en: "Yes, I am a student", ja: "はい、学生です", es: "Sí, soy estudiante" },
                  audio_url: "/media/audio/dialogue/lesson2_line4.mp3"
                }
              ]
            }
          ]
        }
      }
    }
  },
  { upsert: true }
);

print("==================== Dialogue Seed Complete ====================");
print("Lesson 1: Basic Greetings - All stages populated");
print("Lesson 2: Self Introduction - Dialogue stage populated");
print("================================================================");
