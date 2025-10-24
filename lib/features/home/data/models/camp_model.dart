import '../../domain/entities/camp_entity.dart';

/// 캠프 모델 - 데이터 레이어의 JSON 직렬화를 담당
/// API 응답을 엔티티로 변환하는 역할
class CampModel extends CampEntity {
  const CampModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.country,
    required super.city,
    required super.price,
    required super.currency,
    required super.duration,
    required super.minAge,
    required super.maxAge,
    required super.categoryId,
    required super.categoryName,
    required super.imageUrls,
    required super.rating,
    required super.reviewCount,
    required super.providerId,
    required super.providerName,
    required super.startDate,
    required super.endDate,
    required super.createdAt,
    required super.updatedAt,
    required super.isActive,
    required super.isFeatured,
    required super.tags,
    required super.amenities,
    required super.difficulty,
    required super.maxParticipants,
    required super.currentParticipants,
  });

  /// JSON에서 CampModel 생성
  factory CampModel.fromJson(Map<String, dynamic> json) {
    return CampModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      duration: json['duration'] as int,
      minAge: json['minAge'] as int,
      maxAge: json['maxAge'] as int,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool,
      isFeatured: json['isFeatured'] as bool,
      tags: List<String>.from(json['tags'] as List),
      amenities: Map<String, dynamic>.from(json['amenities'] as Map),
      difficulty: json['difficulty'] as String,
      maxParticipants: json['maxParticipants'] as int,
      currentParticipants: json['currentParticipants'] as int,
    );
  }

  /// CampModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'country': country,
      'city': city,
      'price': price,
      'currency': currency,
      'duration': duration,
      'minAge': minAge,
      'maxAge': maxAge,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrls': imageUrls,
      'rating': rating,
      'reviewCount': reviewCount,
      'providerId': providerId,
      'providerName': providerName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'isFeatured': isFeatured,
      'tags': tags,
      'amenities': amenities,
      'difficulty': difficulty,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
    };
  }

  /// CampEntity를 CampModel로 변환
  factory CampModel.fromEntity(CampEntity entity) {
    return CampModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      location: entity.location,
      country: entity.country,
      city: entity.city,
      price: entity.price,
      currency: entity.currency,
      duration: entity.duration,
      minAge: entity.minAge,
      maxAge: entity.maxAge,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      imageUrls: entity.imageUrls,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      providerId: entity.providerId,
      providerName: entity.providerName,
      startDate: entity.startDate,
      endDate: entity.endDate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
      isFeatured: entity.isFeatured,
      tags: entity.tags,
      amenities: entity.amenities,
      difficulty: entity.difficulty,
      maxParticipants: entity.maxParticipants,
      currentParticipants: entity.currentParticipants,
    );
  }

  /// CampModel을 CampEntity로 변환
  CampEntity toEntity() {
    return CampEntity(
      id: id,
      title: title,
      description: description,
      location: location,
      country: country,
      city: city,
      price: price,
      currency: currency,
      duration: duration,
      minAge: minAge,
      maxAge: maxAge,
      categoryId: categoryId,
      categoryName: categoryName,
      imageUrls: imageUrls,
      rating: rating,
      reviewCount: reviewCount,
      providerId: providerId,
      providerName: providerName,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
      isFeatured: isFeatured,
      tags: tags,
      amenities: amenities,
      difficulty: difficulty,
      maxParticipants: maxParticipants,
      currentParticipants: currentParticipants,
    );
  }

  /// JSON 배열에서 CampModel 리스트 생성
  static List<CampModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CampModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// CampModel 리스트를 JSON 배열로 변환
  static List<Map<String, dynamic>> toJsonList(List<CampModel> models) {
    return models.map((model) => model.toJson()).toList();
  }

  @override
  CampModel copyWith({
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
    return CampModel(
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
}
