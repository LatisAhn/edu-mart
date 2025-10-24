import '../../domain/entities/camp_review_entity.dart';

/// 캠프 리뷰 모델 - JSON 직렬화를 담당
class CampReviewModel extends CampReviewEntity {
  const CampReviewModel({
    required super.id,
    required super.campId,
    required super.userId,
    required super.userName,
    super.userAvatarUrl,
    required super.rating,
    required super.title,
    required super.content,
    required super.imageUrls,
    required super.createdAt,
    required super.updatedAt,
    required super.isVerified,
    required super.helpfulCount,
    required super.helpfulUserIds,
    super.response,
    super.responseDate,
  });

  /// JSON에서 CampReviewModel 생성
  factory CampReviewModel.fromJson(Map<String, dynamic> json) {
    return CampReviewModel(
      id: json['id'] as String,
      campId: json['campId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isVerified: json['isVerified'] as bool,
      helpfulCount: json['helpfulCount'] as int,
      helpfulUserIds: List<String>.from(json['helpfulUserIds'] as List? ?? []),
      response: json['response'] as String?,
      responseDate: json['responseDate'] != null 
          ? DateTime.parse(json['responseDate'] as String)
          : null,
    );
  }

  /// CampReviewModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campId': campId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'rating': rating,
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isVerified': isVerified,
      'helpfulCount': helpfulCount,
      'helpfulUserIds': helpfulUserIds,
      'response': response,
      'responseDate': responseDate?.toIso8601String(),
    };
  }

  /// CampReviewEntity를 CampReviewModel로 변환
  factory CampReviewModel.fromEntity(CampReviewEntity entity) {
    return CampReviewModel(
      id: entity.id,
      campId: entity.campId,
      userId: entity.userId,
      userName: entity.userName,
      userAvatarUrl: entity.userAvatarUrl,
      rating: entity.rating,
      title: entity.title,
      content: entity.content,
      imageUrls: entity.imageUrls,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isVerified: entity.isVerified,
      helpfulCount: entity.helpfulCount,
      helpfulUserIds: entity.helpfulUserIds,
      response: entity.response,
      responseDate: entity.responseDate,
    );
  }

  /// CampReviewModel을 CampReviewEntity로 변환
  CampReviewEntity toEntity() {
    return CampReviewEntity(
      id: id,
      campId: campId,
      userId: userId,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      rating: rating,
      title: title,
      content: content,
      imageUrls: imageUrls,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isVerified: isVerified,
      helpfulCount: helpfulCount,
      helpfulUserIds: helpfulUserIds,
      response: response,
      responseDate: responseDate,
    );
  }

  /// JSON 배열에서 CampReviewModel 리스트 생성
  static List<CampReviewModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CampReviewModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// CampReviewModel 리스트를 JSON 배열로 변환
  static List<Map<String, dynamic>> toJsonList(List<CampReviewModel> models) {
    return models.map((model) => model.toJson()).toList();
  }

  @override
  CampReviewModel copyWith({
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
    return CampReviewModel(
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
}