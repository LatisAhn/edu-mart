import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../widgets/camp_summary_section.dart';
import '../widgets/rating_section.dart';
import '../widgets/category_ratings_section.dart';
import '../widgets/text_review_section.dart';
import '../widgets/photo_upload_section.dart';
import '../widgets/consent_section.dart';
import 'review_success_page.dart';

/// 후기 작성 페이지
/// 캠프 후기를 작성하는 메인 화면
class ReviewWritePage extends StatefulWidget {
  final String campId;
  final String campName;
  final String campImageUrl;
  final String dateRange;
  final String location;

  const ReviewWritePage({
    super.key,
    required this.campId,
    required this.campName,
    required this.campImageUrl,
    required this.dateRange,
    required this.location,
  });

  @override
  State<ReviewWritePage> createState() => _ReviewWritePageState();
}

class _ReviewWritePageState extends State<ReviewWritePage> {
  int _overallRating = 0;
  Map<String, int> _categoryRatings = {
    '수업 만족도': 0,
    '숙소 및 식사': 0,
    '안전 및 관리': 0,
    '활동 프로그램': 0,
  };
  String _reviewText = '';
  List<String> _uploadedPhotos = [];
  bool _isConsentAgreed = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 캠프 요약 섹션
            CampSummarySection(
              campName: widget.campName,
              campImageUrl: widget.campImageUrl,
              dateRange: widget.dateRange,
              location: widget.location,
              onTap: _onCampSummaryTap,
            ),
            
            const SizedBox(height: 24),
            
            // 전체 별점 섹션
            RatingSection(
              rating: _overallRating,
              onRatingChanged: (rating) {
                setState(() {
                  _overallRating = rating;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // 카테고리별 평가 섹션
            CategoryRatingsSection(
              categoryRatings: _categoryRatings,
              onCategoryRatingChanged: (category, rating) {
                setState(() {
                  _categoryRatings[category] = rating;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // 텍스트 후기 섹션
            TextReviewSection(
              reviewText: _reviewText,
              onReviewTextChanged: (text) {
                setState(() {
                  _reviewText = text;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // 사진 업로드 섹션
            PhotoUploadSection(
              uploadedPhotos: _uploadedPhotos,
              onPhotosChanged: (photos) {
                setState(() {
                  _uploadedPhotos = photos;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // 동의 체크박스 섹션
            ConsentSection(
              isAgreed: _isConsentAgreed,
              onAgreementChanged: (isAgreed) {
                setState(() {
                  _isConsentAgreed = isAgreed;
                });
              },
            ),
            
            const SizedBox(height: 32),
            
            // 제출 버튼
            _buildSubmitButton(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundWhite,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '후기 작성하기',
        style: AppTextTheme.headlineSmall.copyWith(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.check,
            color: _isFormValid() ? AppColors.primaryBlue500 : Colors.grey,
          ),
          onPressed: _isFormValid() ? _submitReview : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final isEnabled = _isFormValid() && !_isSubmitting;
    
    print('버튼 상태 - 활성화: $isEnabled, 별점: $_overallRating, 텍스트: ${_reviewText.length}, 동의: $_isConsentAgreed');
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? _submitReview : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.primaryBlue500 : Colors.grey[300],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                '후기 등록하기',
                style: AppTextTheme.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  bool _isFormValid() {
    // 임시로 검증 조건을 완화하여 테스트
    return _overallRating > 0 && 
           _reviewText.trim().length >= 10 && 
           _isConsentAgreed;
  }

  void _onCampSummaryTap() {
    // TODO: 캠프 상세 페이지를 모달로 열기
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('캠프 상세 정보를 보여줍니다')),
    );
  }

  Future<void> _submitReview() async {
    print('후기 제출 시작 - 별점: $_overallRating, 텍스트 길이: ${_reviewText.length}, 동의: $_isConsentAgreed');
    
    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: 실제 API 호출로 후기 제출
      await Future.delayed(const Duration(seconds: 2));
      
      print('후기 제출 완료');
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewSuccessPage(
              campId: widget.campId,
              campName: widget.campName,
              campImageUrl: widget.campImageUrl,
              pointsEarned: 3000,
            ),
          ),
        );
      }
    } catch (e) {
      print('후기 제출 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('후기 등록 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

}
