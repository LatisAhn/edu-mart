# Edu Trip Mart

교육 여행 캠프 예약 플랫폼 - Flutter 웹 애플리케이션

## 🚀 Live Demo

🌐 **[온라인 데모 보기](https://your-username.github.io/edu-trip-mart/)**

## 📱 주요 기능

- **홈 화면**: 추천 캠프 및 카테고리별 탐색
- **검색 기능**: 캠프명, 지역별 검색 및 필터링
- **캠프 상세**: 캠프 정보, 리뷰, 예약 기능
- **예약/결제**: 3단계 예약 프로세스
- **마이페이지**: 예약 내역 및 후기 관리
- **후기 시스템**: 별점 평가 및 텍스트 후기

## 🛠 기술 스택

- **Frontend**: Flutter Web
- **State Management**: Provider
- **Architecture**: Clean Architecture
- **Deployment**: GitHub Pages

## 📦 설치 및 실행

### 로컬 개발 환경

```bash
# 저장소 클론
git clone https://github.com/your-username/edu-trip-mart.git

# 프로젝트 디렉토리로 이동
cd edu_trip_mart

# 의존성 설치
flutter pub get

# 웹에서 실행
flutter run -d chrome
```

### 빌드

```bash
# 웹 빌드
flutter build web --release
```

## 🏗 프로젝트 구조

```
lib/
├── core/                    # 핵심 기능
│   ├── cache/              # 캐시 관리
│   ├── data/               # Mock 데이터
│   ├── error/              # 에러 처리
│   └── network/            # 네트워크 설정
├── features/               # 기능별 모듈
│   ├── auth/               # 인증
│   ├── booking/            # 예약/결제
│   ├── camp_detail/        # 캠프 상세
│   ├── home/               # 홈 화면
│   ├── profile/            # 마이페이지
│   ├── review/             # 후기 시스템
│   └── search/             # 검색 기능
├── presentation/           # UI 레이어
│   ├── pages/              # 페이지
│   ├── providers/          # 상태 관리
│   └── widgets/            # 공통 위젯
└── shared/                 # 공통 리소스
    ├── constants/          # 상수
    ├── theme/              # 테마
    └── utils/              # 유틸리티
```

## 🎨 UI/UX 특징

- **반응형 디자인**: 다양한 화면 크기 지원
- **Material Design**: 일관된 디자인 시스템
- **다크/라이트 테마**: 사용자 선호도 지원
- **애니메이션**: 부드러운 전환 효과

## 📝 라이선스

MIT License

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 연락처

프로젝트 링크: [https://github.com/your-username/edu-trip-mart](https://github.com/your-username/edu-trip-mart)
