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
      { file: 'CHANGES.md', label: '변경 이력' },
      { file: 'CLAUDE_INSTRUCTIONS.md', label: 'Claude 작업 지침' },
      { file: 'CLAUDE_SAFETY_README.md', label: 'Claude 안전 가이드' },
      { file: 'JWT_FIX_INSTRUCTIONS.md', label: 'JWT 수정 가이드' },
      { file: 'TEST_REPORT.md', label: '테스트 보고서' },
      { file: 'DATA_LOSS_ANALYSIS.md', label: '데이터 손실 분석' },
      { file: 'VOLUME_PROTECTION_GUIDE.md', label: '볼륨 보호 가이드' },
      { file: 'VOLUME_PROTECTION_SUMMARY.md', label: '볼륨 보호 요약' },
      { file: 'VOLUME_CHECKLIST.md', label: '볼륨 체크리스트' },
      { file: 'VOLUME_AUDIT_REPORT.md', label: '볼륨 감사 보고서' },
      { file: 'WEB_BUILD_VERIFICATION.md', label: '웹 빌드 검증' },
      { file: 'WEB_DEPLOYMENT_SUMMARY.md', label: '웹 배포 요약' },
      { file: 'SAFETY_SYSTEM_COMPLETE.md', label: '안전 시스템 완료' },
    ]
  },
  {
    id: 'api',
    name: 'API 문서',
    icon: 'fa-code',
    paths: [
      { file: 'docs/API.md', label: 'API Overview (총괄)' }
    ],
    basePath: 'docs/api',
    patterns: ['*.md']
  },
  {
    id: 'database',
    name: '데이터베이스',
    icon: 'fa-database',
    paths: [
      { file: 'database/postgres/SCHEMA.md', label: 'PostgreSQL Schema' },
      { file: 'database/mongo/SCHEMA.md', label: 'MongoDB Schema' },
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
      { file: 'nginx/CONFIGURATION.md', label: 'Nginx 설정' },
      { file: 'nginx/QUICKSTART.md', label: 'Nginx 빠른 시작' },
      { file: 'scripts/README.md', label: 'Scripts Overview' },
      { file: 'scripts/backup/README.md', label: 'Backup Scripts' },
      { file: 'scripts/optimization/README.md', label: 'Optimization Scripts' },
      { file: 'kubernetes/README.md', label: 'Kubernetes 배포' },
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

/**
 * PUT /api/admin/docs/content
 * Update documentation file content
 */
const updateDocContent = async (req, res) => {
  try {
    const { path: docPath, content } = req.body;

    // Validation
    if (!docPath || content === undefined) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Path and content are required'
      });
    }

    // Sanitize path (prevent directory traversal)
    const sanitizedPath = path.normalize(docPath).replace(/^(\.\.[\/\\])+/, '');

    // Ensure it's a markdown file
    if (!sanitizedPath.endsWith('.md')) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Only markdown files are allowed'
      });
    }

    const fullPath = path.join(PROJECT_ROOT, sanitizedPath);

    // Ensure within project root
    if (!fullPath.startsWith(PROJECT_ROOT)) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Access denied'
      });
    }

    // File size limit: 5MB
    if (content.length > 5 * 1024 * 1024) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Content exceeds 5MB limit'
      });
    }

    // Create backup before writing
    if (await fileExists(fullPath)) {
      const timestamp = Date.now();
      const backupPath = `${fullPath}.bak.${timestamp}`;
      await fs.copyFile(fullPath, backupPath);

      // Cleanup old backups (keep last 5)
      const dirPath = path.dirname(fullPath);
      const filename = path.basename(fullPath);
      const files = await fs.readdir(dirPath);
      const backups = files
        .filter(f => f.startsWith(`${filename}.bak.`))
        .map(f => ({ name: f, path: path.join(dirPath, f) }))
        .sort((a, b) => b.name.localeCompare(a.name));

      // Delete backups beyond 5
      for (let i = 5; i < backups.length; i++) {
        await fs.unlink(backups[i].path).catch(() => {});
      }
    }

    // Write new content
    await fs.writeFile(fullPath, content, 'utf-8');

    // Get updated stats
    const stats = await fs.stat(fullPath);

    res.json({
      success: true,
      data: {
        path: sanitizedPath,
        size: stats.size,
        modifiedAt: stats.mtime
      }
    });

  } catch (error) {
    console.error('[DOCS_CONTROLLER] Error updating doc:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to update document',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  getDocsList,
  getDocContent,
  updateDocContent
};
