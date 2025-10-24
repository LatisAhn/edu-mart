import 'package:flutter/foundation.dart';
import '../../domain/entities/camp_entity.dart';
import '../../domain/entities/camp_category_entity.dart';
import '../../domain/usecases/get_featured_camps.dart';
import '../../domain/usecases/get_popular_camps.dart';
import '../../domain/usecases/get_camp_categories.dart';
import '../../domain/usecases/search_camps.dart';
import '../../domain/usecases/get_camp_by_id.dart';

/// 홈 화면 상태 관리 Provider
/// 홈 화면의 모든 상태와 비즈니스 로직을 관리
class HomeProvider extends ChangeNotifier {
  final GetFeaturedCamps _getFeaturedCamps;
  final GetPopularCamps _getPopularCamps;
  final GetCampCategories _getCampCategories;
  final SearchCamps _searchCamps;
  final GetCampById _getCampById;

  HomeProvider({
    required GetFeaturedCamps getFeaturedCamps,
    required GetPopularCamps getPopularCamps,
    required GetCampCategories getCampCategories,
    required SearchCamps searchCamps,
    required GetCampById getCampById,
  }) : _getFeaturedCamps = getFeaturedCamps,
       _getPopularCamps = getPopularCamps,
       _getCampCategories = getCampCategories,
       _searchCamps = searchCamps,
       _getCampById = getCampById;

  // ===== 상태 변수들 =====
  
  // 로딩 상태
  bool _isLoadingFeatured = false;
  bool _isLoadingPopular = false;
  bool _isLoadingLatest = false;
  bool _isLoadingCategories = false;
  bool _isLoadingAllCamps = false;
  bool _isSearching = false;

  // 데이터
  List<CampEntity> _featuredCamps = [];
  List<CampEntity> _popularCamps = [];
  List<CampEntity> _latestCamps = [];
  List<CampEntity> _searchResults = [];
  List<CampEntity> _allCamps = [];
  List<CampCategoryEntity> _categories = [];

  // 검색 및 필터
  String _searchQuery = '';
  String? _selectedCategoryId;
  final Map<String, dynamic> _filters = {};

  // 활성 필터 개수
  int get activeFilterCount => _filters.length;

  // 에러 상태
  String? _errorMessage;

  // ===== Getters =====
  
  bool get isLoadingFeatured => _isLoadingFeatured;
  bool get isLoadingFeaturedCamps => _isLoadingFeatured;
  bool get isLoadingPopular => _isLoadingPopular;
  bool get isLoadingLatest => _isLoadingLatest;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingAllCamps => _isLoadingAllCamps;
  bool get isSearching => _isSearching;
  bool get isLoadingSearch => _isSearching;

  List<CampEntity> get featuredCamps => _featuredCamps;
  List<CampEntity> get popularCamps => _popularCamps;
  List<CampEntity> get latestCamps => _latestCamps;
  List<CampEntity> get searchResults => _searchResults;
  List<CampEntity> get allCamps => _allCamps;
  List<CampCategoryEntity> get categories => _categories;

  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  Map<String, dynamic> get filters => _filters;

  String? get errorMessage => _errorMessage;

  // ===== 메서드들 =====

  /// 홈 화면 초기 데이터 로드
  Future<void> loadHomeData() async {
    await Future.wait([
      loadFeaturedCamps(),
      loadPopularCamps(),
      loadLatestCamps(),
      loadCategories(),
      loadAllCamps(),
    ]);
  }

  /// 추천 캠프 로드
  Future<void> loadFeaturedCamps() async {
    _setLoading(true, 'featured');
    _clearError();

    try {
      final camps = await _getFeaturedCamps();
      _featuredCamps = camps;
    } catch (e) {
      _setError('추천 캠프를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false, 'featured');
    }
  }

  /// 인기 캠프 로드
  Future<void> loadPopularCamps() async {
    _setLoading(true, 'popular');
    _clearError();

    try {
      final camps = await _getPopularCamps();
      _popularCamps = camps;
    } catch (e) {
      _setError('인기 캠프를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false, 'popular');
    }
  }

  /// 최신 캠프 로드
  Future<void> loadLatestCamps() async {
    _setLoading(true, 'latest');
    _clearError();

    try {
      // TODO: GetLatestCamps use case 구현 후 교체
      final camps = await _getFeaturedCamps(); // 임시로 추천 캠프 사용
      _latestCamps = camps;
    } catch (e) {
      _setError('최신 캠프를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false, 'latest');
    }
  }

  /// 카테고리 로드
  Future<void> loadCategories() async {
    _setLoading(true, 'categories');
    _clearError();

    try {
      final categories = await _getCampCategories();
      _categories = categories;
    } catch (e) {
      _setError('카테고리를 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false, 'categories');
    }
  }

  /// 캠프 검색
  Future<void> searchCamps(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _setLoading(true, 'search');
    _clearError();

    try {
      final camps = await _searchCamps(query.trim());
      _searchResults = camps;
      _searchQuery = query.trim();
    } catch (e) {
      _setError('검색에 실패했습니다: $e');
    } finally {
      _setLoading(false, 'search');
    }
  }

  /// 검색 쿼리 업데이트
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// 카테고리 선택
  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
    
    // TODO: 카테고리별 캠프 로드 구현
  }

  /// 필터 업데이트
  void updateFilter(String key, dynamic value) {
    if (value == null) {
      _filters.remove(key);
    } else {
      _filters[key] = value;
    }
    notifyListeners();
  }

  /// 필터 초기화
  void clearFilters() {
    _filters.clear();
    _selectedCategoryId = null;
    notifyListeners();
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite(String campId) async {
    // TODO: 즐겨찾기 토글 로직 구현
    notifyListeners();
  }

  /// 캠프 상세 정보 로드
  Future<CampEntity?> loadCampDetail(String campId) async {
    try {
      final camp = await _getCampById(campId);
      return camp;
    } catch (e) {
      _setError('캠프 정보를 불러오는데 실패했습니다: $e');
      return null;
    }
  }

  /// 에러 상태 초기화
  void clearError() {
    _clearError();
  }

  /// 모든 캠프 로드
  Future<void> loadAllCamps() async {
    _setLoading(true, 'allCamps');
    _clearError();

    try {
      // 모든 캠프를 가져오기 위해 빈 쿼리로 검색
      final camps = await _searchCamps('');
      _allCamps = camps;
    } catch (e) {
      _setError('캠프 목록을 불러오는데 실패했습니다: $e');
    } finally {
      _setLoading(false, 'allCamps');
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadHomeData();
  }

  // ===== Private 메서드들 =====

  void _setLoading(bool isLoading, String type) {
    switch (type) {
      case 'featured':
        _isLoadingFeatured = isLoading;
        break;
      case 'popular':
        _isLoadingPopular = isLoading;
        break;
      case 'latest':
        _isLoadingLatest = isLoading;
        break;
      case 'categories':
        _isLoadingCategories = isLoading;
        break;
      case 'allCamps':
        _isLoadingAllCamps = isLoading;
        break;
      case 'search':
        _isSearching = isLoading;
        break;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
