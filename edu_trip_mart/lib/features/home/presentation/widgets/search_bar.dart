import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 검색바 위젯
/// 홈 화면에서 캠프 검색을 위한 검색바 컴포넌트
class SearchBar extends StatefulWidget {
  final String? hint;
  final String? initialValue;
  final String? initialText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool showFilterButton;
  final VoidCallback? onFilterTap;
  final int? filterCount;

  const SearchBar({
    super.key,
    this.hint,
    this.initialValue,
    this.initialText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.autofocus = false,
    this.showFilterButton = true,
    this.onFilterTap,
    this.filterCount,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? widget.initialText);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchField(context, isDark),
          ),
          if (widget.showFilterButton) ...[
            const SizedBox(width: AppDimensions.spacingS),
            _buildFilterButton(context, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDark) {
    return SearchTextField(
      controller: _controller,
      hintText: widget.hint ?? '캠프를 검색해보세요',
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
      },
      onClear: () {
        widget.onClear?.call();
      },
    );
  }

  Widget _buildFilterButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: widget.onFilterTap,
      child: Container(
        height: AppDimensions.searchBarHeight,
        width: AppDimensions.searchBarHeight,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.tune,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                size: 20,
              ),
            ),
            if (widget.filterCount != null && widget.filterCount! > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.primaryBlue300 : AppColors.primaryBlue500,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.filterCount}',
                      style: AppTextTheme.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 검색 히스토리 위젯
class SearchHistory extends StatelessWidget {
  final List<String> history;
  final Function(String)? onHistoryTap;
  final VoidCallback? onClearHistory;
  final bool isLoading;

  const SearchHistory({
    super.key,
    required this.history,
    this.onHistoryTap,
    this.onClearHistory,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingHistory();
    }

    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildHistoryList(context);
  }

  Widget _buildLoadingHistory() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          ...List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: Container(
                height: 16,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 검색어',
                style: AppTextTheme.titleMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              TextButton(
                onPressed: onClearHistory,
                child: Text(
                  '전체 삭제',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Wrap(
            spacing: AppDimensions.spacingS,
            runSpacing: AppDimensions.spacingS,
            children: history.map((query) {
              return _buildHistoryChip(context, query, isDark);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryChip(BuildContext context, String query, bool isDark) {
    return GestureDetector(
      onTap: () => onHistoryTap?.call(query),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.neutralGray100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 16,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: AppDimensions.spacingXS),
            Text(
              query,
              style: AppTextTheme.bodySmall.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
