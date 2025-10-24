import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 포인트 적립 정보 카드
/// 사용자가 받은 포인트 정보를 표시하는 카드
class RewardInfoCard extends StatelessWidget {
  final int pointsEarned;
  final Animation<double> slideAnimation;
  final Animation<double> fadeAnimation;

  const RewardInfoCard({
    super.key,
    required this.pointsEarned,
    required this.slideAnimation,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, slideAnimation.value),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue50,
                    AppColors.backgroundWhite,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 포인트 아이콘
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue500,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // 포인트 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '감사합니다! ${pointsEarned}P가 적립되었습니다.',
                          style: AppTextTheme.bodyLarge.copyWith(
                            color: AppColors.primaryBlue500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          '마이페이지 > 포인트 내역에서 확인할 수 있습니다.',
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
