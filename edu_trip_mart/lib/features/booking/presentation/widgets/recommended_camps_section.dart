import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

class RecommendedCampsSection extends StatelessWidget {
  const RecommendedCampsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '이 캠프를 신청한 분들이 함께 본 다른 캠프',
          style: AppTextTheme.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 추천 캠프 리스트
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recommendedCamps.length,
            itemBuilder: (context, index) {
              final camp = _recommendedCamps[index];
              return _buildCampCard(context, camp, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCampCard(BuildContext context, Map<String, dynamic> camp, bool isDark) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
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
          // 캠프 이미지
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              color: AppColors.primaryBlue50,
              child: camp['imageUrl'] != null
                  ? Image.network(
                      camp['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImage();
                      },
                    )
                  : _buildPlaceholderImage(),
            ),
          ),
          
          // 캠프 정보
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 캠프 제목
                Text(
                  camp['title'],
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                // 가격
                Text(
                  camp['price'],
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.primaryBlue500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                // 평점
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: AppColors.warningYellow,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      camp['rating'],
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
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

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.primaryBlue50,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 30,
          color: AppColors.primaryBlue300,
        ),
      ),
    );
  }

  // 추천 캠프 데이터
  static final List<Map<String, dynamic>> _recommendedCamps = [
    {
      'title': '미국 뉴욕 영어 캠프',
      'price': '₩2,500,000',
      'rating': '4.5',
      'imageUrl': null,
    },
    {
      'title': '캐나다 토론토 영어 캠프',
      'price': '₩2,800,000',
      'rating': '4.3',
      'imageUrl': null,
    },
    {
      'title': '호주 시드니 영어 캠프',
      'price': '₩2,200,000',
      'rating': '4.6',
      'imageUrl': null,
    },
    {
      'title': '아일랜드 더블린 영어 캠프',
      'price': '₩1,900,000',
      'rating': '4.2',
      'imageUrl': null,
    },
  ];
}
