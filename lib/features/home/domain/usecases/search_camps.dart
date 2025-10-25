import '../entities/camp_entity.dart';
import '../repositories/camp_repository.dart';

/// 캠프 검색 Use Case
/// 사용자 검색어로 캠프를 검색하는 비즈니스 로직
class SearchCamps {
  final CampRepository repository;

  const SearchCamps(this.repository);

  /// 캠프 검색
  /// 
  /// [query] 검색어
  /// [allowShortQuery] 짧은 검색어도 허용할지 여부 (국가별 검색용)
  /// Returns: 검색된 캠프 목록
  /// Throws: [Exception] when search fails
  Future<List<CampEntity>> call(String query, {bool allowShortQuery = false}) async {
    try {
      // 비즈니스 로직: 검색어 유효성 검사
      if (query.trim().isEmpty) {
        return [];
      }

      // 비즈니스 로직: 검색어 길이 제한 (최소 2글자, 단 allowShortQuery가 true면 제외)
      if (!allowShortQuery && query.trim().length < 2) {
        return [];
      }

      // 비즈니스 로직: 검색어 길이 제한 (최대 50글자)
      if (query.trim().length > 50) {
        throw Exception('검색어는 최대 50글자까지 입력 가능합니다.');
      }

      final camps = await repository.searchCamps(query.trim());
      
      // 비즈니스 로직: 활성화된 캠프만 필터링
      final activeCamps = camps.where((camp) => camp.isActive).toList();
      
      // 비즈니스 로직: 검색 결과는 최대 50개로 제한
      if (activeCamps.length > 50) {
        return activeCamps.take(50).toList();
      }
      
      return activeCamps;
    } catch (e) {
      throw Exception('Failed to search camps: $e');
    }
  }
}
