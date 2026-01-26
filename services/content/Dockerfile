# ==================== Build Stage ====================
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
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
      service="content-service" \
      version="1.0.0" \
      description="Content management service for Lemon Korean"

# Install runtime dependencies
RUN apk add --no-cache \
    dumb-init \
    curl \
    tzdata && \
    rm -rf /var/cache/apk/*

# Set timezone
ENV TZ=Asia/Seoul

# Create app user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

# Set working directory
WORKDIR /app

# Copy node_modules from builder
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copy package.json
COPY --chown=nodejs:nodejs package*.json ./

# Copy application code
COPY --chown=nodejs:nodejs src ./src

# Set environment variables
ENV NODE_ENV=production \
    PORT=3002

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3002

# Health check
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=40s \
            --retries=3 \
    CMD curl -f http://localhost:3002/health || exit 1

# Use dumb-init
ENTRYPOINT ["dumb-init", "--"]

# Start application
CMD ["node", "src/index.js"]
