import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

class ReservationActionButtons extends StatelessWidget {
  final VoidCallback onViewReceipt;
  final VoidCallback? onCancelReservation;
  final VoidCallback onGoHome;
  final bool canCancel;

  const ReservationActionButtons({
    super.key,
    required this.onViewReceipt,
    this.onCancelReservation,
    required this.onGoHome,
    this.canCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 영수증 보기 버튼
            CustomButton(
              text: '📄 영수증 보기',
              onPressed: onViewReceipt,
              type: CustomButtonType.outlined,
              backgroundColor: Colors.transparent,
              textColor: AppColors.primaryBlue500,
              borderColor: AppColors.primaryBlue500,
              isFullWidth: true,
              height: 48,
            ),
            
            const SizedBox(height: 12),
            
            // 예약 취소하기 버튼 (조건부)
            if (canCancel && onCancelReservation != null)
              CustomButton(
                text: '❌ 예약 취소하기',
                onPressed: onCancelReservation,
                backgroundColor: AppColors.errorRed500,
                textColor: Colors.white,
                isFullWidth: true,
                height: 48,
              )
            else if (!canCancel)
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.neutralGray600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '출발일 7일 전 이후에는 취소할 수 없습니다',
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: AppColors.neutralGray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (canCancel && onCancelReservation != null)
              const SizedBox(height: 12),
            
            // 홈으로 버튼
            CustomButton(
              text: '🏠 홈으로',
              onPressed: onGoHome,
              type: CustomButtonType.outlined,
              backgroundColor: Colors.transparent,
              textColor: AppColors.textSecondary,
              borderColor: AppColors.neutralGray300,
              isFullWidth: true,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
