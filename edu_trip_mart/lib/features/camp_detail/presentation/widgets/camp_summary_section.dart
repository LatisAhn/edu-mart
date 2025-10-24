import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/rating_widget.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 캠프 요약 섹션 위젯
/// 캠프의 기본 정보와 주요 액션 버튼을 표시
class CampSummarySection extends StatelessWidget {
  final CampEntity camp;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onReserveTap;

  const CampSummarySection({
    super.key,
    required this.camp,
    this.onWishlistTap,
    this.onReserveTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Camp Title
          Text(
            camp.title,
            style: AppTextTheme.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),

          // Subtitle (Provider name)
          Text(
            camp.providerName,
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // Rating and Reviews
          Row(
            children: [
              RatingWidget(
                rating: camp.rating,
                size: 20,
                showRating: true,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                '(${camp.reviewCount}명 후기)',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // Location
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: AppDimensions.spacingXS),
              Text(
                '${camp.city}, ${camp.country}',
                style: AppTextTheme.bodyLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // Price Info
          Row(
            children: [
              Text(
                camp.formattedPrice,
                style: AppTextTheme.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                '/ ${camp.formattedDuration}',
                style: AppTextTheme.bodyLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          if (camp.discountedPrice != camp.price) ...[
            const SizedBox(height: AppDimensions.spacingXS),
            Text(
              camp.formattedDiscountedPrice,
              style: AppTextTheme.bodyMedium.copyWith(
                decoration: TextDecoration.lineThrough,
                color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.spacingL),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: '❤️ 찜하기',
                  type: CustomButtonType.outlined,
                  onPressed: onWishlistTap,
                  icon: Icons.favorite_border,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: CustomButton(
                  text: '예약하기',
                  type: CustomButtonType.primary,
                  onPressed: onReserveTap,
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
