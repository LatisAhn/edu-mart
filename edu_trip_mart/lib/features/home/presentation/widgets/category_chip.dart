import 'package:flutter/material.dart';
import '../../domain/entities/camp_category_entity.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 카테고리 칩 위젯
/// 홈 화면에서 카테고리 필터를 표시하는 칩 컴포넌트
class CategoryChip extends StatelessWidget {
  final CampCategoryEntity category;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isLoading;

        const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingChip();
    }

    return _buildCategoryChip(context);
  }

  Widget _buildLoadingChip() {
    return Container(
      height: AppDimensions.chipHeight,
      width: 100,
      margin: const EdgeInsets.only(right: AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppDimensions.chipHeight,
        margin: const EdgeInsets.only(right: AppDimensions.spacingS),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.chipPadding,
          vertical: AppDimensions.spacingXS,
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          border: isSelected ? Border.all(
            color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
            width: 1.5,
          ) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (category.iconUrl.isNotEmpty) ...[
              _buildIcon(context, isDark),
              const SizedBox(width: AppDimensions.spacingXS),
            ],
            Text(
              category.name,
              style: _getTextStyle(isDark),
            ),
            if (category.campCount > 0) ...[
              const SizedBox(width: AppDimensions.spacingXS),
              _buildCountBadge(context, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, bool isDark) {
    // TODO: 실제 아이콘 URL을 사용하여 이미지를 로드
    // 현재는 기본 아이콘을 사용
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isSelected 
            ? (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500)
            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getCategoryIcon(),
        size: 10,
        color: Colors.white,
      ),
    );
  }

  IconData _getCategoryIcon() {
    // 카테고리 이름에 따라 적절한 아이콘 반환
    final name = category.name.toLowerCase();
    if (name.contains('어학')) return Icons.school;
    if (name.contains('스포츠')) return Icons.sports_soccer;
    if (name.contains('문화')) return Icons.museum;
    if (name.contains('여행')) return Icons.travel_explore;
    if (name.contains('캠프')) return Icons.place;
    if (name.contains('체험')) return Icons.explore;
    return Icons.category;
  }

  Widget _buildCountBadge(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isSelected 
            ? (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500)
            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        '${category.campCount}',
        style: AppTextTheme.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    if (isSelected) {
      return isDark ? AppColors.primaryBlue300.withOpacity(0.2) : AppColors.primaryBlue500.withOpacity(0.1);
    }
    return isDark ? AppColors.surfaceDark : AppColors.neutralGray100;
  }

  TextStyle _getTextStyle(bool isDark) {
    return AppTextTheme.bodyMedium.copyWith(
      color: isSelected 
          ? (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500)
          : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
    );
  }
}

/// 카테고리 리스트 위젯
class CategoryList extends StatelessWidget {
  final List<CampCategoryEntity> categories;
  final String? selectedCategoryId;
  final Function(String)? onCategorySelected;
  final bool isLoading;

  const CategoryList({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.onCategorySelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingList();
    }

    return _buildCategoryList(context);
  }

  Widget _buildLoadingList() {
    return SizedBox(
      height: AppDimensions.chipHeight + AppDimensions.spacingM,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        itemCount: 6,
        itemBuilder: (context, index) {
          return CategoryChip(
            category: CampCategoryEntity(
              id: '',
              name: '',
              description: '',
              iconUrl: '',
              color: '',
              sortOrder: 0,
              isActive: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              campCount: 0,
            ),
            isLoading: true,
          );
        },
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return SizedBox(
      height: AppDimensions.chipHeight + AppDimensions.spacingM,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;
          
          return CategoryChip(
            category: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected?.call(category.id),
          );
        },
      ),
    );
  }
}
