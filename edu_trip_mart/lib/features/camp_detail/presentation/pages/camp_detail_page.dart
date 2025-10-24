import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/domain/entities/camp_entity.dart';
import '../providers/camp_detail_provider.dart';
import '../widgets/image_carousel.dart';
import '../widgets/camp_summary_section.dart';
import '../widgets/tab_section.dart';
import '../widgets/tab_content_section.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';

/// 캠프 상세 페이지
/// 캠프의 상세 정보, 이미지, 일정, 시설, 리뷰를 표시
class CampDetailPage extends StatefulWidget {
  final String campId;

  const CampDetailPage({
    super.key,
    required this.campId,
  });

  @override
  State<CampDetailPage> createState() => _CampDetailPageState();
}

class _CampDetailPageState extends State<CampDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CampDetailProvider>().loadCampDetail(widget.campId);
      context.read<CampDetailProvider>().loadCampReviews(widget.campId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
            onPressed: () => _navigateToHome(),
          ),
        ],
      ),
      body: Consumer<CampDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.error != null) {
            return _buildErrorState(provider.error!);
          }

          final camp = provider.camp;
          if (camp == null) {
            return _buildErrorState('캠프 정보를 찾을 수 없습니다.');
          }

          return Column(
            children: [
              // Image Carousel
              ImageCarousel(
                images: camp.imageUrls,
                onImageTap: (index) {
                  // TODO: 전체화면 이미지 뷰어 열기
                },
              ),

              // Camp Summary Section
              CampSummarySection(
                camp: camp,
                onWishlistTap: () => _toggleWishlist(camp),
                onReserveTap: () => _navigateToReservation(camp),
              ),

              // Tab Section
              TabSection(
                tabController: _tabController,
                onTabChanged: (index) {
                  // Tab changed
                },
              ),

              // Tab Content
              Expanded(
                child: TabContentSection(
                  camp: camp,
                  reviews: provider.reviews,
                  isLoadingReviews: provider.isLoadingReviews,
                  tabController: _tabController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Text(
            error,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          ElevatedButton(
            onPressed: () {
              context.read<CampDetailProvider>().loadCampDetail(widget.campId);
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  void _toggleWishlist(CampEntity camp) {
    // TODO: 찜하기 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${camp.title}을(를) 찜 목록에 추가했습니다.'),
      ),
    );
  }

  void _navigateToReservation(CampEntity camp) {
    Navigator.pushNamed(
      context,
      '/booking',
      arguments: camp.id,
    );
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

}
