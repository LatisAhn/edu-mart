import '../../domain/entities/camp_review_entity.dart';
import '../../domain/repositories/camp_review_repository.dart';
import '../../../home/data/datasources/camp_remote_datasource.dart';
import '../../../home/data/datasources/camp_local_datasource.dart';
import '../../../../core/error/result.dart';

/// 캠프 후기 레포지토리 구현체
class CampReviewRepositoryImpl implements CampReviewRepository {
  final CampRemoteDataSource remoteDataSource;
  final CampLocalDataSource localDataSource;

  const CampReviewRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<CampReviewEntity>>> getCampReviews(String campId) async {
    try {
      final reviews = await remoteDataSource.getCampReviews(campId);
      final entities = reviews.map((model) => CampReviewEntity(
        id: model.id,
        campId: model.campId,
        userId: model.userId,
        userName: model.userName,
        userAvatarUrl: model.userAvatarUrl,
        rating: model.rating,
        title: model.title,
        content: model.content,
        imageUrls: model.imageUrls,
        isVerified: model.isVerified,
        helpfulCount: model.helpfulCount,
        helpfulUserIds: model.helpfulUserIds,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      )).toList();
      return Success(entities);
    } catch (e) {
      return FailureResult.fromException(Exception('Failed to fetch camp reviews: $e'));
    }
  }

  @override
  Future<Result<CampReviewEntity>> createReview(CampReviewEntity review) async {
    // TODO: 실제 구현
    return FailureResult.fromException(Exception('Not implemented'));
  }

  @override
  Future<Result<CampReviewEntity>> updateReview(CampReviewEntity review) async {
    // TODO: 실제 구현
    return FailureResult.fromException(Exception('Not implemented'));
  }

  @override
  Future<Result<void>> deleteReview(String reviewId) async {
    // TODO: 실제 구현
    return FailureResult.fromException(Exception('Not implemented'));
  }

  @override
  Future<Result<void>> toggleHelpful(String reviewId, bool isHelpful) async {
    // TODO: 실제 구현
    return FailureResult.fromException(Exception('Not implemented'));
  }
}
