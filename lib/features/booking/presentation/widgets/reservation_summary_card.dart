import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';

class ReservationSummaryCard extends StatelessWidget {
  final Map<String, dynamic> reservationData;

  const ReservationSummaryCard({
    super.key,
    required this.reservationData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 캠프 이미지
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              color: AppColors.primaryBlue50,
              child: reservationData['imageUrl'] != null
                  ? Image.network(
                      reservationData['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 캠프 제목
                Text(
                  reservationData['campTitle'] ?? '영국 런던 영어 캠프',
                  style: AppTextTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 예약 상세 정보
                _buildReservationDetails(isDark),
                
                const SizedBox(height: 16),
                
                // 상태 배지
                _buildStatusBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primaryBlue50,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 60,
          color: AppColors.primaryBlue300,
        ),
      ),
    );
  }

  Widget _buildReservationDetails(bool isDark) {
    final details = [
      {
        'label': '일정',
        'value': reservationData['schedule'] ?? '2025.12.08 ~ 2025.12.29',
      },
      {
        'label': '참가자',
        'value': reservationData['participantName'] ?? '김민수',
      },
      {
        'label': '결제금액',
        'value': reservationData['totalAmount'] ?? '₩3,300,000',
      },
      {
        'label': '결제수단',
        'value': reservationData['paymentMethod'] ?? '카드 결제 (신한카드)',
      },
      {
        'label': '예약번호',
        'value': reservationData['reservationId'] ?? 'EDCM-2025-1208-00042',
      },
    ];

    return Column(
      children: details.map((detail) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  detail['label']!,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  detail['value']!,
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

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.successGreen,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.successGreen,
          ),
          const SizedBox(width: 4),
          Text(
            '결제 완료',
            style: AppTextTheme.caption.copyWith(
              color: AppColors.successGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
