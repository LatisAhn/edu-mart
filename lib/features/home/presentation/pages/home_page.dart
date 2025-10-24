import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/camp_entity.dart';
import '../../domain/entities/camp_category_entity.dart';
import '../widgets/camp_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/camp_list_view.dart';
import '../widgets/promotion_banner.dart';
import '../providers/home_provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/animated_fade_in.dart';

/// 홈 화면 페이지
/// Wireframe에 따라 구성된 메인 화면
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // 홈 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<HomeProvider>().loadHomeData(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroBanner(context),
                      _buildRecommendedSection(context),
                      const SizedBox(height: 200), // AI 추천 캠프와 국가별 캠프 사이 간격
                      _buildCategorySection(context),
                      _buildCampListSection(context),
                      _buildPromotionBanner(context),
                      const SizedBox(height: 100), // 하단 네비게이션 공간
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Header (Top Navigation Bar)
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          GestureDetector(
            onTap: () {
              // 홈으로 스크롤
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue500,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Edu Trip Market',
                  style: AppTextTheme.titleLarge.copyWith(
                    color: isDark ? AppColors.backgroundWhite : AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Search Bar
          Expanded(
            flex: 2,
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '캠프 검색 (예: 필리핀 여름 캠프)',
                  hintStyle: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onTap: () {
                  // 검색 화면으로 이동
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ),
          ),
          // Notification Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                    size: 20,
                  ),
                ),
                // Notification Badge
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Hero Banner Section
  Widget _buildHeroBanner(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingFeaturedCamps && provider.featuredCamps.isEmpty) {
          return _buildHeroBannerLoading();
        }
        
        if (provider.featuredCamps.isEmpty) {
          return const SizedBox.shrink();
        }

        return AnimatedFadeIn(
          child: HeroBanner(
            camps: provider.featuredCamps,
            onCampTap: (camp) {
              // 캠프 상세 페이지로 이동
              Navigator.pushNamed(
                context,
                '/camp-detail',
                arguments: camp.id,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeroBannerLoading() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// 3. Recommended / Category Section
  Widget _buildRecommendedSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular Camps
            if (provider.popularCamps.isNotEmpty)
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 100),
                child: _buildSectionHeader(
                  '인기 캠프',
                  '지금 가장 인기 있는 캠프들을 확인해보세요',
                  () {
                    // 인기 캠프 전체 보기
                  },
                ),
              ),
            if (provider.popularCamps.isNotEmpty)
              _buildHorizontalCampList(provider.popularCamps),
            
            const SizedBox(height: 120),
            
            // AI Recommendation
            if (provider.featuredCamps.isNotEmpty)
              AnimatedFadeIn(
                delay: const Duration(milliseconds: 200),
                child: _buildSectionHeader(
                  'AI 추천 캠프',
                  '당신을 위한 맞춤 추천 캠프',
                  () {
                    // AI 추천 전체 보기
                  },
                ),
              ),
            if (provider.featuredCamps.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildHorizontalCampList(provider.featuredCamps),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, VoidCallback? onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextTheme.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                '전체보기',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.primaryBlue500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCampList(List<CampEntity> camps) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: AppDimensions.spacingM,
        ),
        itemCount: camps.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingM),
            child: SizedBox(
              width: 200,
              child: CampCard(
                camp: camps[index],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/camp-detail',
                    arguments: camps[index].id,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// 4. Country Category Grid
  Widget _buildCategorySection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingCategories && provider.categories.isEmpty) {
          return _buildCategoryLoading();
        }

        return AnimatedFadeIn(
          delay: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '국가별 캠프',
                  style: AppTextTheme.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    return _buildCategoryCard(category);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(CampCategoryEntity category) {
    return GestureDetector(
      onTap: () {
        // 카테고리별 캠프 목록으로 이동
        Navigator.pushNamed(
          context,
          '/search',
          arguments: {'category': category.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.place,
                color: Colors.white,
                size: 20,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: AppTextTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${category.campCount}개 캠프',
                    style: AppTextTheme.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 5. Camp List Preview Section
  Widget _buildCampListSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingAllCamps && provider.allCamps.isEmpty) {
          return _buildCampListLoading();
        }

        if (provider.allCamps.isEmpty) {
          return const SizedBox.shrink();
        }

        return AnimatedFadeIn(
          delay: const Duration(milliseconds: 400),
          child: CampListView(
            title: '모든 캠프',
            camps: provider.allCamps,
            onSeeAll: () {
              // 모든 캠프 전체 보기
            },
          ),
        );
      },
    );
  }

  Widget _buildCampListLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(3, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )),
        ],
      ),
    );
  }

  /// 6. Event / Promotion Banner
  Widget _buildPromotionBanner(BuildContext context) {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: PromotionBanner(
          title: '🎁 지금 예약하면 10% 할인!',
          subtitle: '얼리버드 특가로 더 저렴하게',
          onTap: () {
            // 프로모션 상세 페이지로 이동
          },
        ),
      ),
    );
  }
}