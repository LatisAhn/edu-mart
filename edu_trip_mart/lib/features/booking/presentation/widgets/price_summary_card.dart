import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 가격 요약 카드 위젯
/// 최종 결제 금액과 결제 버튼을 표시하는 하단 고정 카드
class PriceSummaryCard extends StatelessWidget {
  final dynamic camp;
  final VoidCallback? onPaymentTap;
  final bool isEnabled;
  final String buttonText;

  const PriceSummaryCard({
    super.key,
    required this.camp,
    this.onPaymentTap,
    this.isEnabled = false,
    this.buttonText = '다음 단계',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 가격 요약
            _buildPriceSummary(),
            const SizedBox(height: 16),
            
            // 결제 버튼
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: buttonText,
                type: CustomButtonType.primary,
                onPressed: isEnabled ? onPaymentTap : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    // 기본 가격
    final basePrice = camp.price;
    
    // 추가 옵션 가격 (실제로는 Provider에서 가져와야 함)
    final pickupPrice = 100000.0; // 공항 픽업
    final insurancePrice = 50000.0; // 보험
    final discount = 50000.0; // 할인
    
    final totalPrice = basePrice + pickupPrice + insurancePrice - discount;
    
    return Column(
      children: [
        _buildPriceRow('기본 2주 캠프', '${camp.currency} ${_formatPrice(basePrice)}'),
        _buildPriceRow('공항 픽업', '+${camp.currency} ${_formatPrice(pickupPrice)}'),
        _buildPriceRow('여행자 보험', '+${camp.currency} ${_formatPrice(insurancePrice)}'),
        _buildPriceRow('할인 코드 적용', '-${camp.currency} ${_formatPrice(discount)}', isDiscount: true),
        const Divider(height: 16),
        _buildPriceRow(
          '총 결제금액',
          '${camp.currency} ${_formatPrice(totalPrice)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : AppTextTheme.bodyMedium.copyWith(
                    color: isDiscount ? AppColors.primaryBlue500 : AppColors.textDark,
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextTheme.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue500,
                  )
                : AppTextTheme.bodyMedium.copyWith(
                    color: isDiscount ? AppColors.primaryBlue500 : AppColors.textDark,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return price.toStringAsFixed(0);
    }
  }
}
