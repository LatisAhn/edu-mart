import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/camp_entity.dart';
import '../widgets/camp_list_view.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/filter_bottom_sheet.dart';
import '../providers/home_provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 검색 결과 페이지
/// 검색어에 대한 캠프 결과를 표시하는 페이지
class SearchResultsPage extends StatefulWidget {
  final String initialQuery;

  const SearchResultsPage({
    super.key,
    required this.initialQuery,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _scrollController = ScrollController();
    _currentQuery = widget.initialQuery;
    
    // 초기 검색 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().searchCamps(widget.initialQuery);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '검색 결과',
          style: AppTextTheme.titleLarge.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: custom.SearchBar(
              onChanged: (query) {
                setState(() {
                  _currentQuery = query;
                });
              },
              onSubmitted: (query) {
                _performSearch(query);
              },
              onFilterTap: () => _showFilterBottomSheet(context),
              filterCount: context.watch<HomeProvider>().activeFilterCount,
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildSearchInfo(context, provider, isDark),
              Expanded(
                child: _buildSearchResults(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchInfo(BuildContext context, HomeProvider provider, bool isDark) {
    if (provider.isSearching) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Text(
              '검색 중...',
              style: AppTextTheme.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${provider.searchResults.length}개의 캠프를 찾았습니다',
            style: AppTextTheme.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          if (provider.activeFilterCount > 0)
            GestureDetector(
              onTap: () => _clearFilters(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primaryBlue300.withOpacity(0.2) : AppColors.primaryBlue500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '필터 ${provider.activeFilterCount}개',
                      style: AppTextTheme.bodySmall.copyWith(
                        color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingXS),
                    Icon(
                      Icons.close,
                      size: 16,
                      color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, HomeProvider provider) {
    if (provider.searchResults.isEmpty && !provider.isSearching) {
      return _buildEmptyState(context);
    }

    return CampListView(
      camps: provider.searchResults,
      isLoading: provider.isSearching,
      onCampTap: (camp) => _navigateToCampDetail(context, camp),
      onFavoriteTap: (campId) => _toggleFavorite(context, campId),
      emptyMessage: '검색 결과가 없습니다',
      errorMessage: provider.errorMessage,
      onRetry: () => _performSearch(_currentQuery),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              '검색 결과가 없습니다',
              style: AppTextTheme.headlineMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              '다른 검색어로 시도해보세요',
              style: AppTextTheme.bodyLarge.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            ElevatedButton(
              onPressed: () => _clearSearch(context),
              child: const Text('검색 초기화'),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    context.read<HomeProvider>().searchCamps(query.trim());
  }

  void _clearSearch(BuildContext context) {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
    });
    context.read<HomeProvider>().updateSearchQuery('');
  }

  void _clearFilters(BuildContext context) {
    context.read<HomeProvider>().clearFilters();
  }

  void _showFilterBottomSheet(BuildContext context) {
    final provider = context.read<HomeProvider>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: provider.filters,
        onFiltersChanged: (filters) {
          provider.updateFilter('filters', filters);
          // 필터 적용 후 재검색
          _performSearch(_currentQuery);
        },
        onClearFilters: () {
          provider.clearFilters();
          _performSearch(_currentQuery);
        },
      ),
    );
  }

  void _navigateToCampDetail(BuildContext context, CampEntity camp) {
    // TODO: 캠프 상세 화면으로 네비게이션
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${camp.title} 상세 화면으로 이동')),
    );
  }

  void _toggleFavorite(BuildContext context, String campId) {
    // TODO: 즐겨찾기 토글 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('즐겨찾기 기능은 준비 중입니다')),
    );
  }
}
