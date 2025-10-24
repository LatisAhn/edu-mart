/// 참가자 엔티티
/// 캠프 참가자 정보를 나타내는 도메인 엔티티
class ParticipantEntity {
  final String id;
  final String bookingId;
  final String name;
  final int age;
  final String phone;
  final String email;
  final String passportNumber;
  final String emergencyContact;
  final String specialRequests;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParticipantEntity({
    required this.id,
    required this.bookingId,
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
    required this.passportNumber,
    required this.emergencyContact,
    required this.specialRequests,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 빈 참가자 엔티티 생성
  factory ParticipantEntity.empty() {
    final now = DateTime.now();
    return ParticipantEntity(
      id: '',
      bookingId: '',
      name: '',
      age: 0,
      phone: '',
      email: '',
      passportNumber: '',
      emergencyContact: '',
      specialRequests: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 참가자 엔티티 복사
  ParticipantEntity copyWith({
    String? id,
    String? bookingId,
    String? name,
    int? age,
    String? phone,
    String? email,
    String? passportNumber,
    String? emergencyContact,
    String? specialRequests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ParticipantEntity(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      name: name ?? this.name,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      passportNumber: passportNumber ?? this.passportNumber,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      specialRequests: specialRequests ?? this.specialRequests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParticipantEntity &&
        other.id == id &&
        other.bookingId == bookingId &&
        other.name == name &&
        other.age == age &&
        other.phone == phone &&
        other.email == email &&
        other.passportNumber == passportNumber &&
        other.emergencyContact == emergencyContact &&
        other.specialRequests == specialRequests &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      bookingId,
      name,
      age,
      phone,
      email,
      passportNumber,
      emergencyContact,
      specialRequests,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'ParticipantEntity(id: $id, bookingId: $bookingId, name: $name, age: $age, phone: $phone, email: $email)';
  }
}

