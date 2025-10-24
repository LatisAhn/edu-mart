import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 사진 업로드 섹션
/// 사용자가 후기와 함께 사진을 업로드하는 위젯
class PhotoUploadSection extends StatelessWidget {
  final List<String> uploadedPhotos;
  final ValueChanged<List<String>> onPhotosChanged;

  const PhotoUploadSection({
    super.key,
    required this.uploadedPhotos,
    required this.onPhotosChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          // 섹션 제목
          Text(
            '사진을 함께 올려보세요 (선택 사항)',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 사진 추가 버튼
          if (uploadedPhotos.length < 5)
            GestureDetector(
              onTap: () => _addPhoto(context),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primaryBlue500,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      color: AppColors.primaryBlue500,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '사진 추가',
                      style: AppTextTheme.bodySmall.copyWith(
                        color: AppColors.primaryBlue500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // 업로드된 사진 그리드
          if (uploadedPhotos.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: uploadedPhotos.length,
              itemBuilder: (context, index) {
                return _buildPhotoItem(context, uploadedPhotos[index], index, isDark);
              },
            ),
          
          const SizedBox(height: 8),
          
          // 제한 사항 안내
          Text(
            '최대 5장, 각 10MB 이하 (JPG, PNG만 가능)',
            style: AppTextTheme.bodySmall.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem(BuildContext context, String photoUrl, int index, bool isDark) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: photoUrl.startsWith('http')
                ? Image.network(
                    photoUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),
        ),
        
        // 삭제 버튼
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.errorRed500,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
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

  void _addPhoto(BuildContext context) {
    // TODO: 실제 사진 선택 로직 구현
    final newPhotos = List<String>.from(uploadedPhotos);
    newPhotos.add('https://picsum.photos/300/300?random=${newPhotos.length}');
    onPhotosChanged(newPhotos);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('사진이 추가되었습니다')),
    );
  }

  void _removePhoto(int index) {
    final newPhotos = List<String>.from(uploadedPhotos);
    newPhotos.removeAt(index);
    onPhotosChanged(newPhotos);
  }
}
