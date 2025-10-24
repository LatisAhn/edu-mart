import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/camp_model.dart';
import '../models/camp_category_model.dart';
import '../models/camp_review_model.dart';

/// 캠프 로컬 데이터소스 - 로컬 캐시 관리를 담당
/// SharedPreferences를 사용한 데이터 저장 및 조회
abstract class CampLocalDataSource {
  /// 추천 캠프 목록 캐시 저장
  Future<void> cacheFeaturedCamps(List<CampModel> camps);
  
  /// 추천 캠프 목록 캐시 조회
  Future<List<CampModel>?> getCachedFeaturedCamps();
  
  /// 인기 캠프 목록 캐시 저장
  Future<void> cachePopularCamps(List<CampModel> camps);
  
  /// 인기 캠프 목록 캐시 조회
  Future<List<CampModel>?> getCachedPopularCamps();
  
  /// 카테고리 목록 캐시 저장
  Future<void> cacheCampCategories(List<CampCategoryModel> categories);
  
  /// 카테고리 목록 캐시 조회
  Future<List<CampCategoryModel>?> getCachedCampCategories();
  
  /// 캠프 상세 정보 캐시 저장
  Future<void> cacheCamp(CampModel camp);
  
  /// 캠프 상세 정보 캐시 조회
  Future<CampModel?> getCachedCamp(String campId);
  
  /// 캠프 리뷰 캐시 저장
  Future<void> cacheCampReviews(String campId, List<CampReviewModel> reviews);
  
  /// 캠프 리뷰 캐시 조회
  Future<List<CampReviewModel>?> getCachedCampReviews(String campId);
  
  /// 검색 히스토리 저장
  Future<void> saveSearchHistory(String query);
  
  /// 검색 히스토리 조회
  Future<List<String>> getSearchHistory();
  
  /// 검색 히스토리 삭제
  Future<void> clearSearchHistory();
  
  /// 즐겨찾기 캠프 저장
  Future<void> saveFavoriteCamp(String campId);
  
  /// 즐겨찾기 캠프 삭제
  Future<void> removeFavoriteCamp(String campId);
  
  /// 즐겨찾기 캠프 목록 조회
  Future<List<String>> getFavoriteCamps();
  
  /// 캐시 만료 시간 확인
  bool isCacheExpired(String key);
  
  /// 캐시 삭제
  Future<void> clearCache();
}

class CampLocalDataSourceImpl implements CampLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // 캐시 키 상수
  static const String _featuredCampsKey = 'featured_camps';
  static const String _popularCampsKey = 'popular_camps';
  static const String _categoriesKey = 'camp_categories';
  static const String _searchHistoryKey = 'search_history';
  static const String _favoriteCampsKey = 'favorite_camps';
  // static const String _cacheTimestampKey = 'cache_timestamp'; // 사용되지 않는 필드
  
  // 캐시 만료 시간 (24시간)
  static const Duration _cacheExpiration = Duration(hours: 24);

  const CampLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheFeaturedCamps(List<CampModel> camps) async {
    final jsonString = json.encode(CampModel.toJsonList(camps));
    await sharedPreferences.setString(_featuredCampsKey, jsonString);
    await _updateCacheTimestamp(_featuredCampsKey);
  }

  @override
  Future<List<CampModel>?> getCachedFeaturedCamps() async {
    if (isCacheExpired(_featuredCampsKey)) {
      return null;
    }
    
    final jsonString = sharedPreferences.getString(_featuredCampsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return CampModel.fromJsonList(jsonList);
    }
    return null;
  }

  @override
  Future<void> cachePopularCamps(List<CampModel> camps) async {
    final jsonString = json.encode(CampModel.toJsonList(camps));
    await sharedPreferences.setString(_popularCampsKey, jsonString);
    await _updateCacheTimestamp(_popularCampsKey);
  }

  @override
  Future<List<CampModel>?> getCachedPopularCamps() async {
    if (isCacheExpired(_popularCampsKey)) {
      return null;
    }
    
    final jsonString = sharedPreferences.getString(_popularCampsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return CampModel.fromJsonList(jsonList);
    }
    return null;
  }

  @override
  Future<void> cacheCampCategories(List<CampCategoryModel> categories) async {
    final jsonString = json.encode(CampCategoryModel.toJsonList(categories));
    await sharedPreferences.setString(_categoriesKey, jsonString);
    await _updateCacheTimestamp(_categoriesKey);
  }

  @override
  Future<List<CampCategoryModel>?> getCachedCampCategories() async {
    if (isCacheExpired(_categoriesKey)) {
      return null;
    }
    
    final jsonString = sharedPreferences.getString(_categoriesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return CampCategoryModel.fromJsonList(jsonList);
    }
    return null;
  }

  @override
  Future<void> cacheCamp(CampModel camp) async {
    final key = 'camp_${camp.id}';
    final jsonString = json.encode(camp.toJson());
    await sharedPreferences.setString(key, jsonString);
    await _updateCacheTimestamp(key);
  }

  @override
  Future<CampModel?> getCachedCamp(String campId) async {
    final key = 'camp_$campId';
    if (isCacheExpired(key)) {
      return null;
    }
    
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return CampModel.fromJson(jsonData);
    }
    return null;
  }

  @override
  Future<void> cacheCampReviews(String campId, List<CampReviewModel> reviews) async {
    final key = 'reviews_$campId';
    final jsonString = json.encode(CampReviewModel.toJsonList(reviews));
    await sharedPreferences.setString(key, jsonString);
    await _updateCacheTimestamp(key);
  }

  @override
  Future<List<CampReviewModel>?> getCachedCampReviews(String campId) async {
    final key = 'reviews_$campId';
    if (isCacheExpired(key)) {
      return null;
    }
    
    final jsonString = sharedPreferences.getString(key);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return CampReviewModel.fromJsonList(jsonList);
    }
    return null;
  }

  @override
  Future<void> saveSearchHistory(String query) async {
    final history = await getSearchHistory();
    
    // 중복 제거 및 최신 순으로 정렬
    history.remove(query);
    history.insert(0, query);
    
    // 최대 10개까지만 저장
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    
    await sharedPreferences.setStringList(_searchHistoryKey, history);
  }

  @override
  Future<List<String>> getSearchHistory() async {
    return sharedPreferences.getStringList(_searchHistoryKey) ?? [];
  }

  @override
  Future<void> clearSearchHistory() async {
    await sharedPreferences.remove(_searchHistoryKey);
  }

  @override
  Future<void> saveFavoriteCamp(String campId) async {
    final favorites = await getFavoriteCamps();
    if (!favorites.contains(campId)) {
      favorites.add(campId);
      await sharedPreferences.setStringList(_favoriteCampsKey, favorites);
    }
  }

  @override
  Future<void> removeFavoriteCamp(String campId) async {
    final favorites = await getFavoriteCamps();
    favorites.remove(campId);
    await sharedPreferences.setStringList(_favoriteCampsKey, favorites);
  }

  @override
  Future<List<String>> getFavoriteCamps() async {
    return sharedPreferences.getStringList(_favoriteCampsKey) ?? [];
  }

  @override
  bool isCacheExpired(String key) {
    final timestampKey = '${key}_timestamp';
    final timestamp = sharedPreferences.getInt(timestampKey);
    
    if (timestamp == null) return true;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    
    return now.difference(cacheTime) > _cacheExpiration;
  }

  @override
  Future<void> clearCache() async {
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith('camp_') || 
          key.startsWith('reviews_') || 
          key.endsWith('_timestamp') ||
          key == _featuredCampsKey ||
          key == _popularCampsKey ||
          key == _categoriesKey) {
        await sharedPreferences.remove(key);
      }
    }
  }

  /// 캐시 타임스탬프 업데이트
  Future<void> _updateCacheTimestamp(String key) async {
    final timestampKey = '${key}_timestamp';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await sharedPreferences.setInt(timestampKey, timestamp);
  }
}
