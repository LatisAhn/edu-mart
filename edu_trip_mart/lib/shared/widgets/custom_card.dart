import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// 커스텀 카드 컴포넌트
/// 일관된 카드 디자인을 제공하는 재사용 가능한 위젯
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isClickable;
  final double? width;
  final double? height;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isClickable = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget card = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(AppDimensions.cardMargin),
      decoration: BoxDecoration(
        color: backgroundColor ?? 
            (isDark ? AppColors.cardDark : AppColors.backgroundWhite),
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusL),
        border: border,
        boxShadow: elevation != null ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation!,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
        child: child,
      ),
    );

    if (isClickable && onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.radiusL),
          child: card,
        ),
      );
    }

    return card;
  }
}

/// 캠프 카드 전용 컴포넌트
class CampCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? price;
  final String? rating;
  final String? location;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isLoading;

  const CampCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.price,
    this.rating,
    this.location,
    this.onTap,
    this.trailing,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingCard();
    }

    return CustomCard(
      onTap: onTap,
      isClickable: onTap != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(context),
          const SizedBox(height: AppDimensions.spacingM),
          _buildContentSection(context),
          if (trailing != null) ...[
            const SizedBox(height: AppDimensions.spacingM),
            trailing!,
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppDimensions.campCardImageHeight,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Container(
            height: 16,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      child: Container(
        height: AppDimensions.campCardImageHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image,
          color: Colors.grey,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (location != null) ...[
          const SizedBox(height: AppDimensions.spacingXS),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: AppDimensions.spacingXS),
              Expanded(
                child: Text(
                  location!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppDimensions.spacingM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (price != null)
              Text(
                price!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (rating != null)
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: AppDimensions.spacingXS),
                  Text(
                    rating!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
