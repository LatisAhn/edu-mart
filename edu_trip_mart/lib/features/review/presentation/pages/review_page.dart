import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/rating_widget.dart';
import '../../../../shared/widgets/animated_fade_in.dart';
import '../providers/review_provider.dart';

/// 후기 작성 페이지
/// 캠프 후기를 작성하고 제출하는 화면
class ReviewPage extends StatefulWidget {
  final String campId;
  final String bookingId;

  const ReviewPage({
    super.key,
    required this.campId,
    required this.bookingId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  double _rating = 0.0;
  final List<String> _selectedTags = [];
  final List<String> _imageUrls = [];

  final List<String> _availableTags = [
    '친절한 강사',
    '체계적인 프로그램',
    '안전한 환경',
    '좋은 숙소',
    '맛있는 식사',
    '다양한 액티비티',
    '가성비 좋음',
    '재방문 의사 있음',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().loadCampInfo(widget.campId);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('후기 작성'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submitReview,
            child: Text(
              '완료',
              style: AppTextTheme.bodyLarge.copyWith(
                color: AppColors.primaryBlue500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.camp == null) {
            return _buildErrorState();
          }

          return _buildContent(provider);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '캠프 정보를 불러올 수 없습니다',
            style: AppTextTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ReviewProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampInfo(provider.camp!),
                  const SizedBox(height: 24),
                  _buildRatingSection(),
                  const SizedBox(height: 24),
                  _buildTitleSection(),
                  const SizedBox(height: 24),
                  _buildContentSection(),
                  const SizedBox(height: 24),
                  _buildTagsSection(),
                  const SizedBox(height: 24),
                  _buildImageSection(),
                  const SizedBox(height: 100), // 하단 버튼 공간 확보
                ],
              ),
            ),
          ),
          _buildBottomBar(provider),
        ],
      ),
    );
  }

  Widget _buildCampInfo(dynamic camp) {
    return AnimatedFadeIn(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
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
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camp.title,
                    style: AppTextTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${camp.city}, ${camp.country}',
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
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '전체 평점',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                RatingWidget(
                  rating: _rating,
                  size: 40,
                  onRatingChanged: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  _getRatingText(_rating),
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '후기 제목',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _titleController,
            labelText: '제목을 입력해주세요',
            hintText: '예: 정말 좋은 경험이었습니다!',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '제목을 입력해주세요';
              }
              if (value.length < 5) {
                return '제목은 5자 이상 입력해주세요';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '후기 내용',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _contentController,
            labelText: '상세한 후기를 작성해주세요',
            hintText: '캠프 경험에 대한 자세한 후기를 작성해주세요.\n예: 강사님들이 친절하시고, 프로그램이 체계적이었습니다...',
            maxLines: 8,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '후기 내용을 입력해주세요';
              }
              if (value.length < 20) {
                return '후기는 20자 이상 입력해주세요';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '태그 선택',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '해당하는 항목을 선택해주세요 (복수 선택 가능)',
            style: AppTextTheme.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue500 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryBlue500 : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: AppTextTheme.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return AnimatedFadeIn(
      delay: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '사진 첨부',
            style: AppTextTheme.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '캠프 관련 사진을 첨부해주세요 (선택사항)',
            style: AppTextTheme.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderLight,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '사진 추가',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ReviewProvider provider) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomButton(
          text: '후기 등록하기',
          onPressed: _submitReview,
        ),
      ),
    );
  }

  String _getRatingText(double rating) {
    if (rating == 0) return '평점을 선택해주세요';
    if (rating <= 1) return '매우 불만족';
    if (rating <= 2) return '불만족';
    if (rating <= 3) return '보통';
    if (rating <= 4) return '만족';
    return '매우 만족';
  }

  void _submitReview() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('평점을 선택해주세요'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final provider = context.read<ReviewProvider>();
    final success = await provider.submitReview(
      campId: widget.campId,
      bookingId: widget.bookingId,
      rating: _rating,
      title: _titleController.text,
      content: _contentController.text,
      tags: _selectedTags,
      imageUrls: _imageUrls,
    );

    if (success) {
      Navigator.pop(context, true); // 성공 시 true 반환
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('후기 등록 중 오류가 발생했습니다. 다시 시도해주세요.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

