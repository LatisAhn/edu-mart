import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 필터 바텀시트 위젯
/// 캠프 검색을 위한 다양한 필터 옵션을 제공
class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;
  final VoidCallback? onClearFilters;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
    this.onClearFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _tempFilters;

  // 필터 옵션들
  final List<String> _countries = ['전체', '미국', '영국', '캐나다', '호주', '뉴질랜드', '아일랜드'];
  final List<String> _priceRanges = ['전체', '100만원 이하', '100-200만원', '200-300만원', '300만원 이상'];
  final List<String> _ageGroups = ['전체', '초등학생', '중학생', '고등학생', '성인'];
  final List<String> _durations = ['전체', '1주', '2주', '3주', '4주 이상'];
  final List<String> _difficulties = ['전체', '초급', '중급', '고급'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tempFilters = Map.from(widget.currentFilters);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusL),
          topRight: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context, isDark),
          _buildTabBar(context, isDark),
          Expanded(
            child: _buildTabBarView(context, isDark),
          ),
          _buildFooter(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '필터',
            style: AppTextTheme.headlineMedium.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _tempFilters.clear();
                  });
                },
                child: Text(
                  '초기화',
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.neutralGray100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        labelStyle: AppTextTheme.bodySmall.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextTheme.bodySmall,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(text: '국가'),
          Tab(text: '가격'),
          Tab(text: '연령'),
          Tab(text: '기간'),
          Tab(text: '난이도'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context, bool isDark) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildCountryFilter(isDark),
        _buildPriceFilter(isDark),
        _buildAgeFilter(isDark),
        _buildDurationFilter(isDark),
        _buildDifficultyFilter(isDark),
      ],
    );
  }

  Widget _buildCountryFilter(bool isDark) {
    return _buildFilterList(
      items: _countries,
      selectedValue: _tempFilters['country'] ?? '전체',
      onChanged: (value) {
        setState(() {
          if (value == '전체') {
            _tempFilters.remove('country');
          } else {
            _tempFilters['country'] = value;
          }
        });
      },
      isDark: isDark,
    );
  }

  Widget _buildPriceFilter(bool isDark) {
    return _buildFilterList(
      items: _priceRanges,
      selectedValue: _tempFilters['priceRange'] ?? '전체',
      onChanged: (value) {
        setState(() {
          if (value == '전체') {
            _tempFilters.remove('priceRange');
          } else {
            _tempFilters['priceRange'] = value;
          }
        });
      },
      isDark: isDark,
    );
  }

  Widget _buildAgeFilter(bool isDark) {
    return _buildFilterList(
      items: _ageGroups,
      selectedValue: _tempFilters['ageGroup'] ?? '전체',
      onChanged: (value) {
        setState(() {
          if (value == '전체') {
            _tempFilters.remove('ageGroup');
          } else {
            _tempFilters['ageGroup'] = value;
          }
        });
      },
      isDark: isDark,
    );
  }

  Widget _buildDurationFilter(bool isDark) {
    return _buildFilterList(
      items: _durations,
      selectedValue: _tempFilters['duration'] ?? '전체',
      onChanged: (value) {
        setState(() {
          if (value == '전체') {
            _tempFilters.remove('duration');
          } else {
            _tempFilters['duration'] = value;
          }
        });
      },
      isDark: isDark,
    );
  }

  Widget _buildDifficultyFilter(bool isDark) {
    return _buildFilterList(
      items: _difficulties,
      selectedValue: _tempFilters['difficulty'] ?? '전체',
      onChanged: (value) {
        setState(() {
          if (value == '전체') {
            _tempFilters.remove('difficulty');
          } else {
            _tempFilters['difficulty'] = value;
          }
        });
      },
      isDark: isDark,
    );
  }

  Widget _buildFilterList({
    required List<String> items,
    required String selectedValue,
    required Function(String) onChanged,
    required bool isDark,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == selectedValue;

        return GestureDetector(
          onTap: () => onChanged(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.primaryBlue300.withOpacity(0.2) : AppColors.primaryBlue500.withOpacity(0.1))
                  : (isDark ? AppColors.surfaceDark : AppColors.neutralGray100),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: isSelected
                  ? Border.all(
                      color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected
                      ? (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500)
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Text(
                  item,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: isSelected
                        ? (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500)
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: '초기화',
              type: CustomButtonType.outlined,
              onPressed: () {
                setState(() {
                  _tempFilters.clear();
                });
              },
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: CustomButton(
              text: '적용',
              type: CustomButtonType.primary,
              onPressed: () {
                widget.onFiltersChanged(_tempFilters);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
