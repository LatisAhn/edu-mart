import '../entities/camp_category_entity.dart';
import '../repositories/camp_repository.dart';

/// 캠프 카테고리 조회 Use Case
/// 홈 화면에서 표시할 카테고리 목록을 가져오는 비즈니스 로직
class GetCampCategories {
  final CampRepository repository;

  const GetCampCategories(this.repository);

  /// 캠프 카테고리 목록 조회
  /// 
  /// Returns: 활성화된 캠프 카테고리 목록 (정렬 순서대로)
  /// Throws: [Exception] when data fetching fails
  Future<List<CampCategoryEntity>> call() async {
    try {
      final categories = await repository.getCampCategories();
      
      // 비즈니스 로직: 활성화된 카테고리만 필터링
      final activeCategories = categories.where((category) => category.isActive).toList();
      
      // 비즈니스 로직: 정렬 순서대로 정렬
      activeCategories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      
      return activeCategories;
    } catch (e) {
      throw Exception('Failed to get camp categories: $e');
    }
  }
}
