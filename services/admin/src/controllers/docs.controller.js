const fs = require('fs').promises;
const path = require('path');

/**
 * Docs Controller
 * Handles HTTP requests for development documentation
 */

// Project root directory (mounted as /project in Docker container)
const PROJECT_ROOT = '/project';

/**
 * Document categories and their paths
 */
const DOC_CATEGORIES = [
  {
    id: 'project',
    name: '프로젝트',
    icon: 'fa-home',
    paths: [
      { file: 'README.md', label: 'README' },
      { file: 'CLAUDE.md', label: 'CLAUDE (개발 가이드)' },
      { file: 'DEPLOYMENT.md', label: 'DEPLOYMENT (배포)' },
      { file: 'TESTING.md', label: 'TESTING (테스트)' },
      { file: 'MONITORING.md', label: 'MONITORING (모니터링)' },
    ]
  },
  {
    id: 'api',
    name: 'API 문서',
    icon: 'fa-code',
    basePath: 'docs/api',
    patterns: ['*.md']
  },
  {
    id: 'database',
    name: '데이터베이스',
    icon: 'fa-database',
    paths: [
      { file: 'database/postgres/SCHEMA.md', label: 'PostgreSQL Schema' },
    ]
  },
  {
    id: 'services',
    name: '서비스',
    icon: 'fa-cubes',
    subCategories: [
      { id: 'auth', name: 'Auth Service', basePath: 'services/auth' },
      { id: 'content', name: 'Content Service', basePath: 'services/content' },
      { id: 'progress', name: 'Progress Service', basePath: 'services/progress' },
      { id: 'media', name: 'Media Service', basePath: 'services/media' },
      { id: 'admin', name: 'Admin Service', basePath: 'services/admin' },
      { id: 'analytics', name: 'Analytics Service', basePath: 'services/analytics' },
    ]
  },
  {
    id: 'mobile',
    name: '모바일 앱',
    icon: 'fa-mobile-alt',
    basePath: 'mobile/lemon_korean',
    patterns: ['*.md', '**/*.md']
  },
  {
    id: 'infrastructure',
    name: '인프라',
    icon: 'fa-server',
    paths: [
      { file: 'nginx/README.md', label: 'Nginx' },
      { file: 'scripts/backup/README.md', label: 'Backup Scripts' },
      { file: 'scripts/optimization/README.md', label: 'Optimization Scripts' },
      { file: 'monitoring/README.md', label: 'Monitoring' },
    ]
  },
  {
    id: 'cicd',
    name: 'CI/CD',
    icon: 'fa-sync-alt',
    basePath: '.github/workflows',
    patterns: ['*.md', 'README.md']
  }
];

/**
 * Check if a file exists
 */
async function fileExists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

/**
 * Get markdown files from a directory
 */
async function getMarkdownFiles(dirPath) {
  const files = [];
  const fullPath = path.join(PROJECT_ROOT, dirPath);

  try {
    const entries = await fs.readdir(fullPath, { withFileTypes: true });

    for (const entry of entries) {
      if (entry.isFile() && entry.name.endsWith('.md')) {
        files.push({
          file: path.join(dirPath, entry.name),
          label: entry.name.replace('.md', '')
        });
      }
    }
  } catch (error) {
    console.log(`[DOCS] Directory not found: ${dirPath}`);
  }

  return files;
}

/**
 * Build document tree structure
 */
async function buildDocTree() {
  const tree = [];

  for (const category of DOC_CATEGORIES) {
    const categoryNode = {
      id: category.id,
      name: category.name,
      icon: category.icon,
      items: []
    };

    // Handle explicit paths
    if (category.paths) {
      for (const pathItem of category.paths) {
        const fullPath = path.join(PROJECT_ROOT, pathItem.file);
        if (await fileExists(fullPath)) {
          categoryNode.items.push({
            path: pathItem.file,
            label: pathItem.label
          });
        }
      }
    }

    // Handle basePath with patterns
    if (category.basePath && category.patterns) {
      const mdFiles = await getMarkdownFiles(category.basePath);
      categoryNode.items.push(...mdFiles.map(f => ({
        path: f.file,
        label: f.label
      })));
    }

    // Handle subCategories (for services)
    if (category.subCategories) {
      categoryNode.subCategories = [];

      for (const sub of category.subCategories) {
        const subNode = {
          id: sub.id,
          name: sub.name,
          items: []
        };

        // Look for README.md and other .md files
        const readmePath = path.join(sub.basePath, 'README.md');
        const fullReadmePath = path.join(PROJECT_ROOT, readmePath);

        if (await fileExists(fullReadmePath)) {
          subNode.items.push({
            path: readmePath,
            label: 'README'
          });
        }

        // Look for additional .md files
        const mdFiles = await getMarkdownFiles(sub.basePath);
        for (const f of mdFiles) {
          if (f.label !== 'README') {
            subNode.items.push({
              path: f.file,
              label: f.label
            });
          }
        }

        if (subNode.items.length > 0) {
          categoryNode.subCategories.push(subNode);
        }
      }
    }

    // Only add category if it has items or subCategories
    if (categoryNode.items.length > 0 || (categoryNode.subCategories && categoryNode.subCategories.length > 0)) {
      tree.push(categoryNode);
    }
  }

  return tree;
}

/**
 * GET /api/admin/docs
 * Get list of all documentation files
 */
const getDocsList = async (req, res) => {
  try {
    console.log('[DOCS_CONTROLLER] Getting docs list, PROJECT_ROOT:', PROJECT_ROOT);
    const tree = await buildDocTree();
    console.log('[DOCS_CONTROLLER] Built tree with', tree.length, 'categories');

    res.json({
      success: true,
      data: tree
    });
  } catch (error) {
    console.error('[DOCS_CONTROLLER] Error getting docs list:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve documentation list',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/docs/content
 * Get content of a specific documentation file
 */
const getDocContent = async (req, res) => {
  try {
    const { path: docPath } = req.query;

    if (!docPath) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Document path is required'
      });
    }

    // Sanitize path to prevent directory traversal attacks
    const sanitizedPath = path.normalize(docPath).replace(/^(\.\.[\/\\])+/, '');

    // Ensure it's a markdown file
    if (!sanitizedPath.endsWith('.md')) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Only markdown files are allowed'
      });
    }

    const fullPath = path.join(PROJECT_ROOT, sanitizedPath);

    // Ensure the file is within project root
    if (!fullPath.startsWith(PROJECT_ROOT)) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Access denied'
      });
    }

    // Check if file exists
    if (!(await fileExists(fullPath))) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Document not found'
      });
    }

    // Read file content
    const content = await fs.readFile(fullPath, 'utf-8');

    // Get file stats for metadata
    const stats = await fs.stat(fullPath);

    res.json({
      success: true,
      data: {
        path: sanitizedPath,
        content: content,
        size: stats.size,
        modifiedAt: stats.mtime
      }
    });
  } catch (error) {
    console.error('[DOCS_CONTROLLER] Error getting doc content:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve document content',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  getDocsList,
  getDocContent
};
