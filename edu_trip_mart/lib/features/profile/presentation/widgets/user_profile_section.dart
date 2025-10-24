import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 사용자 프로필 섹션
/// 사용자 정보와 상태를 표시하는 위젯
class UserProfileSection extends StatelessWidget {
  final String userName;
  final int activeReservationCount;
  final VoidCallback onEditProfile;

  const UserProfileSection({
    super.key,
    required this.userName,
    required this.activeReservationCount,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingM),
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
        children: [
          // 프로필 아바타
          GestureDetector(
            onTap: onEditProfile,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue100,
                border: Border.all(
                  color: AppColors.primaryBlue500,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.primaryBlue500,
              ),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          // 사용자 이름
          Text(
            '$userName 님',
            style: AppTextTheme.headlineSmall.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingS),
          
          // 예약 상태
          Text(
            '$activeReservationCount개의 예약이 진행 중입니다.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // 내 정보 수정 버튼
          CustomButton(
            text: '내 정보 수정',
            onPressed: onEditProfile,
            variant: ButtonVariant.outline,
          ),
        ],
      ),
    );
  }
}
