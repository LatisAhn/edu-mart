import '../../features/home/domain/entities/camp_entity.dart';
import '../../features/home/domain/entities/camp_category_entity.dart';
import '../../features/camp_detail/domain/entities/camp_review_entity.dart';
import '../../features/booking/domain/entities/booking_entity.dart';
import '../../features/booking/domain/entities/participant_entity.dart';
import '../../features/profile/domain/entities/user_profile_entity.dart';

/// Mock 데이터 생성기
/// 개발 및 테스트를 위한 샘플 데이터를 제공
class MockData {
  /// Mock 캠프 데이터 생성
  static List<CampEntity> getMockCamps() {
    return [
      CampEntity(
        id: '1',
        title: '미국 뉴욕 영어 캠프',
        description: '뉴욕 맨하튼에서 진행되는 2주 영어 캠프입니다. 현지 원어민과 함께 생활하며 자연스럽게 영어를 습득할 수 있습니다.',
        location: '뉴욕, 미국',
        country: '미국',
        city: '뉴욕',
        price: 2500000,
        currency: 'KRW',
        duration: 14,
        minAge: 16,
        maxAge: 25,
        categoryId: '1',
        categoryName: '어학',
        imageUrls: [
          'https://picsum.photos/800/600?random=1',
          'https://picsum.photos/800/600?random=2',
          'https://picsum.photos/800/600?random=3',
        ],
        rating: 4.5,
        reviewCount: 128,
        providerId: '1',
        providerName: 'EduTrip Korea',
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 44)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        isActive: true,
        isFeatured: true,
        tags: ['영어', '뉴욕', '어학', '맨하튼'],
        amenities: {
          'accommodation': '기숙사',
          'meals': '3식 제공',
          'airport_pickup': '공항 픽업',
          'wifi': '무료 WiFi',
          'laundry': '세탁 시설',
        },
        difficulty: '중급',
        maxParticipants: 30,
        currentParticipants: 15,
      ),
      CampEntity(
        id: '2',
        title: '영국 런던 영어 캠프',
        description: '런던 중심가에서 진행되는 3주 영어 캠프입니다. 영국 문화를 체험하며 영어 실력을 향상시킬 수 있습니다.',
        location: '런던, 영국',
        country: '영국',
        city: '런던',
        price: 3200000,
        currency: 'KRW',
        duration: 21,
        minAge: 18,
        maxAge: 30,
        categoryId: '1',
        categoryName: '어학',
        imageUrls: [
          'https://picsum.photos/800/600?random=7',
          'https://picsum.photos/800/600?random=8',
          'https://picsum.photos/800/600?random=9',
        ],
        rating: 4.8,
        reviewCount: 256,
        providerId: '2',
        providerName: 'London English Center',
        startDate: DateTime.now().add(const Duration(days: 45)),
        endDate: DateTime.now().add(const Duration(days: 66)),
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
        isActive: true,
        isFeatured: false,
        tags: ['영어', '런던', '어학', '영국문화'],
        amenities: {
          'accommodation': '홈스테이',
          'meals': '2식 제공',
          'airport_pickup': '공항 픽업',
          'wifi': '무료 WiFi',
          'cultural_activities': '문화 체험',
        },
        difficulty: '고급',
        maxParticipants: 25,
        currentParticipants: 20,
      ),
      CampEntity(
        id: '3',
        title: '캐나다 토론토 영어 캠프',
        description: '토론토 대학에서 진행되는 4주 영어 캠프입니다. 학업과 여행을 동시에 즐길 수 있는 프로그램입니다.',
        location: '토론토, 캐나다',
        country: '캐나다',
        city: '토론토',
        price: 2800000,
        currency: 'KRW',
        duration: 28,
        minAge: 16,
        maxAge: 28,
        categoryId: '1',
        categoryName: '어학',
        imageUrls: [
          'https://picsum.photos/800/600?random=10',
          'https://picsum.photos/800/600?random=11',
          'https://picsum.photos/800/600?random=11',
        ],
        rating: 4.3,
        reviewCount: 89,
        providerId: '3',
        providerName: 'Toronto Language School',
        startDate: DateTime.now().add(const Duration(days: 60)),
        endDate: DateTime.now().add(const Duration(days: 88)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        isActive: true,
        isFeatured: false,
        tags: ['영어', '토론토', '어학', '대학'],
        amenities: {
          'accommodation': '기숙사',
          'meals': '3식 제공',
          'airport_pickup': '공항 픽업',
          'wifi': '무료 WiFi',
          'library': '도서관 이용',
        },
        difficulty: '중급',
        maxParticipants: 35,
        currentParticipants: 12,
      ),
      CampEntity(
        id: '4',
        title: '호주 시드니 영어 캠프',
        description: '시드니 해변가에서 진행되는 3주 영어 캠프입니다. 자연과 함께하며 영어를 배울 수 있습니다.',
        location: '시드니, 호주',
        country: '호주',
        city: '시드니',
        price: 2200000,
        currency: 'KRW',
        duration: 21,
        minAge: 16,
        maxAge: 30,
        categoryId: '1',
        categoryName: '어학',
        imageUrls: [
          'https://picsum.photos/800/600?random=11',
          'https://picsum.photos/800/600?random=11',
          'https://picsum.photos/800/600?random=11',
        ],
        rating: 4.6,
        reviewCount: 156,
        providerId: '4',
        providerName: 'Sydney English Academy',
        startDate: DateTime.now().add(const Duration(days: 75)),
        endDate: DateTime.now().add(const Duration(days: 96)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        isActive: true,
        isFeatured: false,
        tags: ['영어', '시드니', '어학', '해변'],
        amenities: {
          'accommodation': '홈스테이',
          'meals': '2식 제공',
          'airport_pickup': '공항 픽업',
          'wifi': '무료 WiFi',
          'beach_activities': '해변 활동',
        },
        difficulty: '중급',
        maxParticipants: 28,
        currentParticipants: 18,
      ),
      CampEntity(
        id: '5',
        title: '아일랜드 더블린 영어 캠프',
        description: '더블린 시내에서 진행되는 2주 영어 캠프입니다. 아일랜드의 독특한 문화를 경험할 수 있습니다.',
        location: '더블린, 아일랜드',
        country: '아일랜드',
        city: '더블린',
        price: 1900000,
        currency: 'KRW',
        duration: 14,
        minAge: 18,
        maxAge: 35,
        categoryId: '1',
        categoryName: '어학',
        imageUrls: [
          'https://picsum.photos/800/600?random=11',
          'https://picsum.photos/800/600?random=11',
          'https://picsum.photos/800/600?random=11',
        ],
        rating: 4.2,
        reviewCount: 67,
        providerId: '5',
        providerName: 'Dublin Language Institute',
        startDate: DateTime.now().add(const Duration(days: 90)),
        endDate: DateTime.now().add(const Duration(days: 104)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        isActive: true,
        isFeatured: false,
        tags: ['영어', '더블린', '어학', '아일랜드'],
        amenities: {
          'accommodation': '기숙사',
          'meals': '3식 제공',
          'airport_pickup': '공항 픽업',
          'wifi': '무료 WiFi',
          'pub_tours': '펍 투어',
        },
        difficulty: '초급',
        maxParticipants: 20,
        currentParticipants: 8,
      ),
    ];
  }

  /// Mock 카테고리 데이터 생성
  static List<CampCategoryEntity> getMockCategories() {
    return [
      CampCategoryEntity(
        id: '1',
        name: '어학',
        description: '영어 학습을 위한 캠프',
        iconUrl: 'https://picsum.photos/100/100?random=16',
        color: '#4A90E2',
        sortOrder: 1,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        updatedAt: DateTime.now(),
        campCount: 45,
      ),
      CampCategoryEntity(
        id: '2',
        name: '스포츠',
        description: '스포츠 활동을 위한 캠프',
        iconUrl: 'https://picsum.photos/100/100?random=17',
        color: '#7ED321',
        sortOrder: 2,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
        campCount: 23,
      ),
      CampCategoryEntity(
        id: '3',
        name: '문화',
        description: '문화 체험을 위한 캠프',
        iconUrl: 'https://picsum.photos/100/100?random=18',
        color: '#F5A623',
        sortOrder: 3,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 80)),
        updatedAt: DateTime.now(),
        campCount: 18,
      ),
      CampCategoryEntity(
        id: '4',
        name: '여행',
        description: '여행을 위한 캠프',
        iconUrl: 'https://picsum.photos/100/100?random=19',
        color: '#50E3C2',
        sortOrder: 4,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 70)),
        updatedAt: DateTime.now(),
        campCount: 32,
      ),
      CampCategoryEntity(
        id: '5',
        name: '캠프',
        description: '일반 캠프 활동',
        iconUrl: 'https://picsum.photos/100/100?random=20',
        color: '#BD10E0',
        sortOrder: 5,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
        campCount: 15,
      ),
      CampCategoryEntity(
        id: '6',
        name: '체험',
        description: '다양한 체험 활동',
        iconUrl: 'https://picsum.photos/100/100?random=12',
        color: '#B8E986',
        sortOrder: 6,
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
        updatedAt: DateTime.now(),
        campCount: 28,
      ),
    ];
  }


  /// Mock 검색 제안 데이터 생성
  static List<String> getMockSearchSuggestions() {
    return [
      '뉴욕 영어 캠프',
      '런던 영어 캠프',
      '토론토 영어 캠프',
      '시드니 영어 캠프',
      '더블린 영어 캠프',
      '미국 영어 캠프',
      '영국 영어 캠프',
      '캐나다 영어 캠프',
      '호주 영어 캠프',
      '아일랜드 영어 캠프',
    ];
  }

  /// Mock 검색 히스토리 데이터 생성
  static List<String> getMockSearchHistory() {
    return [
      '뉴욕 영어 캠프',
      '런던 영어 캠프',
      '토론토 영어 캠프',
      '미국 영어 캠프',
      '영국 영어 캠프',
    ];
  }

  /// Mock 예약 데이터 생성
  static List<BookingEntity> getMockBookings() {
    final now = DateTime.now();
    return [
      BookingEntity(
        id: 'booking_001',
        campId: '1',
        userId: 'user_001',
        status: 'confirmed',
        totalAmount: 2500000,
        currency: 'KRW',
        paymentMethod: 'card',
        paymentStatus: 'completed',
        startDate: now.add(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 44)),
        participantCount: 1,
        participantIds: ['participant_001'],
        specialRequests: {
          'dietary_restrictions': '없음',
          'medical_conditions': '없음',
          'special_needs': '없음',
        },
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      BookingEntity(
        id: 'booking_002',
        campId: '2',
        userId: 'user_001',
        status: 'pending',
        totalAmount: 1800000,
        currency: 'KRW',
        paymentMethod: 'kakao',
        paymentStatus: 'pending',
        startDate: now.add(const Duration(days: 60)),
        endDate: now.add(const Duration(days: 74)),
        participantCount: 1,
        participantIds: ['participant_002'],
        specialRequests: {
          'dietary_restrictions': '채식주의',
          'medical_conditions': '없음',
          'special_needs': '없음',
        },
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      BookingEntity(
        id: 'booking_003',
        campId: '3',
        userId: 'user_001',
        status: 'completed',
        totalAmount: 3200000,
        currency: 'KRW',
        paymentMethod: 'bank',
        paymentStatus: 'completed',
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.subtract(const Duration(days: 16)),
        participantCount: 1,
        participantIds: ['participant_003'],
        specialRequests: {
          'dietary_restrictions': '없음',
          'medical_conditions': '없음',
          'special_needs': '없음',
        },
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 16)),
      ),
    ];
  }

  /// Mock 참가자 데이터 생성
  static List<ParticipantEntity> getMockParticipants() {
    final now = DateTime.now();
    return [
      ParticipantEntity(
        id: 'participant_001',
        bookingId: 'booking_001',
        name: '김학생',
        age: 18,
        phone: '010-1234-5678',
        email: 'student@example.com',
        passportNumber: 'M12345678',
        emergencyContact: '010-9876-5432',
        specialRequests: '없음',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      ParticipantEntity(
        id: 'participant_002',
        bookingId: 'booking_002',
        name: '이학생',
        age: 20,
        phone: '010-2345-6789',
        email: 'student2@example.com',
        passportNumber: 'M23456789',
        emergencyContact: '010-8765-4321',
        specialRequests: '채식주의 식사 요청',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      ParticipantEntity(
        id: 'participant_003',
        bookingId: 'booking_003',
        name: '박학생',
        age: 22,
        phone: '010-3456-7890',
        email: 'student3@example.com',
        passportNumber: 'M34567890',
        emergencyContact: '010-7654-3210',
        specialRequests: '없음',
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 16)),
      ),
    ];
  }

  /// Mock 사용자 프로필 데이터 생성
  static UserProfileEntity getMockUserProfile() {
    final now = DateTime.now();
    return UserProfileEntity(
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
        'theme': 'light',
      },
      createdAt: now.subtract(const Duration(days: 365)),
      updatedAt: now,
    );
  }

  /// Mock 후기 데이터 생성
  static List<CampReviewEntity> getMockReviews() {
    final now = DateTime.now();
    return [
      CampReviewEntity(
        id: 'review_001',
        campId: '1',
        userId: 'user_001',
        userName: '김학부모',
        userAvatarUrl: 'https://via.placeholder.com/50',
        rating: 4.5,
        title: '정말 좋은 경험이었습니다!',
        content: '강사님들이 친절하시고 프로그램이 체계적이었습니다. 아이가 영어에 대한 자신감을 많이 얻었어요. 특히 현지 문화 체험 프로그램이 인상적이었습니다.',
        imageUrls: [
          'https://picsum.photos/400/300?random=13',
          'https://picsum.photos/400/300?random=14',
        ],
        isVerified: true,
        helpfulCount: 12,
        helpfulUserIds: ['user_002', 'user_003'],
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),
      CampReviewEntity(
        id: 'review_002',
        campId: '2',
        userId: 'user_002',
        userName: '이학부모',
        userAvatarUrl: 'https://via.placeholder.com/50',
        rating: 5.0,
        title: '완벽한 캠프였어요',
        content: '숙소도 깔끔하고 식사도 맛있었습니다. 아이가 정말 즐거워했고, 영어 실력도 많이 늘었어요. 다음에도 참여하고 싶습니다.',
        imageUrls: [
          'https://picsum.photos/400/300?random=15',
        ],
        isVerified: true,
        helpfulCount: 8,
        helpfulUserIds: ['user_001'],
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      CampReviewEntity(
        id: 'review_003',
        campId: '3',
        userId: 'user_003',
        userName: '박학부모',
        userAvatarUrl: 'https://via.placeholder.com/50',
        rating: 4.0,
        title: '전반적으로 만족스러웠어요',
        content: '프로그램은 좋았지만 일부 일정이 조금 빡빡했어요. 그래도 아이가 많이 배웠다고 하니 다행입니다.',
        imageUrls: [],
        isVerified: true,
        helpfulCount: 5,
        helpfulUserIds: [],
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 45)),
      ),
    ];
  }

  /// Mock 데이터 추가 메서드들
  static void addMockReview(CampReviewEntity review) {
    // 실제 구현에서는 데이터베이스에 추가
  }

  static void updateMockCamp(CampEntity camp) {
    // 실제 구현에서는 데이터베이스 업데이트
  }

  static void addSearchHistory(String query) {
    // 실제 구현에서는 로컬 저장소에 추가
  }

  static void removeSearchHistory(String query) {
    // 실제 구현에서는 로컬 저장소에서 제거
  }

  static void clearSearchHistory() {
    // 실제 구현에서는 로컬 저장소 초기화
  }
}
