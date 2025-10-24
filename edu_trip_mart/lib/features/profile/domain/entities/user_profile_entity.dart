/// 사용자 프로필 엔티티
/// 사용자의 프로필 정보를 나타내는 도메인 엔티티
class UserProfileEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
    this.address,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 빈 사용자 프로필 엔티티 생성
  factory UserProfileEntity.empty() {
    final now = DateTime.now();
    return UserProfileEntity(
      id: '',
      name: '',
      email: '',
      phone: '',
      preferences: const {},
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 사용자 프로필 엔티티 복사
  UserProfileEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.profileImageUrl == profileImageUrl &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.address == address &&
        other.preferences == preferences &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      phone,
      profileImageUrl,
      dateOfBirth,
      gender,
      address,
      preferences,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfileEntity(id: $id, name: $name, email: $email, phone: $phone, profileImageUrl: $profileImageUrl)';
  }
}

