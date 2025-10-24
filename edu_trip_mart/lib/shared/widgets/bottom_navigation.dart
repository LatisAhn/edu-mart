import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_theme.dart';

/// 하단 네비게이션 바
/// 앱의 주요 화면으로 이동할 수 있는 하단 네비게이션
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '홈',
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: '검색',
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.book_online_outlined,
                activeIcon: Icons.book_online,
                label: '예약',
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '마이페이지',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryBlue500.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected 
                  ? AppColors.primaryBlue500 
                  : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: AppTextTheme.caption.copyWith(
                  color: isSelected 
                      ? AppColors.primaryBlue500 
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 네비게이션 아이템 데이터 클래스
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

/// 네비게이션 상수
class NavigationConstants {
  static const List<NavigationItem> items = [
    NavigationItem(
      label: '홈',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/home',
    ),
    NavigationItem(
      label: '검색',
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      route: '/search',
    ),
    NavigationItem(
      label: '예약',
      icon: Icons.book_online_outlined,
      activeIcon: Icons.book_online,
      route: '/bookings',
    ),
    NavigationItem(
      label: '마이페이지',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      route: '/profile',
    ),
  ];

  static const int homeIndex = 0;
  static const int searchIndex = 1;
  static const int bookingIndex = 2;
  static const int profileIndex = 3;
}

