import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 결과 요약 바 위젯
/// 검색 결과 개수와 정렬 옵션을 표시
class ResultSummaryBar extends StatelessWidget {
  final int resultCount;
  final String sortBy;
  final Function(String) onSortChanged;

  const ResultSummaryBar({
    super.key,
    required this.resultCount,
    required this.sortBy,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Result Count
          Text(
            '총 $resultCount개의 캠프가 검색되었습니다.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          // Sort Dropdown
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
              vertical: AppDimensions.spacingS,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: sortBy,
                isDense: true,
                style: AppTextTheme.bodyMedium.copyWith(
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
                items: const [
                  DropdownMenuItem(value: '인기순', child: Text('인기순')),
                  DropdownMenuItem(value: '가격 낮은순', child: Text('가격 낮은순')),
                  DropdownMenuItem(value: '가격 높은순', child: Text('가격 높은순')),
                  DropdownMenuItem(value: '평점순', child: Text('평점순')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
