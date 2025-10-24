import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 검색 앱바 위젯
/// 뒤로가기, 검색 입력 필드, 필터 버튼을 포함
class SearchAppBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final VoidCallback? onFilterTap;
  final bool showBackButton;

  const SearchAppBar({
    super.key,
    required this.controller,
    this.onSearch,
    this.onFilterTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingS,
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
          // Back Button
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),

          // Search Input Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSearch?.call(),
                style: AppTextTheme.bodyMedium.copyWith(
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: '캠프명, 지역, 기간으로 검색',
                  hintStyle: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            controller.clear();
                            onSearch?.call();
                          },
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: AppDimensions.spacingS),

          // Filter Button
          IconButton(
            onPressed: onFilterTap,
            icon: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
              ),
              child: const Icon(
                Icons.tune,
                color: AppColors.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
