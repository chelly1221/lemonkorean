const fs = require('fs').promises;
const path = require('path');
const yaml = require('js-yaml');

// Base directory for development notes
// In Docker: /project/dev-notes (mounted from project root)
const DEV_NOTES_BASE_DIR = process.env.DEV_NOTES_DIR || '/project/dev-notes';

/**
 * Parse frontmatter from markdown content
 * @param {string} content - Full markdown content with frontmatter
 * @returns {Object} - {metadata, content}
 */
function parseFrontmatter(content) {
  const frontmatterRegex = /^---\s*\n([\s\S]*?)\n---\s*\n([\s\S]*)$/;
  const match = content.match(frontmatterRegex);

  if (!match) {
    return {
      metadata: {},
      content: content
    };
  }

  try {
    const metadata = yaml.load(match[1]);
    const markdownContent = match[2];

    return {
      metadata: metadata || {},
      content: markdownContent
    };
  } catch (error) {
    console.error('Error parsing frontmatter:', error);
    return {
      metadata: {},
      content: content
    };
  }
}

/**
 * Extract date from filename (YYYY-MM-DD-*.md pattern)
 * @param {string} filename - Filename to extract date from
 * @returns {string|null} - ISO date string or null
 */
function extractDateFromFilename(filename) {
  const dateRegex = /^(\d{4}-\d{2}-\d{2})/;
  const match = filename.match(dateRegex);

  if (match) {
    return match[1];
  }

  return null;
}

/**
 * Sanitize path to prevent directory traversal attacks
 * @param {string} inputPath - User-provided path
 * @returns {string|null} - Sanitized path or null if invalid
 */
function sanitizePath(inputPath) {
  // Remove any ../ or ..\\ sequences
  const normalized = path.normalize(inputPath).replace(/^(\.\.(\/|\\|$))+/, '');

  // Ensure path starts with dev-notes/
  if (!normalized.startsWith('dev-notes/') && !normalized.startsWith('dev-notes\\')) {
    return null;
  }

  // Extract filename from normalized path (remove 'dev-notes/' prefix)
  const filename = normalized.replace(/^dev-notes[\/\\]/, '');

  // Resolve full path using DEV_NOTES_BASE_DIR
  const fullPath = path.join(DEV_NOTES_BASE_DIR, filename);

  // Ensure resolved path is within DEV_NOTES_BASE_DIR
  if (!fullPath.startsWith(DEV_NOTES_BASE_DIR)) {
    return null;
  }

  return fullPath;
}

/**
 * Get list of all development notes with metadata
 * GET /api/admin/dev-notes
 */
async function getDevNotesList(req, res) {
  try {
    // Check if dev-notes directory exists
    try {
      await fs.access(DEV_NOTES_BASE_DIR);
    } catch (error) {
      return res.json({
        success: true,
        notes: [],
        message: 'Dev notes directory does not exist yet'
      });
    }

    // Read directory contents
    const files = await fs.readdir(DEV_NOTES_BASE_DIR);

    // Filter markdown files (exclude README.md)
    const markdownFiles = files.filter(file =>
      file.endsWith('.md') && file !== 'README.md'
    );

    // Process each file to extract metadata
    const notes = await Promise.all(
      markdownFiles.map(async (filename) => {
        const filePath = path.join(DEV_NOTES_BASE_DIR, filename);

        try {
          // Read file content
          const content = await fs.readFile(filePath, 'utf-8');

          // Get file stats
          const stats = await fs.stat(filePath);

          // Parse frontmatter
          const { metadata } = parseFrontmatter(content);

          // Extract date from filename if not in metadata
          const dateFromFilename = extractDateFromFilename(filename);

          // Convert date to string (js-yaml may parse it as Date object)
          let dateString = metadata.date || dateFromFilename || null;
          if (dateString instanceof Date) {
            // Convert Date object to YYYY-MM-DD string
            dateString = dateString.toISOString().split('T')[0];
          } else if (dateString && typeof dateString !== 'string') {
            // Convert any other type to string
            dateString = String(dateString);
          }

          return {
            filename,
            path: `dev-notes/${filename}`,
            date: dateString,
            category: metadata.category || 'Uncategorized',
            title: metadata.title || filename.replace('.md', ''),
            author: metadata.author || 'Unknown',
            tags: metadata.tags || [],
            priority: metadata.priority || 'medium',
            size: stats.size,
            modifiedAt: stats.mtime.toISOString()
          };
        } catch (error) {
          console.error(`Error processing file ${filename}:`, error);
          return null;
        }
      })
    );

    // Filter out failed reads and sort by date (newest first)
    const validNotes = notes
      .filter(note => note !== null)
      .sort((a, b) => {
        if (!a.date) return 1;
        if (!b.date) return -1;
        return b.date.localeCompare(a.date);
      });

    res.json({
      success: true,
      notes: validNotes,
      count: validNotes.length
    });

  } catch (error) {
    console.error('Error listing dev notes:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to list development notes'
    });
  }
}

/**
 * Get content of a specific development note
 * GET /api/admin/dev-notes/content?path=dev-notes/2026-01-30-example.md
 */
async function getDevNoteContent(req, res) {
  try {
    const { path: notePath } = req.query;

    if (!notePath) {
      return res.status(400).json({
        success: false,
        error: 'Path parameter is required'
      });
    }

    // Sanitize path
    const sanitizedPath = sanitizePath(notePath);

    if (!sanitizedPath) {
      return res.status(400).json({
        success: false,
        error: 'Invalid path'
      });
    }

    // Check if file exists
    try {
      await fs.access(sanitizedPath);
    } catch (error) {
      return res.status(404).json({
        success: false,
        error: 'Note not found'
      });
    }

    // Read file content
    const content = await fs.readFile(sanitizedPath, 'utf-8');

    // Get file stats
    const stats = await fs.stat(sanitizedPath);

    // Parse frontmatter
    const { metadata, content: markdownContent } = parseFrontmatter(content);

    // Extract filename
    const filename = path.basename(sanitizedPath);

    // Extract date from filename if not in metadata
    const dateFromFilename = extractDateFromFilename(filename);

    // Convert date to string (js-yaml may parse it as Date object)
    let dateString = metadata.date || dateFromFilename || null;
    if (dateString instanceof Date) {
      // Convert Date object to YYYY-MM-DD string
      dateString = dateString.toISOString().split('T')[0];
    } else if (dateString && typeof dateString !== 'string') {
      // Convert any other type to string
      dateString = String(dateString);
    }

    res.json({
      success: true,
      note: {
        filename,
        path: notePath,
        date: dateString,
        category: metadata.category || 'Uncategorized',
        title: metadata.title || filename.replace('.md', ''),
        author: metadata.author || 'Unknown',
        tags: metadata.tags || [],
        priority: metadata.priority || 'medium',
        size: stats.size,
        modifiedAt: stats.mtime.toISOString(),
        content: markdownContent,
        metadata
      }
    });

  } catch (error) {
    console.error('Error reading dev note:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to read development note'
    });
  }
}

/**
 * Get unique categories from all notes
 * GET /api/admin/dev-notes/categories
 */
async function getCategories(req, res) {
  try {
    // Check if dev-notes directory exists
    try {
      await fs.access(DEV_NOTES_BASE_DIR);
    } catch (error) {
      return res.json({
        success: true,
        categories: []
      });
    }

    // Read directory contents
    const files = await fs.readdir(DEV_NOTES_BASE_DIR);

    // Filter markdown files
    const markdownFiles = files.filter(file =>
      file.endsWith('.md') && file !== 'README.md'
    );

    // Extract categories from all notes
    const categoriesSet = new Set();

    await Promise.all(
      markdownFiles.map(async (filename) => {
        const filePath = path.join(DEV_NOTES_BASE_DIR, filename);

        try {
          const content = await fs.readFile(filePath, 'utf-8');
          const { metadata } = parseFrontmatter(content);

          if (metadata.category) {
            categoriesSet.add(metadata.category);
          }
        } catch (error) {
          console.error(`Error reading file ${filename}:`, error);
        }
      })
    );

    const categories = Array.from(categoriesSet).sort();

    res.json({
      success: true,
      categories
    });

  } catch (error) {
    console.error('Error getting categories:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get categories'
    });
  }
}

module.exports = {
  getDevNotesList,
  getDevNoteContent,
  getCategories
};
