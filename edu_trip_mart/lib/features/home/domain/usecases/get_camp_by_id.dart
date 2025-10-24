import '../entities/camp_entity.dart';
import '../repositories/camp_repository.dart';

/// 캠프 상세 조회 Use Case
/// 특정 캠프의 상세 정보를 가져오는 비즈니스 로직
class GetCampById {
  final CampRepository repository;

  const GetCampById(this.repository);

  /// 캠프 상세 정보 조회
  /// 
  /// [campId] 캠프 ID
  /// Returns: 캠프 상세 정보
  /// Throws: [Exception] when camp not found or data fetching fails
  Future<CampEntity> call(String campId) async {
    try {
      // 비즈니스 로직: 캠프 ID 유효성 검사
      if (campId.trim().isEmpty) {
        throw Exception('캠프 ID가 필요합니다.');
      }

      final camp = await repository.getCampById(campId.trim());
      
      // 비즈니스 로직: 비활성화된 캠프는 접근 제한
      if (!camp.isActive) {
        throw Exception('해당 캠프는 현재 이용할 수 없습니다.');
      }
      
      return camp;
    } catch (e) {
      throw Exception('Failed to get camp by id: $e');
    }
  }
}
