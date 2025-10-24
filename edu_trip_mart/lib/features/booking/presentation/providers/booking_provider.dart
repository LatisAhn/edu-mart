import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../../core/data/mock_data.dart';
import '../../domain/entities/participant_entity.dart';

/// 예약 Provider
/// 예약 관련 상태와 비즈니스 로직을 관리
class BookingProvider extends ChangeNotifier {
  // 상태 변수들
  dynamic _camp;
  ParticipantEntity? _participantInfo;
  Map<String, dynamic>? _guardianInfo;
  Map<String, dynamic>? _paymentInfo;
  Map<String, dynamic>? _selectedOptions;
  bool _isLoading = false;
  String? _error;

  // Getters
  dynamic get camp => _camp;
  ParticipantEntity? get participantInfo => _participantInfo;
  Map<String, dynamic>? get guardianInfo => _guardianInfo;
  Map<String, dynamic>? get paymentInfo => _paymentInfo;
  Map<String, dynamic>? get selectedOptions => _selectedOptions;
  bool get isLoading => _isLoading;
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

  /// 참가자 정보 설정
  void setParticipantInfo({
    required String name,
    required int age,
    required String phone,
    required String email,
    required String passportNumber,
    required String emergencyContact,
    required String specialRequests,
  }) {
    _participantInfo = ParticipantEntity(
      id: '',
      bookingId: '',
      name: name,
      age: age,
      phone: phone,
      email: email,
      passportNumber: passportNumber,
      emergencyContact: emergencyContact,
      specialRequests: specialRequests,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// 보호자 정보 설정
  void setGuardianInfo({
    required String name,
    required String relationship,
    required String phone,
    required String email,
  }) {
    _guardianInfo = {
      'name': name,
      'relationship': relationship,
      'phone': phone,
      'email': email,
    };
    notifyListeners();
  }

  /// 결제 정보 설정
  void setPaymentInfo({
    required String paymentMethod,
    required String promoCode,
    bool agreeToTerms = false,
  }) {
    _paymentInfo = {
      'paymentMethod': paymentMethod,
      'promoCode': promoCode,
      'agreeToTerms': agreeToTerms,
    };
    notifyListeners();
  }

  /// 선택된 옵션 설정
  void setSelectedOptions({
    required String roomType,
    required bool pickupService,
    required bool insurance,
    required String dietaryOption,
  }) {
    _selectedOptions = {
      'roomType': roomType,
      'pickupService': pickupService,
      'insurance': insurance,
      'dietaryOption': dietaryOption,
    };
    notifyListeners();
  }

  /// 참가자 정보 유효성 검사
  bool isParticipantInfoValid() {
    if (_participantInfo == null) return false;
    
    return _participantInfo!.name.isNotEmpty &&
           _participantInfo!.phone.isNotEmpty &&
           _participantInfo!.passportNumber.isNotEmpty;
  }

  /// 결제 정보 유효성 검사
  bool isPaymentInfoValid() {
    if (_paymentInfo == null) return false;
    
    final paymentMethod = _paymentInfo!['paymentMethod'] as String?;
    final agreeToTerms = _paymentInfo!['agreeToTerms'] as bool?;
    
    return paymentMethod != null && paymentMethod.isNotEmpty && (agreeToTerms ?? false);
  }

  /// 예약 생성
  Future<bool> createBooking() async {
    if (_camp == null || _participantInfo == null) {
      return false;
    }

    try {
      // TODO: 실제 API 호출로 예약 생성
      // 현재는 Mock 데이터로 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));
      
      // 예약 성공 시뮬레이션
      return true;
    } catch (e) {
      _error = '예약 생성 중 오류가 발생했습니다: $e';
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

