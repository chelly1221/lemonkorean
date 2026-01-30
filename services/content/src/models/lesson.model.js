const { query } = require('../config/database');
const { collections } = require('../config/mongodb');

class Lesson {
  /**
   * Get all lessons (metadata from PostgreSQL + vocabulary count from MongoDB)
   * @param {Object} filters - Filter options
   * @returns {Array} Lessons array
   */
  static async findAll(filters = {}) {
    const { level, status, limit = 100, offset = 0 } = filters;

    let sql = `
      SELECT l.id, l.level, l.week, l.order_num, l.title_ko, l.title_zh,
             l.description_ko, l.description_zh, l.duration_minutes, l.difficulty,
             l.thumbnail_url, l.version, l.status, l.published_at, l.view_count, l.completion_count,
             l.tags, l.created_at, l.updated_at,
             l.duration_minutes as estimated_minutes
      FROM lessons l
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
   * Get lesson by ID (metadata from PostgreSQL)
   * @param {Number} id - Lesson ID
   * @returns {Object|null} Lesson object
   */
  static async findById(id) {
    const sql = `
      SELECT id, level, week, order_num, title_ko, title_zh,
             description_ko, description_zh, duration_minutes, difficulty,
             thumbnail_url, version, status, published_at, view_count, completion_count,
             prerequisites, tags, created_at, updated_at
      FROM lessons
      WHERE id = $1
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
   * Get lessons by level
   * @param {Number} level - TOPIK level (1-6)
   * @returns {Array} Lessons array
   */
  static async findByLevel(level) {
    const sql = `
      SELECT l.id, l.level, l.week, l.order_num, l.title_ko, l.title_zh,
             l.duration_minutes, l.difficulty, l.thumbnail_url, l.status,
             l.duration_minutes as estimated_minutes
      FROM lessons l
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
   * Get lesson vocabulary
   * @param {Number} lessonId - Lesson ID
   * @returns {Array} Vocabulary array
   */
  static async getVocabulary(lessonId) {
    const sql = `
      SELECT v.id, v.korean, v.hanja, v.chinese, v.pinyin,
             v.part_of_speech, v.level, v.similarity_score,
             v.image_url, v.audio_url_male, v.audio_url_female,
             lv.is_primary, lv.display_order
      FROM vocabulary v
      INNER JOIN lesson_vocabulary lv ON v.id = lv.vocab_id
      WHERE lv.lesson_id = $1
      ORDER BY lv.display_order, lv.is_primary DESC
    `;

    const result = await query(sql, [lessonId]);
    return result.rows;
  }

  /**
   * Get lesson grammar rules
   * @param {Number} lessonId - Lesson ID
   * @returns {Array} Grammar rules array
   */
  static async getGrammar(lessonId) {
    const sql = `
      SELECT g.id, g.name_ko, g.name_zh, g.category, g.level,
             g.difficulty, g.description, g.chinese_comparison, g.examples,
             lg.is_primary, lg.display_order
      FROM grammar_rules g
      INNER JOIN lesson_grammar lg ON g.id = lg.grammar_id
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
