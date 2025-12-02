# RealWorld App Makefile
# =====================

.PHONY: help dev dev-frontend dev-backend build build-frontend build-backend test test-frontend test-backend test-e2e lint lint-frontend lint-backend clean docker-up docker-down docker-build

# Default target
help:
	@echo "RealWorld App - Available Commands"
	@echo "==================================="
	@echo ""
	@echo "Development:"
	@echo "  make dev            - Run both frontend and backend dev servers"
	@echo "  make dev-frontend   - Run frontend dev server only"
	@echo "  make dev-backend    - Run backend dev server only"
	@echo ""
	@echo "Build:"
	@echo "  make build          - Build both frontend and backend"
	@echo "  make build-frontend - Build frontend only"
	@echo "  make build-backend  - Build backend only"
	@echo ""
	@echo "Test:"
	@echo "  make test           - Run all tests"
	@echo "  make test-frontend  - Run frontend tests"
	@echo "  make test-backend   - Run backend tests"
	@echo "  make test-e2e       - Run E2E tests with Playwright"
	@echo ""
	@echo "Lint:"
	@echo "  make lint           - Run all linters"
	@echo "  make lint-frontend  - Run ESLint on frontend"
	@echo "  make lint-backend   - Run golangci-lint on backend"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-up      - Start all containers"
	@echo "  make docker-down    - Stop all containers"
	@echo "  make docker-build   - Build Docker images"
	@echo ""
	@echo "Utility:"
	@echo "  make clean          - Clean build artifacts"

# ===================
# Development
# ===================

# Run both frontend and backend in parallel
dev:
	@echo "Starting development servers..."
	@trap 'kill 0' INT; \
	$(MAKE) dev-backend & \
	$(MAKE) dev-frontend & \
	wait

dev-frontend:
	@echo "Starting frontend dev server..."
	cd frontend && npm run dev

dev-backend:
	@echo "Starting backend dev server..."
	cd backend && go run ./cmd/server

# ===================
# Build
# ===================

build: build-frontend build-backend
	@echo "Build complete!"

build-frontend:
	@echo "Building frontend..."
	cd frontend && npm run build

build-backend:
	@echo "Building backend..."
	cd backend && go build -o bin/server ./cmd/server

# ===================
# Test
# ===================

test: test-backend test-frontend
	@echo "All tests passed!"

test-frontend:
	@echo "Running frontend tests..."
	cd frontend && npm run test

test-backend:
	@echo "Running backend tests..."
	cd backend && go test -v ./...

test-e2e:
	@echo "Running E2E tests..."
	cd frontend && npx playwright test

# ===================
# Lint
# ===================

lint: lint-frontend lint-backend
	@echo "Lint complete!"

lint-frontend:
	@echo "Linting frontend..."
	cd frontend && npm run lint

lint-backend:
	@echo "Linting backend..."
	cd backend && golangci-lint run

# ===================
# Docker
# ===================

docker-up:
	@echo "Starting Docker containers..."
	docker-compose up -d

docker-down:
	@echo "Stopping Docker containers..."
	docker-compose down

docker-build:
	@echo "Building Docker images..."
	docker-compose build

# ===================
# Utility
# ===================

clean:
	@echo "Cleaning build artifacts..."
	rm -rf frontend/dist
	rm -rf frontend/node_modules/.cache
	rm -rf backend/bin
	rm -rf backend/tmp
	rm -rf coverage
	@echo "Clean complete!"
