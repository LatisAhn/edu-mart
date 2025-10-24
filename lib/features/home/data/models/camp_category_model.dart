import '../../domain/entities/camp_category_entity.dart';

/// 캠프 카테고리 모델 - JSON 직렬화를 담당
class CampCategoryModel extends CampCategoryEntity {
  const CampCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconUrl,
    required super.color,
    required super.sortOrder,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    required super.campCount,
  });

  /// JSON에서 CampCategoryModel 생성
  factory CampCategoryModel.fromJson(Map<String, dynamic> json) {
    return CampCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      color: json['color'] as String,
      sortOrder: json['sortOrder'] as int,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      campCount: json['campCount'] as int,
    );
  }

  /// CampCategoryModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'color': color,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'campCount': campCount,
    };
  }

  /// CampCategoryEntity를 CampCategoryModel로 변환
  factory CampCategoryModel.fromEntity(CampCategoryEntity entity) {
    return CampCategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      iconUrl: entity.iconUrl,
      color: entity.color,
      sortOrder: entity.sortOrder,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      campCount: entity.campCount,
    );
  }

  /// CampCategoryModel을 CampCategoryEntity로 변환
  CampCategoryEntity toEntity() {
    return CampCategoryEntity(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      color: color,
      sortOrder: sortOrder,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      campCount: campCount,
    );
  }

  /// JSON 배열에서 CampCategoryModel 리스트 생성
  static List<CampCategoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => CampCategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// CampCategoryModel 리스트를 JSON 배열로 변환
  static List<Map<String, dynamic>> toJsonList(List<CampCategoryModel> models) {
    return models.map((model) => model.toJson()).toList();
  }

  @override
  CampCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    String? color,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? campCount,
  }) {
    return CampCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      campCount: campCount ?? this.campCount,
    );
  }
}
