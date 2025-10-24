import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../../core/data/mock_data.dart';

/// 후기 Provider
/// 후기 작성 및 관리 관련 상태와 비즈니스 로직을 관리
class ReviewProvider extends ChangeNotifier {
  // 상태 변수들
  dynamic _camp;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  // Getters
  dynamic get camp => _camp;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  /// 캠프 정보 로드
  Future<void> loadCampInfo(String campId) async {
    _setLoading(true);
    _error = null;

    try {
      // Mock 데이터에서 캠프 정보 조회
      final mockCamps = MockData.getMockCamps();
      _camp = mockCamps.firstWhere(
        (camp) => camp.id == campId,
        orElse: () => CampEntity.empty(),
      );

      if (_camp == null) {
        _error = '캠프 정보를 찾을 수 없습니다';
      }
    } catch (e) {
      _error = '캠프 정보를 불러오는 중 오류가 발생했습니다: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 후기 제출
  Future<bool> submitReview({
    required String campId,
    required String bookingId,
    required double rating,
    required String title,
    required String content,
    required List<String> tags,
    required List<String> imageUrls,
  }) async {
    _setSubmitting(true);
    _error = null;

    try {
      // 후기 제출 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));
      
      // 후기 제출 성공 시뮬레이션 (95% 성공률)
      final success = DateTime.now().millisecond % 20 != 0;
      
      if (!success) {
        _error = '후기 등록 중 오류가 발생했습니다';
      }
      
      return success;
    } catch (e) {
      _error = '후기 등록 중 오류가 발생했습니다: $e';
      return false;
    } finally {
      _setSubmitting(false);
    }
  }

  /// 후기 수정
  Future<bool> updateReview({
    required String reviewId,
    required double rating,
    required String title,
    required String content,
    required List<String> tags,
    required List<String> imageUrls,
  }) async {
    _setSubmitting(true);
    _error = null;

    try {
      // 후기 수정 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      _error = '후기 수정 중 오류가 발생했습니다: $e';
      return false;
    } finally {
      _setSubmitting(false);
    }
  }

  /// 후기 삭제
  Future<bool> deleteReview(String reviewId) async {
    _setSubmitting(true);
    _error = null;

    try {
      // 후기 삭제 시뮬레이션
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _error = '후기 삭제 중 오류가 발생했습니다: $e';
      return false;
    } finally {
      _setSubmitting(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSubmitting(bool submitting) {
    _isSubmitting = submitting;
    notifyListeners();
  }
}

