import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/animated_fade_in.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/camp_list_view.dart';
import '../providers/home_provider.dart';

/// 검색 페이지
/// 캠프 검색 및 필터링 기능을 제공하는 페이지
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: custom.SearchBar(
              initialText: _currentQuery,
              onChanged: (query) {
                setState(() {
                  _currentQuery = query;
                });
                if (query.isNotEmpty) {
                  context.read<HomeProvider>().searchCamps(query);
                }
              },
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  _performSearch(query);
                }
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (_currentQuery.isEmpty) {
            return _buildEmptyState();
          }

          if (provider.isLoadingSearch) {
            return _buildLoadingState();
          }

          if (provider.searchResults.isEmpty) {
            return _buildNoResultsState();
          }

          return _buildSearchResults(provider);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '캠프를 검색해보세요',
              style: AppTextTheme.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '원하는 캠프를 찾아보세요',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: AppTextTheme.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '다른 검색어로 시도해보세요',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(HomeProvider provider) {
    return AnimatedFadeIn(
      child: CampListView(
        title: '검색 결과',
        camps: provider.searchResults,
        onSeeAll: null, // 검색 결과는 '모두 보기' 없음
      ),
    );
  }

  void _performSearch(String query) {
    context.read<HomeProvider>().searchCamps(query);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        onFiltersChanged: (filters) {
          // 필터 적용 로직
          context.read<HomeProvider>().updateFilter('filters', filters);
        },
      ),
    );
  }
}

/// 필터 바텀 시트
class _FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;

  const _FilterBottomSheet({
    required this.onFiltersChanged,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  Map<String, dynamic> _filters = {
    'priceRange': [0, 1000000],
    'duration': null,
    'ageRange': [0, 100],
    'country': null,
    'rating': null,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '필터',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters = {
                        'priceRange': [0, 1000000],
                        'duration': null,
                        'ageRange': [0, 100],
                        'country': null,
                        'rating': null,
                      };
                    });
                  },
                  child: Text(
                    '초기화',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.primaryBlue500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceFilter(),
                  const SizedBox(height: 24),
                  _buildDurationFilter(),
                  const SizedBox(height: 24),
                  _buildAgeFilter(),
                  const SizedBox(height: 24),
                  _buildCountryFilter(),
                  const SizedBox(height: 24),
                  _buildRatingFilter(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersChanged(_filters);
                      Navigator.pop(context);
                    },
                    child: const Text('적용'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '가격 범위',
          style: AppTextTheme.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        RangeSlider(
          values: RangeValues(
            _filters['priceRange'][0].toDouble(),
            _filters['priceRange'][1].toDouble(),
          ),
          min: 0,
          max: 1000000,
          divisions: 20,
          onChanged: (values) {
            setState(() {
              _filters['priceRange'] = [values.start.round(), values.end.round()];
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('₩${_filters['priceRange'][0].toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )}'),
            Text('₩${_filters['priceRange'][1].toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )}'),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기간',
          style: AppTextTheme.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            '1주',
            '2주',
            '3주',
            '4주',
            '1개월',
            '2개월',
          ].map((duration) {
            final isSelected = _filters['duration'] == duration;
            return FilterChip(
              label: Text(duration),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['duration'] = selected ? duration : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '연령대',
          style: AppTextTheme.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        RangeSlider(
          values: RangeValues(
            _filters['ageRange'][0].toDouble(),
            _filters['ageRange'][1].toDouble(),
          ),
          min: 0,
          max: 100,
          divisions: 20,
          onChanged: (values) {
            setState(() {
              _filters['ageRange'] = [values.start.round(), values.end.round()];
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_filters['ageRange'][0]}세'),
            Text('${_filters['ageRange'][1]}세'),
          ],
        ),
      ],
    );
  }

  Widget _buildCountryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '국가',
          style: AppTextTheme.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            '미국',
            '영국',
            '캐나다',
            '호주',
            '뉴질랜드',
            '싱가포르',
          ].map((country) {
            final isSelected = _filters['country'] == country;
            return FilterChip(
              label: Text(country),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['country'] = selected ? country : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최소 평점',
          style: AppTextTheme.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _filters['rating']?.toDouble() ?? 0.0,
          min: 0.0,
          max: 5.0,
          divisions: 10,
          onChanged: (value) {
            setState(() {
              _filters['rating'] = value;
            });
          },
        ),
        Text('${(_filters['rating'] ?? 0.0).toStringAsFixed(1)}점 이상'),
      ],
    );
  }
}

