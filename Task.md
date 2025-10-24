# 🏠 Edu Trip Market - 홈 화면 UI 개발 태스크 목록

> **프로젝트**: Edu Trip Market (해외 영어 캠프 전문 플랫폼)  
> **목표**: 홈 화면 UI 구현을 통한 MVP 개발  
> **기간**: 2-3주 (우선순위별 단계적 개발)

---

## 📋 Phase 1: 프로젝트 기반 설정 (1-2일)

### 🔧 1.1 의존성 패키지 설정
- [x] `pubspec.yaml`에 필요한 패키지 추가
  - [x] `google_fonts` (Noto Sans KR 폰트)
  - [x] `flutter_dotenv` (환경변수 관리)
  - [x] `provider` (상태 관리)
  - [x] `http` (API 통신)
  - [x] `cached_network_image` (이미지 캐싱)
  - [x] `shimmer` (로딩 애니메이션)
  - [x] `intl` (국제화)

### 🎨 1.2 디자인 시스템 구현
- [x] `lib/shared/theme/` 폴더에 테마 파일 생성
  - [x] `app_colors.dart` - 색상 토큰 정의
  - [x] `app_text_theme.dart` - 타이포그래피 시스템
  - [x] `app_theme.dart` - 라이트/다크 테마 통합
  - [x] `app_dimensions.dart` - 간격, 크기 상수

### 🏗️ 1.3 폴더 구조 정리
- [x] `lib/features/home/presentation/` 구조 완성
  - [x] `pages/` - 홈 화면 페이지
  - [x] `widgets/` - 홈 전용 위젯들
  - [x] `providers/` - 홈 상태 관리

---

## 📋 Phase 2: 데이터 모델 및 서비스 설정 (2-3일)

### 📊 2.1 데이터 모델 생성
- [x] `lib/features/home/domain/entities/` 생성
  - [x] `camp_entity.dart` - 캠프 엔티티
  - [x] `camp_category_entity.dart` - 캠프 카테고리
  - [x] `camp_review_entity.dart` - 캠프 리뷰

- [x] `lib/features/home/data/models/` 생성
  - [x] `camp_model.dart` - 캠프 모델 (JSON 직렬화)
  - [x] `camp_category_model.dart` - 카테고리 모델
  - [x] `camp_review_model.dart` - 리뷰 모델

### 🔌 2.2 API 서비스 설정
- [x] `lib/features/home/data/datasources/` 생성
  - [x] `camp_remote_datasource.dart` - 캠프 API 호출
  - [x] `camp_local_datasource.dart` - 로컬 캐시 관리

- [x] `lib/features/home/domain/repositories/` 생성
  - [x] `camp_repository.dart` - 캠프 데이터 인터페이스

- [x] `lib/features/home/data/repositories/` 생성
  - [x] `camp_repository_impl.dart` - 캠프 데이터 구현체

### 🎯 2.3 Use Case 구현
- [x] `lib/features/home/domain/usecases/` 생성
  - [x] `get_featured_camps.dart` - 추천 캠프 조회
  - [x] `get_camp_categories.dart` - 카테고리 조회
  - [x] `search_camps.dart` - 캠프 검색
  - [x] `get_popular_camps.dart` - 인기 캠프 조회
  - [x] `get_camp_by_id.dart` - 캠프 상세 조회

---

## 📋 Phase 3: 공통 컴포넌트 개발 (3-4일)

### 🧩 3.1 기본 UI 컴포넌트
- [x] `lib/shared/widgets/` 컴포넌트 개발
  - [x] `custom_button.dart` - Primary/Secondary 버튼
  - [x] `custom_card.dart` - 기본 카드 컴포넌트
  - [x] `custom_text_field.dart` - 검색 입력창
  - [x] `loading_shimmer.dart` - 로딩 스켈레톤
  - [x] `rating_widget.dart` - 별점 위젯

### 🎨 3.2 홈 전용 위젯
- [x] `lib/features/home/presentation/widgets/` 개발
  - [x] `camp_card.dart` - 캠프 카드 위젯
  - [x] `category_chip.dart` - 카테고리 칩
  - [x] `search_bar.dart` - 검색바
  - [x] `featured_banner.dart` - 추천 배너
  - [x] `camp_list_view.dart` - 캠프 리스트

### 🎭 3.3 애니메이션 및 인터랙션
- [x] 페이지 전환 애니메이션
- [x] 카드 호버/탭 효과
- [x] 로딩 스피너 애니메이션
- [x] 스크롤 기반 페이드 인 효과

---

## 📋 Phase 4: 홈 화면 UI 구현 (4-5일)

### 🏠 4.1 홈 화면 레이아웃
- [x] `lib/features/home/presentation/pages/home_page.dart` 생성
  - [x] AppBar 구현 (로고, 알림, 프로필)
  - [x] 검색바 섹션
  - [x] 카테고리 필터 섹션
  - [x] 추천 캠프 배너
  - [x] 인기 캠프 리스트
  - [x] 하단 네비게이션 바

### 🔍 4.2 검색 및 필터 기능
- [x] 검색바 구현
  - [x] 실시간 검색 제안
  - [x] 검색 히스토리
  - [x] 검색 결과 화면

- [x] 필터 시스템
  - [x] 국가별 필터
  - [x] 가격대 필터
  - [x] 연령대 필터
  - [x] 기간별 필터

### 📱 4.3 반응형 디자인
- [x] 다양한 화면 크기 대응
- [x] 세로/가로 모드 지원
- [x] 태블릿 레이아웃 최적화

---

## 📋 Phase 5: 상태 관리 및 데이터 연동 (2-3일)

### 🔄 5.1 상태 관리 설정
- [x] `lib/features/home/presentation/providers/` 구현
  - [x] `home_provider.dart` - 홈 화면 상태 관리
  - [x] `search_provider.dart` - 검색 상태 관리
  - [x] `filter_provider.dart` - 필터 상태 관리

### 🌐 5.2 API 연동
- [x] Mock API 데이터 설정
- [x] 실제 API 엔드포인트 연동
- [x] 에러 핸들링 구현
- [x] 로딩 상태 관리

### 💾 5.3 로컬 캐싱
- [x] SharedPreferences 설정
- [x] 이미지 캐싱 최적화
- [x] 오프라인 데이터 지원

---

## 📋 Phase 6: 테스트 및 최적화 (2-3일)

### 🧪 6.1 단위 테스트
- [ ] 위젯 테스트 작성
- [ ] Provider 테스트
- [ ] API 서비스 테스트
- [ ] Use Case 테스트

### 🚀 6.2 성능 최적화
- [ ] 이미지 로딩 최적화
- [ ] 리스트 성능 최적화 (ListView.builder)
- [ ] 메모리 사용량 최적화
- [ ] 앱 시작 시간 최적화

### 🐛 6.3 버그 수정 및 QA
- [ ] 다양한 디바이스에서 테스트
- [ ] 접근성 테스트
- [ ] 다크 모드 테스트
- [ ] 에러 케이스 처리

---

## 📋 Phase 7: 추가 기능 및 개선 (1-2일)

### ✨ 7.1 사용자 경험 개선
- [ ] Pull-to-refresh 기능
- [ ] 무한 스크롤 구현
- [ ] 즐겨찾기 기능
- [ ] 최근 본 캠프 히스토리

### 📊 7.2 분석 및 모니터링
- [ ] Google Analytics 설정
- [ ] 사용자 행동 추적
- [ ] 성능 메트릭 수집

---

## 🎯 완료 기준 (Definition of Done)

### ✅ 기능적 요구사항
- [ ] 홈 화면에서 추천 캠프 목록 표시
- [ ] 검색 및 필터 기능 정상 작동
- [ ] 캠프 카드 클릭 시 상세 페이지 이동
- [ ] 반응형 디자인 적용
- [ ] 라이트/다크 모드 지원

### ✅ 비기능적 요구사항
- [ ] 앱 시작 시간 < 3초
- [ ] 이미지 로딩 시간 < 2초
- [ ] 메모리 사용량 < 100MB
- [ ] 60fps 스크롤 성능
- [ ] 다양한 디바이스 호환성

### ✅ 코드 품질
- [ ] 코드 커버리지 > 80%
- [ ] Lint 규칙 준수
- [ ] 주석 및 문서화 완료
- [ ] Git 커밋 메시지 규칙 준수

---

## 📅 예상 일정

| Phase | 기간 | 주요 산출물 |
|-------|------|-------------|
| Phase 1 | 1-2일 | 프로젝트 설정, 디자인 시스템 |
| Phase 2 | 2-3일 | 데이터 모델, API 서비스 |
| Phase 3 | 3-4일 | 공통 컴포넌트, 위젯 |
| Phase 4 | 4-5일 | 홈 화면 UI 구현 |
| Phase 5 | 2-3일 | 상태 관리, API 연동 |
| Phase 6 | 2-3일 | 테스트, 최적화 |
| Phase 7 | 1-2일 | 추가 기능, 개선 |
| **총합** | **15-22일** | **완성된 홈 화면** |

---

## 🚨 주의사항

1. **디자인 시스템 우선**: 모든 컴포넌트는 정의된 디자인 시스템을 따라야 함
2. **성능 고려**: 이미지 로딩과 리스트 렌더링 성능을 최우선으로 고려
3. **접근성**: 스크린 리더 지원 및 키보드 네비게이션 고려
4. **국제화**: 다국어 지원을 위한 구조 설계
5. **확장성**: 향후 기능 추가를 고려한 모듈화된 구조

---

**📝 업데이트 이력**
- 2024-01-XX: 초기 태스크 목록 작성
- 2024-01-XX: Phase별 세부 항목 추가
- 2024-01-XX: 완료 기준 및 일정 추가
- 2024-01-XX: Phase 1 완료 - 프로젝트 기반 설정 완료
- 2024-01-XX: Phase 2 완료 - 데이터 모델 및 서비스 설정 완료
- 2024-01-XX: Phase 3 완료 - 공통 컴포넌트 개발 완료
- 2024-01-XX: Phase 4 완료 - 홈 화면 UI 구현 완료
- 2024-01-XX: Phase 5 완료 - 상태 관리 및 데이터 연동 완료
