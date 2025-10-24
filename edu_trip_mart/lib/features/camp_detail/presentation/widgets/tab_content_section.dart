import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../domain/entities/camp_review_entity.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/rating_widget.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 탭 콘텐츠 섹션 위젯
/// 캠프 소개, 일정 및 비용, 시설 안내, 리뷰 탭의 내용을 표시
class TabContentSection extends StatelessWidget {
  final CampEntity camp;
  final List<CampReviewEntity> reviews;
  final bool isLoadingReviews;
  final TabController tabController;

  const TabContentSection({
    super.key,
    required this.camp,
    required this.reviews,
    required this.isLoadingReviews,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: TabBarView(
        controller: tabController,
        children: [
          _buildAboutTab(context, isDark),
          _buildScheduleTab(context, isDark),
          _buildFacilityTab(context, isDark),
          _buildReviewsTab(context, isDark),
        ],
      ),
    );
  }

  Widget _buildAboutTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            '캠프 소개',
            style: AppTextTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            camp.description,
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textDark,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Key Features
          Text(
            '주요 특징',
            style: AppTextTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildFeatureList(isDark),
          const SizedBox(height: AppDimensions.spacingL),

          // Duration and Age
          _buildInfoCard(
            context,
            isDark,
            '기간 및 연령',
            [
              '기간: ${camp.formattedDuration}',
              '연령: ${camp.minAge}-${camp.maxAge}세',
              '최대 인원: ${camp.maxParticipants}명',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '일정 및 비용',
            style: AppTextTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Schedule Info
          _buildInfoCard(
            context,
            isDark,
            '캠프 일정',
            [
              '시작일: ${_formatDate(camp.startDate)}',
              '종료일: ${_formatDate(camp.endDate)}',
              '총 기간: ${camp.duration}일',
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Pricing
          _buildInfoCard(
            context,
            isDark,
            '비용 정보',
            [
              '기본 가격: ${camp.formattedPrice}',
              if (camp.discountedPrice != camp.price)
                '할인 가격: ${camp.formattedDiscountedPrice}',
              '포함 사항: 숙박, 식사, 수업료, 활동비',
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Reserve Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: '지금 예약하기',
              type: CustomButtonType.primary,
              onPressed: () {
                // TODO: 예약 페이지로 이동
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '시설 안내',
            style: AppTextTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Amenities
          _buildInfoCard(
            context,
            isDark,
            '편의시설',
            [
              '무료 Wi-Fi',
              '24시간 보안',
              '공항 픽업 서비스',
              '세탁 시설',
              '수영장',
              '체육관',
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Accommodation
          _buildInfoCard(
            context,
            isDark,
            '숙박 정보',
            [
              '2-3인실 기준',
              '개인 화장실',
              '에어컨 완비',
              '개인 수납공간',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '리뷰',
                style: AppTextTheme.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              if (reviews.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // TODO: 전체 리뷰 페이지로 이동
                  },
                  child: const Text('전체보기'),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),

          if (isLoadingReviews)
            const Center(child: CircularProgressIndicator())
          else if (reviews.isEmpty)
            _buildEmptyReviews(isDark)
          else
            Column(
              children: [
                // Average Rating
                _buildAverageRating(isDark),
                const SizedBox(height: AppDimensions.spacingL),

                // Reviews List
                ...reviews.take(3).map((review) => _buildReviewCard(review, isDark)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureList(bool isDark) {
    final features = [
      '영어 집중 수업 (1:1 수업 4회 / 그룹 수업 3회)',
      '주말 문화 체험 활동 포함',
      '공인 TESOL 강사진',
      '소규모 그룹 수업 (최대 8명)',
      '개인별 맞춤 학습 계획',
    ];

    return Column(
      children: features.map((feature) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6, right: AppDimensions.spacingS),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                feature,
                style: AppTextTheme.bodyMedium.copyWith(
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDark, String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
            child: Text(
              '• $item',
              style: AppTextTheme.bodyMedium.copyWith(
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAverageRating(bool isDark) {
    final averageRating = reviews.isNotEmpty
        ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
      ),
      child: Row(
        children: [
          RatingWidget(
            rating: averageRating,
            size: 24,
            showRating: true,
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Text(
            '${reviews.length}명의 후기',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(CampReviewEntity review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: review.userAvatarUrl != null
                    ? NetworkImage(review.userAvatarUrl!)
                    : null,
                child: review.userAvatarUrl == null
                    ? Text(review.userName.isNotEmpty ? review.userName[0] : '?')
                    : null,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppTextTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    RatingWidget(
                      rating: review.rating,
                      size: 16,
                      showRating: false,
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(review.createdAt),
                style: AppTextTheme.bodySmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            review.title,
            style: AppTextTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            review.content,
            style: AppTextTheme.bodyMedium.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReviews(bool isDark) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.reviews,
            size: 64,
            color: isDark ? AppColors.iconDisabled : AppColors.textSecondaryLight,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            '아직 후기가 없습니다.',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          CustomButton(
            text: '첫 후기 작성하기',
            type: CustomButtonType.outlined,
            onPressed: () {
              // TODO: 후기 작성 페이지로 이동
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
