/// 캠프 카테고리 엔티티
/// 캠프의 분류를 담당하는 도메인 객체
class CampCategoryEntity {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String color; // HEX 색상 코드
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int campCount; // 해당 카테고리의 캠프 수

  const CampCategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.color,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.campCount,
  });

  /// 카테고리 색상을 Color 객체로 반환
  /// Flutter에서 사용할 수 있도록 변환
  int get colorValue {
    // #RRGGBB 형태의 HEX 색상을 int로 변환
    return int.parse(color.replaceFirst('#', '0xFF'));
  }

  /// 카테고리가 활성화되어 있는지 확인
  bool get isAvailable {
    return isActive;
  }

  /// 캠프 수가 있는지 확인
  bool get hasCamps {
    return campCount > 0;
  }

  /// 복사 생성자
  CampCategoryEntity copyWith({
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
    return CampCategoryEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CampCategoryEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CampCategoryEntity(id: $id, name: $name, campCount: $campCount)';
  }
}
