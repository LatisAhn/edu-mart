import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/filter_summary_bar.dart';
import '../widgets/result_summary_bar.dart';
import '../widgets/camp_list_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 검색 결과 페이지
/// 검색어, 필터 조건에 따른 캠프 목록을 표시
class SearchResultsPage extends StatefulWidget {
  final String? query;
  final Map<String, dynamic>? filters;
  final bool showBackButton;

  const SearchResultsPage({
    super.key,
    this.query,
    this.filters,
    this.showBackButton = true,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late TextEditingController _searchController;
  List<String> _activeFilters = [];
  String _sortBy = '인기순';
  bool _isLoading = false;
  List<CampEntity> _searchResults = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query ?? '');
    _activeFilters = _extractFiltersFromArguments();
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _extractFiltersFromArguments() {
    final filters = <String>[];
    if (widget.filters != null) {
      if (widget.filters!['category'] != null) {
        filters.add(widget.filters!['category']);
      }
      if (widget.filters!['country'] != null) {
        filters.add(widget.filters!['country']);
      }
      if (widget.filters!['ageGroup'] != null) {
        filters.add(widget.filters!['ageGroup']);
      }
    }
    return filters;
  }

  Future<void> _performSearch() async {
    // 검색어가 2글자 미만이면 검색하지 않음
    if (_searchController.text.trim().length < 2) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final homeProvider = context.read<HomeProvider>();
      await homeProvider.searchCamps(_searchController.text);
      setState(() {
        _searchResults = homeProvider.searchResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '검색 중 오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        activeFilters: _activeFilters,
        onApplyFilters: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _performSearch();
        },
      ),
    );
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
    _performSearch();
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
    _performSearch();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header (Search Bar)
            SearchAppBar(
              controller: _searchController,
              onSearch: _performSearch,
              onFilterTap: _onFilterTap,
              showBackButton: widget.showBackButton,
            ),

            // Filter Summary Bar
            if (_activeFilters.isNotEmpty)
              FilterSummaryBar(
                activeFilters: _activeFilters,
                onRemoveFilter: _removeFilter,
                onClearAll: _clearAllFilters,
              ),

            // Result Summary Bar
            ResultSummaryBar(
              resultCount: _searchResults.length,
              sortBy: _sortBy,
              onSortChanged: _onSortChanged,
            ),

            // Camp List
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState();
    }

    return _buildCampList();
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.spacingM),
          child: CampListCardShimmer(),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            _errorMessage!,
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          ElevatedButton(
            onPressed: _performSearch,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    // 검색어가 2글자 미만인 경우
    if (_searchController.text.trim().length > 0 && _searchController.text.trim().length < 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              '검색어를 2글자 이상 입력해주세요.',
              style: AppTextTheme.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              '더 자세한 검색어를 입력하시면 더 정확한 결과를 찾을 수 있습니다.',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    // 일반적인 검색 결과 없음 상태
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            '검색 조건에 맞는 캠프가 없습니다.',
            style: AppTextTheme.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            '다른 검색어나 필터를 시도해보세요.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          ElevatedButton(
            onPressed: _clearAllFilters,
            child: const Text('필터 다시 설정하기'),
          ),
        ],
      ),
    );
  }

  Widget _buildCampList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final camp = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
          child: CampListCard(
            camp: camp,
            onTap: () {
              Navigator.pushNamed(context, '/camp-detail', arguments: camp.id);
            },
            onFavoriteTap: () {
              // TODO: 즐겨찾기 토글
            },
          ),
        );
      },
    );
  }
}
