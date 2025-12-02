# RealWorld App - Vibe Coding Edition

> **Go + React** 기반의 RealWorld 구현체로, CRUD 작업, 인증, 라우팅, 페이지네이션 등 실제 애플리케이션에 필요한 기능을 포함합니다.

이 프로젝트는 [RealWorld](https://github.com/gothinkster/realworld) 스펙을 준수하며, [Armin Ronacher의 Agentic Coding](http://lucumr.pocoo.org/2025/6/12/agentic-coding/) 권장 기술 스택을 사용하여 **바이브 코딩(Vibe Coding)** 기법으로 구현됩니다.

### [Demo](https://demo.realworld.io/) · [RealWorld Spec](https://realworld-docs.netlify.app/)

---

## 프로젝트 목적

이 프로젝트는 **바이브 코딩 학습**을 위한 실험적 프로젝트입니다:

- **RealWorld 스펙**: Medium.com 클론으로, 단순한 Todo 앱을 넘어선 실제 프로덕션 수준의 복잡성을 다룹니다
- **바이브 코딩**: AI 어시스턴트와 협업하여 빠르게 애플리케이션을 구축하는 개발 방식을 실험합니다
- **권장 기술 스택**: Armin Ronacher가 제안한 AI 친화적인 기술 스택을 채택하여 효율적인 개발을 목표로 합니다

---

## 기술 스택

### Frontend
| 영역 | 기술 |
|------|------|
| 언어 | TypeScript |
| UI 라이브러리 | React |
| 빌드 도구 | Vite |
| UI 컴포넌트 | shadcn/ui |
| 스타일링 | Tailwind CSS |
| 라우팅 | TanStack Router |
| 서버 상태 | TanStack Query |
| 클라이언트 상태 | Zustand |

### Backend
| 영역 | 기술 |
|------|------|
| 언어 | Go |
| HTTP 라우터 | Chi / 표준 라이브러리 |
| 데이터베이스 | SQLite |
| SQL | sqlc (ORM 미사용) |
| 인증 | golang-jwt + bcrypt |

### DevOps
| 영역 | 기술 |
|------|------|
| 컨테이너 | Docker |
| 오케스트레이션 | Docker Compose |
| 빌드/실행 | Makefile |
| E2E 테스트 | Playwright |

---

## 주요 기능

- **인증**: 회원가입, 로그인, JWT 기반 인증
- **게시글**: CRUD 작업, Markdown 렌더링
- **댓글**: 게시글에 댓글 작성/삭제
- **프로필**: 사용자 프로필 조회, 팔로우/언팔로우
- **좋아요**: 게시글 좋아요 추가/취소
- **태그**: 태그 기반 게시글 필터링

---

## 시작하기

### 사전 요구사항
- Go 1.21+
- Node.js 20+
- Docker & Docker Compose (선택사항)

### 개발 서버 실행

```bash
# 의존성 설치
make install

# 개발 서버 실행 (프론트엔드 + 백엔드)
make dev
```

### Docker로 실행

```bash
docker-compose up
```

### 테스트

```bash
# 전체 테스트
make test

# E2E 테스트
make test-e2e
```

---

## 프로젝트 구조

```
realworld-app/
├── frontend/          # React 프론트엔드
├── backend/           # Go 백엔드
├── docs/              # 문서
│   ├── PRD.md         # 제품 요구사항 문서
│   └── tasks.md       # 구현 작업 목록
├── docker-compose.yml
├── Makefile
└── README.md
```

---

## 문서

- [PRD (제품 요구사항)](./docs/PRD.md)
- [구현 작업 목록](./docs/tasks.md)

---

## 참고 자료

- [RealWorld 공식 문서](https://realworld-docs.netlify.app/)
- [RealWorld GitHub](https://github.com/gothinkster/realworld)
- [Agentic Coding - Armin Ronacher](http://lucumr.pocoo.org/2025/6/12/agentic-coding/)
- [RealWorld Starter Kit](https://github.com/gothinkster/realworld-starter-kit)

---

## 라이선스

MIT License
