import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 텍스트 후기 섹션
/// 사용자가 후기 텍스트를 작성하는 위젯
class TextReviewSection extends StatelessWidget {
  final String reviewText;
  final ValueChanged<String> onReviewTextChanged;

  const TextReviewSection({
    super.key,
    required this.reviewText,
    required this.onReviewTextChanged,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            '후기를 남겨주세요',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 텍스트 입력 필드
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: TextField(
              maxLines: 6,
              maxLength: 1000,
              style: AppTextTheme.bodyMedium.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: '캠프를 통해 어떤 경험을 하셨나요? 좋은 점과 아쉬운 점을 함께 적어주세요.',
                hintStyle: AppTextTheme.bodyMedium.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
                border: InputBorder.none,
                counterStyle: AppTextTheme.bodySmall.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
              onChanged: onReviewTextChanged,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // 문자 수 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최소 10자 이상 입력해주세요',
                style: AppTextTheme.bodySmall.copyWith(
                  color: reviewText.length >= 10 
                      ? AppColors.successGreen 
                      : AppColors.errorRed500,
                ),
              ),
              
              Text(
                '${reviewText.length} / 1000자',
                style: AppTextTheme.bodySmall.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
