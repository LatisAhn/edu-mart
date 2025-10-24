import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 빠른 액션 섹션
/// 자주 사용하는 기능들에 대한 바로가기 버튼들
class QuickActionsSection extends StatelessWidget {
  final VoidCallback onPaymentHistory;
  final VoidCallback onReceipts;
  final VoidCallback onInquiries;
  final VoidCallback onSettings;

  const QuickActionsSection({
    super.key,
    required this.onPaymentHistory,
    required this.onReceipts,
    required this.onInquiries,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingL),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '빠른 액션',
            style: AppTextTheme.headlineSmall.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // 액션 버튼 그리드
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: AppDimensions.spacingM,
            mainAxisSpacing: AppDimensions.spacingM,
            childAspectRatio: 1.0,
            children: [
              _buildActionItem(
                context,
                icon: Icons.payment,
                label: '결제 내역',
                onTap: onPaymentHistory,
                isDark: isDark,
              ),
              _buildActionItem(
                context,
                icon: Icons.receipt,
                label: '영수증',
                onTap: onReceipts,
                isDark: isDark,
              ),
              _buildActionItem(
                context,
                icon: Icons.chat_bubble_outline,
                label: '문의내역',
                onTap: onInquiries,
                isDark: isDark,
              ),
              _buildActionItem(
                context,
                icon: Icons.settings,
                label: '설정',
                onTap: onSettings,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primaryBlue500,
            ),
            
            const SizedBox(height: AppDimensions.spacingS),
            
            Text(
              label,
              style: AppTextTheme.bodySmall.copyWith(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
