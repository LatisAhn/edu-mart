import '../entities/camp_entity.dart';
import '../entities/camp_category_entity.dart';
import '../entities/camp_review_entity.dart';

/// 캠프 레포지토리 인터페이스 - 도메인 레이어
/// 데이터 소스와 도메인 레이어 간의 추상화 계층
abstract class CampRepository {
  /// 추천 캠프 목록 조회
  Future<List<CampEntity>> getFeaturedCamps();
  
  /// 인기 캠프 목록 조회
  Future<List<CampEntity>> getPopularCamps();
  
  /// 최신 캠프 목록 조회
  Future<List<CampEntity>> getLatestCamps();
  
  /// 카테고리별 캠프 목록 조회
  Future<List<CampEntity>> getCampsByCategory(String categoryId);
  
  /// 캠프 검색
  Future<List<CampEntity>> searchCamps(String query);
  
  /// 캠프 상세 정보 조회
  Future<CampEntity> getCampById(String campId);
  
  /// 캠프 카테고리 목록 조회
  Future<List<CampCategoryEntity>> getCampCategories();
  
  /// 캠프 리뷰 목록 조회
  Future<List<CampReviewEntity>> getCampReviews(String campId);
  
  /// 캠프 리뷰 작성
  Future<CampReviewEntity> createCampReview(CampReviewEntity review);
  
  /// 즐겨찾기 캠프 목록 조회
  Future<List<CampEntity>> getFavoriteCamps();
  
  /// 즐겨찾기 캠프 추가
  Future<void> addFavoriteCamp(String campId);
  
  /// 즐겨찾기 캠프 제거
  Future<void> removeFavoriteCamp(String campId);
  
  /// 검색 히스토리 조회
  Future<List<String>> getSearchHistory();
  
  /// 검색 히스토리 저장
  Future<void> saveSearchHistory(String query);
  
  /// 검색 히스토리 삭제
  Future<void> clearSearchHistory();
}
