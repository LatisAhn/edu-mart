import '../../../../core/error/result.dart';
import '../entities/camp_review_entity.dart';

/// 캠프 후기 Repository 인터페이스
/// 캠프 후기 관련 데이터 접근을 위한 추상화 계층
abstract class CampReviewRepository {
  /// 캠프 후기 목록 조회
  Future<Result<List<CampReviewEntity>>> getCampReviews(String campId);

  /// 후기 작성
  Future<Result<CampReviewEntity>> createReview(CampReviewEntity review);

  /// 후기 수정
  Future<Result<CampReviewEntity>> updateReview(CampReviewEntity review);

  /// 후기 삭제
  Future<Result<void>> deleteReview(String reviewId);

  /// 후기 도움됨 토글
  Future<Result<void>> toggleHelpful(String reviewId, bool isHelpful);
}

