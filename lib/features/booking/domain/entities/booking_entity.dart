/// 예약 엔티티
/// 캠프 예약 정보를 나타내는 도메인 엔티티
class BookingEntity {
  final String id;
  final String campId;
  final String userId;
  final String status;
  final double totalAmount;
  final String currency;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime startDate;
  final DateTime endDate;
  final int participantCount;
  final List<String> participantIds;
  final Map<String, dynamic> specialRequests;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingEntity({
    required this.id,
    required this.campId,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.startDate,
    required this.endDate,
    required this.participantCount,
    required this.participantIds,
    required this.specialRequests,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 빈 예약 엔티티 생성
  factory BookingEntity.empty() {
    final now = DateTime.now();
    return BookingEntity(
      id: '',
      campId: '',
      userId: '',
      status: 'pending',
      totalAmount: 0.0,
      currency: 'KRW',
      paymentMethod: '',
      paymentStatus: 'pending',
      startDate: now,
      endDate: now,
      participantCount: 0,
      participantIds: const [],
      specialRequests: const {},
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 예약 엔티티 복사
  BookingEntity copyWith({
    String? id,
    String? campId,
    String? userId,
    String? status,
    double? totalAmount,
    String? currency,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    int? participantCount,
    List<String>? participantIds,
    Map<String, dynamic>? specialRequests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingEntity(
      id: id ?? this.id,
      campId: campId ?? this.campId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      participantCount: participantCount ?? this.participantCount,
      participantIds: participantIds ?? this.participantIds,
      specialRequests: specialRequests ?? this.specialRequests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingEntity &&
        other.id == id &&
        other.campId == campId &&
        other.userId == userId &&
        other.status == status &&
        other.totalAmount == totalAmount &&
        other.currency == currency &&
        other.paymentMethod == paymentMethod &&
        other.paymentStatus == paymentStatus &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.participantCount == participantCount &&
        other.participantIds == participantIds &&
        other.specialRequests == specialRequests &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      campId,
      userId,
      status,
      totalAmount,
      currency,
      paymentMethod,
      paymentStatus,
      startDate,
      endDate,
      participantCount,
      participantIds,
      specialRequests,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'BookingEntity(id: $id, campId: $campId, userId: $userId, status: $status, totalAmount: $totalAmount, currency: $currency, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus)';
  }
}

