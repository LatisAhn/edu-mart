import '../../domain/entities/camp_entity.dart';
import '../../domain/entities/camp_category_entity.dart';
import '../../domain/entities/camp_review_entity.dart';
import '../../domain/repositories/camp_repository.dart';
import '../datasources/camp_remote_datasource.dart';
import '../datasources/camp_local_datasource.dart';
// import '../models/camp_model.dart'; // 사용되지 않는 import
// import '../models/camp_category_model.dart'; // 사용되지 않는 import
import '../models/camp_review_model.dart';

/// 캠프 레포지토리 구현체 - 데이터 레이어
/// 원격 데이터소스와 로컬 데이터소스를 조합하여 데이터 관리
class CampRepositoryImpl implements CampRepository {
  final CampRemoteDataSource remoteDataSource;
  final CampLocalDataSource localDataSource;

  const CampRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CampEntity>> getFeaturedCamps() async {
    try {
      // 먼저 로컬 캐시에서 조회
      final cachedCamps = await localDataSource.getCachedFeaturedCamps();
      if (cachedCamps != null && cachedCamps.isNotEmpty) {
        return cachedCamps.map((model) => model.toEntity()).toList();
      }

      // 캐시가 없으면 원격에서 조회
      final remoteCamps = await remoteDataSource.getFeaturedCamps();
      
      // 로컬 캐시에 저장
      await localDataSource.cacheFeaturedCamps(remoteCamps);
      
      return remoteCamps.map((model) => model.toEntity()).toList();
    } catch (e) {
      // 원격 조회 실패 시 로컬 캐시에서 조회 (오프라인 지원)
      final cachedCamps = await localDataSource.getCachedFeaturedCamps();
      if (cachedCamps != null && cachedCamps.isNotEmpty) {
        return cachedCamps.map((model) => model.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<CampEntity>> getPopularCamps() async {
    try {
      // 먼저 로컬 캐시에서 조회
      final cachedCamps = await localDataSource.getCachedPopularCamps();
      if (cachedCamps != null && cachedCamps.isNotEmpty) {
        return cachedCamps.map((model) => model.toEntity()).toList();
      }

      // 캐시가 없으면 원격에서 조회
      final remoteCamps = await remoteDataSource.getPopularCamps();
      
      // 로컬 캐시에 저장
      await localDataSource.cachePopularCamps(remoteCamps);
      
      return remoteCamps.map((model) => model.toEntity()).toList();
    } catch (e) {
      // 원격 조회 실패 시 로컬 캐시에서 조회 (오프라인 지원)
      final cachedCamps = await localDataSource.getCachedPopularCamps();
      if (cachedCamps != null && cachedCamps.isNotEmpty) {
        return cachedCamps.map((model) => model.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<CampEntity>> getLatestCamps() async {
    try {
      final remoteCamps = await remoteDataSource.getLatestCamps();
      return remoteCamps.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch latest camps: $e');
    }
  }

  @override
  Future<List<CampEntity>> getCampsByCategory(String categoryId) async {
    try {
      final remoteCamps = await remoteDataSource.getCampsByCategory(categoryId);
      return remoteCamps.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch camps by category: $e');
    }
  }

  @override
  Future<List<CampEntity>> searchCamps(String query) async {
    try {
      // 검색 히스토리 저장
      await localDataSource.saveSearchHistory(query);
      
      final remoteCamps = await remoteDataSource.searchCamps(query);
      return remoteCamps.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search camps: $e');
    }
  }

  @override
  Future<CampEntity> getCampById(String campId) async {
    try {
      // 먼저 로컬 캐시에서 조회
      final cachedCamp = await localDataSource.getCachedCamp(campId);
      if (cachedCamp != null) {
        return cachedCamp.toEntity();
      }

      // 캐시가 없으면 원격에서 조회
      final remoteCamp = await remoteDataSource.getCampById(campId);
      
      // 로컬 캐시에 저장
      await localDataSource.cacheCamp(remoteCamp);
      
      return remoteCamp.toEntity();
    } catch (e) {
      // 원격 조회 실패 시 로컬 캐시에서 조회 (오프라인 지원)
      final cachedCamp = await localDataSource.getCachedCamp(campId);
      if (cachedCamp != null) {
        return cachedCamp.toEntity();
      }
      rethrow;
    }
  }

  @override
  Future<List<CampCategoryEntity>> getCampCategories() async {
    try {
      // 먼저 로컬 캐시에서 조회
      final cachedCategories = await localDataSource.getCachedCampCategories();
      if (cachedCategories != null && cachedCategories.isNotEmpty) {
        return cachedCategories.map((model) => model.toEntity()).toList();
      }

      // 캐시가 없으면 원격에서 조회
      final remoteCategories = await remoteDataSource.getCampCategories();
      
      // 로컬 캐시에 저장
      await localDataSource.cacheCampCategories(remoteCategories);
      
      return remoteCategories.map((model) => model.toEntity()).toList();
    } catch (e) {
      // 원격 조회 실패 시 로컬 캐시에서 조회 (오프라인 지원)
      final cachedCategories = await localDataSource.getCachedCampCategories();
      if (cachedCategories != null && cachedCategories.isNotEmpty) {
        return cachedCategories.map((model) => model.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<List<CampReviewEntity>> getCampReviews(String campId) async {
    try {
      // 먼저 로컬 캐시에서 조회
      final cachedReviews = await localDataSource.getCachedCampReviews(campId);
      if (cachedReviews != null && cachedReviews.isNotEmpty) {
        return cachedReviews.map((model) => model.toEntity()).toList();
      }

      // 캐시가 없으면 원격에서 조회
      final remoteReviews = await remoteDataSource.getCampReviews(campId);
      
      // 로컬 캐시에 저장
      await localDataSource.cacheCampReviews(campId, remoteReviews);
      
      return remoteReviews.map((model) => model.toEntity()).toList();
    } catch (e) {
      // 원격 조회 실패 시 로컬 캐시에서 조회 (오프라인 지원)
      final cachedReviews = await localDataSource.getCachedCampReviews(campId);
      if (cachedReviews != null && cachedReviews.isNotEmpty) {
        return cachedReviews.map((model) => model.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<CampReviewEntity> createCampReview(CampReviewEntity review) async {
    try {
      final reviewModel = CampReviewModel.fromEntity(review);
      final createdReview = await remoteDataSource.createCampReview(reviewModel);
      
      // 로컬 캐시 업데이트
      final existingReviews = await localDataSource.getCachedCampReviews(review.campId);
      if (existingReviews != null) {
        existingReviews.add(createdReview);
        await localDataSource.cacheCampReviews(review.campId, existingReviews);
      }
      
      return createdReview.toEntity();
    } catch (e) {
      throw Exception('Failed to create camp review: $e');
    }
  }

  @override
  Future<List<CampEntity>> getFavoriteCamps() async {
    try {
      final favoriteIds = await localDataSource.getFavoriteCamps();
      if (favoriteIds.isEmpty) {
        return [];
      }

      // 즐겨찾기된 캠프들의 상세 정보 조회
      final List<CampEntity> favoriteCamps = [];
      for (final campId in favoriteIds) {
        try {
          final camp = await getCampById(campId);
          favoriteCamps.add(camp);
        } catch (e) {
          // 캠프를 찾을 수 없으면 즐겨찾기에서 제거
          await localDataSource.removeFavoriteCamp(campId);
        }
      }
      
      return favoriteCamps;
    } catch (e) {
      throw Exception('Failed to fetch favorite camps: $e');
    }
  }

  @override
  Future<void> addFavoriteCamp(String campId) async {
    try {
      await localDataSource.saveFavoriteCamp(campId);
    } catch (e) {
      throw Exception('Failed to add favorite camp: $e');
    }
  }

  @override
  Future<void> removeFavoriteCamp(String campId) async {
    try {
      await localDataSource.removeFavoriteCamp(campId);
    } catch (e) {
      throw Exception('Failed to remove favorite camp: $e');
    }
  }

  @override
  Future<List<String>> getSearchHistory() async {
    try {
      return await localDataSource.getSearchHistory();
    } catch (e) {
      throw Exception('Failed to fetch search history: $e');
    }
  }

  @override
  Future<void> saveSearchHistory(String query) async {
    try {
      await localDataSource.saveSearchHistory(query);
    } catch (e) {
      throw Exception('Failed to save search history: $e');
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await localDataSource.clearSearchHistory();
    } catch (e) {
      throw Exception('Failed to clear search history: $e');
    }
  }

}
