# RealWorld App PRD (Product Requirements Document)

## 1. 프로젝트 개요

### 1.1 프로젝트 목적
RealWorld는 Medium.com 클론 애플리케이션으로, 다양한 프론트엔드/백엔드 기술 스택으로 동일한 애플리케이션을 구현할 수 있는 레퍼런스 프로젝트입니다.

### 1.2 해결하고자 하는 문제
- 기존의 "Todo" 데모 앱은 실제 개발에 필요한 복잡성을 다루지 못함
- RealWorld는 실제 프로덕션 수준의 기능을 포함한 완전한 애플리케이션 스펙을 제공

### 1.3 핵심 특징
- 150개 이상의 다양한 언어, 라이브러리, 프레임워크 구현체 존재
- 모든 프론트엔드는 어떤 백엔드와도 연동 가능 (표준화된 API 스펙)
- Tailwind CSS + shadcn/ui를 사용한 일관된 UI/UX

---

## 2. 기능 요구사항

### 2.1 사용자 인증 (Authentication)

#### 2.1.1 회원가입
- **URL**: `/#/register`
- **필수 입력**: username, email, password
- **기능**: 새 사용자 계정 생성
- **성공 시**: JWT 토큰 발급 및 localStorage 저장

#### 2.1.2 로그인
- **URL**: `/#/login`
- **필수 입력**: email, password
- **기능**: 기존 사용자 인증
- **성공 시**: JWT 토큰 발급 및 localStorage 저장

#### 2.1.3 로그아웃
- **위치**: Settings 페이지
- **기능**: localStorage에서 토큰 제거, 로그아웃 처리

### 2.2 사용자 프로필 (User Profile)

#### 2.2.1 프로필 조회
- **URL**: `/#/profile/:username`
- **표시 정보**: 프로필 이미지, username, bio
- **탭**: My Articles / Favorited Articles

#### 2.2.2 사용자 설정
- **URL**: `/#/settings`
- **수정 가능 항목**:
  - 프로필 이미지 URL
  - Username
  - Bio (자기소개)
  - Email
  - Password

#### 2.2.3 팔로우/언팔로우
- 다른 사용자를 팔로우/언팔로우 가능
- 인증된 사용자만 가능

### 2.3 게시글 (Articles)

#### 2.3.1 게시글 목록 조회
- **URL**: `/#/` (홈페이지)
- **피드 종류**:
  - **Your Feed**: 팔로우한 사용자의 게시글 (인증 필요)
  - **Global Feed**: 전체 게시글
  - **Tag Feed**: 특정 태그의 게시글
- **페이지네이션**: 기본 20개, offset으로 페이지 이동
- **정렬**: 최신순

#### 2.3.2 게시글 상세 조회
- **URL**: `/#/article/:slug`
- **표시 정보**:
  - 제목, 본문 (Markdown 렌더링)
  - 작성자 정보, 작성일
  - 좋아요 수
  - 댓글 목록

#### 2.3.3 게시글 작성
- **URL**: `/#/editor`
- **필수 입력**: title, description, body
- **선택 입력**: tagList (태그 배열)
- **인증 필요**

#### 2.3.4 게시글 수정
- **URL**: `/#/editor/:slug`
- **수정 가능**: title, description, body
- **권한**: 작성자만 수정 가능

#### 2.3.5 게시글 삭제
- **권한**: 작성자만 삭제 가능

### 2.4 댓글 (Comments)

#### 2.4.1 댓글 조회
- 게시글 상세 페이지에서 댓글 목록 표시
- 인증 없이 조회 가능

#### 2.4.2 댓글 작성
- **필수 입력**: body (댓글 내용)
- **인증 필요**

#### 2.4.3 댓글 삭제
- **권한**: 댓글 작성자만 삭제 가능

### 2.5 좋아요 (Favorites)

#### 2.5.1 좋아요 추가/취소
- 게시글에 좋아요 추가/취소 가능
- **인증 필요**
- 좋아요한 게시글은 프로필의 Favorited Articles에 표시

### 2.6 태그 (Tags)

#### 2.6.1 태그 목록
- 홈페이지 사이드바에 인기 태그 표시
- 태그 클릭 시 해당 태그의 게시글 필터링

---

## 3. 페이지 구조 및 라우팅

### 3.1 라우팅 테이블

| 경로 | 페이지 | 인증 필요 |
|------|--------|----------|
| `/#/` | 홈페이지 | 선택 |
| `/#/login` | 로그인 | 불필요 |
| `/#/register` | 회원가입 | 불필요 |
| `/#/settings` | 설정 | 필수 |
| `/#/editor` | 새 글 작성 | 필수 |
| `/#/editor/:slug` | 글 수정 | 필수 |
| `/#/article/:slug` | 글 상세 | 선택 |
| `/#/profile/:username` | 프로필 | 선택 |
| `/#/profile/:username/favorites` | 좋아요 목록 | 선택 |

### 3.2 네비게이션

#### 비인증 상태
- Home
- Sign in
- Sign up

#### 인증 상태
- Home
- New Article (아이콘: compose)
- Settings (아이콘: gear)
- Profile (사용자 아바타 포함)

---

## 4. API 스펙

### 4.1 인증 헤더
```
Authorization: Token jwt.token.here
```

### 4.2 API 엔드포인트

#### 인증 API
| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| POST | `/api/users/login` | 로그인 | 불필요 |
| POST | `/api/users` | 회원가입 | 불필요 |
| GET | `/api/user` | 현재 사용자 조회 | 필수 |
| PUT | `/api/user` | 사용자 정보 수정 | 필수 |

#### 프로필 API
| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| GET | `/api/profiles/:username` | 프로필 조회 | 선택 |
| POST | `/api/profiles/:username/follow` | 팔로우 | 필수 |
| DELETE | `/api/profiles/:username/follow` | 언팔로우 | 필수 |

#### 게시글 API
| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| GET | `/api/articles` | 게시글 목록 | 선택 |
| GET | `/api/articles/feed` | 피드 | 필수 |
| GET | `/api/articles/:slug` | 게시글 상세 | 선택 |
| POST | `/api/articles` | 게시글 작성 | 필수 |
| PUT | `/api/articles/:slug` | 게시글 수정 | 필수 |
| DELETE | `/api/articles/:slug` | 게시글 삭제 | 필수 |

#### 댓글 API
| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| GET | `/api/articles/:slug/comments` | 댓글 목록 | 선택 |
| POST | `/api/articles/:slug/comments` | 댓글 작성 | 필수 |
| DELETE | `/api/articles/:slug/comments/:id` | 댓글 삭제 | 필수 |

#### 좋아요 API
| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| POST | `/api/articles/:slug/favorite` | 좋아요 | 필수 |
| DELETE | `/api/articles/:slug/favorite` | 좋아요 취소 | 필수 |

#### 태그 API
| Method | Endpoint | 설명 | 인증 |
|--------|----------|------|------|
| GET | `/api/tags` | 태그 목록 | 불필요 |

### 4.3 Query Parameters (게시글 목록)
| Parameter | 설명 | 기본값 |
|-----------|------|--------|
| `tag` | 태그 필터 | - |
| `author` | 작성자 필터 | - |
| `favorited` | 좋아요한 사용자 필터 | - |
| `limit` | 페이지당 개수 | 20 |
| `offset` | 시작 위치 | 0 |

### 4.4 에러 응답 형식

#### HTTP 상태 코드
| 코드 | 설명 |
|------|------|
| 401 | 인증 필요 |
| 403 | 권한 없음 |
| 404 | 리소스 없음 |
| 422 | 유효성 검사 실패 |

#### 에러 응답 구조
```json
{
  "errors": {
    "body": [
      "can't be empty"
    ]
  }
}
```

---

## 5. 데이터 모델

### 5.1 User
```json
{
  "user": {
    "email": "jake@jake.jake",
    "token": "jwt.token.here",
    "username": "jake",
    "bio": "I work at statefarm",
    "image": "https://api.realworld.io/images/smiley-cyrus.jpg"
  }
}
```

### 5.2 Profile
```json
{
  "profile": {
    "username": "jake",
    "bio": "I work at statefarm",
    "image": "https://api.realworld.io/images/smiley-cyrus.jpg",
    "following": false
  }
}
```

### 5.3 Article
```json
{
  "article": {
    "slug": "how-to-train-your-dragon",
    "title": "How to train your dragon",
    "description": "Ever wonder how?",
    "body": "It takes a Jacobian",
    "tagList": ["dragons", "training"],
    "createdAt": "2016-02-18T03:22:56.637Z",
    "updatedAt": "2016-02-18T03:48:35.824Z",
    "favorited": false,
    "favoritesCount": 0,
    "author": {
      "username": "jake",
      "bio": "I work at statefarm",
      "image": "https://api.realworld.io/images/smiley-cyrus.jpg",
      "following": false
    }
  }
}
```

### 5.4 Comment
```json
{
  "comment": {
    "id": 1,
    "createdAt": "2016-02-18T03:22:56.637Z",
    "updatedAt": "2016-02-18T03:22:56.637Z",
    "body": "It takes a Jacobian",
    "author": {
      "username": "jake",
      "bio": "I work at statefarm",
      "image": "https://api.realworld.io/images/smiley-cyrus.jpg",
      "following": false
    }
  }
}
```

### 5.5 Tags
```json
{
  "tags": ["reactjs", "angularjs"]
}
```

---

## 6. UI/UX 요구사항

### 6.1 디자인 시스템
- **CSS 프레임워크**: Tailwind CSS
- **폰트**:
  - Titillium Web
  - Source Serif Pro
  - Merriweather Sans
  - Source Sans Pro
- **아이콘**: Ionicons

### 6.2 레이아웃 구조

#### Header (네비게이션)
- 로고: "conduit"
- 메뉴 항목: 상태에 따라 변경
- 현재 페이지 active 표시

#### Footer
- 브랜딩 정보
- 저작권 표시 (MIT License)

### 6.3 주요 컴포넌트

#### Article Preview
- 작성자 아바타
- 작성자 이름
- 작성일
- 좋아요 버튼 및 카운트
- 제목
- 설명
- 태그 목록

#### Pagination
- 페이지 번호 표시
- 현재 페이지 하이라이트

#### Tag List
- 클릭 가능한 태그 pills
- 삭제 가능 (에디터에서)

---

## 7. 기술 스택

> 기술 스택 선정은 [Agentic Coding](http://lucumr.pocoo.org/2025/6/12/agentic-coding/) 권장사항을 기반으로 합니다.

### 7.1 프론트엔드

| 영역 | 기술 | 비고 |
|------|------|------|
| 언어 | TypeScript | 타입 안전성 |
| UI 라이브러리 | React | 함수형 컴포넌트 |
| 빌드 도구 | Vite | 빠른 개발 서버 |
| UI 컴포넌트 | shadcn/ui | 재사용 가능한 컴포넌트 |
| 스타일링 | Tailwind CSS | 유틸리티 기반 |
| 라우팅 | TanStack Router | Hash 기반 (`/#/`) |
| 서버 상태 | TanStack Query | 캐싱 및 동기화 |
| 클라이언트 상태 | Zustand | 경량 상태 관리 |
| Markdown | react-markdown | 게시글 렌더링 |

**요구사항**:
- Hash 기반 라우팅 (`/#/`)
- JWT 토큰 localStorage 저장
- Markdown 렌더링 지원
- 반응형 디자인

### 7.2 백엔드

| 영역 | 기술 | 비고 |
|------|------|------|
| 언어 | Go | 명시적 Context, 빠른 테스트 |
| HTTP 라우터 | Chi 또는 표준 라이브러리 | 단순함 우선 |
| 데이터베이스 | SQLite | 단일 파일 DB |
| SQL | 직접 SQL 사용 (sqlc 권장) | ORM 미사용 |
| 인증 | golang-jwt | JWT 토큰 생성/검증 |
| 비밀번호 | bcrypt | 해싱 |

**요구사항**:
- RESTful API
- JWT 인증
- CORS 설정
- 일관된 에러 응답 형식

### 7.3 개발 환경

| 영역 | 도구 | 비고 |
|------|------|------|
| 실행 환경 | Docker | 컨테이너 기반 배포 |
| 오케스트레이션 | Docker Compose | 프론트엔드 + 백엔드 통합 |
| 빌드/실행 | Makefile | `make dev`, `make build`, `make test` |
| 로깅 | 파일 기반 로깅 | 디버깅용 |
| 백엔드 테스트 | Go 표준 테스트 | `go test ./...` |
| E2E 테스트 | Playwright | 브라우저 자동화 |

### 7.4 보안

- **Password 해싱**: bcrypt 사용
- **JWT 토큰 기반 인증**: 만료 시간 설정
- **권한 검증**: 핸들러 레벨에서 명시적 작성자 확인
- **HTTPS**: 프로덕션 환경 필수

---

## 8. 참고 자료

- **공식 문서**: https://realworld-docs.netlify.app/
- **API 스펙**: https://realworld-docs.netlify.app/specifications/backend/endpoints/
- **프론트엔드 스펙**: https://realworld-docs.netlify.app/specifications/frontend/
- **GitHub**: https://github.com/gothinkster/realworld
