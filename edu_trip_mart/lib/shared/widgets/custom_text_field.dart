import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// 커스텀 텍스트 필드 위젯
class CustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final Color? fillColor;
  final bool filled;
  final double? borderRadius;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? helperStyle;
  final TextStyle? errorStyle;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.contentPadding,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.fillColor,
    this.filled = false,
    this.borderRadius,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.helperStyle,
    this.errorStyle,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  // bool _isFocused = false; // 사용되지 않는 필드

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    // _focusNode.addListener(_onFocusChange); // 사용되지 않는 리스너
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  // void _onFocusChange() { // 사용되지 않는 메서드
  //   setState(() {
  //     _isFocused = _focusNode.hasFocus;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final borderRadius = widget.borderRadius ?? AppDimensions.radiusM;
    final contentPadding = widget.contentPadding ?? 
        const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        );

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      style: widget.textStyle ?? TextStyle(
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        contentPadding: contentPadding,
        filled: true, // 항상 배경색 적용
        fillColor: widget.fillColor ?? 
            (isDark ? Color(0xFF1E1E1E) : Colors.white),
        border: widget.border ?? _buildBorder(borderRadius, isDark),
        enabledBorder: widget.enabledBorder ?? _buildBorder(borderRadius, isDark),
        focusedBorder: widget.focusedBorder ?? _buildFocusedBorder(borderRadius, isDark),
        errorBorder: widget.errorBorder ?? _buildErrorBorder(borderRadius),
        focusedErrorBorder: widget.focusedErrorBorder ?? _buildErrorBorder(borderRadius),
        hintStyle: widget.hintStyle ?? TextStyle(
          fontSize: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.normal,
        ),
        labelStyle: widget.labelStyle ?? TextStyle(
          fontSize: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.normal,
        ),
        helperStyle: widget.helperStyle ?? TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.normal,
        ),
        errorStyle: widget.errorStyle ?? TextStyle(
          fontSize: 12,
          color: Colors.red,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  InputBorder _buildBorder(double borderRadius, bool isDark) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: isDark ? AppColors.neutralGray600 : AppColors.neutralGray300,
        width: 1.0,
      ),
    );
  }

  InputBorder _buildFocusedBorder(double borderRadius, bool isDark) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 2.0,
      ),
    );
  }

  InputBorder _buildErrorBorder(double borderRadius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: AppColors.error,
        width: 1.0,
      ),
    );
  }
}

/// 검색 텍스트 필드
class SearchTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onSearch;
  final bool showClearButton;
  final bool showSearchButton;
  final Widget? prefixIcon;
  final FocusNode? focusNode;

  const SearchTextField({
    super.key,
    this.hintText = '검색어를 입력하세요',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onSearch,
    this.showClearButton = true,
    this.showSearchButton = false,
    this.prefixIcon,
    this.focusNode,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomTextField(
      controller: _controller,
      focusNode: _focusNode,
      hintText: widget.hintText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      prefixIcon: widget.prefixIcon ?? Icon(
        Icons.search,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
      suffixIcon: _controller.text.isNotEmpty && widget.showClearButton
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onPressed: _onClear,
            )
          : widget.showSearchButton
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  onPressed: widget.onSearch,
                )
              : null,
      textInputAction: TextInputAction.search,
    );
  }
}