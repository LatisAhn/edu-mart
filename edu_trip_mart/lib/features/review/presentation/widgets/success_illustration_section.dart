import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 성공 일러스트레이션 섹션
/// 후기 등록 성공을 나타내는 시각적 요소들
class SuccessIllustrationSection extends StatelessWidget {
  final AnimationController confettiController;
  final Animation<double> slideAnimation;
  final Animation<double> fadeAnimation;

  const SuccessIllustrationSection({
    super.key,
    required this.confettiController,
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
            child: Column(
              children: [
                // 성공 아이콘
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.successGreen,
                      size: 64,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 메인 메시지
                Text(
                  '후기가 성공적으로 등록되었습니다!',
                  style: AppTextTheme.headlineMedium.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                // 보조 메시지
                Text(
                  '여러분의 경험이 다른 학부모님께 큰 도움이 됩니다.',
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
