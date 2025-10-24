import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../providers/booking_provider.dart';
import '../widgets/reservation_summary_card.dart';
import '../widgets/success_message_section.dart';
import '../widgets/action_buttons_section.dart';
import '../widgets/recommended_camps_section.dart';
import '../widgets/floating_share_banner.dart';

class ReservationConfirmationPage extends StatefulWidget {
  final String reservationId;
  final Map<String, dynamic> reservationData;

  const ReservationConfirmationPage({
    super.key,
    required this.reservationId,
    required this.reservationData,
  });

  @override
  State<ReservationConfirmationPage> createState() => _ReservationConfirmationPageState();
}

class _ReservationConfirmationPageState extends State<ReservationConfirmationPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _showShareBanner = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _showShareBannerAfterDelay();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _showShareBannerAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showShareBanner = true;
        });
      }
    });
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
      floatingActionButton: _showShareBanner
          ? FloatingShareBanner(
              onDismiss: () {
                setState(() {
                  _showShareBanner = false;
                });
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '예약 완료',
        style: AppTextTheme.headlineSmall.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _shareReservation,
          icon: const Icon(
            Icons.share,
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
          // 성공 메시지 섹션
          SuccessMessageSection(),
          
          const SizedBox(height: 32),
          
          // 예약 요약 카드
          ReservationSummaryCard(
            reservationData: widget.reservationData,
          ),
          
          const SizedBox(height: 32),
          
          // 액션 버튼 섹션
          ActionButtonsSection(
            onViewReservation: _viewReservationDetails,
            onGoHome: _goToHome,
          ),
          
          const SizedBox(height: 40),
          
          // 추천 캠프 섹션
          RecommendedCampsSection(),
          
          const SizedBox(height: 100), // 하단 네비게이션 공간
        ],
      ),
    );
  }

  void _shareReservation() {
    // TODO: 공유 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('예약 정보를 공유합니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewReservationDetails() {
    Navigator.pushNamed(context, '/reservation-detail', arguments: widget.reservationId);
  }

  void _goToHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
