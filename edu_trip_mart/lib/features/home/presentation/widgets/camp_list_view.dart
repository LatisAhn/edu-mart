import 'package:flutter/material.dart';
import '../../domain/entities/camp_entity.dart';
import 'camp_card.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/theme/app_dimensions.dart';

/// 캠프 리스트 뷰 위젯
/// 홈 화면에서 캠프 목록을 표시하는 리스트 컴포넌트
class CampListView extends StatelessWidget {
  final List<CampEntity> camps;
  final String? title;
  final VoidCallback? onSeeAll;
  final Function(CampEntity)? onCampTap;
  final Function(String)? onFavoriteTap;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final String? emptyMessage;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ScrollController? scrollController;

  const CampListView({
    super.key,
    required this.camps,
    this.title,
    this.onSeeAll,
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
      return _buildLoadingList();
    }

    if (errorMessage != null) {
      return _buildErrorState(context);
    }

    if (camps.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildCampList(context);
  }

  Widget _buildLoadingList() {
    return const CampListShimmer();
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              errorMessage ?? '오류가 발생했습니다',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingM),
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
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              emptyMessage ?? '캠프를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
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

  Widget _buildCampList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) _buildHeader(context),
        ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          itemCount: camps.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == camps.length) {
              return _buildLoadMoreButton(context);
            }

            final camp = camps[index];
            return CampCard(
              camp: camp,
              onTap: () => onCampTap?.call(camp),
              onFavoriteTap: () => onFavoriteTap?.call(camp.id),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingM,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('전체보기'),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Center(
        child: ElevatedButton(
          onPressed: onLoadMore,
          child: const Text('더 보기'),
        ),
      ),
    );
  }
}

/// 캠프 그리드 뷰 위젯
class CampGridView extends StatelessWidget {
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
  final int crossAxisCount;
  final double childAspectRatio;

  const CampGridView({
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
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && camps.isEmpty) {
      return _buildLoadingGrid();
    }

    if (errorMessage != null) {
      return _buildErrorState(context);
    }

    if (camps.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildCampGrid(context);
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: AppDimensions.spacingS,
        mainAxisSpacing: AppDimensions.spacingS,
      ),
      itemCount: 6,
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
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              errorMessage ?? '오류가 발생했습니다',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingM),
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
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              emptyMessage ?? '캠프를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
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

  Widget _buildCampGrid(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: AppDimensions.spacingS,
        mainAxisSpacing: AppDimensions.spacingS,
      ),
      itemCount: camps.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == camps.length) {
          return _buildLoadMoreButton(context);
        }

        final camp = camps[index];
        return CampCard(
          camp: camp,
          onTap: () => onCampTap?.call(camp),
          onFavoriteTap: () => onFavoriteTap?.call(camp.id),
        );
      },
    );
  }

  Widget _buildLoadMoreButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onLoadMore,
        child: const Text('더 보기'),
      ),
    );
  }
}
