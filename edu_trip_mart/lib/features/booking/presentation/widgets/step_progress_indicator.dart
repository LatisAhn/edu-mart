import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 단계 진행 표시기 위젯
/// 예약/결제 과정의 현재 단계를 시각적으로 표시
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: AppColors.backgroundWhite,
      child: Column(
        children: [
          // 단계 라벨과 숫자
          Row(
            children: List.generate(steps.length, (index) {
              final isActive = index <= currentStep;
              final isCompleted = index < currentStep;
              
              return Expanded(
                child: Column(
                  children: [
                    // 단계 라벨
                    Text(
                      steps[index],
                      textAlign: TextAlign.center,
                      style: AppTextTheme.caption.copyWith(
                        color: isActive 
                            ? AppColors.primaryBlue500 
                            : AppColors.textSecondary,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // 단계 원 (숫자)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive 
                            ? AppColors.primaryBlue500 
                            : AppColors.borderLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : Text(
                                '${index + 1}',
                                style: AppTextTheme.bodySmall.copyWith(
                                  color: isActive ? Colors.white : AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          
          const SizedBox(height: 12),
          
          // 진행 바 (연결선)
          Row(
            children: List.generate(steps.length - 1, (index) {
              final isCompleted = index < currentStep;
              
              return Expanded(
                child: Container(
                  height: 2,
                  margin: EdgeInsets.only(
                    left: 16, // 원의 반지름만큼 오프셋
                    right: 16,
                  ),
                  color: isCompleted 
                      ? AppColors.primaryBlue500 
                      : AppColors.borderLight,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
