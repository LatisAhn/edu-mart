import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../providers/booking_provider.dart';
import '../widgets/reservation_status_banner.dart';
import '../widgets/camp_info_card.dart';
import '../widgets/reservation_info_section.dart';
import '../widgets/payment_info_section.dart';
import '../widgets/policy_notice_section.dart';
import '../widgets/reservation_action_buttons.dart';
import '../widgets/customer_support_section.dart';

class ReservationDetailPage extends StatefulWidget {
  final String reservationId;

  const ReservationDetailPage({
    super.key,
    required this.reservationId,
  });

  @override
  State<ReservationDetailPage> createState() => _ReservationDetailPageState();
}

class _ReservationDetailPageState extends State<ReservationDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(provider),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ReservationActionButtons(
        onViewReceipt: _viewReceipt,
        onCancelReservation: _cancelReservation,
        onGoHome: _goToHome,
        canCancel: _canCancelReservation(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textDark,
        ),
      ),
      title: Text(
        '예약 내역 상세',
        style: AppTextTheme.headlineSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _showHelpDialog,
          icon: const Icon(
            Icons.help_outline,
            color: AppColors.primaryBlue500,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BookingProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        children: [
          // 예약 상태 배너
          ReservationStatusBanner(
            status: 'completed', // completed, pending, cancelled
          ),
          
          const SizedBox(height: 24),
          
          // 캠프 정보 카드
          CampInfoCard(
            campTitle: '영국 런던 영어 캠프',
            dateRange: '2025.12.08 ~ 2025.12.29',
            location: '런던, 영국',
            organizer: 'London English Center',
            onContactTap: _contactOrganizer,
            onImageTap: _viewCampDetail,
          ),
          
          const SizedBox(height: 24),
          
          // 예약 정보 섹션
          ReservationInfoSection(
            reservationNumber: 'EDCM-2025-1208-00042',
            participantName: '김민수',
            guardianName: '안진호',
            phone: '010-1234-5678',
            email: 'jinho@example.com',
            participantCount: 1,
            roomType: '2인실',
            pickupService: true,
            insurance: true,
          ),
          
          const SizedBox(height: 24),
          
          // 결제 정보 섹션
          PaymentInfoSection(
            paymentDate: '2025.12.08 14:32',
            paymentMethod: '신한카드 (****-1234)',
            totalAmount: 3300000,
            discountCode: 'SUMMER50',
            discountAmount: 50000,
            status: 'completed',
          ),
          
          const SizedBox(height: 24),
          
          // 정책 안내 섹션
          PolicyNoticeSection(
            onViewPolicy: _viewRefundPolicy,
          ),
          
          const SizedBox(height: 24),
          
          // 고객 지원 섹션
          CustomerSupportSection(
            onChatSupport: _openChatSupport,
            onViewFAQ: _viewFAQ,
          ),
          
          const SizedBox(height: 100), // 하단 버튼 공간
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('도움말'),
        content: const Text('예약 관련 문의사항이 있으시면 고객지원팀으로 연락해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _contactOrganizer() {
    // TODO: 기관 문의하기 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('기관 문의하기 기능을 준비 중입니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewCampDetail() {
    // TODO: 캠프 상세 페이지로 이동
    Navigator.pushNamed(context, '/camp-detail', arguments: 'camp-id');
  }

  void _viewRefundPolicy() {
    // TODO: 환불 정책 페이지로 이동
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('환불 정책'),
        content: const Text('출발일 30일 전까지 전액 환불 가능합니다.\n출발일 7일 전 이후 취소 시 환불 불가합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _openChatSupport() {
    // TODO: 1:1 채팅 문의 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('1:1 채팅 문의 기능을 준비 중입니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewFAQ() {
    // TODO: FAQ 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('FAQ 페이지를 준비 중입니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewReceipt() {
    // TODO: 영수증 보기 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('영수증 보기 기능을 준비 중입니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _cancelReservation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 취소'),
        content: const Text('정말로 예약을 취소하시겠습니까?\n취소 시 환불 정책에 따라 처리됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 예약 취소 API 호출
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('예약 취소 요청이 접수되었습니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('예, 취소합니다'),
          ),
        ],
      ),
    );
  }

  void _goToHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  bool _canCancelReservation() {
    // TODO: 실제 취소 가능 여부 로직 구현
    // 예: 출발일 7일 전까지 취소 가능
    return true;
  }
}
