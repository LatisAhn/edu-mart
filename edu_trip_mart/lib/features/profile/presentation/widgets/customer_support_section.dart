import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 고객 지원 섹션
/// 1:1 문의, FAQ, 긴급 연락처 등의 지원 기능들
class CustomerSupportSection extends StatelessWidget {
  final VoidCallback onOneOnOneInquiry;
  final VoidCallback onViewFAQ;
  final VoidCallback onEmergencyContact;

  const CustomerSupportSection({
    super.key,
    required this.onOneOnOneInquiry,
    required this.onViewFAQ,
    required this.onEmergencyContact,
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
            '도움이 필요하신가요?',
            style: AppTextTheme.headlineSmall.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // 1:1 문의 버튼
          CustomButton(
            text: '1:1 문의',
            onPressed: onOneOnOneInquiry,
            variant: ButtonVariant.primary,
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // FAQ 링크
          GestureDetector(
            onTap: onViewFAQ,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingM,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: AppColors.primaryBlue500,
                    size: 20,
                  ),
                  
                  const SizedBox(width: AppDimensions.spacingS),
                  
                  Text(
                    'FAQ 보기',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.primaryBlue500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  Icon(
                    Icons.arrow_forward_ios,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // 긴급 연락처
          Row(
            children: [
              Icon(
                Icons.phone,
                color: AppColors.errorRed500,
                size: 20,
              ),
              
              const SizedBox(width: AppDimensions.spacingS),
              
              Text(
                '긴급 연락처: ',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
              
              GestureDetector(
                onTap: onEmergencyContact,
                child: Text(
                  '010-1234-5678',
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.errorRed500,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
