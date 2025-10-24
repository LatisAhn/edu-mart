import '../entities/camp_entity.dart';
import '../repositories/camp_repository.dart';

/// 추천 캠프 조회 Use Case
/// 홈 화면에서 표시할 추천 캠프 목록을 가져오는 비즈니스 로직
class GetFeaturedCamps {
  final CampRepository repository;

  const GetFeaturedCamps(this.repository);

  /// 추천 캠프 목록 조회
  /// 
  /// Returns: 추천 캠프 목록
  /// Throws: [Exception] when data fetching fails
  Future<List<CampEntity>> call() async {
    try {
      final camps = await repository.getFeaturedCamps();
      
      // 비즈니스 로직: 활성화된 캠프만 필터링
      final activeCamps = camps.where((camp) => camp.isActive).toList();
      
      // 비즈니스 로직: 추천 캠프는 최대 10개로 제한
      if (activeCamps.length > 10) {
        return activeCamps.take(10).toList();
      }
      
      return activeCamps;
    } catch (e) {
      throw Exception('Failed to get featured camps: $e');
    }
  }
}
