import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../providers/booking_provider.dart';
import '../widgets/step_progress_indicator.dart';
import '../widgets/camp_summary_card.dart';
import '../widgets/participant_info_form.dart';
import '../widgets/guardian_info_form.dart';
import '../widgets/options_selection_form.dart';
import '../widgets/payment_method_form.dart';
import '../widgets/price_summary_card.dart';

/// 예약/결제 페이지
/// 캠프 예약을 위한 참가자 정보 입력, 옵션 선택, 결제 정보 입력을 통합한 화면
class BookingPage extends StatefulWidget {
  final String campId;

  const BookingPage({
    super.key,
    required this.campId,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  int _currentStep = 0; // 0: 정보입력, 1: 결제정보, 2: 확인완료

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadCampInfo(widget.campId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: Consumer<BookingProvider>(
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
      bottomNavigationBar: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.camp == null) {
            return const SizedBox.shrink();
          }
          return PriceSummaryCard(
            camp: provider.camp!,
            onPaymentTap: _currentStep == 2 ? () => _processPayment(provider) : () => _nextStep(),
            isEnabled: _isPaymentEnabled(),
            buttonText: _getButtonText(),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '예약 / 결제',
        style: AppTextTheme.titleLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, color: AppColors.textSecondary),
          onPressed: () => _showHelpDialog(),
        ),
      ],
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
            '캠프 정보를 불러올 수 없습니다',
            style: AppTextTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '잠시 후 다시 시도해주세요',
            style: AppTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BookingProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 캠프 요약 카드
          CampSummaryCard(
            camp: provider.camp!,
            onEditTap: () => _showDateSelector(provider),
          ),
          
          // 단계 진행 표시기
          StepProgressIndicator(
            currentStep: _currentStep,
            steps: const ['정보 입력', '결제 정보', '확인 완료'],
          ),
          
          // 메인 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                children: [
                  if (_currentStep == 0) ...[
                    // 참가자 정보 입력
                    _buildSectionTitle('참가자 정보'),
                    const SizedBox(height: 8),
                    ParticipantInfoForm(),
                    const SizedBox(height: 24),
                    
                    // 보호자 정보 입력
                    _buildSectionTitle('보호자 정보'),
                    const SizedBox(height: 8),
                    GuardianInfoForm(),
                    const SizedBox(height: 24),
                    
                    // 추가 선택
                    _buildSectionTitle('추가 선택'),
                    const SizedBox(height: 8),
                    OptionsSelectionForm(
                      onOptionsChanged: () => setState(() {}),
                      onNext: () => _nextStep(),
                    ),
                  ] else if (_currentStep == 1) ...[
                    // 결제 정보 입력
                    PaymentMethodForm(
                      onNext: () => _nextStep(),
                    ),
                  ] else if (_currentStep == 2) ...[
                    // 확인 완료
                    _buildConfirmationContent(provider),
                  ],
                  const SizedBox(height: 20), // 하단 버튼 공간 확보
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationContent(BookingProvider provider) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: AppColors.primaryBlue500,
              ),
              const SizedBox(height: 16),
              Text(
                '예약 정보를 확인해주세요',
                style: AppTextTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildConfirmationRow('캠프명', provider.camp?.title ?? ''),
              _buildConfirmationRow('기간', '${provider.camp?.duration}일'),
              _buildConfirmationRow('참가자', provider.participantInfo?.name ?? ''),
              _buildConfirmationRow('총 금액', '${provider.camp?.currency} ${provider.camp?.price.toStringAsFixed(0)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextTheme.bodyMedium.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: AppTextTheme.bodyMedium.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }


  bool _isPaymentEnabled() {
    // 필수 정보가 모두 입력되었는지 확인
    if (_currentStep == 0) {
      // 참가자 정보 단계에서는 참가자 정보가 입력되어야 함
      return context.read<BookingProvider>().isParticipantInfoValid();
    }
    if (_currentStep == 1) {
      // 결제 정보 단계에서는 결제 방법이 선택되어야 함
      return context.read<BookingProvider>().isPaymentInfoValid();
    }
    return _currentStep >= 1;
  }

  String _getButtonText() {
    switch (_currentStep) {
      case 0:
        return '다음 단계';
      case 1:
        return '다음 단계';
      case 2:
        return '결제하기';
      default:
        return '다음 단계';
    }
  }

  void _showDateSelector(BookingProvider provider) {
    // 날짜 선택 모달 표시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('날짜 변경'),
        content: const Text('날짜 변경 기능은 준비 중입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('결제 관련 문의'),
        content: const Text('결제 관련 문의사항이 있으시면 고객센터로 연락해주세요.\n\n전화: 1588-0000\n이메일: support@edutrip.com'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _processPayment(BookingProvider provider) {
    // 결제 처리 로직
    // TODO: 실제 결제 API 호출
    
    // 예약 완료 페이지로 이동
    final reservationData = {
      'campTitle': provider.camp?.title ?? '영국 런던 영어 캠프',
      'schedule': '2025.12.08 ~ 2025.12.29',
      'participantName': provider.participantInfo?.name ?? '김민수',
      'totalAmount': '₩3,300,000',
      'paymentMethod': '카드 결제 (신한카드)',
      'reservationId': 'EDCM-2025-1208-00042',
      'imageUrl': provider.camp?.imageUrls?.isNotEmpty == true 
          ? provider.camp!.imageUrls!.first 
          : null,
    };
    
    final reservationId = 'EDCM-2025-1208-00042';
    
    Navigator.pushReplacementNamed(
      context,
      '/reservation-confirmation',
      arguments: {
        'reservationId': reservationId,
        'reservationData': reservationData,
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextTheme.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

