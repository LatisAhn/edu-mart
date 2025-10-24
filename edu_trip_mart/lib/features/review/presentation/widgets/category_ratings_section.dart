import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 카테고리별 평가 섹션
/// 수업 만족도, 숙소 및 식사, 안전 및 관리, 활동 프로그램을 평가하는 위젯
class CategoryRatingsSection extends StatelessWidget {
  final Map<String, int> categoryRatings;
  final Function(String category, int rating) onCategoryRatingChanged;

  const CategoryRatingsSection({
    super.key,
    required this.categoryRatings,
    required this.onCategoryRatingChanged,
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
            '세부 항목 평가',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 카테고리별 평가
          ...categoryRatings.keys.map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildCategoryRating(
                context,
                category,
                categoryRatings[category] ?? 0,
                isDark,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryRating(
    BuildContext context,
    String category,
    int rating,
    bool isDark,
  ) {
    return Row(
      children: [
        // 카테고리 라벨
        Expanded(
          flex: 2,
          child: Text(
            category,
            style: AppTextTheme.bodyMedium.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // 별점 버튼들
        Expanded(
          flex: 3,
          child: Row(
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= rating;
              
              return GestureDetector(
                onTap: () => onCategoryRatingChanged(category, starIndex),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 20,
                    color: isSelected ? AppColors.warningYellow : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
