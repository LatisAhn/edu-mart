/// 캠프 리뷰 엔티티
/// 캠프에 대한 사용자 리뷰와 평점을 담당하는 도메인 객체
class CampReviewEntity {
  final String id;
  final String campId;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final double rating; // 1.0 ~ 5.0
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified; // 검증된 리뷰인지 여부
  final int helpfulCount; // 도움이 된 횟수
  final List<String> helpfulUserIds; // 도움이 되었다고 한 사용자 ID들
  final String? response; // 캠프 제공자의 답변
  final DateTime? responseDate; // 답변 작성일

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

  /// 평점을 별점으로 표시할 수 있는 정수로 반환
  int get starRating {
    return rating.round();
  }

  /// 평점을 별점 문자열로 반환 (예: "★★★★☆")
  String get starRatingString {
    final fullStars = rating.floor();
    final hasHalfStar = rating - fullStars >= 0.5;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    
    return '★' * fullStars + 
           (hasHalfStar ? '☆' : '') + 
           '☆' * emptyStars;
  }

  /// 리뷰가 도움이 되었는지 확인 (특정 사용자 기준)
  bool isHelpfulForUser(String userId) {
    return helpfulUserIds.contains(userId);
  }

  /// 리뷰에 도움됨 표시 추가/제거
  CampReviewEntity toggleHelpful(String userId) {
    final newHelpfulUserIds = List<String>.from(helpfulUserIds);
    final newHelpfulCount = helpfulCount;
    
    if (newHelpfulUserIds.contains(userId)) {
      newHelpfulUserIds.remove(userId);
      return copyWith(
        helpfulUserIds: newHelpfulUserIds,
        helpfulCount: newHelpfulCount - 1,
      );
    } else {
      newHelpfulUserIds.add(userId);
      return copyWith(
        helpfulUserIds: newHelpfulUserIds,
        helpfulCount: newHelpfulCount + 1,
      );
    }
  }

  /// 리뷰 작성일을 상대적 시간으로 반환 (예: "3일 전")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years년 전';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months개월 전';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  /// 리뷰가 이미지가 있는지 확인
  bool get hasImages {
    return imageUrls.isNotEmpty;
  }

  /// 리뷰가 답변이 있는지 확인
  bool get hasResponse {
    return response != null && response!.isNotEmpty;
  }

  /// 복사 생성자
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
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    int? helpfulCount,
    List<String>? helpfulUserIds,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      helpfulUserIds: helpfulUserIds ?? this.helpfulUserIds,
      response: response ?? this.response,
      responseDate: responseDate ?? this.responseDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CampReviewEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CampReviewEntity(id: $id, campId: $campId, rating: $rating, title: $title)';
  }
}
