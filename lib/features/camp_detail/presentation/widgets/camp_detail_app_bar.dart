import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 캠프 상세 페이지 앱바 위젯
/// 뒤로가기, 제목, 공유/찜하기 버튼을 포함
class CampDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSharePressed;
  final VoidCallback? onWishlistPressed;
  final bool isWishlisted;

  const CampDetailAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.onSharePressed,
    this.onWishlistPressed,
    this.isWishlisted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? AppColors.textLight : AppColors.textDark,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
      title: title != null
          ? Text(
              title!,
              style: AppTextTheme.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.share,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
          onPressed: onSharePressed,
        ),
        IconButton(
          icon: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: isWishlisted
                ? AppColors.error
                : (isDark ? AppColors.textLight : AppColors.textDark),
          ),
          onPressed: onWishlistPressed,
        ),
        const SizedBox(width: AppDimensions.spacingXS),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
