import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 다음 액션 섹션
/// 사용자가 취할 수 있는 다음 행동들을 제시하는 섹션
class NextActionSection extends StatelessWidget {
  final Animation<double> slideAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback onGoHome;
  final VoidCallback onViewCommunity;
  final VoidCallback onExploreCamps;

  const NextActionSection({
    super.key,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onGoHome,
    required this.onViewCommunity,
    required this.onExploreCamps,
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
                color: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
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
                    '다음으로 하실 일은?',
                    style: AppTextTheme.bodyLarge.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 홈으로 돌아가기 버튼 (Primary)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onGoHome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.home, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '홈으로 돌아가기',
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 커뮤니티 후기 보기 버튼 (Secondary)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onViewCommunity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.primaryBlue500,
                        side: BorderSide(color: AppColors.primaryBlue500),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '커뮤니티 후기 보기',
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: AppColors.primaryBlue500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 다른 캠프 둘러보기 버튼 (Tertiary)
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: onExploreCamps,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.explore, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '다른 캠프 둘러보기',
                            style: AppTextTheme.bodyLarge.copyWith(
                              color: AppColors.primaryBlue500,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
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
