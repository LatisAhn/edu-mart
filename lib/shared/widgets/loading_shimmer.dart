import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// 로딩 스켈레톤 위젯
class LoadingShimmer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  const LoadingShimmer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget shimmerChild = child ?? Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: borderRadius,
      ),
    );
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? AppColors.neutralGray800 : AppColors.shimmerBase),
      highlightColor: highlightColor ?? (isDark ? AppColors.neutralGray700 : AppColors.shimmerHighlight),
      period: period ?? const Duration(milliseconds: 1500),
      child: shimmerChild,
    );
  }
}

/// 카드 스켈레톤
class CardShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const CardShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppDimensions.radiusM,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height ?? 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// 텍스트 스켈레톤
class TextShimmer extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const TextShimmer({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// 리스트 아이템 스켈레톤
class ListItemShimmer extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const ListItemShimmer({
    super.key,
    this.width,
    this.height = 80.0,
    this.borderRadius = AppDimensions.radiusM,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingS,
          horizontal: AppDimensions.spacingM,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// 그리드 아이템 스켈레톤
class GridItemShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const GridItemShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppDimensions.radiusM,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height ?? 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// 캠프 리스트 스켈레톤
class CampListShimmer extends StatelessWidget {
  final int itemCount;

  const CampListShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ListItemShimmer();
      },
    );
  }
}

/// 캠프 그리드 스켈레톤
class CampGridShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  const CampGridShimmer({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
        mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const GridItemShimmer();
      },
    );
  }
}

/// 배너 스켈레톤
class BannerShimmer extends StatelessWidget {
  final double? width;
  final double height;

  const BannerShimmer({
    super.key,
    this.width,
    this.height = AppDimensions.bannerHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
    );
  }
}

/// 프로필 스켈레톤
class ProfileShimmer extends StatelessWidget {
  final double size;

  const ProfileShimmer({
    super.key,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingShimmer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}