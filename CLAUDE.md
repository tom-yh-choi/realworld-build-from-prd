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

## Development Guidelines

### Test-Driven Development (TDD)

- Backend and core logic MUST be implemented using TDD approach
- Write tests first, then implement the code to pass the tests
- Follow the Red-Green-Refactor cycle:
  1. **Red**: Write a failing test
  2. **Green**: Write minimal code to pass the test
  3. **Refactor**: Improve the code while keeping tests green

### SOLID Principles & Clean Architecture

- Apply SOLID principles throughout the codebase:
  - **S**ingle Responsibility: Each module/class should have one reason to change
  - **O**pen/Closed: Open for extension, closed for modification
  - **L**iskov Substitution: Subtypes must be substitutable for their base types
  - **I**nterface Segregation: Prefer small, specific interfaces
  - **D**ependency Inversion: Depend on abstractions, not concretions
- Follow Clean Architecture layers:
  - Entities (domain models) → Use Cases (business logic) → Interface Adapters (handlers, repositories) → Frameworks (DB, HTTP)
- Dependencies should point inward (from frameworks to entities)

### Commit & Issue Tracking

- Each commit should represent a completed unit of work
- After each commit, verify that the work meets the acceptance criteria
- Add a comment to the related GitHub issue confirming which acceptance criteria have been satisfied
- **IMPORTANT**: Do NOT close issues automatically. Issues should only be closed manually by the user after review.
- Comment format:
  ```
  ✅ AC verified by commit [commit-hash]:
  - [x] Acceptance criteria item 1
  - [x] Acceptance criteria item 2
  ```

### GitHub CLI 사용

- 모든 GitHub 관련 작업은 `gh` CLI를 사용하여 수행
- 주요 명령어:
  ```bash
  # 이슈 목록 조회
  gh issue list

  # 이슈 상세 조회
  gh issue view <issue-number>

  # 이슈 생성
  gh issue create --title "제목" --body "내용"

  # 이슈에 코멘트 추가
  gh issue comment <issue-number> --body "코멘트 내용"

  # 이슈 본문 수정
  gh issue edit <issue-number> --body "수정된 내용"

  # PR 생성
  gh pr create --title "제목" --body "내용"

  # PR 목록 조회
  gh pr list
  ```
- MCP GitHub 도구 대신 `gh` CLI 사용을 우선시할 것
