import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/loading_shimmer.dart';

/// 캠프 목록 카드 위젯
/// 검색 결과에서 사용하는 가로형 캠프 카드
class CampListCard extends StatelessWidget {
  final CampEntity camp;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const CampListCard({
    super.key,
    required this.camp,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: AppDimensions.elevationS,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            _buildThumbnail(context, isDark),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, isDark),
                    const SizedBox(height: AppDimensions.spacingS),
                    _buildLocation(context, isDark),
                    const SizedBox(height: AppDimensions.spacingS),
                    _buildPrice(context, isDark),
                    const Spacer(),
                    _buildFooter(context, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, bool isDark) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusM),
          bottomLeft: Radius.circular(AppDimensions.borderRadiusM),
        ),
        image: camp.imageUrls.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(camp.imageUrls.first),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: camp.imageUrls.isEmpty
          ? Container(
              color: AppColors.placeholder,
              child: Icon(
                Icons.image_not_supported,
                color: AppColors.iconDisabled,
                size: 32,
              ),
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Text(
            camp.title,
            style: AppTextTheme.titleMedium.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onFavoriteTap,
          child: Icon(
            Icons.favorite_border,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(BuildContext context, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppDimensions.spacingXS),
        Expanded(
          child: Text(
            '${camp.country} • ${camp.duration}일',
            style: AppTextTheme.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context, bool isDark) {
    return Text(
      '${camp.price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}원',
      style: AppTextTheme.titleMedium.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Rating
        Icon(
          Icons.star,
          size: 16,
          color: Colors.amber,
        ),
        const SizedBox(width: AppDimensions.spacingXS),
        Text(
          camp.rating.toStringAsFixed(1),
          style: AppTextTheme.bodySmall.copyWith(
            color: isDark ? AppColors.textLight : AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXS),
        Text(
          '(${camp.reviewCount})',
          style: AppTextTheme.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        
        const Spacer(),
        
        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingS,
            vertical: AppDimensions.spacingXS,
          ),
          decoration: BoxDecoration(
            color: camp.isActive ? AppColors.success : AppColors.warning,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
          ),
          child: Text(
            camp.isActive ? '예약 가능' : '마감 임박',
            style: AppTextTheme.caption.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// 캠프 목록 카드 로딩 쉬머
class CampListCardShimmer extends StatelessWidget {
  const CampListCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
      ),
      child: Row(
        children: [
          // Thumbnail shimmer
          LoadingShimmer(
            width: 120,
            height: 120,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.borderRadiusM),
              bottomLeft: Radius.circular(AppDimensions.borderRadiusM),
            ),
          ),
          
          // Content shimmer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingShimmer(
                    width: double.infinity,
                    height: 20,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  LoadingShimmer(
                    width: 120,
                    height: 16,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  LoadingShimmer(
                    width: 80,
                    height: 18,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      LoadingShimmer(
                        width: 60,
                        height: 16,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                      ),
                      const Spacer(),
                      LoadingShimmer(
                        width: 50,
                        height: 20,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
