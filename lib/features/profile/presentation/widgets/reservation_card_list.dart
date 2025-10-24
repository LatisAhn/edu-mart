import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

/// 예약 카드 리스트 위젯
/// 탭에 따라 다른 예약 목록을 표시하는 위젯
class ReservationCardList extends StatelessWidget {
  final TabController tabController;
  final Function(String) onViewDetails;
  final Function(String) onViewReceipt;
  final Function(String) onContactSupport;

  const ReservationCardList({
    super.key,
    required this.tabController,
    required this.onViewDetails,
    required this.onViewReceipt,
    required this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _buildReservationList(context, '진행 중', _getActiveReservations()),
        _buildReservationList(context, '완료됨', _getCompletedReservations()),
        _buildReservationList(context, '취소됨', _getCancelledReservations()),
      ],
    );
  }

  Widget _buildReservationList(BuildContext context, String status, List<Map<String, dynamic>> reservations) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (reservations.isEmpty) {
      return _buildEmptyState(context, status);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Column(
        children: reservations.map((reservation) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: _buildReservationCard(context, reservation, isDark),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReservationCard(BuildContext context, Map<String, dynamic> reservation, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppDimensions.elevationS,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 캠프 이미지
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radiusL),
              topRight: Radius.circular(AppDimensions.radiusL),
            ),
            child: Container(
              height: 120,
              width: double.infinity,
              color: AppColors.neutralGray100,
              child: reservation['imageUrl'] != null
                  ? Image.network(
                      reservation['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                    )
                  : _buildImagePlaceholder(),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 캠프 제목
                Text(
                  reservation['title'],
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppDimensions.spacingS),
                
                // 날짜
                Text(
                  reservation['dateRange'],
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: AppDimensions.spacingM),
                
                // 상태 배지와 액션 버튼들
                Row(
                  children: [
                    // 상태 배지
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingS,
                        vertical: AppDimensions.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(reservation['status']),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: Text(
                        reservation['status'],
                        style: AppTextTheme.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // 액션 버튼들
                    Row(
                      children: [
                        CustomButton(
                          text: '상세보기',
                          onPressed: () => onViewDetails(reservation['id']),
                          variant: ButtonVariant.outline,
                        ),
                        
                        const SizedBox(width: AppDimensions.spacingS),
                        
                        CustomButton(
                          text: '영수증',
                          onPressed: () => onViewReceipt(reservation['id']),
                          variant: ButtonVariant.outline,
                        ),
                        
                        const SizedBox(width: AppDimensions.spacingS),
                        
                        CustomButton(
                          text: '문의하기',
                          onPressed: () => onContactSupport(reservation['id']),
                          variant: ButtonVariant.outline,
                        ),
                      ],
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

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.neutralGray100,
      child: const Center(
        child: Icon(
          Icons.image,
          color: AppColors.textDisabledLight,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String status) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingXL),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            '예약 내역이 없습니다.',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingM),
          
          CustomButton(
            text: '캠프 둘러보기',
            onPressed: () {
              // TODO: 홈 페이지로 이동
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '진행 중':
        return AppColors.primaryBlue500;
      case '완료됨':
        return AppColors.successGreen;
      case '취소됨':
        return AppColors.neutralGray500;
      default:
        return AppColors.neutralGray500;
    }
  }

  // TODO: 실제 데이터로 교체
  List<Map<String, dynamic>> _getActiveReservations() {
    return [
      {
        'id': 'EDCM-2025-1208-00042',
        'title': '세부 여름 영어 캠프 (2주 과정)',
        'dateRange': '2025.07.10 ~ 2025.07.24',
        'status': '진행 중',
        'imageUrl': 'https://picsum.photos/400/250?random=1',
      },
      {
        'id': 'EDCM-2025-1208-00043',
        'title': '영국 런던 영어 캠프 (3주 과정)',
        'dateRange': '2025.08.15 ~ 2025.09.05',
        'status': '진행 중',
        'imageUrl': 'https://picsum.photos/400/250?random=2',
      },
    ];
  }

  List<Map<String, dynamic>> _getCompletedReservations() {
    return [
      {
        'id': 'EDCM-2025-1101-00040',
        'title': '필리핀 세부 영어 캠프 (1주 과정)',
        'dateRange': '2025.06.01 ~ 2025.06.08',
        'status': '완료됨',
        'imageUrl': 'https://picsum.photos/400/250?random=3',
      },
    ];
  }

  List<Map<String, dynamic>> _getCancelledReservations() {
    return [];
  }
}
