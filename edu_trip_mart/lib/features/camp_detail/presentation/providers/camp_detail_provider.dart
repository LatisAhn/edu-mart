import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../home/domain/usecases/get_camp_by_id.dart';
import '../../domain/entities/camp_review_entity.dart';
import '../../domain/usecases/get_camp_reviews.dart';

/// 캠프 상세 정보 Provider
/// 캠프 상세 정보와 후기 데이터를 관리
class CampDetailProvider extends ChangeNotifier {
  final GetCampById _getCampById;
  final GetCampReviews _getCampReviews;

  CampDetailProvider({
    required GetCampById getCampById,
    required GetCampReviews getCampReviews,
  }) : _getCampById = getCampById,
       _getCampReviews = getCampReviews;

  // 상태 변수들
  CampEntity? _camp;
  List<CampReviewEntity> _reviews = [];
  bool _isLoading = false;
  bool _isLoadingReviews = false;
  String? _error;

  // Getters
  CampEntity? get camp => _camp;
  List<CampReviewEntity> get reviews => _reviews;
  bool get isLoading => _isLoading;
  bool get isLoadingReviews => _isLoadingReviews;
  String? get error => _error;

  /// 캠프 상세 정보 로드
  Future<void> loadCampDetail(String campId) async {
    _setLoading(true);
    _error = null;

    try {
      _camp = await _getCampById(campId);
    } catch (e) {
      _error = '캠프 정보를 불러오는 중 오류가 발생했습니다: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 캠프 후기 로드
  Future<void> loadCampReviews(String campId) async {
    _setLoadingReviews(true);

    try {
      final result = await _getCampReviews(campId);
      if (result.isSuccess) {
        _reviews = result.data ?? [];
      }
    } catch (e) {
      // 후기 로드 실패는 에러로 처리하지 않음
    } finally {
      _setLoadingReviews(false);
    }
  }

  /// 즐겨찾기 토글
  Future<void> toggleFavorite() async {
    if (_camp == null) return;

    try {
      // TODO: 즐겨찾기 API 호출
      // 현재는 로컬 상태만 변경
      _camp = _camp!.copyWith(isFeatured: !_camp!.isFeatured);
      notifyListeners();
    } catch (e) {
      // 에러 처리
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    if (_camp != null) {
      await loadCampDetail(_camp!.id);
      await loadCampReviews(_camp!.id);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingReviews(bool loading) {
    _isLoadingReviews = loading;
    notifyListeners();
  }
}

