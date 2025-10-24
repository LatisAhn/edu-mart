import 'package:flutter/material.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 하단 고정 CTA 바 위젯
/// 가격 정보와 예약 버튼을 하단에 고정하여 표시
class FloatingCtaBar extends StatelessWidget {
  final CampEntity camp;
  final VoidCallback? onReserveTap;

  const FloatingCtaBar({
    super.key,
    required this.camp,
    this.onReserveTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.screenPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          // Price Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  camp.formattedPrice,
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                  ),
                ),
                Text(
                  '/ ${camp.formattedDuration}',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Reserve Button
          CustomButton(
            text: '예약하기',
            type: CustomButtonType.primary,
            onPressed: onReserveTap,
            icon: Icons.calendar_today,
            width: 120,
          ),
        ],
      ),
    );
  }
}
