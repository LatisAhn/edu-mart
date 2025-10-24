import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';

class ActionButtonsSection extends StatelessWidget {
  final VoidCallback onViewReservation;
  final VoidCallback onGoHome;

  const ActionButtonsSection({
    super.key,
    required this.onViewReservation,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 예약 내역 보기 버튼 (Primary)
        CustomButton(
          text: '📄 예약 내역 보기',
          onPressed: onViewReservation,
          backgroundColor: AppColors.primaryBlue500,
          textColor: Colors.white,
          isFullWidth: true,
          height: 56,
        ),
        
        const SizedBox(height: 12),
        
        // 홈으로 돌아가기 버튼 (Secondary)
        CustomButton(
          text: '🏠 홈으로 돌아가기',
          onPressed: onGoHome,
          type: CustomButtonType.outlined,
          backgroundColor: Colors.transparent,
          textColor: AppColors.primaryBlue500,
          borderColor: AppColors.primaryBlue500,
          isFullWidth: true,
          height: 56,
        ),
      ],
    );
  }
}
