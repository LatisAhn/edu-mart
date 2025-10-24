import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';

class CustomerSupportSection extends StatelessWidget {
  final VoidCallback onChatSupport;
  final VoidCallback onViewFAQ;

  const CustomerSupportSection({
    super.key,
    required this.onChatSupport,
    required this.onViewFAQ,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            '도움이 필요하신가요?',
            style: AppTextTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 설명 텍스트
          Text(
            '결제, 환불 또는 캠프 관련 문의사항이 있다면\n아래로 문의해 주세요.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 1:1 채팅 문의 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onChatSupport,
              icon: const Icon(Icons.chat, size: 18),
              label: const Text('1:1 채팅 문의'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // FAQ 보기 링크
          Center(
            child: TextButton(
              onPressed: onViewFAQ,
              child: Text(
                'FAQ 보기',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.primaryBlue500,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
