import 'package:flutter/material.dart';

/// 반응형 디자인 헬퍼 클래스
/// 다양한 화면 크기에 대응하는 반응형 디자인을 위한 유틸리티
class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// 현재 화면이 모바일인지 확인
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// 현재 화면이 태블릿인지 확인
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// 현재 화면이 데스크톱인지 확인
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// 화면 크기에 따른 컬럼 수 반환
  static int getColumnCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    if (isDesktop(context)) return 3;
    return 1;
  }

  /// 화면 크기에 따른 카드 너비 반환
  static double getCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 32.0; // 좌우 패딩
    
    if (isMobile(context)) {
      return screenWidth - padding;
    } else if (isTablet(context)) {
      return (screenWidth - padding - 16) / 2; // 2열, 16은 간격
    } else {
      return (screenWidth - padding - 32) / 3; // 3열, 32는 간격
    }
  }

  /// 화면 크기에 따른 패딩 반환
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  /// 화면 크기에 따른 폰트 크기 반환
  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// 화면 크기에 따른 아이콘 크기 반환
  static double getResponsiveIconSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// 화면 크기에 따른 그리드 간격 반환
  static double getGridSpacing(BuildContext context) {
    if (isMobile(context)) return 8.0;
    if (isTablet(context)) return 12.0;
    return 16.0;
  }

  /// 화면 크기에 따른 앱바 높이 반환
  static double getAppBarHeight(BuildContext context) {
    if (isMobile(context)) return 56.0;
    if (isTablet(context)) return 64.0;
    return 72.0;
  }

  /// 화면 크기에 따른 탭바 높이 반환
  static double getTabBarHeight(BuildContext context) {
    if (isMobile(context)) return 48.0;
    if (isTablet(context)) return 56.0;
    return 64.0;
  }

  /// 화면 크기에 따른 버튼 높이 반환
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) return 40.0;
    if (isTablet(context)) return 44.0;
    return 48.0;
  }

  /// 화면 크기에 따른 카드 높이 반환
  static double getCardHeight(BuildContext context) {
    if (isMobile(context)) return 200.0;
    if (isTablet(context)) return 220.0;
    return 240.0;
  }

  /// 화면 크기에 따른 이미지 높이 반환
  static double getImageHeight(BuildContext context) {
    if (isMobile(context)) return 120.0;
    if (isTablet(context)) return 140.0;
    return 160.0;
  }

  /// 화면 크기에 따른 최대 너비 반환
  static double getMaxWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 800.0;
    return 1200.0;
  }

  /// 화면 크기에 따른 사이드바 너비 반환
  static double getSidebarWidth(BuildContext context) {
    if (isMobile(context)) return 0.0;
    if (isTablet(context)) return 200.0;
    return 250.0;
  }

  /// 화면 크기에 따른 네비게이션 바 높이 반환
  static double getBottomNavHeight(BuildContext context) {
    if (isMobile(context)) return 60.0;
    if (isTablet(context)) return 70.0;
    return 80.0;
  }

  /// 화면 크기에 따른 모달 높이 반환
  static double getModalHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (isMobile(context)) return screenHeight * 0.8;
    if (isTablet(context)) return screenHeight * 0.7;
    return screenHeight * 0.6;
  }

  /// 화면 크기에 따른 텍스트 스타일 반환
  static TextStyle getResponsiveTextStyle(BuildContext context, {
    required TextStyle mobile,
    required TextStyle tablet,
    required TextStyle desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// 화면 크기에 따른 애니메이션 지속 시간 반환
  static Duration getResponsiveDuration(BuildContext context, {
    required Duration mobile,
    required Duration tablet,
    required Duration desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// 화면 크기에 따른 그리드 뷰 설정 반환
  static SliverGridDelegate getGridDelegate(BuildContext context) {
    final crossAxisCount = getColumnCount(context);
    final spacing = getGridSpacing(context);
    
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      childAspectRatio: 0.75,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
    );
  }

  /// 화면 크기에 따른 리스트 뷰 설정 반환
  static SliverChildBuilderDelegate getListDelegate(BuildContext context) {
    return SliverChildBuilderDelegate(
      (context, index) {
        // 리스트 아이템 빌더
        return Container(); // 실제 구현에서는 위젯 반환
      },
      childCount: 0, // 실제 구현에서는 아이템 수 반환
    );
  }

  /// 화면 크기에 따른 스크롤 물리학 반환
  static ScrollPhysics getScrollPhysics(BuildContext context) {
    if (isMobile(context)) {
      return const BouncingScrollPhysics();
    } else {
      return const ClampingScrollPhysics();
    }
  }

  /// 화면 크기에 따른 키보드 동작 반환
  static ScrollViewKeyboardDismissBehavior getKeyboardDismissBehavior(BuildContext context) {
    if (isMobile(context)) {
      return ScrollViewKeyboardDismissBehavior.onDrag;
    } else {
      return ScrollViewKeyboardDismissBehavior.manual;
    }
  }
}
