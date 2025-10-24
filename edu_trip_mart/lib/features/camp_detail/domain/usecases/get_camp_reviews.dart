import '../../../../core/error/result.dart';
import '../entities/camp_review_entity.dart';
import '../repositories/camp_review_repository.dart';

/// 캠프 후기 조회 Use Case
/// 특정 캠프의 후기 목록을 조회하는 비즈니스 로직
class GetCampReviews {
  final CampReviewRepository _repository;

  const GetCampReviews(this._repository);

  /// 캠프 후기 목록 조회
  Future<Result<List<CampReviewEntity>>> call(String campId) async {
    return await _repository.getCampReviews(campId);
  }
}

