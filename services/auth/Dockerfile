# ==================== Build Stage ====================
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install build dependencies (for native modules like bcrypt)
RUN apk add --no-cache python3 make g++

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies with clean install for reproducibility
# Use --omit=dev to exclude devDependencies
RUN npm ci --omit=dev && \
    npm cache clean --force

# ==================== Production Stage ====================
FROM node:20-alpine

# Metadata labels
LABEL maintainer="Lemon Korean Team" \
      service="auth-service" \
      version="1.0.0" \
      description="Authentication and authorization service for Lemon Korean"

# Install runtime dependencies
# - dumb-init: proper signal handling for PID 1
# - curl: for health checks (alternative to node http check)
RUN apk add --no-cache \
    dumb-init \
    curl \
    tzdata && \
    rm -rf /var/cache/apk/*

# Set timezone (optional)
ENV TZ=Asia/Seoul

# Create app user for security (non-root)
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

# Set working directory
WORKDIR /app

# Copy node_modules from builder stage
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copy package.json for reference
COPY --chown=nodejs:nodejs package*.json ./

# Copy application source code
COPY --chown=nodejs:nodejs src ./src

# Set environment variables
ENV NODE_ENV=production \
    PORT=3001

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 3001

# Health check configuration
# Checks /health endpoint every 30s
# Timeout after 10s
# Start checking after 40s (startup period)
# Mark unhealthy after 3 consecutive failures
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=40s \
            --retries=3 \
    CMD curl -f http://localhost:3001/health || exit 1

# Alternative health check using node (if curl not desired)
# HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
#   CMD node -e "require('http').get('http://localhost:3001/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "src/index.js"]
