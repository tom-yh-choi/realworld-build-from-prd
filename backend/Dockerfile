# Backend Dockerfile
# Multi-stage build for Go application

# Stage 1: Build
FROM golang:1.25-alpine AS builder

# Install build dependencies
RUN apk add --no-cache gcc musl-dev sqlite-dev

WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application with CGO enabled for SQLite
RUN CGO_ENABLED=1 GOOS=linux go build -a -ldflags '-linkmode external -extldflags "-static"' -o server ./cmd/server

# Stage 2: Production
FROM alpine:latest AS production

# Install runtime dependencies
RUN apk add --no-cache ca-certificates tzdata sqlite

WORKDIR /app

# Create data directory for SQLite
RUN mkdir -p /app/data

# Copy the binary from builder
COPY --from=builder /app/server .

# Copy migrations if needed
COPY --from=builder /app/db/migrations ./db/migrations

# Expose port
EXPOSE 8080

# Set environment variables
ENV PORT=8080
ENV DB_PATH=/app/data/realworld.db

# Run the application
CMD ["./server"]
