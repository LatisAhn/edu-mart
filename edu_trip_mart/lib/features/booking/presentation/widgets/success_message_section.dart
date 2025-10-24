import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

class SuccessMessageSection extends StatefulWidget {
  const SuccessMessageSection({super.key});

  @override
  State<SuccessMessageSection> createState() => _SuccessMessageSectionState();
}

class _SuccessMessageSectionState extends State<SuccessMessageSection>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late Animation<double> _checkmarkAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));

    _checkmarkController.forward();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 성공 체크마크 애니메이션
        AnimatedBuilder(
          animation: _checkmarkAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _checkmarkAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.successGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.successGreen.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // 제목
        Text(
          '예약이 완료되었습니다!',
          style: AppTextTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // 부제목
        Text(
          '결제가 정상적으로 처리되었으며,\n예약 내역을 확인하실 수 있습니다.',
          style: AppTextTheme.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
