import '../entities/camp_entity.dart';
import '../repositories/camp_repository.dart';

/// 인기 캠프 조회 Use Case
/// 홈 화면에서 표시할 인기 캠프 목록을 가져오는 비즈니스 로직
class GetPopularCamps {
  final CampRepository repository;

  const GetPopularCamps(this.repository);

  /// 인기 캠프 목록 조회
  /// 
  /// [limit] 조회할 캠프 수 제한 (기본값: 20)
  /// Returns: 인기 캠프 목록
  /// Throws: [Exception] when data fetching fails
  Future<List<CampEntity>> call({int limit = 20}) async {
    try {
      final camps = await repository.getPopularCamps();
      
      // 비즈니스 로직: 활성화된 캠프만 필터링
      final activeCamps = camps.where((camp) => camp.isActive).toList();
      
      // 비즈니스 로직: 평점이 높은 순으로 정렬
      activeCamps.sort((a, b) => b.rating.compareTo(a.rating));
      
      // 비즈니스 로직: 리뷰 수가 많은 순으로 정렬 (평점이 같을 경우)
      activeCamps.sort((a, b) {
        if (a.rating == b.rating) {
          return b.reviewCount.compareTo(a.reviewCount);
        }
        return 0; // 이미 평점으로 정렬되었으므로 변경하지 않음
      });
      
      // 비즈니스 로직: 제한된 수만큼만 반환
      if (activeCamps.length > limit) {
        return activeCamps.take(limit).toList();
      }
      
      return activeCamps;
    } catch (e) {
      throw Exception('Failed to get popular camps: $e');
    }
  }
}
