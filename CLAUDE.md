# Project rule

## Language

- All user-facing communication must be in Korean

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RealWorld 앱(Medium.com 클론)을 Go + React로 구현하는 바이브 코딩 학습 프로젝트입니다. [RealWorld 스펙](https://realworld-docs.netlify.app/)과 [Armin Ronacher의 Agentic Coding](http://lucumr.pocoo.org/2025/6/12/agentic-coding/) 권장 기술 스택을 따릅니다.

## Commands

```bash
# 개발 서버 실행
make dev

# 프로덕션 빌드
make build

# 테스트 실행
make test

# E2E 테스트
make test-e2e

# 린트
make lint

# Docker로 실행
docker-compose up
```

## Architecture

### Tech Stack

- **Frontend**: React + TypeScript + Vite + TanStack Router/Query + Zustand + Tailwind CSS + shadcn/ui
- **Backend**: Go + Chi + SQLite + sqlc + golang-jwt + bcrypt
- **DevOps**: Docker + Docker Compose + Makefile + Playwright

### Project Structure

```
realworld-app/
├── frontend/           # React SPA (Hash 라우팅 /#/)
├── backend/            # Go REST API
│   ├── cmd/server/     # 엔트리포인트
│   ├── internal/       # 비공개 패키지
│   │   ├── handler/    # HTTP 핸들러
│   │   ├── service/    # 비즈니스 로직
│   │   ├── repository/ # 데이터 액세스
│   │   └── middleware/ # JWT 인증, CORS, 로깅
│   └── pkg/            # 공용 패키지
└── docs/               # PRD, 설계 문서, 작업 목록
```

### Backend Layers

Handler → Service → Repository → SQLite (sqlc로 타입 안전한 SQL)

### Frontend State Management

- **서버 상태**: TanStack Query (캐싱, 자동 갱신)
- **클라이언트 상태**: Zustand (인증 상태)

### API Authentication

```
Authorization: Token jwt.token.here
```

## Key Documents

- [PRD](docs/PRD.md) - 제품 요구사항
- [설계 문서](docs/DESIGN.md) - 아키텍처, ERD, API 명세
- [작업 목록](docs/tasks.md) - 구현 체크리스트
