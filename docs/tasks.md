# RealWorld App 구현 작업 목록

> PRD.md와 [RealWorld 공식 문서](https://realworld-docs.netlify.app/)를 기반으로 작성된 구현 작업 목록입니다.

---

## Phase 1: 프로젝트 초기 설정

### 1.1 디렉토리 구조 설정
- [ ] 모노레포 구조 생성 (`frontend/`, `backend/`, `docs/`, `scripts/`)
- [ ] `.gitignore` 업데이트 (node_modules, Go 빌드 파일, SQLite DB 등)
- [ ] `.editorconfig` 설정

### 1.2 Makefile 작성
- [ ] `make dev` - 개발 서버 실행 (프론트엔드 + 백엔드)
- [ ] `make build` - 프로덕션 빌드
- [ ] `make test` - 전체 테스트 실행
- [ ] `make lint` - 린트 검사

### 1.3 Docker 설정
- [ ] 프론트엔드 Dockerfile 작성
- [ ] 백엔드 Dockerfile 작성
- [ ] Docker Compose 설정 (통합 실행 환경)
- [ ] `.dockerignore` 파일 작성

### 1.4 개발 환경 설정
- [ ] Git hooks 설정 (pre-commit)
- [ ] ESLint + Prettier 설정 (프론트엔드)
- [ ] golangci-lint 설정 (백엔드)

---

## Phase 2: 백엔드 개발

### 2.1 프로젝트 기반 구축
- [ ] Go 모듈 초기화 (`go mod init`)
- [ ] 디렉토리 구조 설정
  - `cmd/server/` - 메인 엔트리포인트
  - `internal/handler/` - HTTP 핸들러
  - `internal/service/` - 비즈니스 로직
  - `internal/repository/` - 데이터 액세스
  - `internal/model/` - 데이터 모델
  - `internal/middleware/` - 미들웨어
  - `pkg/` - 공용 패키지
- [ ] HTTP 라우터 설정 (Chi 또는 표준 라이브러리)
- [ ] 설정 관리 (환경 변수, config 파일)
- [ ] 기본 미들웨어 구현
  - CORS 미들웨어
  - 로깅 미들웨어
  - Recovery 미들웨어 (패닉 처리)

### 2.2 데이터베이스 계층
- [ ] SQLite 연결 설정
- [ ] 데이터베이스 스키마 설계
  ```sql
  - users (id, email, username, password_hash, bio, image, created_at, updated_at)
  - articles (id, slug, title, description, body, author_id, created_at, updated_at)
  - comments (id, body, article_id, author_id, created_at, updated_at)
  - tags (id, name)
  - article_tags (article_id, tag_id)
  - favorites (user_id, article_id)
  - follows (follower_id, following_id)
  ```
- [ ] 마이그레이션 스크립트 작성
- [ ] sqlc 설정 및 쿼리 작성
  - 사용자 CRUD 쿼리
  - 게시글 CRUD 쿼리
  - 댓글 CRUD 쿼리
  - 태그 쿼리
  - 팔로우/좋아요 쿼리

### 2.3 인증 시스템
- [ ] 비밀번호 해싱 (bcrypt)
- [ ] JWT 토큰 생성/검증 (golang-jwt)
  - 토큰 생성 함수
  - 토큰 검증 함수
  - 토큰 만료 시간 설정
- [ ] 인증 미들웨어 구현
  - `Authorization: Token jwt.token.here` 헤더 파싱
  - 선택적 인증 (인증 없이도 접근 가능한 엔드포인트)
  - 필수 인증 (인증 필요 엔드포인트)

### 2.4 사용자 API
- [ ] `POST /api/users` - 회원가입
  - 입력: username, email, password
  - 출력: User 객체 + JWT 토큰
  - 유효성 검사: 이메일 형식, 중복 체크
- [ ] `POST /api/users/login` - 로그인
  - 입력: email, password
  - 출력: User 객체 + JWT 토큰
  - 에러: 401 (잘못된 인증 정보)
- [ ] `GET /api/user` - 현재 사용자 조회 (인증 필수)
  - 출력: User 객체
- [ ] `PUT /api/user` - 사용자 정보 수정 (인증 필수)
  - 입력: email, username, password, image, bio (선택)
  - 출력: 수정된 User 객체

### 2.5 프로필 API
- [ ] `GET /api/profiles/:username` - 프로필 조회 (인증 선택)
  - 출력: Profile 객체 (username, bio, image, following)
- [ ] `POST /api/profiles/:username/follow` - 팔로우 (인증 필수)
  - 출력: Profile 객체 (following: true)
- [ ] `DELETE /api/profiles/:username/follow` - 언팔로우 (인증 필수)
  - 출력: Profile 객체 (following: false)

### 2.6 게시글 API
- [ ] `GET /api/articles` - 게시글 목록 (인증 선택)
  - Query: tag, author, favorited, limit(20), offset(0)
  - 출력: articles 배열 + articlesCount
  - 정렬: 최신순
- [ ] `GET /api/articles/feed` - 팔로우 피드 (인증 필수)
  - Query: limit(20), offset(0)
  - 출력: 팔로우한 사용자의 게시글
- [ ] `GET /api/articles/:slug` - 게시글 상세 (인증 선택)
  - 출력: Article 객체
- [ ] `POST /api/articles` - 게시글 작성 (인증 필수)
  - 입력: title, description, body, tagList (선택)
  - 출력: Article 객체
  - slug 자동 생성 (title 기반)
- [ ] `PUT /api/articles/:slug` - 게시글 수정 (인증 필수)
  - 권한: 작성자만
  - 입력: title, description, body (선택)
  - 출력: 수정된 Article 객체
- [ ] `DELETE /api/articles/:slug` - 게시글 삭제 (인증 필수)
  - 권한: 작성자만

### 2.7 좋아요 API
- [ ] `POST /api/articles/:slug/favorite` - 좋아요 (인증 필수)
  - 출력: Article 객체 (favorited: true, favoritesCount 증가)
- [ ] `DELETE /api/articles/:slug/favorite` - 좋아요 취소 (인증 필수)
  - 출력: Article 객체 (favorited: false, favoritesCount 감소)

### 2.8 댓글 API
- [ ] `GET /api/articles/:slug/comments` - 댓글 목록 (인증 선택)
  - 출력: comments 배열
- [ ] `POST /api/articles/:slug/comments` - 댓글 작성 (인증 필수)
  - 입력: body
  - 출력: Comment 객체
- [ ] `DELETE /api/articles/:slug/comments/:id` - 댓글 삭제 (인증 필수)
  - 권한: 댓글 작성자만

### 2.9 태그 API
- [ ] `GET /api/tags` - 태그 목록 (인증 불필요)
  - 출력: tags 배열 (문자열 목록)

### 2.10 에러 처리
- [ ] 표준 에러 응답 형식 구현
  ```json
  {
    "errors": {
      "body": ["can't be empty"]
    }
  }
  ```
- [ ] HTTP 상태 코드 처리
  - 401: 인증 필요
  - 403: 권한 없음
  - 404: 리소스 없음
  - 422: 유효성 검사 실패
- [ ] 유효성 검사 미들웨어

### 2.11 백엔드 테스트
- [ ] 단위 테스트 작성 (service 계층)
- [ ] 통합 테스트 작성 (API 엔드포인트)
- [ ] 테스트 데이터베이스 설정

---

## Phase 3: 프론트엔드 개발

### 3.1 프로젝트 기반 구축
- [ ] Vite + React + TypeScript 프로젝트 생성
- [ ] Tailwind CSS 설정
- [ ] shadcn/ui 설정 및 기본 컴포넌트 설치
- [ ] TanStack Router 설정 (Hash 기반 라우팅 `/#/`)
- [ ] TanStack Query 설정
- [ ] Zustand 스토어 설정 (인증 상태 관리)
- [ ] API 클라이언트 설정
  - Axios 또는 fetch wrapper
  - 인터셉터 (JWT 토큰 자동 첨부)
  - 에러 핸들링

### 3.2 타입 정의
- [ ] User 타입
- [ ] Profile 타입
- [ ] Article 타입
- [ ] Comment 타입
- [ ] API 응답 타입

### 3.3 레이아웃 컴포넌트
- [ ] Header 컴포넌트
  - 로고 ("conduit")
  - 비인증 상태: Home, Sign in, Sign up
  - 인증 상태: Home, New Article, Settings, Profile (아바타)
  - 현재 페이지 active 표시
- [ ] Footer 컴포넌트
  - 브랜딩 정보
  - 저작권 표시
- [ ] Layout 래퍼 컴포넌트

### 3.4 인증 페이지
- [ ] 로그인 페이지 (`/#/login`)
  - 이메일, 비밀번호 입력 폼
  - 에러 메시지 표시
  - 회원가입 링크
  - 로그인 성공 시 홈으로 리다이렉트
- [ ] 회원가입 페이지 (`/#/register`)
  - username, 이메일, 비밀번호 입력 폼
  - 에러 메시지 표시
  - 로그인 링크
  - 가입 성공 시 홈으로 리다이렉트
- [ ] 인증 상태 관리
  - JWT 토큰 localStorage 저장/조회/삭제
  - Zustand 스토어에 사용자 정보 저장
  - 앱 시작 시 토큰 유효성 검사

### 3.5 설정 페이지
- [ ] 설정 페이지 (`/#/settings`)
  - 프로필 이미지 URL 입력
  - Username 입력
  - Bio (자기소개) 텍스트영역
  - Email 입력
  - 새 비밀번호 입력
  - 업데이트 버튼
  - 로그아웃 버튼
- [ ] 폼 유효성 검사
- [ ] 업데이트 성공/실패 피드백

### 3.6 홈페이지
- [ ] 홈페이지 (`/#/`)
- [ ] 피드 탭 컴포넌트
  - Your Feed (인증 시에만 표시, 팔로우한 사용자 게시글)
  - Global Feed (전체 게시글)
  - Tag Feed (태그 클릭 시 동적 추가)
- [ ] 게시글 목록 컴포넌트
  - 무한 스크롤 또는 페이지네이션
  - 로딩 상태 표시
  - 빈 상태 처리
- [ ] 인기 태그 사이드바
  - 태그 목록 표시
  - 태그 클릭 시 필터링

### 3.7 게시글 프리뷰 컴포넌트
- [ ] ArticlePreview 컴포넌트
  - 작성자 아바타
  - 작성자 이름 (프로필 링크)
  - 작성일
  - 좋아요 버튼 및 카운트
  - 게시글 제목 (상세 페이지 링크)
  - 게시글 설명
  - 태그 목록

### 3.8 페이지네이션 컴포넌트
- [ ] Pagination 컴포넌트
  - 페이지 번호 표시
  - 현재 페이지 하이라이트
  - 페이지 이동 기능

### 3.9 게시글 에디터
- [ ] 새 글 작성 페이지 (`/#/editor`)
- [ ] 글 수정 페이지 (`/#/editor/:slug`)
- [ ] 에디터 폼 컴포넌트
  - 제목 입력
  - 설명 입력
  - 본문 입력 (Markdown)
  - 태그 입력 (Enter로 추가)
  - 태그 목록 표시 (삭제 가능)
  - 발행 버튼
- [ ] 수정 시 기존 데이터 로드
- [ ] 폼 유효성 검사

### 3.10 게시글 상세 페이지
- [ ] 게시글 상세 페이지 (`/#/article/:slug`)
- [ ] 게시글 배너
  - 제목
  - 작성자 정보 (아바타, 이름, 작성일)
  - 액션 버튼 (팔로우, 좋아요)
  - 작성자인 경우: 수정, 삭제 버튼
- [ ] 게시글 본문
  - Markdown 렌더링 (react-markdown)
  - 태그 목록
- [ ] 댓글 섹션
  - 댓글 작성 폼 (인증 시)
  - 댓글 목록
  - 댓글 삭제 버튼 (작성자만)

### 3.11 프로필 페이지
- [ ] 프로필 페이지 (`/#/profile/:username`)
- [ ] 좋아요한 글 탭 (`/#/profile/:username/favorites`)
- [ ] 프로필 헤더
  - 프로필 이미지
  - Username
  - Bio
  - 팔로우/언팔로우 버튼 (다른 사용자)
  - 설정 버튼 (본인 프로필)
- [ ] 게시글 탭
  - My Articles (작성한 글)
  - Favorited Articles (좋아요한 글)
- [ ] 게시글 목록 (ArticlePreview 재사용)

### 3.12 공통 컴포넌트
- [ ] FollowButton 컴포넌트
- [ ] FavoriteButton 컴포넌트
- [ ] TagList 컴포넌트
- [ ] ErrorMessages 컴포넌트
- [ ] LoadingSpinner 컴포넌트

### 3.13 라우트 가드
- [ ] 인증 필요 라우트 보호 (settings, editor)
- [ ] 인증 시 접근 불가 라우트 (login, register)
- [ ] 리다이렉트 처리

---

## Phase 4: 통합 및 테스트

### 4.1 프론트엔드-백엔드 통합
- [ ] API 엔드포인트 연결 테스트
- [ ] CORS 설정 검증
- [ ] 인증 플로우 통합 테스트

### 4.2 E2E 테스트 (Playwright)
- [ ] Playwright 설정
- [ ] 회원가입/로그인 플로우 테스트
- [ ] 게시글 CRUD 플로우 테스트
- [ ] 댓글 CRUD 플로우 테스트
- [ ] 프로필 및 팔로우 플로우 테스트
- [ ] 좋아요 기능 테스트

### 4.3 크로스 브라우저 테스트
- [ ] Chrome 테스트
- [ ] Firefox 테스트
- [ ] Safari 테스트

---

## Phase 5: 배포 설정

### 5.1 Docker 이미지 최적화
- [ ] 프론트엔드 멀티스테이지 빌드
- [ ] 백엔드 멀티스테이지 빌드
- [ ] 이미지 크기 최적화

### 5.2 Docker Compose 설정
- [ ] 개발 환경 compose 파일 (`docker-compose.dev.yml`)
- [ ] 프로덕션 환경 compose 파일 (`docker-compose.yml`)
- [ ] 볼륨 설정 (SQLite 데이터 영속성)

### 5.3 환경 설정
- [ ] 환경 변수 문서화
- [ ] `.env.example` 파일 작성
- [ ] 프로덕션/개발 환경 분리

---

## 참고 자료

- [RealWorld 공식 문서](https://realworld-docs.netlify.app/)
- [API 스펙](https://realworld-docs.netlify.app/specifications/backend/endpoints/)
- [프론트엔드 라우팅 스펙](https://realworld-docs.netlify.app/specifications/frontend/routing/)
- [GitHub - RealWorld](https://github.com/gothinkster/realworld)
