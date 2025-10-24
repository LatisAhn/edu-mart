/// 캠프 엔티티 - 도메인 레이어의 핵심 비즈니스 객체
/// 캠프의 기본 정보와 비즈니스 로직을 담당
class CampEntity {
  final String id;
  final String title;
  final String description;
  final String location;
  final String country;
  final String city;
  final double price;
  final String currency;
  final int duration; // 일 단위
  final int minAge;
  final int maxAge;
  final String categoryId;
  final String categoryName;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final String providerId;
  final String providerName;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isFeatured;
  final List<String> tags;
  final Map<String, dynamic> amenities; // 편의시설 정보
  final String difficulty; // 초급, 중급, 고급
  final int maxParticipants;
  final int currentParticipants;

  const CampEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.country,
    required this.city,
    required this.price,
    required this.currency,
    required this.duration,
    required this.minAge,
    required this.maxAge,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrls,
    required this.rating,
    required this.reviewCount,
    required this.providerId,
    required this.providerName,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.isFeatured,
    required this.tags,
    required this.amenities,
    required this.difficulty,
    required this.maxParticipants,
    required this.currentParticipants,
  });

  /// 가격을 포맷된 문자열로 반환
  String get formattedPrice {
    return '$currency ${price.toStringAsFixed(0)}';
  }

  /// 연령대를 문자열로 반환
  String get ageRange {
    if (minAge == maxAge) {
      return '$minAge세';
    }
    return '$minAge-$maxAge세';
  }

  /// 기간을 문자열로 반환
  String get formattedDuration {
    if (duration == 1) {
      return '1일';
    } else if (duration < 7) {
      return '$duration일';
    } else if (duration == 7) {
      return '1주';
    } else if (duration < 30) {
      return '${(duration / 7).floor()}주';
    } else {
      return '${(duration / 30).floor()}개월';
    }
  }

  /// 평점을 별점으로 표시할 수 있는 정수로 반환
  int get starRating {
    return rating.round();
  }

  /// 예약 가능 여부
  bool get isAvailable {
    return isActive && 
           currentParticipants < maxParticipants && 
           DateTime.now().isBefore(startDate);
  }

  /// 할인율 계산 (예시: 조기 예약 할인)
  double getDiscountPercentage() {
    final daysUntilStart = startDate.difference(DateTime.now()).inDays;
    if (daysUntilStart > 60) {
      return 0.15; // 15% 할인
    } else if (daysUntilStart > 30) {
      return 0.10; // 10% 할인
    }
    return 0.0;
  }

  /// 할인된 가격 계산
  double get discountedPrice {
    final discount = getDiscountPercentage();
    return price * (1 - discount);
  }

  /// 할인된 가격을 포맷된 문자열로 반환
  String get formattedDiscountedPrice {
    return '$currency ${discountedPrice.toStringAsFixed(0)}';
  }

  /// 복사 생성자
  CampEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? country,
    String? city,
    double? price,
    String? currency,
    int? duration,
    int? minAge,
    int? maxAge,
    String? categoryId,
    String? categoryName,
    List<String>? imageUrls,
    double? rating,
    int? reviewCount,
    String? providerId,
    String? providerName,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isFeatured,
    List<String>? tags,
    Map<String, dynamic>? amenities,
    String? difficulty,
    int? maxParticipants,
    int? currentParticipants,
  }) {
    return CampEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      country: country ?? this.country,
      city: city ?? this.city,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      duration: duration ?? this.duration,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
      amenities: amenities ?? this.amenities,
      difficulty: difficulty ?? this.difficulty,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CampEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CampEntity(id: $id, title: $title, location: $location, price: $formattedPrice)';
  }

  /// 빈 캠프 엔티티 생성
  factory CampEntity.empty() {
    final now = DateTime.now();
    return CampEntity(
      id: '',
      title: '',
      description: '',
      location: '',
      country: '',
      city: '',
      price: 0.0,
      currency: 'KRW',
      duration: 0,
      minAge: 0,
      maxAge: 0,
      categoryId: '',
      categoryName: '',
      imageUrls: const [],
      rating: 0.0,
      reviewCount: 0,
      providerId: '',
      providerName: '',
      startDate: now,
      endDate: now,
      createdAt: now,
      updatedAt: now,
      isActive: false,
      isFeatured: false,
      tags: const [],
      amenities: const {},
      difficulty: '',
      maxParticipants: 0,
      currentParticipants: 0,
    );
  }
}
