import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 추천 콘텐츠 섹션
/// 비슷한 캠프들을 추천하는 섹션
class RecommendedContentSection extends StatelessWidget {
  final String campId;
  final Animation<double> slideAnimation;
  final Animation<double> fadeAnimation;
  final Function(String) onCampTap;

  const RecommendedContentSection({
    super.key,
    required this.campId,
    required this.slideAnimation,
    required this.fadeAnimation,
    required this.onCampTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 추천 캠프 데이터 (실제로는 API에서 가져올 데이터)
    final recommendedCamps = [
      {
        'id': 'camp_1',
        'title': '필리핀 가족 영어 캠프',
        'imageUrl': 'https://picsum.photos/200/150?random=1',
        'price': '₩1,200,000',
        'rating': 4.8,
      },
      {
        'id': 'camp_2',
        'title': '세부 어학연수 캠프',
        'imageUrl': 'https://picsum.photos/200/150?random=2',
        'price': '₩980,000',
        'rating': 4.6,
      },
      {
        'id': 'camp_3',
        'title': '보라카이 가족 여행',
        'imageUrl': 'https://picsum.photos/200/150?random=3',
        'price': '₩1,500,000',
        'rating': 4.9,
      },
    ];

    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, slideAnimation.value),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 섹션 제목
                Text(
                  '비슷한 캠프 둘러보기',
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 추천 캠프 카드들
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedCamps.length,
                    itemBuilder: (context, index) {
                      final camp = recommendedCamps[index];
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () => onCampTap(camp['id'] as String),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 캠프 이미지
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    color: AppColors.neutralGray100,
                                    child: Image.network(
                                      camp['imageUrl'] as String,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => 
                                          _buildImagePlaceholder(),
                                    ),
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
                                        camp['title'] as String,
                                        style: AppTextTheme.bodySmall.copyWith(
                                          color: isDark ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      
                                      const SizedBox(height: 8),
                                      
                                      // 가격과 평점
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            camp['price'] as String,
                                            style: AppTextTheme.bodySmall.copyWith(
                                              color: AppColors.primaryBlue500,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: AppColors.warningYellow,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                (camp['rating'] as double).toString(),
                                                style: AppTextTheme.bodySmall.copyWith(
                                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                ),
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.neutralGray100,
      child: const Center(
        child: Icon(
          Icons.image,
          color: AppColors.textDisabledLight,
          size: 24,
        ),
      ),
    );
  }
}
