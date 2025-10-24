import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 추천 배너 위젯
/// 홈 화면에서 프로모션이나 추천 캠프를 표시하는 배너 컴포넌트
class FeaturedBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const FeaturedBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.buttonText,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingBanner();
    }

    return _buildBanner(context);
  }

  Widget _buildLoadingBanner() {
    return Container(
      height: AppDimensions.bannerHeight,
      margin: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.bannerHeight,
        margin: const EdgeInsets.all(AppDimensions.screenPadding),
        decoration: BoxDecoration(
          color: backgroundColor ?? 
              (isDark ? AppColors.cardDark : AppColors.backgroundWhite),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: AppDimensions.elevationM,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Stack(
            children: [
              if (imageUrl != null) _buildBackgroundImage(),
              _buildGradientOverlay(),
              _buildContent(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.image,
              color: Colors.grey,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.bannerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextTheme.displayMedium.copyWith(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              subtitle!,
              style: AppTextTheme.bodyLarge.copyWith(
                color: textColor?.withOpacity(0.9) ?? Colors.white.withOpacity(0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (buttonText != null) ...[
            const SizedBox(height: AppDimensions.spacingL),
            _buildButton(context, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: textColor ?? Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Text(
        buttonText!,
        style: AppTextTheme.bodyMedium.copyWith(
          color: backgroundColor ?? 
              (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 캠페인 배너 위젯
class CampaignBanner extends StatelessWidget {
  final String title;
  final String? description;
  final String? imageUrl;
  final String? discountText;
  final VoidCallback? onTap;
  final bool isLoading;

  const CampaignBanner({
    super.key,
    required this.title,
    this.description,
    this.imageUrl,
    this.discountText,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingBanner();
    }

    return _buildCampaignBanner(context);
  }

  Widget _buildLoadingBanner() {
    return Container(
      height: AppDimensions.bannerHeight,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
    );
  }

  Widget _buildCampaignBanner(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.bannerHeight,
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
              isDark ? AppColors.primaryBlue400 : AppColors.primaryBlue600,
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500).withOpacity(0.3),
              blurRadius: AppDimensions.elevationM,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (imageUrl != null) _buildBackgroundImage(),
            _buildContent(context, isDark),
            if (discountText != null) _buildDiscountBadge(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.image,
                color: Colors.grey,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.bannerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (description != null) ...[
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              description!,
              style: AppTextTheme.bodyLarge.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context) {
    return Positioned(
      top: AppDimensions.spacingM,
      right: AppDimensions.spacingM,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondaryCoral400,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Text(
          discountText!,
          style: AppTextTheme.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
