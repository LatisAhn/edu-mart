import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/animated_fade_in.dart';
import '../providers/profile_provider.dart';

/// 마이페이지
/// 사용자 프로필, 예약 내역, 후기 관리 등을 제공하는 메인 페이지
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동
            },
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
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

  Widget _buildContent(ProfileProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(provider),
          const SizedBox(height: 24),
          _buildStatsSection(provider),
          const SizedBox(height: 24),
          _buildMenuSection(),
          const SizedBox(height: 24),
          _buildRecentBookings(provider),
          const SizedBox(height: 24),
          _buildRecentReviews(provider),
          const SizedBox(height: 100), // 하단 네비게이션 공간 확보
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileProvider provider) {
    return AnimatedFadeIn(
      child: Container(
        margin: const EdgeInsets.all(AppDimensions.screenPadding),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue500,
              AppColors.primaryBlue600,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue500.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: provider.userProfile?.profileImageUrl != null
                  ? ClipOval(
                      child: Image.network(
                        provider.userProfile!.profileImageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.primaryBlue500,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primaryBlue500,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              provider.userProfile?.name ?? '사용자',
              style: AppTextTheme.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.userProfile?.email ?? 'user@example.com',
              style: AppTextTheme.bodyLarge.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('예약', '${provider.bookingCount}'),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildStatItem('후기', '${provider.reviewCount}'),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildStatItem('포인트', '${provider.points}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextTheme.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextTheme.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(ProfileProvider provider) {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '총 예약',
                '${provider.bookingCount}',
                Icons.book_online,
                AppColors.primaryBlue500,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '완료된 캠프',
                '${provider.completedCamps}',
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '포인트',
                '${provider.points}P',
                Icons.stars,
                AppColors.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextTheme.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '메뉴',
              style: AppTextTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menuItems = [
      _MenuItem('예약 내역', Icons.book_online, AppColors.primaryBlue500, '/bookings'),
      _MenuItem('후기 관리', Icons.rate_review, AppColors.secondaryCoral400, '/reviews'),
      _MenuItem('즐겨찾기', Icons.favorite, AppColors.error, '/favorites'),
      _MenuItem('알림', Icons.notifications, AppColors.warning, '/notifications'),
      _MenuItem('고객센터', Icons.support_agent, AppColors.textSecondary, '/support'),
      _MenuItem('설정', Icons.settings, AppColors.textSecondary, '/settings'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return GestureDetector(
      onTap: () {
        // 메뉴 아이템 클릭 처리
        if (item.route != null) {
          Navigator.pushNamed(context, item.route!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: item.color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: AppTextTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookings(ProfileProvider provider) {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 예약',
                  style: AppTextTheme.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/bookings');
                  },
                  child: Text(
                    '전체보기',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.primaryBlue500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (provider.recentBookings.isEmpty)
              _buildEmptyState('예약 내역이 없습니다', Icons.book_online)
            else
              ...provider.recentBookings.take(3).map((booking) => 
                _buildBookingItem(booking)
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentReviews(ProfileProvider provider) {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 후기',
                  style: AppTextTheme.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reviews');
                  },
                  child: Text(
                    '전체보기',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.primaryBlue500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (provider.recentReviews.isEmpty)
              _buildEmptyState('작성한 후기가 없습니다', Icons.rate_review)
            else
              ...provider.recentReviews.take(2).map((review) => 
                _buildReviewItem(review)
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem(dynamic booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              booking.camp?.imageUrls?.isNotEmpty == true 
                  ? booking.camp.imageUrls.first 
                  : '',
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
                  booking.camp?.title ?? '캠프명',
                  style: AppTextTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.camp?.city}, ${booking.camp?.country}',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking.startDate?.year}.${booking.startDate?.month.toString().padLeft(2, '0')}.${booking.startDate?.day.toString().padLeft(2, '0')}',
                  style: AppTextTheme.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getStatusText(booking.status),
              style: AppTextTheme.caption.copyWith(
                color: _getStatusColor(booking.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.title ?? '후기 제목',
                  style: AppTextTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${review.rating?.toStringAsFixed(1) ?? '0.0'}★',
                style: AppTextTheme.bodyMedium.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.content ?? '후기 내용',
            style: AppTextTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '${review.createdAt?.year}.${review.createdAt?.month.toString().padLeft(2, '0')}.${review.createdAt?.day.toString().padLeft(2, '0')}',
            style: AppTextTheme.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextTheme.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return '확정';
      case 'pending':
        return '대기';
      case 'cancelled':
        return '취소';
      default:
        return status;
    }
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final String? route;

  _MenuItem(this.title, this.icon, this.color, this.route);
}

