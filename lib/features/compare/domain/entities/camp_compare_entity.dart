import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'camp_compare_entity.freezed.dart';
part 'camp_compare_entity.g.dart';

@freezed
class CampCompareEntity with _$CampCompareEntity {
  const factory CampCompareEntity({
    required String campId,
    required String name,
    required String location,
    required String duration,
    required int price,
    required double rating,
    required String thumbnailUrl,
    required String description,
    required int maxParticipants,
    required List<String> includedItems,
    required String startDate,
    required String endDate,
    required String category,
  }) = _CampCompareEntity;

  factory CampCompareEntity.fromJson(Map<String, dynamic> json) => _$CampCompareEntityFromJson(json);
}
