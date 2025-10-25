import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/camp_entity.dart';
import '../../../compare/domain/entities/camp_compare_entity.dart';
import '../../../compare/presentation/providers/compare_provider.dart';
import '../../../../shared/widgets/rating_widget.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 캠프 카드 위젯
/// 홈 화면에서 캠프 정보를 표시하는 카드 컴포넌트
class CampCard extends StatelessWidget {
  final CampEntity camp;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool showFavoriteButton;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final bool showCompareButton;

  const CampCard({
    super.key,
    required this.camp,
    this.onTap,
    this.isLoading = false,
    this.showFavoriteButton = true,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.showCompareButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingCard();
    }

    return _buildCampCard(context);
  }

  Widget _buildLoadingCard() {
    return Container(
      height: AppDimensions.campCardHeight,
      margin: const EdgeInsets.all(AppDimensions.cardMargin),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildCampCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.campCardHeight,
        margin: const EdgeInsets.all(AppDimensions.cardMargin),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: AppDimensions.elevationS,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context, isDark),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeaderSection(context, isDark),
                    const SizedBox(height: AppDimensions.spacingS),
                    _buildLocationSection(context, isDark),
                    const SizedBox(height: AppDimensions.spacingM),
                    _buildFooterSection(context, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, bool isDark) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusL),
            topRight: Radius.circular(AppDimensions.radiusL),
          ),
          child: Container(
            height: AppDimensions.campCardImageHeight,
            width: double.infinity,
            color: isDark ? AppColors.surfaceDark : AppColors.neutralGray100,
            child: camp.imageUrls.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: camp.imageUrls.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildImagePlaceholder(isDark),
                    errorWidget: (context, url, error) => _buildImagePlaceholder(isDark),
                  )
                : _buildImagePlaceholder(isDark),
          ),
        ),
        if (showFavoriteButton)
          Positioned(
            top: AppDimensions.spacingS,
            right: AppDimensions.spacingS,
            child: _buildFavoriteButton(context, isDark),
          ),
        if (showCompareButton)
          Positioned(
            top: AppDimensions.spacingS,
            right: showFavoriteButton ? 50 : AppDimensions.spacingS,
            child: _buildCompareButton(context, isDark),
          ),
        if (camp.isFeatured)
          Positioned(
            top: AppDimensions.spacingS,
            left: AppDimensions.spacingS,
            child: _buildFeaturedBadge(context),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder(bool isDark) {
    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.neutralGray100,
      child: Center(
        child: Icon(
          Icons.image,
          color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: onFavoriteTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXS),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCompareButton(BuildContext context, bool isDark) {
    return Consumer<CompareProvider>(
      builder: (context, compareProvider, child) {
        final isInCompare = compareProvider.isInCompareList(camp.id);
        final isFull = compareProvider.isFull && !isInCompare;
        
        return GestureDetector(
          onTap: isFull ? null : () {
            if (isInCompare) {
              compareProvider.removeFromCompare(camp.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${camp.title}을(를) 비교함에서 제거했습니다')),
              );
            } else {
              final compareCamp = CampCompareEntity(
                campId: camp.id,
                name: camp.title,
                location: '${camp.city}, ${camp.country}',
                duration: camp.formattedDuration,
                price: camp.price.toInt(),
                rating: camp.rating,
                thumbnailUrl: camp.imageUrls.isNotEmpty ? camp.imageUrls.first : '',
                description: camp.description,
                maxParticipants: 20, // 기본값
                includedItems: ['숙박', '수업', '식사'], // 기본값
                startDate: '2024-12-15', // 기본값
                endDate: '2025-01-15', // 기본값
                category: '어학', // 기본값
              );
              compareProvider.addToCompare(compareCamp);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${camp.title}을(를) 비교함에 추가했습니다')),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacingXS),
            decoration: BoxDecoration(
              color: isFull ? Colors.grey.withOpacity(0.5) : Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isInCompare ? Icons.compare_arrows : Icons.add,
              color: isFull ? Colors.grey : Colors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryCoral400,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        '추천',
        style: AppTextTheme.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          camp.title,
          style: AppTextTheme.cardTitle.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (camp.description.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            camp.description,
            style: AppTextTheme.cardSubtitle.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        const SizedBox(width: AppDimensions.spacingXS),
        Expanded(
          child: Text(
            '${camp.city}, ${camp.country}',
            style: AppTextTheme.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 가격
        Text(
          camp.formattedPrice,
          style: AppTextTheme.priceText.copyWith(
            color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
          ),
        ),
        if (camp.discountedPrice != camp.price) ...[
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            camp.formattedDiscountedPrice,
            style: AppTextTheme.bodySmall.copyWith(
              decoration: TextDecoration.lineThrough,
              color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
            ),
          ),
        ],
        const SizedBox(height: AppDimensions.spacingS),
        
        // 별점
        RatingWidget(
          rating: camp.rating,
          size: 16,
          showRating: true,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        
        // 기간
        Text(
          camp.formattedDuration,
          style: AppTextTheme.bodySmall.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
