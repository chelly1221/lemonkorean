# Lemon Korean - Auth Service

Authentication and authorization service for Lemon Korean platform.

## Features

- User registration with email/password
- Login with JWT token generation
- Token refresh mechanism
- User profile management
- Session management
- Password hashing with bcrypt
- Input validation and sanitization

## Tech Stack

- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: PostgreSQL
- **Authentication**: JWT (jsonwebtoken)
- **Password Hashing**: bcrypt
- **Validation**: Custom validators

## Environment Variables

Create a `.env` file in the root directory:

```env
NODE_ENV=development
PORT=3001
DATABASE_URL=postgres://user:password@localhost:5432/lemon_korean
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d
REDIS_URL=redis://:password@localhost:6379
```

## Installation

```bash
# Install dependencies
npm install

# Development mode with auto-reload
npm run dev

# Production mode
npm start
```

## API Endpoints

### Public Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "张伟",
  "language_preference": "zh"
}
```

**Response:**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "张伟",
    "subscription_type": "free"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Refresh Token
```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Protected Endpoints

#### Get Profile
```http
GET /api/auth/profile
Authorization: Bearer <accessToken>
```

#### Update Profile
```http
PUT /api/auth/profile
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "name": "新名字",
  "language_preference": "ko"
}
```

#### Logout
```http
POST /api/auth/logout
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## Project Structure

```
auth/
├── src/
│   ├── config/
│   │   ├── database.js      # PostgreSQL connection
│   │   └── jwt.js           # JWT configuration
│   ├── controllers/
│   │   └── auth.controller.js    # Business logic
│   ├── middleware/
│   │   └── auth.middleware.js    # Authentication middleware
│   ├── models/
│   │   └── user.model.js         # User model
│   ├── routes/
│   │   └── auth.routes.js        # Route definitions
│   ├── utils/
│   │   └── validator.js          # Input validation
│   └── index.js             # Entry point
├── Dockerfile
├── package.json
└── README.md
```

## Docker

### Build Image
```bash
docker build -t lemon-auth-service .
```

### Run Container
```bash
docker run -p 3001:3001 \
  -e DATABASE_URL=postgres://user:pass@host:5432/db \
  -e JWT_SECRET=secret \
  lemon-auth-service
```

### With Docker Compose
```bash
docker-compose up auth-service
```

## Error Codes

| Code | Description |
|------|-------------|
| `TOKEN_EXPIRED` | JWT access token has expired |
| `INVALID_TOKEN` | JWT token is invalid or malformed |
| `REFRESH_TOKEN_EXPIRED` | Refresh token has expired |
| `PREMIUM_REQUIRED` | Feature requires premium subscription |

## Security

- Passwords are hashed with bcrypt (10 salt rounds)
- JWT tokens are signed with HS256 algorithm
- Sessions are stored in database
- Email validation and sanitization
- SQL injection protection via parameterized queries

## Health Check

```http
GET /health
```

Returns service health status and uptime.

## Development

```bash
# Install dependencies
npm install

# Run in development mode
npm run dev

# The server will reload automatically on file changes
```

## Testing

```bash
# Run tests (not implemented yet)
npm test
```

## License

MIT
