import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';

class CampInfoCard extends StatelessWidget {
  final String campTitle;
  final String dateRange;
  final String location;
  final String organizer;
  final VoidCallback onContactTap;
  final VoidCallback onImageTap;

  const CampInfoCard({
    super.key,
    required this.campTitle,
    required this.dateRange,
    required this.location,
    required this.organizer,
    required this.onContactTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 캠프 이미지
          GestureDetector(
            onTap: onImageTap,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                height: 200,
                width: double.infinity,
                color: AppColors.primaryBlue50,
                child: _buildPlaceholderImage(),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 캠프 제목
                Text(
                  campTitle,
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 캠프 정보
                _buildInfoRow(
                  Icons.calendar_today,
                  '기간',
                  dateRange,
                  isDark,
                ),
                
                const SizedBox(height: 8),
                
                _buildInfoRow(
                  Icons.location_on,
                  '위치',
                  location,
                  isDark,
                ),
                
                const SizedBox(height: 8),
                
                _buildInfoRow(
                  Icons.business,
                  '주최기관',
                  organizer,
                  isDark,
                ),
                
                const SizedBox(height: 16),
                
                // 기관 문의하기 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onContactTap,
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('기관 문의하기'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.primaryBlue500,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextTheme.bodyMedium.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primaryBlue50,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 60,
          color: AppColors.primaryBlue300,
        ),
      ),
    );
  }
}
