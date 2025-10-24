import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 예약 탭 위젯
/// 진행중/완료됨/취소됨 탭을 표시하는 위젯
class ReservationTabs extends StatelessWidget {
  final TabController tabController;
  final ValueChanged<int> onTabChanged;

  const ReservationTabs({
    super.key,
    required this.tabController,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppDimensions.elevationS,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        onTap: onTabChanged,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(
            width: 3,
            color: AppColors.primaryBlue500,
          ),
          insets: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.primaryBlue500,
        unselectedLabelColor: isDark ? Colors.grey[300] : Colors.grey[600],
        labelStyle: AppTextTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: AppTextTheme.bodyLarge.copyWith(
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: '진행 중'),
          Tab(text: '완료됨'),
          Tab(text: '취소됨'),
        ],
      ),
    );
  }
}
