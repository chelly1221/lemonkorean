const crypto = require('crypto');
const archiver = require('archiver');
const Lesson = require('../models/lesson.model');

/**
 * ================================================================
 * LESSON PACKAGER SERVICE
 * ================================================================
 * Creates downloadable lesson packages with content and media URLs
 * Supports ZIP archives, checksum validation, and media URL generation
 * ================================================================
 */

// Media Service configuration
const MEDIA_SERVICE_BASE_URL = process.env.MEDIA_SERVICE_URL || 'http://media-service:3004';

class LessonPackagerService {
  /**
   * ================================================================
   * Create a complete lesson download package
   * ================================================================
   * @param {Number} lessonId - Lesson ID
   * @returns {Object} Complete package with metadata, content, media URLs, checksum
   */
  static async createPackage(lessonId) {
    try {
      console.log(`[PACKAGER] Creating package for lesson ${lessonId}`);

      // 1. Get lesson metadata from PostgreSQL
      const lesson = await Lesson.findById(lessonId);
      if (!lesson) {
        throw new Error(`Lesson ${lessonId} not found`);
      }

      if (lesson.status !== 'published') {
        throw new Error(`Lesson ${lessonId} is not published (status: ${lesson.status})`);
      }

      // 2. Get lesson content from MongoDB
      const contentDoc = await Lesson.findContentById(lessonId);
      if (!contentDoc) {
        throw new Error(`Content for lesson ${lessonId} not found in MongoDB`);
      }

      // 3. Get vocabulary for this lesson (parallel fetch)
      // 4. Get grammar rules for this lesson (parallel fetch)
      const [vocabulary, grammar] = await Promise.all([
        Lesson.getVocabulary(lessonId),
        Lesson.getGrammar(lessonId)
      ]);

      console.log(`[PACKAGER] Lesson ${lessonId}: ${vocabulary.length} vocab, ${grammar.length} grammar rules`);

      // 5. Extract and generate media URLs
      const mediaUrls = this.extractAndGenerateMediaUrls(contentDoc, vocabulary, lesson);

      // 6. Build lesson package
      const packageData = {
        lesson_id: lesson.id,
        version: lesson.version,

        metadata: {
          level: lesson.level,
          week: lesson.week,
          order_num: lesson.order_num,
          title_ko: lesson.title_ko,
          title_zh: lesson.title_zh,
          description_ko: lesson.description_ko,
          description_zh: lesson.description_zh,
          duration_minutes: lesson.duration_minutes,
          difficulty: lesson.difficulty,
          thumbnail_url: this.generateMediaUrl('images', lesson.thumbnail_url),
          prerequisites: lesson.prerequisites,
          tags: lesson.tags,
          published_at: lesson.published_at,
          updated_at: lesson.updated_at
        },

        content: contentDoc.content || {},

        vocabulary: vocabulary.map(v => ({
          id: v.id,
          korean: v.korean,
          hanja: v.hanja,
          chinese: v.chinese,
          pinyin: v.pinyin,
          part_of_speech: v.part_of_speech,
          similarity_score: v.similarity_score,
          example_sentence_ko: v.example_sentence_ko,
          example_sentence_zh: v.example_sentence_zh,
          image_url: this.generateMediaUrl('images', v.image_url),
          audio_url_male: this.generateMediaUrl('audio', v.audio_url_male),
          audio_url_female: this.generateMediaUrl('audio', v.audio_url_female),
          is_primary: v.is_primary
        })),

        grammar: grammar.map(g => ({
          id: g.id,
          name_ko: g.name_ko,
          name_zh: g.name_zh,
          category: g.category,
          difficulty: g.difficulty,
          description: g.description,
          chinese_comparison: g.chinese_comparison,
          examples: g.examples,
          usage_notes: g.usage_notes,
          is_primary: g.is_primary
        })),

        media_urls: mediaUrls
      };

      console.log(`[PACKAGER] Package created for lesson ${lessonId}, ${Object.keys(mediaUrls).length} media files`);

      return packageData;

    } catch (error) {
      console.error(`[PACKAGER] Error creating package for lesson ${lessonId}:`, error);
      throw error;
    }
  }

  /**
   * ================================================================
   * Extract media files and generate URLs via Media Service
   * ================================================================
   * @param {Object} contentDoc - Lesson content from MongoDB
   * @param {Array} vocabulary - Vocabulary array
   * @param {Object} lesson - Lesson metadata
   * @returns {Object} Media URLs mapping {path: full_url}
   */
  static extractAndGenerateMediaUrls(contentDoc, vocabulary, lesson) {
    const mediaUrls = {};

    // 1. Extract from content.media_manifest (MongoDB)
    if (contentDoc.content?.media_manifest && Array.isArray(contentDoc.content.media_manifest)) {
      contentDoc.content.media_manifest.forEach(media => {
        if (media.path && media.key) {
          // Generate Media Service URL
          const mediaType = media.type || 'images'; // images, audio, video
          mediaUrls[media.path] = this.generateMediaUrl(mediaType, media.key);
        }
      });
    }

    // 2. Extract from lesson thumbnail
    if (lesson.thumbnail_url) {
      const thumbnailKey = `lessons/lesson_${lesson.id}_thumb.jpg`;
      mediaUrls[thumbnailKey] = this.generateMediaUrl('images', lesson.thumbnail_url);
    }

    // 3. Extract from vocabulary
    vocabulary.forEach(v => {
      // Vocabulary images
      if (v.image_url) {
        const key = `images/vocab_${v.id}.jpg`;
        mediaUrls[key] = this.generateMediaUrl('images', v.image_url);
      }

      // Vocabulary audio (male voice)
      if (v.audio_url_male) {
        const key = `audio/vocab_${v.id}_male.mp3`;
        mediaUrls[key] = this.generateMediaUrl('audio', v.audio_url_male);
      }

      // Vocabulary audio (female voice)
      if (v.audio_url_female) {
        const key = `audio/vocab_${v.id}_female.mp3`;
        mediaUrls[key] = this.generateMediaUrl('audio', v.audio_url_female);
      }
    });

    // 4. Extract additional media from content stages
    if (contentDoc.content) {
      this.extractMediaFromStages(contentDoc.content, mediaUrls);
    }

    console.log(`[PACKAGER] Extracted ${Object.keys(mediaUrls).length} media files`);

    return mediaUrls;
  }

  /**
   * ================================================================
   * Generate Media Service URL from media key
   * ================================================================
   * @param {String} mediaType - Type of media (images, audio, video)
   * @param {String} mediaKey - Media file key or URL
   * @returns {String} Full Media Service URL
   */
  static generateMediaUrl(mediaType, mediaKey) {
    // If already a full URL, return as-is
    if (!mediaKey) return null;
    if (mediaKey.startsWith('http://') || mediaKey.startsWith('https://')) {
      return mediaKey;
    }

    // Generate Media Service URL
    // Format: http://media-service:3004/media/{type}/{key}
    return `${MEDIA_SERVICE_BASE_URL}/media/${mediaType}/${mediaKey}`;
  }

  /**
   * ================================================================
   * Extract media from lesson content stages
   * ================================================================
   * @param {Object} content - Lesson content object
   * @param {Object} mediaUrls - Media URLs object (mutated)
   */
  static extractMediaFromStages(content, mediaUrls) {
    const stages = [
      'stage1_intro',
      'stage2_vocabulary',
      'stage3_grammar',
      'stage4_practice',
      'stage5_dialogue',
      'stage6_quiz',
      'stage7_summary'
    ];

    stages.forEach(stageName => {
      const stage = content[stageName];
      if (!stage) return;

      // Extract images
      if (stage.images && Array.isArray(stage.images)) {
        stage.images.forEach((img, idx) => {
          if (img.url || img.key) {
            const key = `images/stage_${stageName}_${idx}.jpg`;
            mediaUrls[key] = this.generateMediaUrl('images', img.url || img.key);
          }
        });
      }

      // Extract audio
      if (stage.audio && Array.isArray(stage.audio)) {
        stage.audio.forEach((audio, idx) => {
          if (audio.url || audio.key) {
            const key = `audio/stage_${stageName}_${idx}.mp3`;
            mediaUrls[key] = this.generateMediaUrl('audio', audio.url || audio.key);
          }
        });
      }

      // Extract video
      if (stage.video && Array.isArray(stage.video)) {
        stage.video.forEach((video, idx) => {
          if (video.url || video.key) {
            const key = `video/stage_${stageName}_${idx}.mp4`;
            mediaUrls[key] = this.generateMediaUrl('video', video.url || video.key);
          }
        });
      }
    });
  }

  /**
   * ================================================================
   * Calculate checksum for package data
   * ================================================================
   * @param {Object} packageData - Package data
   * @param {String} algorithm - Hash algorithm (md5, sha256)
   * @returns {String} Checksum hash
   */
  static calculateChecksum(packageData, algorithm = 'md5') {
    const jsonString = JSON.stringify(packageData);
    return crypto.createHash(algorithm).update(jsonString).digest('hex');
  }

  /**
   * ================================================================
   * Create ZIP archive stream for download
   * ================================================================
   * Used with Express response stream for direct download
   * @param {Object} packageData - Package data
   * @returns {Stream} ZIP archive stream
   */
  static createArchiveStream(packageData) {
    const archive = archiver('zip', {
      zlib: { level: 9 } // Maximum compression
    });

    console.log(`[PACKAGER] Creating ZIP archive for lesson ${packageData.lesson_id}`);

    // Add complete package as single JSON
    archive.append(JSON.stringify(packageData, null, 2), {
      name: 'package.json'
    });

    // Add individual components (for easier parsing)
    archive.append(JSON.stringify(packageData.metadata, null, 2), {
      name: 'metadata.json'
    });

    archive.append(JSON.stringify(packageData.content, null, 2), {
      name: 'content.json'
    });

    archive.append(JSON.stringify(packageData.vocabulary, null, 2), {
      name: 'vocabulary.json'
    });

    archive.append(JSON.stringify(packageData.grammar, null, 2), {
      name: 'grammar.json'
    });

    archive.append(JSON.stringify(packageData.media_urls, null, 2), {
      name: 'media_urls.json'
    });

    // Add README with package info
    const readme = this.generateReadme(packageData);
    archive.append(readme, {
      name: 'README.txt'
    });

    // Finalize archive (no more files will be added)
    archive.finalize();

    return archive;
  }

  /**
   * ================================================================
   * Estimate package size in bytes
   * ================================================================
   * @param {Object} packageData - Package data
   * @returns {Number} Size in bytes (approximate)
   */
  static estimatePackageSize(packageData) {
    const jsonString = JSON.stringify(packageData);
    const sizeInBytes = Buffer.byteLength(jsonString, 'utf8');

    console.log(`[PACKAGER] Estimated package size: ${(sizeInBytes / 1024).toFixed(2)} KB`);

    return sizeInBytes;
  }

  /**
   * ================================================================
   * Create lightweight package (metadata only)
   * ================================================================
   * Used for lesson lists without full content
   * @param {Number} lessonId - Lesson ID
   * @returns {Object} Lightweight package
   */
  static async createLightweightPackage(lessonId) {
    try {
      console.log(`[PACKAGER] Creating lightweight package for lesson ${lessonId}`);

      const lesson = await Lesson.findById(lessonId);
      if (!lesson) {
        throw new Error(`Lesson ${lessonId} not found`);
      }

      return {
        lesson_id: lesson.id,
        version: lesson.version,
        status: lesson.status,
        metadata: {
          level: lesson.level,
          week: lesson.week,
          order_num: lesson.order_num,
          title_ko: lesson.title_ko,
          title_zh: lesson.title_zh,
          description_ko: lesson.description_ko,
          description_zh: lesson.description_zh,
          duration_minutes: lesson.duration_minutes,
          difficulty: lesson.difficulty,
          thumbnail_url: this.generateMediaUrl('images', lesson.thumbnail_url),
          tags: lesson.tags
        },
        download_url: `/api/content/lessons/${lessonId}/download`,
        package_url: `/api/content/lessons/${lessonId}/package`,
        updated_at: lesson.updated_at
      };

    } catch (error) {
      console.error(`[PACKAGER] Error creating lightweight package:`, error);
      throw error;
    }
  }

  /**
   * ================================================================
   * Generate README file for package
   * ================================================================
   * @param {Object} packageData - Package data
   * @returns {String} README content
   */
  static generateReadme(packageData) {
    const metadata = packageData.metadata;

    return `
=================================================================
柠檬韩语 (Lemon Korean) - Lesson Package
=================================================================

Lesson ID: ${packageData.lesson_id}
Version: ${packageData.version}
Level: ${metadata.level}
Title (Korean): ${metadata.title_ko}
Title (Chinese): ${metadata.title_zh}

=================================================================
Package Contents
=================================================================

- package.json       : Complete lesson package
- metadata.json      : Lesson metadata
- content.json       : Lesson content (7 stages)
- vocabulary.json    : Vocabulary list (${packageData.vocabulary.length} words)
- grammar.json       : Grammar rules (${packageData.grammar.length} rules)
- media_urls.json    : Media file URLs (${Object.keys(packageData.media_urls).length} files)

=================================================================
Media Files
=================================================================

All media files are referenced via URLs in media_urls.json.
Download media files separately from the Media Service.

Media Service Base URL: ${MEDIA_SERVICE_BASE_URL}

=================================================================
Usage
=================================================================

1. Extract this ZIP file
2. Load package.json in your application
3. Download media files using URLs from media_urls.json
4. Cache content locally for offline usage

=================================================================
柠檬韩语 - Learn Korean the Smart Way
https://lemonkorean.com
=================================================================
`.trim();
  }

  /**
   * ================================================================
   * Validate package integrity
   * ================================================================
   * @param {Object} packageData - Package data
   * @param {String} expectedChecksum - Expected checksum
   * @param {String} algorithm - Hash algorithm (md5, sha256)
   * @returns {Boolean} True if valid
   */
  static validatePackage(packageData, expectedChecksum, algorithm = 'md5') {
    const actualChecksum = this.calculateChecksum(packageData, algorithm);
    const isValid = actualChecksum === expectedChecksum;

    if (!isValid) {
      console.error(`[PACKAGER] Checksum mismatch! Expected: ${expectedChecksum}, Got: ${actualChecksum}`);
    }

    return isValid;
  }
}

/**
 * ================================================================
 * EXPORTS
 * ================================================================
 */
module.exports = LessonPackagerService;

module.exports = LessonPackagerService;
