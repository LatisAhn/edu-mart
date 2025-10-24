import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 동의 체크박스 섹션
/// 후기 공개 게시 동의를 받는 위젯
class ConsentSection extends StatelessWidget {
  final bool isAgreed;
  final ValueChanged<bool> onAgreementChanged;

  const ConsentSection({
    super.key,
    required this.isAgreed,
    required this.onAgreementChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 체크박스
          GestureDetector(
            onTap: () => onAgreementChanged(!isAgreed),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isAgreed ? AppColors.primaryBlue500 : Colors.transparent,
                border: Border.all(
                  color: isAgreed ? AppColors.primaryBlue500 : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isAgreed
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 동의 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '후기를 공개적으로 게시하는 데 동의합니다.',
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '개인정보(이름, 연락처)는 게시되지 않습니다.',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
