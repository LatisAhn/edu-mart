import 'package:flutter/material.dart';
import '../../domain/entities/camp_entity.dart';
import 'camp_card.dart';
import '../../../../shared/utils/responsive_helper.dart';
// import '../../../../shared/widgets/loading_shimmer.dart'; // 사용되지 않는 import
import '../../../../shared/theme/app_dimensions.dart';

/// 반응형 캠프 그리드 위젯
/// 화면 크기에 따라 적절한 레이아웃을 제공하는 캠프 그리드
class ResponsiveCampGrid extends StatelessWidget {
  final List<CampEntity> camps;
  final Function(CampEntity)? onCampTap;
  final Function(String)? onFavoriteTap;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final String? emptyMessage;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ScrollController? scrollController;

  const ResponsiveCampGrid({
    super.key,
    required this.camps,
    this.onCampTap,
    this.onFavoriteTap,
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
    this.emptyMessage,
    this.errorMessage,
    this.onRetry,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && camps.isEmpty) {
      return _buildLoadingGrid(context);
    }

    if (errorMessage != null) {
      return _buildErrorState(context);
    }

    if (camps.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildResponsiveGrid(context);
  }

  Widget _buildLoadingGrid(BuildContext context) {
    final columnCount = ResponsiveHelper.getColumnCount(context);
    final spacing = ResponsiveHelper.getGridSpacing(context);
    
    return GridView.builder(
      padding: ResponsiveHelper.getScreenPadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.8 : 0.75,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: columnCount * 2, // 로딩 아이템 수
      itemBuilder: (context, index) {
        return CampCard(
          camp: CampEntity(
            id: '',
            title: '',
            description: '',
            location: '',
            country: '',
            city: '',
            price: 0,
            currency: '',
            duration: 0,
            minAge: 0,
            maxAge: 0,
            categoryId: '',
            categoryName: '',
            imageUrls: [],
            rating: 0,
            reviewCount: 0,
            providerId: '',
            providerName: '',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 30)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isActive: false,
            isFeatured: false,
            tags: [],
            amenities: {},
            difficulty: '',
            maxParticipants: 0,
            currentParticipants: 0,
          ),
          isLoading: true,
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveHelper.getScreenPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 48.0,
                tablet: 56.0,
                desktop: 64.0,
              ),
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: ResponsiveHelper.getGridSpacing(context) * 2),
            Text(
              errorMessage ?? '오류가 발생했습니다',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.getGridSpacing(context)),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveHelper.getScreenPadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: ResponsiveHelper.getResponsiveIconSize(
                context,
                mobile: 48.0,
                tablet: 56.0,
                desktop: 64.0,
              ),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            SizedBox(height: ResponsiveHelper.getGridSpacing(context) * 2),
            Text(
              emptyMessage ?? '캠프를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.getGridSpacing(context)),
            Text(
              '다른 검색어로 시도해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid(BuildContext context) {
    final columnCount = ResponsiveHelper.getColumnCount(context);
    final spacing = ResponsiveHelper.getGridSpacing(context);
    final padding = ResponsiveHelper.getScreenPadding(context);
    
    return GridView.builder(
      controller: scrollController,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        childAspectRatio: ResponsiveHelper.isMobile(context) ? 0.8 : 0.75,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: camps.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == camps.length) {
          return _buildLoadMoreButton(context);
        }

        final camp = camps[index];
        return _buildCampCard(context, camp);
      },
    );
  }

  Widget _buildCampCard(BuildContext context, CampEntity camp) {
    return ResponsiveHelper.isMobile(context)
        ? _buildMobileCampCard(context, camp)
        : _buildDesktopCampCard(context, camp);
  }

  Widget _buildMobileCampCard(BuildContext context, CampEntity camp) {
    return CampCard(
      camp: camp,
      onTap: () => onCampTap?.call(camp),
      onFavoriteTap: () => onFavoriteTap?.call(camp.id),
    );
  }

  Widget _buildDesktopCampCard(BuildContext context, CampEntity camp) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: CampCard(
        camp: camp,
        onTap: () => onCampTap?.call(camp),
        onFavoriteTap: () => onFavoriteTap?.call(camp.id),
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? AppDimensions.spacingM : AppDimensions.spacingL,
        ),
        child: ElevatedButton(
          onPressed: onLoadMore,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
              isMobile ? 120 : 140,
              ResponsiveHelper.getButtonHeight(context),
            ),
          ),
          child: Text(
            '더 보기',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14.0,
                tablet: 16.0,
                desktop: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
