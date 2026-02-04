const Hangul = require('../models/hangul.model');
const { cacheHelpers } = require('../config/redis');

/**
 * ================================================================
 * HANGUL CONTROLLER
 * ================================================================
 * Handles Korean alphabet (한글) character endpoints
 * Features: Alphabet table, character details, filtering by type
 * ================================================================
 */

/**
 * ================================================================
 * GET /api/content/hangul/characters
 * ================================================================
 * Get all hangul characters with optional filtering
 * @query character_type - Filter by type (basic_consonant, double_consonant, basic_vowel, compound_vowel)
 */
const getCharacters = async (req, res) => {
  try {
    console.log('[HANGUL] GET /api/content/hangul/characters', req.query);

    const { character_type } = req.query;

    // Validate character_type if provided
    const validTypes = ['basic_consonant', 'double_consonant', 'basic_vowel', 'compound_vowel', 'final_consonant'];
    if (character_type && !validTypes.includes(character_type)) {
      return res.status(400).json({
        success: false,
        error: `Invalid character_type. Must be one of: ${validTypes.join(', ')}`
      });
    }

    // Build cache key
    const cacheKey = `hangul:characters:${character_type || 'all'}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch characters
    const characters = await Hangul.findAll({ character_type });

    const response = {
      count: characters.length,
      characters
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[HANGUL] Returned ${characters.length} characters`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[HANGUL] Error in getCharacters:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch hangul characters',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/characters/:id
 * ================================================================
 * Get hangul character by ID with full details
 */
const getCharacterById = async (req, res) => {
  try {
    const characterId = parseInt(req.params.id);
    console.log('[HANGUL] GET /api/content/hangul/characters/:id', characterId);

    // Validate ID
    if (isNaN(characterId) || characterId < 1) {
      return res.status(400).json({
        success: false,
        error: 'Invalid character ID'
      });
    }

    // Check cache
    const cacheKey = `hangul:character:${characterId}`;
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        character: cached
      });
    }

    // Fetch from database
    const character = await Hangul.findById(characterId);

    if (!character) {
      return res.status(404).json({
        success: false,
        error: 'Hangul character not found'
      });
    }

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, character, 3600);

    console.log('[HANGUL] Found:', character.character, '-', character.romanization);

    res.json({
      success: true,
      character
    });

  } catch (error) {
    console.error('[HANGUL] Error in getCharacterById:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch hangul character',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/characters/type/:type
 * ================================================================
 * Get hangul characters by type
 */
const getCharactersByType = async (req, res) => {
  try {
    const { type } = req.params;
    console.log('[HANGUL] GET /api/content/hangul/characters/type/:type', type);

    // Validate type
    const validTypes = ['basic_consonant', 'double_consonant', 'basic_vowel', 'compound_vowel', 'final_consonant'];
    if (!validTypes.includes(type)) {
      return res.status(400).json({
        success: false,
        error: `Invalid type. Must be one of: ${validTypes.join(', ')}`
      });
    }

    // Check cache
    const cacheKey = `hangul:type:${type}`;
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch characters
    const characters = await Hangul.findByType(type);

    const response = {
      type,
      count: characters.length,
      characters
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[HANGUL] Type ${type} has ${characters.length} characters`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[HANGUL] Error in getCharactersByType:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch hangul characters by type',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/table
 * ================================================================
 * Get full alphabet table organized by type (for UI display)
 */
const getAlphabetTable = async (req, res) => {
  try {
    console.log('[HANGUL] GET /api/content/hangul/table');

    // Check cache
    const cacheKey = 'hangul:table';
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch alphabet table
    const table = await Hangul.getAlphabetTable();
    const stats = await Hangul.getStatistics();

    const response = {
      table,
      stats: {
        total: parseInt(stats.total_characters),
        basic_consonants: parseInt(stats.basic_consonants),
        double_consonants: parseInt(stats.double_consonants),
        basic_vowels: parseInt(stats.basic_vowels),
        compound_vowels: parseInt(stats.compound_vowels)
      }
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log('[HANGUL] Returned alphabet table');

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[HANGUL] Error in getAlphabetTable:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch alphabet table',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/stats
 * ================================================================
 * Get hangul character statistics
 */
const getStats = async (req, res) => {
  try {
    console.log('[HANGUL] GET /api/content/hangul/stats');

    // Check cache
    const cacheKey = 'hangul:stats';
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        stats: cached
      });
    }

    // Get statistics
    const stats = await Hangul.getStatistics();

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, stats, 3600);

    console.log('[HANGUL] Stats:', stats);

    res.json({
      success: true,
      stats
    });

  } catch (error) {
    console.error('[HANGUL] Error in getStats:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch hangul statistics',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/pronunciation-guides
 * ================================================================
 * Get pronunciation guides for all characters
 */
const getPronunciationGuides = async (req, res) => {
  try {
    console.log('[HANGUL] GET /api/content/hangul/pronunciation-guides');

    // Check cache
    const cacheKey = 'hangul:pronunciation-guides';
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch pronunciation guides
    const guides = await Hangul.getPronunciationGuides();

    const response = {
      count: guides.length,
      guides
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[HANGUL] Returned ${guides.length} pronunciation guides`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[HANGUL] Error in getPronunciationGuides:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch pronunciation guides',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/pronunciation-guides/:characterId
 * ================================================================
 * Get pronunciation guide for a specific character
 */
const getPronunciationGuideByCharacterId = async (req, res) => {
  try {
    const characterId = parseInt(req.params.characterId);
    console.log('[HANGUL] GET /api/content/hangul/pronunciation-guides/:characterId', characterId);

    if (isNaN(characterId) || characterId < 1) {
      return res.status(400).json({
        success: false,
        error: 'Invalid character ID'
      });
    }

    // Check cache
    const cacheKey = `hangul:pronunciation-guide:${characterId}`;
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        guide: cached
      });
    }

    // Fetch guide
    const guide = await Hangul.getPronunciationGuideByCharacterId(characterId);

    if (!guide) {
      return res.status(404).json({
        success: false,
        error: 'Pronunciation guide not found'
      });
    }

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, guide, 3600);

    res.json({
      success: true,
      guide
    });

  } catch (error) {
    console.error('[HANGUL] Error in getPronunciationGuideByCharacterId:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch pronunciation guide',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/syllables
 * ================================================================
 * Get syllable combinations with optional filtering
 */
const getSyllables = async (req, res) => {
  try {
    const { initial, vowel, final, limit = 100, offset = 0 } = req.query;
    console.log('[HANGUL] GET /api/content/hangul/syllables', req.query);

    // Build cache key
    const cacheKey = `hangul:syllables:${initial || 'all'}:${vowel || 'all'}:${final || 'none'}:${limit}:${offset}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch syllables
    const syllables = await Hangul.getSyllables({ initial, vowel, final, limit, offset });

    const response = {
      count: syllables.length,
      syllables
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[HANGUL] Returned ${syllables.length} syllables`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[HANGUL] Error in getSyllables:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch syllables',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/hangul/similar-sounds
 * ================================================================
 * Get similar sound groups for discrimination training
 */
const getSimilarSoundGroups = async (req, res) => {
  try {
    const { category } = req.query;
    console.log('[HANGUL] GET /api/content/hangul/similar-sounds', req.query);

    // Validate category if provided
    if (category && !['consonant', 'vowel'].includes(category)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid category. Must be "consonant" or "vowel"'
      });
    }

    // Build cache key
    const cacheKey = `hangul:similar-sounds:${category || 'all'}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[HANGUL] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch similar sound groups
    const groups = await Hangul.getSimilarSoundGroups(category);

    const response = {
      count: groups.length,
      groups
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[HANGUL] Returned ${groups.length} similar sound groups`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[HANGUL] Error in getSimilarSoundGroups:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch similar sound groups',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * EXPORTS
 * ================================================================
 */
module.exports = {
  getCharacters,
  getCharacterById,
  getCharactersByType,
  getAlphabetTable,
  getStats,
  getPronunciationGuides,
  getPronunciationGuideByCharacterId,
  getSyllables,
  getSimilarSoundGroups
};
