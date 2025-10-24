import '../models/camp_model.dart';
import '../models/camp_category_model.dart';
import '../models/camp_review_model.dart';
import '../services/camp_api_service.dart';

/// 캠프 원격 데이터소스 인터페이스
abstract class CampRemoteDataSource {
  /// 추천 캠프 목록 조회
  Future<List<CampModel>> getFeaturedCamps();
  
  /// 인기 캠프 목록 조회
  Future<List<CampModel>> getPopularCamps();
  
  /// 최신 캠프 목록 조회
  Future<List<CampModel>> getLatestCamps();
  
  /// 카테고리별 캠프 목록 조회
  Future<List<CampModel>> getCampsByCategory(String categoryId);
  
  /// 캠프 검색
  Future<List<CampModel>> searchCamps(String query);
  
  /// 캠프 상세 정보 조회
  Future<CampModel> getCampById(String campId);
  
  /// 캠프 카테고리 목록 조회
  Future<List<CampCategoryModel>> getCampCategories();
  
  /// 캠프 리뷰 목록 조회
  Future<List<CampReviewModel>> getCampReviews(String campId);
  
  /// 캠프 리뷰 작성
  Future<CampReviewModel> createCampReview(CampReviewModel review);
}

/// 캠프 원격 데이터소스 구현
class CampRemoteDataSourceImpl implements CampRemoteDataSource {
  final CampApiService _apiService;

  const CampRemoteDataSourceImpl({
    required CampApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<List<CampModel>> getFeaturedCamps() async {
    return await _apiService.getFeaturedCamps();
  }

  @override
  Future<List<CampModel>> getPopularCamps() async {
    return await _apiService.getPopularCamps();
  }

  @override
  Future<List<CampModel>> getLatestCamps() async {
    return await _apiService.getLatestCamps();
  }

  @override
  Future<List<CampModel>> getCampsByCategory(String categoryId) async {
    return await _apiService.getCampsByCategory(categoryId: categoryId);
  }

  @override
  Future<List<CampModel>> searchCamps(String query) async {
    return await _apiService.searchCamps(query);
  }

  @override
  Future<CampModel> getCampById(String campId) async {
    return await _apiService.getCampById(campId);
  }

  @override
  Future<List<CampCategoryModel>> getCampCategories() async {
    return await _apiService.getCategories();
  }

  @override
  Future<List<CampReviewModel>> getCampReviews(String campId) async {
    return await _apiService.getCampReviews(campId);
  }

  @override
  Future<CampReviewModel> createCampReview(CampReviewModel review) async {
    // TODO: 리뷰 작성 API 구현
    throw UnimplementedError('리뷰 작성 기능은 아직 구현되지 않았습니다');
  }
}