import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../widgets/success_illustration_section.dart';
import '../widgets/reward_info_card.dart';
import '../widgets/next_action_section.dart';
import '../widgets/progress_summary_section.dart';
import '../widgets/recommended_content_section.dart';

/// 후기 제출 완료 페이지
/// 후기 등록 성공 후 사용자를 안내하는 화면
class ReviewSuccessPage extends StatefulWidget {
  final String campId;
  final String campName;
  final String campImageUrl;
  final int pointsEarned;

  const ReviewSuccessPage({
    super.key,
    required this.campId,
    required this.campName,
    required this.campImageUrl,
    this.pointsEarned = 3000,
  });

  @override
  State<ReviewSuccessPage> createState() => _ReviewSuccessPageState();
}

class _ReviewSuccessPageState extends State<ReviewSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    // 애니메이션 시작
    _confettiController.forward();
    _slideController.forward();

    // 토스트 알림 표시
    _showToastNotification();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showToastNotification() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.stars, color: Colors.white),
                const SizedBox(width: 8),
                Text('${widget.pointsEarned}P가 적립되었습니다 🎉'),
              ],
            ),
            backgroundColor: AppColors.successGreen,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 성공 일러스트레이션 섹션
            SuccessIllustrationSection(
              confettiController: _confettiController,
              slideAnimation: _slideAnimation,
              fadeAnimation: _fadeAnimation,
            ),
            
            const SizedBox(height: 24),
            
            // 포인트 적립 정보 카드
            RewardInfoCard(
              pointsEarned: widget.pointsEarned,
              slideAnimation: _slideAnimation,
              fadeAnimation: _fadeAnimation,
            ),
            
            const SizedBox(height: 32),
            
            // 다음 액션 섹션
            NextActionSection(
              slideAnimation: _slideAnimation,
              fadeAnimation: _fadeAnimation,
              onGoHome: _onGoHome,
              onViewCommunity: _onViewCommunity,
              onExploreCamps: _onExploreCamps,
            ),
            
            const SizedBox(height: 32),
            
            // 진행 상황 요약 섹션
            ProgressSummarySection(
              slideAnimation: _slideAnimation,
              fadeAnimation: _fadeAnimation,
              onViewMyCamps: _onViewMyCamps,
            ),
            
            const SizedBox(height: 32),
            
            // 추천 콘텐츠 섹션
            RecommendedContentSection(
              campId: widget.campId,
              slideAnimation: _slideAnimation,
              fadeAnimation: _fadeAnimation,
              onCampTap: _onCampTap,
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
      elevation: 0,
      title: Text(
        '후기 등록 완료',
        style: AppTextTheme.headlineSmall.copyWith(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          color: isDark ? Colors.white : Colors.black,
          onPressed: _onGoHome,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _onGoHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  void _onViewCommunity() {
    // TODO: 커뮤니티 피드로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('커뮤니티 후기 보기 페이지로 이동합니다')),
    );
  }

  void _onExploreCamps() {
    // TODO: 캠프 탐색 페이지로 이동
    Navigator.pushNamed(context, '/search');
  }

  void _onViewMyCamps() {
    Navigator.pushNamed(context, '/my-page');
  }

  void _onCampTap(String campId) {
    Navigator.pushNamed(context, '/camp-detail', arguments: campId);
  }
}
