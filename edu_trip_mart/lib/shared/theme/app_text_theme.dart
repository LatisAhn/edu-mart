import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Edu Trip Market 앱의 타이포그래피 시스템
/// Noto Sans KR 폰트 기반으로 계층적 텍스트 스타일 정의
class AppTextTheme {
  // Private constructor to prevent instantiation
  AppTextTheme._();

  // ===== FONT FAMILY =====
  // static const String _fontFamily = 'Noto Sans KR'; // 사용되지 않는 필드

  // ===== TEXT STYLES =====
  
  /// Display Large - 메인 프로모션 타이틀, 홈 배너
  static TextStyle get displayLarge => GoogleFonts.notoSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25, // line height = 40sp
    letterSpacing: -0.5,
  );
  
  /// Display Small - 서브 프로모션 타이틀
  static TextStyle get displaySmall => GoogleFonts.notoSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33, // line height = 32sp
    letterSpacing: -0.25,
  );

  /// Display Medium - 캠페인 문구, 카드형 캠프 타이틀
  static TextStyle get displayMedium => GoogleFonts.notoSans(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3, // line height = 36sp
    letterSpacing: -0.25,
  );

  /// Headline 1 - 화면 제목 (예: "캠프 상세 정보")
  static TextStyle get headlineLarge => GoogleFonts.notoSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33, // line height = 32sp
    letterSpacing: 0,
  );

  /// Headline Small - 작은 제목
  static TextStyle get headlineSmall => GoogleFonts.notoSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Headline 2 - 섹션 헤더, 카드 타이틀
  static TextStyle get headlineMedium => GoogleFonts.notoSans(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4, // line height = 28sp
    letterSpacing: 0.15,
  );

  /// Title 1 - 리스트 타이틀, 버튼 내부 강조 텍스트
  static TextStyle get titleLarge => GoogleFonts.notoSans(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.45, // line height = 26sp
    letterSpacing: 0.15,
  );

  /// Title 2 - 서브헤더, 예약 카드 정보
  static TextStyle get titleMedium => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5, // line height = 24sp
    letterSpacing: 0.15,
  );

  /// Body 1 - 일반 본문 (설명, 후기 내용 등)
  static TextStyle get bodyLarge => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5, // line height = 24sp
    letterSpacing: 0.5,
  );

  /// Body 2 - 부가 설명, 보조 텍스트
  static TextStyle get bodyMedium => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.57, // line height = 22sp
    letterSpacing: 0.25,
  );

  /// Caption - 라벨, 가격 단위, 작은 안내 문구
  static TextStyle get bodySmall => GoogleFonts.notoSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5, // line height = 18sp
    letterSpacing: 0.4,
  );

  /// Button Text - 주요 CTA 버튼 ("예약하기", "결제하기")
  static TextStyle get labelLarge => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25, // line height = 20sp
    letterSpacing: 0.1,
  );

  /// Label Small - 배지, 상태표시 ("결제 완료")
  static TextStyle get labelSmall => GoogleFonts.notoSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45, // line height = 16sp
    letterSpacing: 0.5,
  );

  // ===== CUSTOM TEXT STYLES =====
  
  /// 가격 표시용 텍스트 스타일
  static TextStyle get priceText => GoogleFonts.notoSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0.15,
  );

  /// 별점 표시용 텍스트 스타일
  static TextStyle get ratingText => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  /// 검색바 플레이스홀더 텍스트
  static TextStyle get searchPlaceholder => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  /// 카드 제목 텍스트
  static TextStyle get cardTitle => GoogleFonts.notoSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
  );

  /// 카드 부제목 텍스트
  static TextStyle get cardSubtitle => GoogleFonts.notoSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.57,
    letterSpacing: 0.25,
  );

  /// Caption - 작은 텍스트
  static TextStyle get caption => GoogleFonts.notoSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
  );

  // ===== TEXT THEME =====
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelSmall: labelSmall,
  );
}
