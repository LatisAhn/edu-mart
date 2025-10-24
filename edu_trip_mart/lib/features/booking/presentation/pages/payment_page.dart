import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/animated_fade_in.dart';
import '../providers/payment_provider.dart';

/// 결제 페이지
/// 결제 수단 선택 및 결제 처리
class PaymentPage extends StatefulWidget {
  final String campId;
  final Map<String, dynamic> participantInfo;

  const PaymentPage({
    super.key,
    required this.campId,
    required this.participantInfo,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'card';
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().loadPaymentInfo(widget.campId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.camp == null) {
            return _buildErrorState();
          }

          return _buildContent(provider);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '결제 정보를 불러올 수 없습니다',
            style: AppTextTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PaymentProvider provider) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentSummary(provider),
                const SizedBox(height: 24),
                _buildPaymentMethodSection(),
                const SizedBox(height: 24),
                _buildTermsSection(),
                const SizedBox(height: 100), // 하단 버튼 공간 확보
              ],
            ),
          ),
        ),
        _buildBottomBar(provider),
      ],
    );
  }

  Widget _buildPaymentSummary(PaymentProvider provider) {
    return AnimatedFadeIn(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '결제 정보',
              style: AppTextTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    provider.camp!.imageUrls.isNotEmpty ? provider.camp!.imageUrls.first : '',
                    width: 60,
                    height: 45,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 45,
                        color: AppColors.primaryBlue300,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.camp!.title,
                        style: AppTextTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.camp!.city}, ${provider.camp!.country}',
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${provider.camp!.currency} ${provider.camp!.price.toStringAsFixed(0)}',
                  style: AppTextTheme.titleLarge.copyWith(
                    color: AppColors.primaryBlue500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('참가자', widget.participantInfo['name'] ?? ''),
            _buildSummaryRow('나이', '${widget.participantInfo['age']}세'),
            _buildSummaryRow('연락처', widget.participantInfo['phone'] ?? ''),
            const Divider(height: 24),
            _buildSummaryRow(
              '총 결제 금액',
              '${provider.camp!.currency} ${provider.camp!.price.toStringAsFixed(0)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
                : AppTextTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTextTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue500,
                  )
                : AppTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '결제 수단',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodOption(
            'card',
            '신용카드',
            Icons.credit_card,
            'Visa, MasterCard, AMEX',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodOption(
            'bank',
            '계좌이체',
            Icons.account_balance,
            '실시간 계좌이체',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodOption(
            'kakao',
            '카카오페이',
            Icons.payment,
            '간편결제',
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodOption(
            'naver',
            '네이버페이',
            Icons.payment,
            '간편결제',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    String value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue500.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue500 : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue500 : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.primaryBlue500 : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue500,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '약관 동의',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCheckboxOption(
            '이용약관에 동의합니다',
            _agreeToTerms,
            (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildCheckboxOption(
            '개인정보 처리방침에 동의합니다',
            _agreeToPrivacy,
            (value) {
              setState(() {
                _agreeToPrivacy = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue500,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              title,
              style: AppTextTheme.bodyMedium,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // 약관 상세 보기
          },
          child: Text(
            '보기',
            style: AppTextTheme.bodySmall.copyWith(
              color: AppColors.primaryBlue500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(PaymentProvider provider) {
    final canProceed = _agreeToTerms && _agreeToPrivacy;
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: '${provider.camp?.currency} ${provider.camp?.price.toStringAsFixed(0)} 결제하기',
          onPressed: canProceed ? () => _processPayment(provider) : null,
        ),
      ),
    );
  }

  void _processPayment(PaymentProvider provider) async {
    // 결제 처리
    final success = await provider.processPayment(
      campId: widget.campId,
      participantInfo: widget.participantInfo,
      paymentMethod: _selectedPaymentMethod,
    );

    if (success) {
      // 결제 성공 페이지로 이동
      Navigator.pushReplacementNamed(
        context,
        '/payment-success',
        arguments: {
          'campId': widget.campId,
          'participantInfo': widget.participantInfo,
        },
      );
    } else {
      // 결제 실패 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('결제 처리 중 오류가 발생했습니다. 다시 시도해주세요.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

