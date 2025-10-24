import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 별점 평가 섹션
/// 전체적인 캠프 만족도를 5점 만점으로 평가하는 위젯
class RatingSection extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const RatingSection({
    super.key,
    required this.rating,
    required this.onRatingChanged,
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
            '캠프는 전반적으로 만족스러우셨나요?',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 별점 위젯
          Row(
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= rating;
              
              return GestureDetector(
                onTap: () => onRatingChanged(starIndex),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 32,
                    color: isSelected ? AppColors.warningYellow : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // 별점 텍스트
          if (rating > 0)
            Text(
              '5점 만점 중 ${rating}점',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.primaryBlue500,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
