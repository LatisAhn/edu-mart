import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 진행 상황 요약 섹션
/// 사용자의 참여 현황을 게임화된 형태로 표시하는 섹션
class ProgressSummarySection extends StatelessWidget {
  final Animation<double> slideAnimation;
  final Animation<double> fadeAnimation;
  final VoidCallback onViewMyCamps;

  const ProgressSummarySection({
    super.key,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onViewMyCamps,
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
                    '참여 현황',
                    style: AppTextTheme.bodyLarge.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 진행률 표시
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryBlue300,
                      ),
                    ),
                    child: Column(
                      children: [
                        // 진행률 바
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: 0.67, // 2/3 완료
                                backgroundColor: Colors.grey[300],
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryBlue500,
                                ),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '2/3',
                              style: AppTextTheme.bodyMedium.copyWith(
                                color: AppColors.primaryBlue500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // 진행률 텍스트
                        Text(
                          '캠프 후기 작성률 2/3 완료',
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          '후기를 더 작성하면 리워드 포인트가 추가 지급됩니다.',
                          style: AppTextTheme.bodySmall.copyWith(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 내 캠프 보기 링크
                  GestureDetector(
                    onTap: onViewMyCamps,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: AppColors.primaryBlue500,
                            size: 20,
                          ),
                          
                          const SizedBox(width: 8),
                          
                          Text(
                            '내 캠프 보기',
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.primaryBlue500,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primaryBlue500,
                            size: 16,
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
