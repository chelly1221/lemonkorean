const contentService = require('../services/content-management.service');
const xlsx = require('xlsx');

/**
 * Vocabulary Controller
 * Handles HTTP requests for vocabulary management
 */

/**
 * GET /api/admin/vocabulary
 * List all vocabulary with pagination and filtering
 */
const listVocabulary = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 50,
      search = '',
      sortBy = 'id',
      sortOrder = 'ASC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: Math.min(parseInt(limit), 200),
      search,
      sortBy,
      sortOrder: sortOrder.toUpperCase()
    };

    const result = await contentService.listVocabulary(options);

    res.json({
      success: true,
      data: result.vocabulary,
      pagination: {
        page: result.page,
        limit: result.limit,
        total: result.total,
        totalPages: result.totalPages
      }
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error listing vocabulary:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/vocabulary/:id
 * Get vocabulary by ID
 */
const getVocabularyById = async (req, res) => {
  try {
    const vocabId = parseInt(req.params.id);

    if (isNaN(vocabId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid vocabulary ID'
      });
    }

    const vocab = await contentService.getVocabularyById(vocabId);

    res.json({
      success: true,
      data: vocab
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error getting vocabulary:', error);

    if (error.message === 'Vocabulary not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Vocabulary not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/vocabulary
 * Create new vocabulary entry
 */
const createVocabulary = async (req, res) => {
  try {
    const { korean, chinese } = req.body;

    // Validate required fields
    if (!korean || !chinese) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Missing required fields: korean, chinese'
      });
    }

    // Check for duplicates
    const existing = await contentService.findVocabularyByKorean(korean);
    if (existing) {
      return res.status(409).json({
        error: 'Conflict',
        message: `단어 '${korean}'이(가) 이미 존재합니다. (ID: ${existing.id})`,
        data: existing
      });
    }

    const vocab = await contentService.createVocabulary(req.body);

    res.status(201).json({
      success: true,
      message: 'Vocabulary created successfully',
      data: vocab
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error creating vocabulary:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to create vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * PUT /api/admin/vocabulary/:id
 * Update vocabulary
 */
const updateVocabulary = async (req, res) => {
  try {
    const vocabId = parseInt(req.params.id);

    if (isNaN(vocabId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid vocabulary ID'
      });
    }

    const updates = req.body;

    if (!updates || Object.keys(updates).length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'No updates provided'
      });
    }

    const vocab = await contentService.updateVocabulary(vocabId, updates);

    res.json({
      success: true,
      message: 'Vocabulary updated successfully',
      data: vocab
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error updating vocabulary:', error);

    if (error.message === 'Vocabulary not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Vocabulary not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to update vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * DELETE /api/admin/vocabulary/:id
 * Delete vocabulary
 */
const deleteVocabulary = async (req, res) => {
  try {
    const vocabId = parseInt(req.params.id);

    if (isNaN(vocabId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid vocabulary ID'
      });
    }

    await contentService.deleteVocabulary(vocabId);

    res.json({
      success: true,
      message: 'Vocabulary deleted successfully'
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error deleting vocabulary:', error);

    if (error.message === 'Vocabulary not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Vocabulary not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to delete vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/vocabulary/bulk-delete
 * Bulk delete vocabulary
 */
const bulkDelete = async (req, res) => {
  try {
    const { vocabIds } = req.body;

    if (!Array.isArray(vocabIds) || vocabIds.length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'vocabIds must be a non-empty array'
      });
    }

    const count = await contentService.bulkDeleteVocabulary(vocabIds);

    res.json({
      success: true,
      message: `${count} vocabulary entries deleted successfully`,
      data: { count }
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error bulk deleting vocabulary:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to bulk delete vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/vocabulary/template
 * Download Excel template for bulk upload
 */
const downloadTemplate = async (req, res) => {
  try {
    // Create Excel template
    const workbook = xlsx.utils.book_new();

    // Define template headers (both English and Chinese)
    const headers = [
      'korean',
      'chinese',
      'hanja',
      'pinyin',
      'part_of_speech',
      'level'
    ];

    const headerLabels = [
      'korean (한국어) *필수',
      'chinese (中文) *필수',
      'hanja (漢字)',
      'pinyin (拼音)',
      'part_of_speech (품사: noun/verb/adjective/adverb/particle/conjunction/interjection/pronoun)',
      'level (레벨: 1-6)'
    ];

    // Sample data
    const sampleData = [
      ['안녕하세요', '你好', '', 'nǐ hǎo', 'interjection', '1'],
      ['사과', '苹果', '蘋果', 'píngguǒ', 'noun', '1'],
      ['먹다', '吃', '', 'chī', 'verb', '2'],
      ['아름답다', '美丽', '', 'měilì', 'adjective', '2'],
      ['빨리', '快', '', 'kuài', 'adverb', '1']
    ];

    // Create worksheet data
    const wsData = [
      headerLabels,
      ...sampleData
    ];

    const worksheet = xlsx.utils.aoa_to_sheet(wsData);

    // Set column widths
    worksheet['!cols'] = [
      { wch: 20 }, // korean
      { wch: 20 }, // chinese
      { wch: 15 }, // hanja
      { wch: 15 }, // pinyin
      { wch: 60 }, // part_of_speech (wider for hint)
      { wch: 15 }  // level
    ];

    // Add worksheet to workbook
    xlsx.utils.book_append_sheet(workbook, worksheet, '단어 목록');

    // Add instruction sheet
    const instructions = [
      ['단어 대량 업로드 가이드 / 词汇批量上传指南'],
      [''],
      ['필수 필드 / 必填字段:'],
      ['  - korean (한국어): 한국어 단어 또는 표현 / 韩语单词或表达'],
      ['  - chinese (中文): 중국어 번역 / 中文翻译'],
      [''],
      ['선택 필드 / 可选字段:'],
      ['  - hanja (漢字): 한자 표기 (있는 경우) / 汉字标记（如有）'],
      ['  - pinyin (拼音): 병음 표기 / 拼音标注'],
      ['  - part_of_speech (품사 / 词性): 다음 값 중 하나 선택 / 从以下值中选择一个'],
      ['      * noun (명사 / 名词)'],
      ['      * verb (동사 / 动词)'],
      ['      * adjective (형용사 / 形容词)'],
      ['      * adverb (부사 / 副词)'],
      ['      * particle (조사 / 助词)'],
      ['      * conjunction (접속사 / 连词)'],
      ['      * interjection (감탄사 / 感叹词)'],
      ['      * pronoun (대명사 / 代词)'],
      ['  - level (레벨 / 等级): 1-6 사이의 숫자 (TOPIK 레벨) / 1-6之间的数字（TOPIK等级）'],
      [''],
      ['주의사항 / 注意事项:'],
      ['  1. 첫 번째 행(헤더)은 삭제하지 마세요 / 不要删除第一行（标题行）'],
      ['  2. part_of_speech는 위에 명시된 값만 사용하세요 / part_of_speech只能使用上述指定的值'],
      ['  3. level은 1-6 사이의 숫자만 입력하세요 / level只能输入1-6之间的数字'],
      ['  4. 샘플 데이터를 참고하여 작성하세요 / 参考示例数据进行填写']
    ];

    const instructionSheet = xlsx.utils.aoa_to_sheet(instructions);
    instructionSheet['!cols'] = [{ wch: 80 }];
    xlsx.utils.book_append_sheet(workbook, instructionSheet, '사용 방법');

    // Generate buffer
    const buffer = xlsx.write(workbook, { type: 'buffer', bookType: 'xlsx' });

    // Set response headers
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', 'attachment; filename=vocabulary_template.xlsx');
    res.setHeader('Content-Length', buffer.length);

    res.send(buffer);
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error generating template:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to generate template',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/vocabulary/bulk-upload
 * Bulk upload vocabulary from Excel file
 *
 * Expected Excel columns:
 * - korean (한국어) - Required
 * - chinese (中文) - Required
 * - hanja (漢字) - Optional
 * - pinyin (拼音) - Optional
 * - part_of_speech (品词) - Optional
 * - level (等级) - Optional
 */
const bulkUpload = async (req, res) => {
  try {
    // Check if file was uploaded
    if (!req.file) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'No file uploaded'
      });
    }

    // Parse Excel file
    const workbook = xlsx.read(req.file.buffer, { type: 'buffer' });
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const data = xlsx.utils.sheet_to_json(worksheet);

    if (data.length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Excel file is empty'
      });
    }

    // Get upload mode from query parameter (skip or update)
    const uploadMode = req.query.mode || 'skip'; // 'skip' or 'update'

    // Validate and process data
    const results = {
      success: 0,
      failed: 0,
      skipped: 0,
      updated: 0,
      errors: [],
      skippedWords: []
    };

    for (let i = 0; i < data.length; i++) {
      const row = data[i];
      const rowNumber = i + 2; // Excel row number (1-indexed + header)

      try {
        // Map Excel columns (support both English and Chinese headers, including template labels)
        const korean = row['korean'] || row['korean (한국어) *필수'] || row['한국어'] || row['韩语'];
        const chinese = row['chinese'] || row['chinese (中文) *필수'] || row['中文'] || row['中国语'];
        const hanja = row['hanja'] || row['hanja (漢字)'] || row['漢字'] || row['汉字'];
        const pinyin = row['pinyin'] || row['pinyin (拼音)'] || row['拼音'];
        const part_of_speech = row['part_of_speech'] || row['part_of_speech (품사: noun/verb/adjective/adverb/particle/conjunction/interjection/pronoun)'] || row['품사'] || row['品词'];
        const levelRaw = row['level'] || row['level (레벨: 1-6)'] || row['레벨'] || row['等级'];

        // Convert level to integer (or null if empty)
        const level = levelRaw ? parseInt(levelRaw, 10) : null;

        // Validate level range if provided
        if (level !== null && (isNaN(level) || level < 1 || level > 6)) {
          results.failed++;
          results.errors.push({
            row: rowNumber,
            error: `Invalid level: ${levelRaw}. Level must be between 1 and 6.`
          });
          continue;
        }

        // Build vocab data object (trim strings and convert empty to null)
        const vocabData = {
          korean: korean ? String(korean).trim() : null,
          chinese: chinese ? String(chinese).trim() : null,
          hanja: hanja ? String(hanja).trim() : null,
          pinyin: pinyin ? String(pinyin).trim() : null,
          part_of_speech: part_of_speech ? String(part_of_speech).trim() : null,
          level
        };

        // Validate required fields
        if (!vocabData.korean || !vocabData.chinese) {
          results.failed++;
          results.errors.push({
            row: rowNumber,
            error: 'Missing required fields: korean and chinese'
          });
          continue;
        }

        // Check for duplicates
        const existing = await contentService.findVocabularyByKorean(vocabData.korean);

        if (existing) {
          if (uploadMode === 'skip') {
            // Skip duplicates
            results.skipped++;
            results.skippedWords.push({
              row: rowNumber,
              korean: vocabData.korean,
              existingId: existing.id
            });
            continue;
          } else if (uploadMode === 'update') {
            // Update existing entry
            await contentService.updateVocabulary(existing.id, vocabData);
            results.updated++;
            continue;
          }
        }

        // Create new vocabulary entry
        await contentService.createVocabulary(vocabData);
        results.success++;
      } catch (error) {
        results.failed++;
        results.errors.push({
          row: rowNumber,
          error: error.message
        });
      }
    }

    const summaryParts = [];
    if (results.success > 0) summaryParts.push(`${results.success} 추가`);
    if (results.updated > 0) summaryParts.push(`${results.updated} 업데이트`);
    if (results.skipped > 0) summaryParts.push(`${results.skipped} 중복 건너뜀`);
    if (results.failed > 0) summaryParts.push(`${results.failed} 실패`);

    res.json({
      success: true,
      message: `대량 업로드 완료: ${summaryParts.join(', ')}`,
      data: results
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error bulk uploading vocabulary:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to process Excel file',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  listVocabulary,
  getVocabularyById,
  createVocabulary,
  updateVocabulary,
  deleteVocabulary,
  bulkDelete,
  downloadTemplate,
  bulkUpload
};
