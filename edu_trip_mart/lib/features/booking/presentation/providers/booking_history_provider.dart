import 'package:flutter/material.dart';
import '../../../../core/data/mock_data.dart';

/// 예약 내역 Provider
/// 사용자의 예약 내역을 관리하는 Provider
class BookingHistoryProvider extends ChangeNotifier {
  // 상태 변수들
  List<dynamic> _allBookings = [];
  List<dynamic> _upcomingBookings = [];
  List<dynamic> _completedBookings = [];
  List<dynamic> _cancelledBookings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<dynamic> get allBookings => _allBookings;
  List<dynamic> get upcomingBookings => _upcomingBookings;
  List<dynamic> get completedBookings => _completedBookings;
  List<dynamic> get cancelledBookings => _cancelledBookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 예약 내역 로드
  Future<void> loadBookingHistory() async {
    _setLoading(true);
    _error = null;

    try {
      // Mock 데이터로 예약 내역 생성
      final mockCamps = MockData.getMockCamps();
      final now = DateTime.now();
      
      _allBookings = [
        _MockBooking(
          id: 'booking_001',
          camp: mockCamps[0],
          status: 'confirmed',
          startDate: now.add(const Duration(days: 30)),
          endDate: now.add(const Duration(days: 37)),
          participantCount: 1,
          paymentMethod: 'card',
          totalAmount: mockCamps[0].price,
          currency: mockCamps[0].currency,
          createdAt: now.subtract(const Duration(days: 10)),
        ),
        _MockBooking(
          id: 'booking_002',
          camp: mockCamps[1],
          status: 'pending',
          startDate: now.add(const Duration(days: 60)),
          endDate: now.add(const Duration(days: 67)),
          participantCount: 1,
          paymentMethod: 'kakao',
          totalAmount: mockCamps[1].price,
          currency: mockCamps[1].currency,
          createdAt: now.subtract(const Duration(days: 5)),
        ),
        _MockBooking(
          id: 'booking_003',
          camp: mockCamps[2],
          status: 'completed',
          startDate: now.subtract(const Duration(days: 30)),
          endDate: now.subtract(const Duration(days: 23)),
          participantCount: 1,
          paymentMethod: 'bank',
          totalAmount: mockCamps[2].price,
          currency: mockCamps[2].currency,
          createdAt: now.subtract(const Duration(days: 45)),
        ),
        _MockBooking(
          id: 'booking_004',
          camp: mockCamps[3],
          status: 'cancelled',
          startDate: now.add(const Duration(days: 15)),
          endDate: now.add(const Duration(days: 22)),
          participantCount: 1,
          paymentMethod: 'card',
          totalAmount: mockCamps[3].price,
          currency: mockCamps[3].currency,
          createdAt: now.subtract(const Duration(days: 20)),
        ),
      ];

      // 상태별로 분류
      _upcomingBookings = _allBookings.where((booking) => 
        booking.status == 'confirmed' || booking.status == 'pending'
      ).toList();
      
      _completedBookings = _allBookings.where((booking) => 
        booking.status == 'completed'
      ).toList();
      
      _cancelledBookings = _allBookings.where((booking) => 
        booking.status == 'cancelled'
      ).toList();

    } catch (e) {
      _error = '예약 내역을 불러오는 중 오류가 발생했습니다: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 예약 취소
  Future<bool> cancelBooking(String bookingId) async {
    try {
      // 예약 취소 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));
      
      // 해당 예약의 상태를 'cancelled'로 변경
      final bookingIndex = _allBookings.indexWhere((booking) => booking.id == bookingId);
      if (bookingIndex != -1) {
        _allBookings[bookingIndex] = _MockBooking(
          id: _allBookings[bookingIndex].id,
          camp: _allBookings[bookingIndex].camp,
          status: 'cancelled',
          startDate: _allBookings[bookingIndex].startDate,
          endDate: _allBookings[bookingIndex].endDate,
          participantCount: _allBookings[bookingIndex].participantCount,
          paymentMethod: _allBookings[bookingIndex].paymentMethod,
          totalAmount: _allBookings[bookingIndex].totalAmount,
          currency: _allBookings[bookingIndex].currency,
          createdAt: _allBookings[bookingIndex].createdAt,
        );
        
        // 상태별 목록 재분류
        _upcomingBookings = _allBookings.where((booking) => 
          booking.status == 'confirmed' || booking.status == 'pending'
        ).toList();
        
        _cancelledBookings = _allBookings.where((booking) => 
          booking.status == 'cancelled'
        ).toList();
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = '예약 취소 중 오류가 발생했습니다: $e';
      return false;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadBookingHistory();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

/// Mock 예약 데이터 클래스
class _MockBooking {
  final String id;
  final dynamic camp;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int participantCount;
  final String paymentMethod;
  final double totalAmount;
  final String currency;
  final DateTime createdAt;

  _MockBooking({
    required this.id,
    required this.camp,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.participantCount,
    required this.paymentMethod,
    required this.totalAmount,
    required this.currency,
    required this.createdAt,
  });
}

