import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 필터 바텀시트 위젯
/// 고급 필터 옵션들을 제공하는 모달
class FilterBottomSheet extends StatefulWidget {
  final List<String> activeFilters;
  final Function(List<String>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.activeFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedFilters;
  String _selectedCountry = '';
  String _selectedAgeGroup = '';
  String _selectedDuration = '';
  String _selectedPriceRange = '';

  final List<String> _countries = [
    '미국', '영국', '캐나다', '호주', '뉴질랜드', '필리핀', '싱가포르', '일본'
  ];
  
  final List<String> _ageGroups = [
    '초등학생', '중학생', '고등학생', '대학생', '성인'
  ];
  
  final List<String> _durations = [
    '1주', '2주', '3주', '4주', '1개월 이상'
  ];
  
  final List<String> _priceRanges = [
    '100만원 이하', '100-200만원', '200-300만원', '300-500만원', '500만원 이상'
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilters = List.from(widget.activeFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusL),
          topRight: Radius.circular(AppDimensions.borderRadiusL),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppDimensions.spacingM),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Row(
              children: [
                Text(
                  '필터',
                  style: AppTextTheme.headlineSmall.copyWith(
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    '초기화',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection('국가', _countries, _selectedCountry, (value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  }),
                  
                  _buildFilterSection('연령대', _ageGroups, _selectedAgeGroup, (value) {
                    setState(() {
                      _selectedAgeGroup = value;
                    });
                  }),
                  
                  _buildFilterSection('기간', _durations, _selectedDuration, (value) {
                    setState(() {
                      _selectedDuration = value;
                    });
                  }),
                  
                  _buildFilterSection('가격대', _priceRanges, _selectedPriceRange, (value) {
                    setState(() {
                      _selectedPriceRange = value;
                    });
                  }),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
                    ),
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

  Widget _buildFilterSection(String title, List<String> options, String selectedValue, Function(String) onChanged) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.titleMedium.copyWith(
            color: isDark ? AppColors.textLight : AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Wrap(
          spacing: AppDimensions.spacingS,
          runSpacing: AppDimensions.spacingS,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primary 
                      : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.primary 
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                child: Text(
                  option,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: isSelected 
                        ? AppColors.onPrimary 
                        : (isDark ? AppColors.textLight : AppColors.textDark),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCountry = '';
      _selectedAgeGroup = '';
      _selectedDuration = '';
      _selectedPriceRange = '';
    });
  }

  void _applyFilters() {
    final filters = <String>[];
    if (_selectedCountry.isNotEmpty) filters.add(_selectedCountry);
    if (_selectedAgeGroup.isNotEmpty) filters.add(_selectedAgeGroup);
    if (_selectedDuration.isNotEmpty) filters.add(_selectedDuration);
    if (_selectedPriceRange.isNotEmpty) filters.add(_selectedPriceRange);
    
    widget.onApplyFilters(filters);
    Navigator.of(context).pop();
  }
}
