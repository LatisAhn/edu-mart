import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

class ReservationStatusBanner extends StatelessWidget {
  final String status; // completed, pending, cancelled

  const ReservationStatusBanner({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(status);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusInfo['color'],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusInfo['color'].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 상태 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              statusInfo['icon'],
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 상태 메시지
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusInfo['title'],
                  style: AppTextTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusInfo['subtitle'],
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'completed':
        return {
          'icon': Icons.check_circle,
          'title': '결제가 완료되었습니다',
          'subtitle': '예약이 성공적으로 확정되었습니다',
          'color': AppColors.successGreen,
        };
      case 'pending':
        return {
          'icon': Icons.schedule,
          'title': '예약 확인 중입니다',
          'subtitle': '결제 확인 후 예약이 확정됩니다',
          'color': AppColors.warning,
        };
      case 'cancelled':
        return {
          'icon': Icons.cancel,
          'title': '예약이 취소되었습니다',
          'subtitle': '환불 처리 중입니다',
          'color': AppColors.neutralGray500,
        };
      default:
        return {
          'icon': Icons.help,
          'title': '상태를 확인할 수 없습니다',
          'subtitle': '고객지원팀에 문의해주세요',
          'color': AppColors.neutralGray500,
        };
    }
  }
}
