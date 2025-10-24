import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';

/// 캠프 요약 카드 위젯
/// 선택된 캠프의 기본 정보를 표시하고 편집 가능
class CampSummaryCard extends StatelessWidget {
  final dynamic camp;
  final VoidCallback? onEditTap;

  const CampSummaryCard({
    super.key,
    required this.camp,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.screenPadding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
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
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '예약 상품',
                style: AppTextTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onEditTap,
                child: Text(
                  '변경',
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.primaryBlue500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 캠프 정보
          Row(
            children: [
              // 썸네일 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  camp.imageUrls.isNotEmpty ? camp.imageUrls.first : '',
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 60,
                      color: AppColors.primaryBlue300,
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 캠프 상세 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      camp.title,
                      style: AppTextTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(camp.startDate)} ~ ${_formatDate(camp.endDate)}',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${camp.duration}일 • ${camp.minAge}-${camp.maxAge}세',
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 가격 정보
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${camp.currency} ${_formatPrice(camp.price)}',
                    style: AppTextTheme.titleLarge.copyWith(
                      color: AppColors.primaryBlue500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '1인 기준',
                    style: AppTextTheme.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return price.toStringAsFixed(0);
    }
  }
}
