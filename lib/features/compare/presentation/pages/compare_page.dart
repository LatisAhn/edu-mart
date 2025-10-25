import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/camp_compare_entity.dart';
import '../providers/compare_provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: _buildAppBar(context),
      body: Consumer<CompareProvider>(
        builder: (context, compareProvider, child) {
          if (compareProvider.isEmpty) {
            return _buildEmptyState(context);
          }
          
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: _buildCampCards(context, compareProvider.compareList),
              ),
              Expanded(
                flex: 3,
                child: _buildCompareTable(context, compareProvider.compareList),
              ),
              _buildBottomButton(context, compareProvider.compareList),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '비교함',
        style: AppTextTheme.headlineMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryLight,
        ),
      ),
      actions: [
        Consumer<CompareProvider>(
          builder: (context, compareProvider, child) {
            if (compareProvider.isEmpty) return const SizedBox.shrink();
            
            return TextButton.icon(
              onPressed: () {
                _showClearAllDialog(context);
              },
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              label: Text(
                '비우기',
                style: AppTextTheme.bodyMedium.copyWith(color: AppColors.error),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compare_arrows,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Text(
            '비교할 캠프가 없습니다',
            style: AppTextTheme.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            '관심 있는 캠프를 추가해서\n비교해보세요',
            textAlign: TextAlign.center,
            style: AppTextTheme.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          ElevatedButton.icon(
            onPressed: () {
              // 홈으로 이동
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
            label: const Text('홈으로 이동'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue500,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampCards(BuildContext context, List<CampCompareEntity> camps) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '비교할 캠프 (${camps.length}/3)',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3, // 최대 3개 슬롯
              itemBuilder: (context, index) {
                if (index < camps.length) {
                  return _buildCampCard(context, camps[index]);
                } else {
                  return _buildEmptySlot(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampCard(BuildContext context, CampCompareEntity camp) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
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
          // 썸네일 이미지
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusL),
            ),
            child: Image.network(
              camp.thumbnailUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: AppColors.backgroundLight,
                  child: const Icon(
                    Icons.image,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          // 캠프 정보
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  camp.name,
                  style: AppTextTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  camp.location,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  camp.duration,
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₩${_formatPrice(camp.price)}',
                      style: AppTextTheme.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue500,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          camp.rating.toString(),
                          style: AppTextTheme.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // 상세보기
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${camp.name} 상세보기 (구현 예정)')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryBlue500),
                          foregroundColor: AppColors.primaryBlue500,
                        ),
                        child: const Text('상세보기'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    IconButton(
                      onPressed: () {
                        context.read<CompareProvider>().removeFromCompare(camp.campId);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySlot(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.borderLight,
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 40,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppDimensions.spacingS),
            Text(
              '캠프 추가',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareTable(BuildContext context, List<CampCompareEntity> camps) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '상세 비교',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                  color: AppColors.borderLight,
                  width: 1,
                ),
                children: [
                  _buildTableHeader(camps),
                  _buildTableRow('위치', camps.map((c) => c.location).toList()),
                  _buildTableRow('기간', camps.map((c) => c.duration).toList()),
                  _buildTableRow('인원 제한', camps.map((c) => '${c.maxParticipants}명').toList()),
                  _buildTableRow('포함 사항', camps.map((c) => c.includedItems.join(', ')).toList()),
                  _buildTableRow('후기 평점', camps.map((c) => '⭐${c.rating}').toList()),
                  _buildTableRow('가격', camps.map((c) => '₩${_formatPrice(c.price)}').toList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader(List<CampCompareEntity> camps) {
    return TableRow(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Text(
            '항목',
            style: AppTextTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
        ...camps.map((camp) => Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Text(
            camp.name,
            style: AppTextTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ],
    );
  }

  TableRow _buildTableRow(String label, List<String> values) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Text(
            label,
            style: AppTextTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
        ...values.map((value) => Container(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Text(
            value,
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        )),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, List<CampCompareEntity> camps) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: camps.isNotEmpty ? () {
            _showReservationDialog(context, camps);
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue500,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingL,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          child: Text(
            '캠프 선택 예약하기',
            style: AppTextTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비교함 비우기'),
        content: const Text('비교함의 모든 캠프를 제거하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              context.read<CompareProvider>().clearAll();
              Navigator.pop(context);
            },
            child: const Text('비우기', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showReservationDialog(BuildContext context, List<CampCompareEntity> camps) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('캠프 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: camps.map((camp) => ListTile(
            title: Text(camp.name),
            subtitle: Text('₩${_formatPrice(camp.price)}'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${camp.name} 예약 페이지로 이동 (구현 예정)')),
              );
            },
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
