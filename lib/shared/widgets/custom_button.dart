import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_theme.dart';

/// 커스텀 버튼 컴포넌트
/// Primary, Secondary, Text 버튼을 통합 관리
enum CustomButtonType {
  primary,
  secondary,
  text,
  outlined,
}

enum CustomButtonSize {
  small,
  medium,
  large,
}

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final CustomButtonSize size;
  final ButtonVariant? variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.size = CustomButtonSize.medium,
    this.variant,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? _getButtonHeight(),
      child: _buildButton(context, isDark),
    );
  }

  Widget _buildButton(BuildContext context, bool isDark) {
    if (isLoading) {
      return _buildLoadingButton(context, isDark);
    }

    // variant가 있으면 variant를 우선 사용
    if (variant != null) {
      switch (variant!) {
        case ButtonVariant.primary:
          return _buildPrimaryButton(context, isDark);
        case ButtonVariant.secondary:
          return _buildSecondaryButton(context, isDark);
        case ButtonVariant.outline:
          return _buildOutlinedButton(context, isDark);
        case ButtonVariant.text:
          return _buildTextButton(context, isDark);
      }
    }

    // variant가 없으면 기존 type 사용
    switch (type) {
      case CustomButtonType.primary:
        return _buildPrimaryButton(context, isDark);
      case CustomButtonType.secondary:
        return _buildSecondaryButton(context, isDark);
      case CustomButtonType.text:
        return _buildTextButton(context, isDark);
      case CustomButtonType.outlined:
        return _buildOutlinedButton(context, isDark);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDark) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? 
            (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500),
        foregroundColor: textColor ?? Colors.white,
        elevation: AppDimensions.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        padding: _getButtonPadding(),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isDark) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? 
            (isDark ? AppColors.surfaceDark : AppColors.neutralGray100),
        foregroundColor: textColor ?? 
            (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        padding: _getButtonPadding(),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDark) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? 
            (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        padding: _getButtonPadding(),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isDark) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? 
            (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500),
        side: BorderSide(
          color: borderColor ?? 
              (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        padding: _getButtonPadding(),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildLoadingButton(BuildContext context, bool isDark) {
    final color = _getLoadingColor(isDark);
    
    return Container(
      decoration: BoxDecoration(
        color: _getLoadingBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: type == CustomButtonType.outlined ? Border.all(
          color: borderColor ?? 
              (isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500),
        ) : null,
      ),
      child: Center(
        child: SizedBox(
          width: _getLoadingSize(),
          height: _getLoadingSize(),
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          SizedBox(width: AppDimensions.spacingXS),
          Text(
            text,
            style: _getTextStyle(),
          ),
        ],
      );
    }
    
    return Text(
      text,
      style: _getTextStyle(),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case CustomButtonSize.small:
        return AppDimensions.buttonHeightSmall;
      case CustomButtonSize.medium:
        return AppDimensions.buttonHeight;
      case CustomButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingXS,
        );
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.buttonPaddingHorizontal,
          vertical: AppDimensions.buttonPaddingVertical,
        );
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingXXL,
          vertical: AppDimensions.spacingL,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case CustomButtonSize.small:
        return AppTextTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        );
      case CustomButtonSize.medium:
        return AppTextTheme.labelLarge;
      case CustomButtonSize.large:
        return AppTextTheme.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case CustomButtonSize.small:
        return AppDimensions.iconSizeS;
      case CustomButtonSize.medium:
        return AppDimensions.iconSizeM;
      case CustomButtonSize.large:
        return AppDimensions.iconSizeL;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case CustomButtonSize.small:
        return AppDimensions.loadingIndicatorSizeSmall;
      case CustomButtonSize.medium:
        return AppDimensions.loadingIndicatorSize;
      case CustomButtonSize.large:
        return AppDimensions.loadingIndicatorSizeLarge;
    }
  }

  Color _getLoadingColor(bool isDark) {
    switch (type) {
      case CustomButtonType.primary:
        return Colors.white;
      case CustomButtonType.secondary:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
      case CustomButtonType.text:
      case CustomButtonType.outlined:
        return isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500;
    }
  }

  Color _getLoadingBackgroundColor(bool isDark) {
    switch (type) {
      case CustomButtonType.primary:
        return isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500;
      case CustomButtonType.secondary:
        return isDark ? AppColors.surfaceDark : AppColors.neutralGray100;
      case CustomButtonType.text:
        return Colors.transparent;
      case CustomButtonType.outlined:
        return Colors.transparent;
    }
  }
}
