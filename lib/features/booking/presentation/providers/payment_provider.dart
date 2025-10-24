import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../../core/data/mock_data.dart';

/// 결제 Provider
/// 결제 관련 상태와 비즈니스 로직을 관리
class PaymentProvider extends ChangeNotifier {
  // 상태 변수들
  dynamic _camp;
  bool _isLoading = false;
  bool _isProcessing = false;
  String? _error;

  // Getters
  dynamic get camp => _camp;
  bool get isLoading => _isLoading;
  bool get isProcessing => _isProcessing;
  String? get error => _error;

  /// 결제 정보 로드
  Future<void> loadPaymentInfo(String campId) async {
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
      _error = '결제 정보를 불러오는 중 오류가 발생했습니다: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 결제 처리
  Future<bool> processPayment({
    required String campId,
    required Map<String, dynamic> participantInfo,
    required String paymentMethod,
  }) async {
    _setProcessing(true);
    _error = null;

    try {
      // 결제 처리 시뮬레이션
      await Future.delayed(const Duration(seconds: 3));
      
      // 결제 성공 시뮬레이션 (90% 성공률)
      final success = DateTime.now().millisecond % 10 != 0;
      
      if (!success) {
        _error = '결제 처리 중 오류가 발생했습니다';
      }
      
      return success;
    } catch (e) {
      _error = '결제 처리 중 오류가 발생했습니다: $e';
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  /// 결제 취소
  Future<bool> cancelPayment(String paymentId) async {
    _setProcessing(true);
    _error = null;

    try {
      // 결제 취소 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      _error = '결제 취소 중 오류가 발생했습니다: $e';
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }
}

