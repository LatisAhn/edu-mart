import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 캠프 요약 섹션
/// 후기를 작성할 캠프의 기본 정보를 표시하는 위젯
class CampSummarySection extends StatelessWidget {
  final String campName;
  final String campImageUrl;
  final String dateRange;
  final String location;
  final VoidCallback onTap;

  const CampSummarySection({
    super.key,
    required this.campName,
    required this.campImageUrl,
    required this.dateRange,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // 캠프 썸네일
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray100,
                ),
                child: campImageUrl.isNotEmpty
                    ? Image.network(
                        campImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 캠프 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 캠프 이름
                  Text(
                    campName,
                    style: AppTextTheme.bodyLarge.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // 날짜
                  Text(
                    dateRange,
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // 위치
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      location,
                      style: AppTextTheme.bodySmall.copyWith(
                        color: AppColors.primaryBlue500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 화살표 아이콘
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.neutralGray100,
      child: const Center(
        child: Icon(
          Icons.image,
          color: AppColors.textDisabledLight,
          size: 24,
        ),
      ),
    );
  }
}
