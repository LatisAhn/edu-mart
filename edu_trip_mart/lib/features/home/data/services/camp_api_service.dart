import 'package:edu_trip_mart/core/network/api_client.dart';
import '../models/camp_model.dart';
import '../models/camp_category_model.dart';
import '../models/camp_review_model.dart';
import '../../domain/entities/camp_entity.dart';
import '../../domain/entities/camp_review_entity.dart';
import '../../../../core/data/mock_data.dart';

/// 캠프 API 서비스
/// 캠프 관련 API 호출을 담당하는 서비스 클래스
class CampApiService {
  final ApiClient _apiClient;

  const CampApiService({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  /// 추천 캠프 목록 조회
  Future<List<CampModel>> getFeaturedCamps({
    int page = 1,
    int limit = 10,
  }) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 시뮬레이션

    final mockCamps = MockData.getMockCamps();
    final featuredCamps = mockCamps.where((camp) => camp.isFeatured).toList();

    // 페이지네이션 적용
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= featuredCamps.length) {
      return [];
    }

    final paginatedCamps = featuredCamps.sublist(
      startIndex,
      endIndex > featuredCamps.length ? featuredCamps.length : endIndex,
    );

    return paginatedCamps.map((camp) => CampModel.fromEntity(camp)).toList();
  }

  /// 인기 캠프 목록 조회
  Future<List<CampModel>> getPopularCamps({
    int page = 1,
    int limit = 10,
  }) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));
    
    final mockCamps = MockData.getMockCamps();
    // 평점 순으로 정렬
    final popularCamps = List<CampEntity>.from(mockCamps)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    
    // 페이지네이션 적용
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= popularCamps.length) {
      return [];
    }
    
    final paginatedCamps = popularCamps.sublist(
      startIndex,
      endIndex > popularCamps.length ? popularCamps.length : endIndex,
    );
    
    return paginatedCamps.map((camp) => CampModel.fromEntity(camp)).toList();
  }

  /// 최신 캠프 목록 조회
  Future<List<CampModel>> getLatestCamps({
    int page = 1,
    int limit = 10,
  }) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    final mockCamps = MockData.getMockCamps();
    // 최신순으로 정렬 (createdAt 기준)
    final latestCamps = List<CampEntity>.from(mockCamps)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // 페이지네이션 적용
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= latestCamps.length) {
      return [];
    }

    final paginatedCamps = latestCamps.sublist(
      startIndex,
      endIndex > latestCamps.length ? latestCamps.length : endIndex,
    );

    return paginatedCamps.map((camp) => CampModel.fromEntity(camp)).toList();
  }

  /// 캠프 상세 정보 조회
  Future<CampModel> getCampById(String campId) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    final mockCamps = MockData.getMockCamps();
    final camp = mockCamps.firstWhere(
      (camp) => camp.id == campId,
      orElse: () => mockCamps.first, // 기본값으로 첫 번째 캠프 반환
    );

    return CampModel.fromEntity(camp);
  }

  /// 카테고리별 캠프 목록 조회
  Future<List<CampModel>> getCampsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    final mockCamps = MockData.getMockCamps();
    final categoryCamps = mockCamps.where((camp) => camp.categoryId == categoryId).toList();

    // 페이지네이션 적용
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= categoryCamps.length) {
      return [];
    }

    final paginatedCamps = categoryCamps.sublist(
      startIndex,
      endIndex > categoryCamps.length ? categoryCamps.length : endIndex,
    );

    return paginatedCamps.map((camp) => CampModel.fromEntity(camp)).toList();
  }

  /// 캠프 검색
  Future<List<CampModel>> searchCamps(String query) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    print('검색 쿼리: "$query"');
    final mockCamps = MockData.getMockCamps();
    print('전체 캠프 수: ${mockCamps.length}');
    
    final searchResults = mockCamps.where((camp) {
      final titleMatch = camp.title.toLowerCase().contains(query.toLowerCase());
      final descMatch = camp.description.toLowerCase().contains(query.toLowerCase());
      final locationMatch = camp.location.toLowerCase().contains(query.toLowerCase());
      final countryMatch = camp.country.toLowerCase().contains(query.toLowerCase());
      final cityMatch = camp.city.toLowerCase().contains(query.toLowerCase());
      
      final isMatch = titleMatch || descMatch || locationMatch || countryMatch || cityMatch;
      
      if (isMatch) {
        print('매칭된 캠프: ${camp.title} (${camp.country}, ${camp.city})');
      }
      
      return isMatch;
    }).toList();

    print('검색 결과 수: ${searchResults.length}');
    return searchResults.map((camp) => CampModel.fromEntity(camp)).toList();
  }

  /// 캠프 카테고리 목록 조회
  Future<List<CampCategoryModel>> getCategories() async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    final mockCategories = MockData.getMockCategories();
    return mockCategories.map((category) => CampCategoryModel.fromEntity(category)).toList();
  }

  /// 캠프 리뷰 목록 조회
  Future<List<CampReviewModel>> getCampReviews(String campId) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    final mockReviews = MockData.getMockReviews();
    final campReviews = mockReviews.where((review) => review.campId == campId).toList();

    // camp_detail의 CampReviewEntity를 home의 CampReviewEntity로 변환
    return campReviews.map((review) {
      final homeReview = CampReviewEntity(
        id: review.id,
        campId: review.campId,
        userId: review.userId,
        userName: review.userName,
        userAvatarUrl: review.userAvatarUrl,
        rating: review.rating,
        title: review.title,
        content: review.content,
        imageUrls: review.imageUrls,
        isVerified: review.isVerified,
        helpfulCount: review.helpfulCount,
        helpfulUserIds: review.helpfulUserIds,
        createdAt: review.createdAt,
        updatedAt: review.updatedAt,
        response: review.response,
        responseDate: review.responseDate,
      );
      return CampReviewModel.fromEntity(homeReview);
    }).toList();
  }

  /// 캠프 리뷰 작성
  Future<CampReviewModel> createCampReview(CampReviewModel review) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    // Mock 데이터에서는 그대로 반환
    return review;
  }

  /// 즐겨찾기 캠프 목록 조회
  Future<List<CampModel>> getFavoriteCamps({
    int page = 1,
    int limit = 10,
  }) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    final mockCamps = MockData.getMockCamps();
    // Mock에서는 평점이 높은 캠프들을 즐겨찾기로 간주
    final favoriteCamps = mockCamps.where((camp) => camp.rating >= 4.5).toList();

    // 페이지네이션 적용
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= favoriteCamps.length) {
      return [];
    }

    final paginatedCamps = favoriteCamps.sublist(
      startIndex,
      endIndex > favoriteCamps.length ? favoriteCamps.length : endIndex,
    );

    return paginatedCamps.map((camp) => CampModel.fromEntity(camp)).toList();
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite(String campId, bool isFavorite) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(seconds: 1));

    // Mock에서는 아무것도 하지 않음
  }

  /// 검색 제안 목록 조회
  Future<List<String>> getSearchSuggestions(String query) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(milliseconds: 500));

    final mockSuggestions = MockData.getMockSearchSuggestions();
    return mockSuggestions.where((suggestion) =>
        suggestion.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// 검색 히스토리 조회
  Future<List<String>> getSearchHistory() async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(milliseconds: 300));

    return MockData.getMockSearchHistory();
  }

  /// 검색 히스토리 저장
  Future<void> saveSearchHistory(String query) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(milliseconds: 200));

    // Mock에서는 아무것도 하지 않음
  }

  /// 검색 히스토리 삭제
  Future<void> removeSearchHistory(String query) async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(milliseconds: 200));

    // Mock에서는 아무것도 하지 않음
  }

  /// 검색 히스토리 전체 삭제
  Future<void> clearSearchHistory() async {
    // TODO: 실제 API 호출로 교체
    // 현재는 Mock 데이터 사용
    await Future.delayed(const Duration(milliseconds: 200));

    // Mock에서는 아무것도 하지 않음
  }
}