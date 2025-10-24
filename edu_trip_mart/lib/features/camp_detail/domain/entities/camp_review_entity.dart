/// 캠프 후기 엔티티
/// 캠프에 대한 후기 정보를 나타내는 도메인 엔티티
class CampReviewEntity {
  final String id;
  final String campId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating;
  final String title;
  final String content;
  final List<String> imageUrls;
  final bool isVerified;
  final int helpfulCount;
  final List<String> helpfulUserIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? response;
  final DateTime? responseDate;

  const CampReviewEntity({
    required this.id,
    required this.campId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rating,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    required this.helpfulCount,
    required this.helpfulUserIds,
    this.response,
    this.responseDate,
  });

  /// 빈 후기 엔티티 생성
  factory CampReviewEntity.empty() {
    final now = DateTime.now();
    return CampReviewEntity(
      id: '',
      campId: '',
      userId: '',
      userName: '',
      userAvatarUrl: null,
      rating: 0.0,
      title: '',
      content: '',
      imageUrls: const [],
      isVerified: false,
      helpfulCount: 0,
      helpfulUserIds: const [],
      createdAt: now,
      updatedAt: now,
      response: null,
      responseDate: null,
    );
  }

  /// 후기 엔티티 복사
  CampReviewEntity copyWith({
    String? id,
    String? campId,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    double? rating,
    String? title,
    String? content,
    List<String>? imageUrls,
    bool? isVerified,
    int? helpfulCount,
    List<String>? helpfulUserIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? response,
    DateTime? responseDate,
  }) {
    return CampReviewEntity(
      id: id ?? this.id,
      campId: campId ?? this.campId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      isVerified: isVerified ?? this.isVerified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      helpfulUserIds: helpfulUserIds ?? this.helpfulUserIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      response: response ?? this.response,
      responseDate: responseDate ?? this.responseDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CampReviewEntity &&
        other.id == id &&
        other.campId == campId &&
        other.userId == userId &&
        other.userName == userName &&
        other.userAvatarUrl == userAvatarUrl &&
        other.rating == rating &&
        other.title == title &&
        other.content == content &&
        other.imageUrls == imageUrls &&
        other.isVerified == isVerified &&
        other.helpfulCount == helpfulCount &&
        other.helpfulUserIds == helpfulUserIds &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.response == response &&
        other.responseDate == responseDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      campId,
      userId,
      userName,
      userAvatarUrl,
      rating,
      title,
      content,
      imageUrls,
      isVerified,
      helpfulCount,
      helpfulUserIds,
      createdAt,
      updatedAt,
      response,
      responseDate,
    );
  }

  @override
  String toString() {
    return 'CampReviewEntity(id: $id, campId: $campId, userId: $userId, userName: $userName, rating: $rating, title: $title, content: $content, isVerified: $isVerified, helpfulCount: $helpfulCount)';
  }
}

