import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 탭 섹션 위젯
/// 캠프 소개, 일정 및 비용, 시설 안내, 리뷰 탭을 표시
class TabSection extends StatelessWidget {
  final TabController tabController;
  final ValueChanged<int>? onTabChanged;

  const TabSection({
    super.key,
    required this.tabController,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: TabBar(
        controller: tabController,
        onTap: onTabChanged,
        labelColor: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
        unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        labelStyle: AppTextTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextTheme.bodyMedium,
        indicatorColor: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
        indicatorWeight: 2,
        tabs: const [
          Tab(text: '캠프 소개'),
          Tab(text: '일정 및 비용'),
          Tab(text: '시설 안내'),
          Tab(text: '리뷰'),
        ],
      ),
    );
  }
}
