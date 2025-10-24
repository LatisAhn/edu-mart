import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';

class ReservationInfoSection extends StatelessWidget {
  final String reservationNumber;
  final String participantName;
  final String guardianName;
  final String phone;
  final String email;
  final int participantCount;
  final String roomType;
  final bool pickupService;
  final bool insurance;

  const ReservationInfoSection({
    super.key,
    required this.reservationNumber,
    required this.participantName,
    required this.guardianName,
    required this.phone,
    required this.email,
    required this.participantCount,
    required this.roomType,
    required this.pickupService,
    required this.insurance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            '예약 정보',
            style: AppTextTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 예약 정보 그리드
          _buildInfoGrid(isDark),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(bool isDark) {
    final infoItems = [
      {'label': '예약번호', 'value': reservationNumber},
      {'label': '신청자명', 'value': participantName},
      {'label': '보호자명', 'value': guardianName},
      {'label': '연락처', 'value': phone},
      {'label': '이메일', 'value': email},
      {'label': '참가자 수', 'value': '$participantCount명'},
      {'label': '숙소 타입', 'value': roomType},
      {'label': '픽업 서비스', 'value': pickupService ? '포함' : '미포함'},
      {'label': '보험', 'value': insurance ? '가입 완료' : '미가입'},
    ];

    return Column(
      children: infoItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  item['label']!,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item['value']!,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
