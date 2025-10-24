import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/booking_provider.dart';

/// 결제 방법 선택 폼 위젯
/// 결제 방법과 할인 코드를 입력받는 폼
class PaymentMethodForm extends StatefulWidget {
  final VoidCallback? onNext;
  
  const PaymentMethodForm({
    super.key,
    this.onNext,
  });

  @override
  State<PaymentMethodForm> createState() => _PaymentMethodFormState();
}

class _PaymentMethodFormState extends State<PaymentMethodForm> {
  final _formKey = GlobalKey<FormState>();
  final _promoCodeController = TextEditingController();
  
  String _selectedPaymentMethod = '';
  bool _agreeToTerms = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'card',
      'name': '카드 결제',
      'description': '신용카드/체크카드',
      'icon': Icons.credit_card,
    },
    {
      'id': 'bank_transfer',
      'name': '무통장 입금',
      'description': '계좌이체',
      'icon': Icons.account_balance,
    },
    {
      'id': 'kakao_pay',
      'name': '간편결제',
      'description': 'KakaoPay, NaverPay 등',
      'icon': Icons.payment,
    },
  ];

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 제목
            Text(
              '결제 방법 선택',
              style: AppTextTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // 결제 방법 선택
            ..._paymentMethods.map((method) {
              return _buildPaymentMethodOption(
                method['id'],
                method['name'],
                method['description'],
                method['icon'],
              );
            }),
            
            const SizedBox(height: 24),
            
            // 할인 코드 입력
            Text(
              '할인 코드',
              style: AppTextTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _promoCodeController,
                    hintText: '할인 코드를 입력해주세요',
                    validator: (value) {
                      // 할인 코드는 선택사항이므로 빈 값도 허용
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _applyPromoCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue500,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '적용',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 약관 동의
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _agreeToTerms ? AppColors.primaryBlue500 : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: _agreeToTerms ? AppColors.primaryBlue500.withOpacity(0.1) : Colors.grey[50],
              ),
              child: CheckboxListTile(
                title: RichText(
                  text: TextSpan(
                    text: '이용약관 및 ',
                    style: AppTextTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '개인정보 처리방침',
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: AppColors.primaryBlue500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: '에 동의합니다'),
                    ],
                  ),
                ),
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                  _savePaymentInfo();
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.primaryBlue500,
                checkColor: Colors.white,
                side: BorderSide(
                  color: _agreeToTerms ? AppColors.primaryBlue500 : Colors.grey[400]!,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // 다음 단계 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 다음 단계로 진행
                  widget.onNext?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '다음 단계',
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    String id,
    String name,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedPaymentMethod == id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = id;
          });
          _savePaymentInfo();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue50 : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue500 : AppColors.borderLight,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: id,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value ?? '';
                  });
                  _savePaymentInfo();
                },
                activeColor: AppColors.primaryBlue500,
              ),
              const SizedBox(width: 12),
              Icon(
                icon,
                color: isSelected ? AppColors.primaryBlue500 : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyPromoCode() {
    final promoCode = _promoCodeController.text.trim();
    if (promoCode.isNotEmpty) {
      // 할인 코드 적용 로직
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('할인 코드 "$promoCode"가 적용되었습니다'),
          backgroundColor: AppColors.primaryBlue500,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('할인 코드를 입력해주세요'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _savePaymentInfo() {
    // Provider에 결제 정보 저장
    context.read<BookingProvider>().setPaymentInfo(
      paymentMethod: _selectedPaymentMethod,
      promoCode: _promoCodeController.text.trim(),
      agreeToTerms: _agreeToTerms,
    );
  }
}
