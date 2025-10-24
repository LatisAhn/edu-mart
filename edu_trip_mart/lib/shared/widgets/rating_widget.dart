import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// 별점 표시 및 입력 위젯
class RatingWidget extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? filledColor;
  final Color? emptyColor;
  final bool showRating;
  final bool readOnly;
  final ValueChanged<double>? onRatingChanged;
  final MainAxisAlignment alignment;

  const RatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = AppDimensions.ratingSize,
    this.filledColor,
    this.emptyColor,
    this.showRating = true,
    this.readOnly = true,
    this.onRatingChanged,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final filled = filledColor ?? AppColors.ratingFilled;
    final empty = emptyColor ?? AppColors.ratingEmpty;

    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          final starRating = index + 1;
          final isFilled = starRating <= rating;
          final isHalfFilled = starRating - 0.5 <= rating && rating < starRating;

          return GestureDetector(
            onTap: readOnly ? null : () => onRatingChanged?.call(starRating.toDouble()),
            child: Container(
              margin: EdgeInsets.only(
                right: index < maxRating - 1 ? AppDimensions.ratingSpacing : 0,
              ),
              child: Icon(
                isHalfFilled
                    ? Icons.star_half
                    : isFilled
                        ? Icons.star
                        : Icons.star_border,
                color: isFilled || isHalfFilled ? filled : empty,
                size: size,
              ),
            ),
          );
        }),
        if (showRating) ...[
          const SizedBox(width: AppDimensions.spacingS),
          Text(
              rating.toStringAsFixed(1),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ],
    );
  }
}

/// 별점 표시만 하는 위젯 (읽기 전용)
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? filledColor;
  final Color? emptyColor;
  final bool showRating;
  final MainAxisAlignment alignment;

  const RatingDisplay({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = AppDimensions.ratingSize,
    this.filledColor,
    this.emptyColor,
    this.showRating = true,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return RatingWidget(
      rating: rating,
      maxRating: maxRating,
      size: size,
      filledColor: filledColor,
      emptyColor: emptyColor,
      showRating: showRating,
      readOnly: true,
      alignment: alignment,
    );
  }
}

/// 별점 입력 위젯
class RatingInput extends StatefulWidget {
  final double initialRating;
  final int maxRating;
  final double size;
  final Color? filledColor;
  final Color? emptyColor;
  final bool showRating;
  final ValueChanged<double>? onRatingChanged;
  final MainAxisAlignment alignment;

  const RatingInput({
    super.key,
    this.initialRating = 0.0,
    this.maxRating = 5,
    this.size = AppDimensions.ratingSize,
    this.filledColor,
    this.emptyColor,
    this.showRating = true,
    this.onRatingChanged,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  State<RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return RatingWidget(
      rating: _currentRating,
      maxRating: widget.maxRating,
      size: widget.size,
      filledColor: widget.filledColor,
      emptyColor: widget.emptyColor,
      showRating: widget.showRating,
      readOnly: false,
      onRatingChanged: (rating) {
        setState(() {
          _currentRating = rating;
        });
        widget.onRatingChanged?.call(rating);
      },
      alignment: widget.alignment,
    );
  }
}