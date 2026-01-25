# Lemon Korean - Content Service

Content management service for Lemon Korean platform - handles lessons, vocabulary, and grammar.

## Features

- **Lessons Management**: CRUD operations for lessons with metadata and full content
- **Vocabulary Management**: Korean-Chinese word mappings with Hanja support
- **Grammar Rules**: Grammar patterns with Chinese comparisons
- **Lesson Packager**: Create downloadable lesson packages (ZIP)
- **Multi-Database**: PostgreSQL for metadata, MongoDB for content, Redis for caching
- **Offline Support**: Check for updates, download lesson packages

## Tech Stack

- **Runtime**: Node.js 20
- **Framework**: Express.js
- **Databases**:
  - PostgreSQL: Lesson metadata, vocabulary, grammar
  - MongoDB: Lesson content (large JSON)
  - Redis: Caching
- **Additional**: archiver (ZIP creation)

## Environment Variables

```env
NODE_ENV=production
PORT=3002

# PostgreSQL
DATABASE_URL=postgres://user:password@postgres:5432/lemon_korean

# MongoDB
MONGO_URL=mongodb://admin:password@mongo:27017/lemon_korean?authSource=admin

# Redis (Optional)
REDIS_URL=redis://:password@redis:6379
```

## Installation

```bash
# Install dependencies
npm install

# Development mode
npm run dev

# Production mode
npm start
```

## API Endpoints

### Lessons

- `GET /api/content/lessons` - Get all lessons
- `GET /api/content/lessons/:id` - Get lesson metadata
- `GET /api/content/lessons/:id/full` - Get full lesson (metadata + content)
- `GET /api/content/lessons/:id/download` - Download lesson package (ZIP)
- `GET /api/content/lessons/level/:level` - Get lessons by level
- `POST /api/content/lessons/check-updates` - Check for lesson updates

### Vocabulary

- `GET /api/content/vocabulary` - Get all vocabulary
- `GET /api/content/vocabulary/:id` - Get vocabulary by ID
- `GET /api/content/vocabulary/search?q=term` - Search vocabulary
- `GET /api/content/vocabulary/stats` - Get vocabulary statistics

### Grammar

- `GET /api/content/grammar` - Get all grammar rules
- `GET /api/content/grammar/:id` - Get grammar rule by ID
- `GET /api/content/grammar/categories` - Get grammar categories

## Docker

### Build

```bash
docker build -t lemon-content-service:latest .
```

### Run

```bash
docker run -d \
  --name lemon-content \
  -p 3002:3002 \
  --env-file .env \
  lemon-content-service:latest
```

### With Docker Compose

```bash
docker-compose up content-service
```

## Project Structure

```
content/
├── src/
│   ├── config/
│   │   ├── database.js       # PostgreSQL
│   │   ├── mongodb.js        # MongoDB
│   │   └── redis.js          # Redis
│   ├── controllers/
│   │   ├── lessons.controller.js
│   │   ├── vocabulary.controller.js
│   │   └── grammar.controller.js
│   ├── models/
│   │   ├── lesson.model.js
│   │   └── vocabulary.model.js
│   ├── routes/
│   │   ├── lessons.routes.js
│   │   ├── vocabulary.routes.js
│   │   └── grammar.routes.js
│   ├── services/
│   │   └── lesson-packager.service.js
│   └── index.js
├── Dockerfile
├── package.json
└── README.md
```

## License

MIT
