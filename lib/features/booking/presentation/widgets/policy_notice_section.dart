import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/theme/app_dimensions.dart';

class PolicyNoticeSection extends StatefulWidget {
  final VoidCallback onViewPolicy;

  const PolicyNoticeSection({
    super.key,
    required this.onViewPolicy,
  });

  @override
  State<PolicyNoticeSection> createState() => _PolicyNoticeSectionState();
}

class _PolicyNoticeSectionState extends State<PolicyNoticeSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            '취소 및 환불 안내',
            style: AppTextTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 정책 내용
          Text(
            '출발일 30일 전까지 전액 환불 가능합니다.',
            style: AppTextTheme.bodyMedium.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textDark,
              height: 1.5,
            ),
          ),
          
          if (_isExpanded) ...[
            const SizedBox(height: 8),
            Text(
              '출발일 7일 전 이후 취소 시 환불 불가합니다.',
              style: AppTextTheme.bodyMedium.copyWith(
                color: isDark ? AppColors.textLight : AppColors.textDark,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '취소 시 수수료가 발생할 수 있습니다.',
              style: AppTextTheme.bodyMedium.copyWith(
                color: isDark ? AppColors.textLight : AppColors.textDark,
                height: 1.5,
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          // 더보기/접기 버튼
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? '접기' : '더보기',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.primaryBlue500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 상세 정책 보기 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onViewPolicy,
              icon: const Icon(Icons.description, size: 18),
              label: const Text('상세 정책 보기'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue500,
                side: const BorderSide(color: AppColors.primaryBlue500),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
