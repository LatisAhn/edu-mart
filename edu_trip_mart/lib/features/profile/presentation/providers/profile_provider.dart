import 'package:flutter/material.dart';
import '../../../../core/data/mock_data.dart';
import '../../domain/entities/user_profile_entity.dart';

/// 프로필 Provider
/// 사용자 프로필 및 관련 데이터를 관리
class ProfileProvider extends ChangeNotifier {
  // 상태 변수들
  UserProfileEntity? _userProfile;
  List<dynamic> _recentBookings = [];
  List<dynamic> _recentReviews = [];
  bool _isLoading = false;
  String? _error;

  // 통계 데이터
  int _bookingCount = 0;
  int _completedCamps = 0;
  int _reviewCount = 0;
  int _points = 0;

  // Getters
  UserProfileEntity? get userProfile => _userProfile;
  List<dynamic> get recentBookings => _recentBookings;
  List<dynamic> get recentReviews => _recentReviews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get bookingCount => _bookingCount;
  int get completedCamps => _completedCamps;
  int get reviewCount => _reviewCount;
  int get points => _points;

  /// 사용자 프로필 로드
  Future<void> loadUserProfile() async {
    _setLoading(true);
    _error = null;

    try {
      // Mock 데이터에서 사용자 프로필 생성
      _userProfile = UserProfileEntity(
        id: 'user_001',
        name: '김학부모',
        email: 'parent@example.com',
        phone: '010-1234-5678',
        profileImageUrl: 'https://via.placeholder.com/150',
        dateOfBirth: DateTime(1985, 5, 15),
        gender: 'female',
        address: '서울특별시 강남구',
        preferences: {
          'notifications': true,
          'marketing': false,
          'language': 'ko',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      );

      // 통계 데이터 로드
      await _loadStatistics();
      
      // 최근 예약 내역 로드
      await _loadRecentBookings();
      
      // 최근 후기 로드
      await _loadRecentReviews();

    } catch (e) {
      _error = '프로필 정보를 불러오는 중 오류가 발생했습니다: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// 통계 데이터 로드
  Future<void> _loadStatistics() async {
    // Mock 데이터로 통계 생성
    _bookingCount = 12;
    _completedCamps = 8;
    _reviewCount = 6;
    _points = 1250;
  }

  /// 최근 예약 내역 로드
  Future<void> _loadRecentBookings() async {
    // Mock 데이터로 최근 예약 내역 생성
    final mockCamps = MockData.getMockCamps();
    _recentBookings = [
      _MockBooking(
        id: 'booking_001',
        camp: mockCamps[0],
        status: 'confirmed',
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 37)),
      ),
      _MockBooking(
        id: 'booking_002',
        camp: mockCamps[1],
        status: 'pending',
        startDate: DateTime.now().add(const Duration(days: 60)),
        endDate: DateTime.now().add(const Duration(days: 67)),
      ),
      _MockBooking(
        id: 'booking_003',
        camp: mockCamps[2],
        status: 'confirmed',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().subtract(const Duration(days: 23)),
      ),
    ];
  }

  /// 최근 후기 로드
  Future<void> _loadRecentReviews() async {
    // Mock 데이터로 최근 후기 생성
    _recentReviews = [
      _MockReview(
        id: 'review_001',
        title: '정말 좋은 경험이었습니다!',
        content: '강사님들이 친절하시고 프로그램이 체계적이었습니다. 아이가 영어에 대한 자신감을 많이 얻었어요.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      _MockReview(
        id: 'review_002',
        title: '다시 참여하고 싶어요',
        content: '안전한 환경에서 다양한 액티비티를 경험할 수 있어서 좋았습니다.',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
    ];
  }

  /// 프로필 업데이트
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) async {
    if (_userProfile == null) return false;

    try {
      _userProfile = _userProfile!.copyWith(
        name: name ?? _userProfile!.name,
        phone: phone ?? _userProfile!.phone,
        address: address ?? _userProfile!.address,
        profileImageUrl: profileImageUrl ?? _userProfile!.profileImageUrl,
        updatedAt: DateTime.now(),
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = '프로필 업데이트 중 오류가 발생했습니다: $e';
      return false;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadUserProfile();
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

  _MockBooking({
    required this.id,
    required this.camp,
    required this.status,
    required this.startDate,
    required this.endDate,
  });
}

/// Mock 후기 데이터 클래스
class _MockReview {
  final String id;
  final String title;
  final String content;
  final double rating;
  final DateTime? createdAt;

  _MockReview({
    required this.id,
    required this.title,
    required this.content,
    required this.rating,
    required this.createdAt,
  });
}

