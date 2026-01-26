# ==================== Build Stage ====================
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install build dependencies (for native modules like bcrypt)
RUN apk add --no-cache python3 make g++

# Copy package files for dependency installation
COPY package*.json ./

# Install dependencies
# Use npm ci for reproducible builds when package-lock.json exists
# Fall back to npm install if package-lock.json is not present
RUN if [ -f package-lock.json ]; then \
        echo "Using npm ci for reproducible build"; \
        npm ci --omit=dev; \
    else \
        echo "Warning: package-lock.json not found, using npm install"; \
        npm install --omit=dev; \
    fi && \
    npm cache clean --force

# ==================== Production Stage ====================
FROM node:20-alpine

# Metadata labels
LABEL maintainer="Lemon Korean Team" \
      service="admin-service" \
      version="1.0.0" \
      description="Admin dashboard service for Lemon Korean"

# Install runtime dependencies
# - dumb-init: proper signal handling for PID 1
# - wget: for health checks (used in docker-compose)
RUN apk add --no-cache \
    dumb-init \
    wget \
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
    PORT=3006

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 3006

# Health check configuration
# Checks /health endpoint every 30s
# Timeout after 10s
# Start checking after 40s (startup period)
# Mark unhealthy after 3 consecutive failures
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=40s \
            --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3006/health || exit 1

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "src/index.js"]
