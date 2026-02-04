const { query } = require('../config/database');
const { collections } = require('../config/mongodb');
const { getFallbackChain } = require('../middleware/language.middleware');

class Lesson {
  /**
   * Get all lessons with translations (metadata from PostgreSQL + vocabulary count from MongoDB)
   * @param {Object} filters - Filter options including language
   * @returns {Array} Lessons array with localized content
   */
  static async findAll(filters = {}) {
    const { level, status, limit = 100, offset = 0, language = 'zh' } = filters;

    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    let sql = `
      SELECT l.id, l.level, l.week, l.order_num,
             l.title_ko,
             COALESCE(lt.title, l.title_ko) as title,
             COALESCE(lt.description, l.description_ko) as description,
             l.duration_minutes, l.difficulty,
             l.thumbnail_url, l.version, l.status, l.published_at, l.view_count, l.completion_count,
             l.tags, l.created_at, l.updated_at,
             l.duration_minutes as estimated_minutes,
             COALESCE(lt.language_code, '${language}') as content_language
      FROM lessons l
      LEFT JOIN LATERAL (
        SELECT title, description, language_code
        FROM lesson_translations
        WHERE lesson_id = l.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) lt ON true
      WHERE 1=1
    `;

    const params = [];
    let paramCount = 1;

    if (level) {
      sql += ` AND l.level = $${paramCount}`;
      params.push(level);
      paramCount++;
    }

    if (status) {
      sql += ` AND l.status = $${paramCount}`;
      params.push(status);
      paramCount++;
    } else {
      // Default: only published lessons
      sql += ` AND l.status = 'published'`;
    }

    sql += ` ORDER BY l.level, l.week, l.order_num`;
    sql += ` LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(limit, offset);

    const result = await query(sql, params);
    const lessons = result.rows;

    // Get vocabulary counts from MongoDB content for all lessons
    try {
      const collection = collections.lessonsContent();
      const lessonIds = lessons.map(l => l.id);
      const contents = await collection.find({ lesson_id: { $in: lessonIds } }).toArray();

      // Create a map of lesson_id -> vocabulary_count
      const vocabCounts = {};
      for (const content of contents) {
        let count = 0;
        if (content.content?.stages) {
          const vocabStage = content.content.stages.find(s => s.type === 'vocabulary');
          if (vocabStage?.data?.words) {
            count = vocabStage.data.words.length;
          }
        }
        vocabCounts[content.lesson_id] = count;
      }

      // Add vocabulary_count to each lesson
      for (const lesson of lessons) {
        lesson.vocabulary_count = vocabCounts[lesson.id] || 0;
      }
    } catch (mongoError) {
      console.error('Error fetching vocabulary counts from MongoDB:', mongoError);
      // Set vocabulary_count to 0 for all lessons if MongoDB fails
      for (const lesson of lessons) {
        lesson.vocabulary_count = 0;
      }
    }

    return lessons;
  }

  /**
   * Get lesson by ID with translations (metadata from PostgreSQL)
   * @param {Number} id - Lesson ID
   * @param {String} language - Language code (default: 'zh')
   * @returns {Object|null} Lesson object with localized content
   */
  static async findById(id, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT l.id, l.level, l.week, l.order_num,
             l.title_ko,
             COALESCE(lt.title, l.title_ko) as title,
             COALESCE(lt.description, l.description_ko) as description,
             l.duration_minutes, l.difficulty,
             l.thumbnail_url, l.version, l.status, l.published_at, l.view_count, l.completion_count,
             l.prerequisites, l.tags, l.created_at, l.updated_at,
             COALESCE(lt.language_code, '${language}') as content_language
      FROM lessons l
      LEFT JOIN LATERAL (
        SELECT title, description, language_code
        FROM lesson_translations
        WHERE lesson_id = l.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) lt ON true
      WHERE l.id = $1
    `;

    const result = await query(sql, [id]);
    return result.rows[0] || null;
  }

  /**
   * Get lesson content (from MongoDB)
   * @param {Number} lessonId - Lesson ID
   * @returns {Object|null} Lesson content
   */
  static async findContentById(lessonId) {
    try {
      const collection = collections.lessonsContent();
      const content = await collection.findOne({ lesson_id: lessonId });
      return content;
    } catch (error) {
      console.error('Error fetching lesson content:', error);
      throw error;
    }
  }

  /**
   * Get lessons by level with translations
   * @param {Number} level - TOPIK level (1-6)
   * @param {String} language - Language code (default: 'zh')
   * @returns {Array} Lessons array with localized content
   */
  static async findByLevel(level, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT l.id, l.level, l.week, l.order_num, l.title_ko,
             COALESCE(lt.title, l.title_zh) as title,
             l.duration_minutes, l.difficulty, l.thumbnail_url, l.status,
             l.duration_minutes as estimated_minutes,
             COALESCE(lt.language_code, 'zh') as content_language
      FROM lessons l
      LEFT JOIN LATERAL (
        SELECT title, language_code
        FROM lesson_translations
        WHERE lesson_id = l.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) lt ON true
      WHERE l.level = $1 AND l.status = 'published'
      ORDER BY l.week, l.order_num
    `;

    const result = await query(sql, [level]);
    const lessons = result.rows;

    // Get vocabulary counts from MongoDB content
    try {
      const collection = collections.lessonsContent();
      const lessonIds = lessons.map(l => l.id);
      const contents = await collection.find({ lesson_id: { $in: lessonIds } }).toArray();

      const vocabCounts = {};
      for (const content of contents) {
        let count = 0;
        if (content.content?.stages) {
          const vocabStage = content.content.stages.find(s => s.type === 'vocabulary');
          if (vocabStage?.data?.words) {
            count = vocabStage.data.words.length;
          }
        }
        vocabCounts[content.lesson_id] = count;
      }

      for (const lesson of lessons) {
        lesson.vocabulary_count = vocabCounts[lesson.id] || 0;
      }
    } catch (mongoError) {
      console.error('Error fetching vocabulary counts from MongoDB:', mongoError);
      for (const lesson of lessons) {
        lesson.vocabulary_count = 0;
      }
    }

    return lessons;
  }

  /**
   * Increment view count
   * @param {Number} id - Lesson ID
   */
  static async incrementViewCount(id) {
    const sql = `
      UPDATE lessons
      SET view_count = view_count + 1
      WHERE id = $1
    `;

    await query(sql, [id]);
  }

  /**
   * Get lesson vocabulary with translations
   * @param {Number} lessonId - Lesson ID
   * @param {String} language - Language code (default: 'zh')
   * @returns {Array} Vocabulary array with localized content
   */
  static async getVocabulary(lessonId, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT v.id, v.korean, v.hanja,
             COALESCE(vt.translation, v.chinese) as translation,
             COALESCE(vt.pronunciation, v.pinyin) as pronunciation,
             v.part_of_speech, v.level, v.similarity_score,
             v.image_url, v.audio_url_male, v.audio_url_female,
             lv.is_primary, lv.display_order,
             COALESCE(vt.language_code, 'zh') as content_language
      FROM vocabulary v
      INNER JOIN lesson_vocabulary lv ON v.id = lv.vocab_id
      LEFT JOIN LATERAL (
        SELECT translation, pronunciation, language_code
        FROM vocabulary_translations
        WHERE vocabulary_id = v.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) vt ON true
      WHERE lv.lesson_id = $1
      ORDER BY lv.display_order, lv.is_primary DESC
    `;

    const result = await query(sql, [lessonId]);
    return result.rows;
  }

  /**
   * Get lesson grammar rules with translations
   * @param {Number} lessonId - Lesson ID
   * @param {String} language - Language code (default: 'zh')
   * @returns {Array} Grammar rules array with localized content
   */
  static async getGrammar(lessonId, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT g.id, g.name_ko,
             COALESCE(gt.name, g.name_zh) as name,
             g.category, g.level, g.difficulty,
             COALESCE(gt.description, g.description) as description,
             COALESCE(gt.language_comparison, g.chinese_comparison) as language_comparison,
             g.examples,
             lg.is_primary, lg.display_order,
             COALESCE(gt.language_code, 'zh') as content_language
      FROM grammar_rules g
      INNER JOIN lesson_grammar lg ON g.id = lg.grammar_id
      LEFT JOIN LATERAL (
        SELECT name, description, language_comparison, language_code
        FROM grammar_translations
        WHERE grammar_id = g.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) gt ON true
      WHERE lg.lesson_id = $1
      ORDER BY lg.display_order, lg.is_primary DESC
    `;

    const result = await query(sql, [lessonId]);
    return result.rows;
  }

  /**
   * Check for updates
   * @param {Array} lessonVersions - Array of {id, version}
   * @returns {Array} Lessons that need updates
   */
  static async checkForUpdates(lessonVersions) {
    if (!lessonVersions || lessonVersions.length === 0) {
      return [];
    }

    const ids = lessonVersions.map(lv => lv.id);
    const sql = `
      SELECT id, version, updated_at
      FROM lessons
      WHERE id = ANY($1)
    `;

    const result = await query(sql, [ids]);

    // Filter lessons that have been updated
    const updates = [];
    for (const serverLesson of result.rows) {
      const clientVersion = lessonVersions.find(lv => lv.id === serverLesson.id);
      if (clientVersion && clientVersion.version !== serverLesson.version) {
        updates.push({
          id: serverLesson.id,
          oldVersion: clientVersion.version,
          newVersion: serverLesson.version,
          updatedAt: serverLesson.updated_at
        });
      }
    }

    return updates;
  }
}

module.exports = Lesson;
