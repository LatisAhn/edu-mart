import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';

class PaymentInfoSection extends StatelessWidget {
  final String paymentDate;
  final String paymentMethod;
  final int totalAmount;
  final String? discountCode;
  final int? discountAmount;
  final String status; // completed, pending, failed

  const PaymentInfoSection({
    super.key,
    required this.paymentDate,
    required this.paymentMethod,
    required this.totalAmount,
    this.discountCode,
    this.discountAmount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.neutralGray50,
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
            '결제 정보',
            style: AppTextTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 결제 정보
          _buildPaymentInfo(isDark),
          
          const SizedBox(height: 16),
          
          // 총 결제금액 (강조)
          _buildTotalAmount(isDark),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(bool isDark) {
    final paymentItems = [
      {'label': '결제일시', 'value': paymentDate},
      {'label': '결제수단', 'value': paymentMethod},
      {'label': '결제상태', 'value': _getStatusText()},
    ];

    if (discountCode != null && discountAmount != null) {
      paymentItems.insert(2, {
        'label': '할인 코드',
        'value': '$discountCode (-₩${discountAmount!.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')})',
      });
    }

    return Column(
      children: paymentItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
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

  Widget _buildTotalAmount(bool isDark) {
    final finalAmount = totalAmount - (discountAmount ?? 0);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryBlue300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '총 결제금액',
            style: AppTextTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          Text(
            '₩${finalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case 'completed':
        return '결제 완료';
      case 'pending':
        return '결제 대기 중';
      case 'failed':
        return '결제 실패';
      default:
        return '알 수 없음';
    }
  }
}
