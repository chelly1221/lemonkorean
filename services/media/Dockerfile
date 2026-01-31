# ==================== Build Stage ====================
FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git ca-certificates tzdata gcc musl-dev

# Set working directory
WORKDIR /app

# Copy go module files
COPY go.mod go.sum ./

# Copy source code first (needed for go mod tidy)
COPY . .

# Tidy dependencies and download
RUN go mod tidy && go mod download

# Build the application
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' \
    -a -installsuffix cgo \
    -o /app/media-service \
    ./main.go

# ==================== Runtime Stage ====================
FROM alpine:latest

# Install runtime dependencies
RUN apk --no-cache add ca-certificates tzdata curl imagemagick libwebp-tools

# Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/media-service /app/media-service

# Copy timezone data
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Set timezone
ENV TZ=Asia/Seoul

# Change ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3004

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3004/health || exit 1

# Run the application
CMD ["/app/media-service"]
