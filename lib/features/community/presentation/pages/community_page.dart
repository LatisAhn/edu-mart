import 'package:flutter/material.dart';
import '../domain/entities/post_entity.dart';
import '../data/mock_community_data.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 커뮤니티 페이지
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = '전체';
  String _searchQuery = '';
  List<PostEntity> _allPosts = [];
  List<PostEntity> _filteredPosts = [];

  @override
  void initState() {
    super.initState();
    _allPosts = MockCommunityData.getPosts();
    _filteredPosts = _allPosts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPosts() {
    setState(() {
      _filteredPosts = _allPosts.where((post) {
        final matchesCategory = _selectedCategory == '전체' || post.category == _selectedCategory;
        final matchesSearch = _searchQuery.isEmpty || 
            post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            post.contentPreview.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabBar(),
            Expanded(
              child: _buildPostList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '커뮤니티',
            style: AppTextTheme.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // 알림 설정
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '커뮤니티 검색어 입력...',
          hintStyle: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          _searchQuery = value;
          _filterPosts();
        },
      ),
    );
  }

  Widget _buildTabBar() {
    final categories = MockCommunityData.getCategories();
    
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingS),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                _filterPosts();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue500 : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue500 : AppColors.borderLight,
                  ),
                ),
                child: Text(
                  category,
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostList() {
    if (_filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: AppTextTheme.bodyLarge.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
      itemCount: _filteredPosts.length,
      itemBuilder: (context, index) {
        final post = _filteredPosts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(PostEntity post) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
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
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(post),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              post.title,
              style: AppTextTheme.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXS),
            Text(
              post.contentPreview,
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            _buildTags(post.tags),
            const SizedBox(height: AppDimensions.spacingS),
            _buildPostActions(post),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader(PostEntity post) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(post.userAvatarUrl),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              Text(
                _formatDate(post.createdAt),
                style: AppTextTheme.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingS,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: _getCategoryColor(post.category),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            post.category,
            style: AppTextTheme.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: AppDimensions.spacingXS,
      runSpacing: AppDimensions.spacingXS,
      children: tags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tag,
          style: AppTextTheme.caption.copyWith(
            color: AppColors.primaryBlue500,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildPostActions(PostEntity post) {
    return Row(
      children: [
        _buildActionButton(
          icon: post.isBookmarked ? Icons.favorite : Icons.favorite_border,
          label: post.likes.toString(),
          color: post.isBookmarked ? AppColors.error : AppColors.textSecondary,
          onTap: () {
            // 좋아요 토글
          },
        ),
        const SizedBox(width: AppDimensions.spacingM),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: post.comments.toString(),
          color: AppColors.textSecondary,
          onTap: () {
            // 댓글 보기
          },
        ),
        const SizedBox(width: AppDimensions.spacingM),
        _buildActionButton(
          icon: post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: '저장',
          color: post.isBookmarked ? AppColors.primaryBlue500 : AppColors.textSecondary,
          onTap: () {
            // 북마크 토글
          },
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            // 게시물 상세 보기
          },
          child: Text(
            '자세히 보기',
            style: AppTextTheme.bodySmall.copyWith(
              color: AppColors.primaryBlue500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextTheme.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // 새 글 작성 화면으로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('새 글 작성 기능은 준비 중입니다'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      backgroundColor: AppColors.primaryBlue500,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '후기':
        return AppColors.success;
      case '질문':
        return AppColors.warning;
      case '자유게시판':
        return AppColors.primaryBlue500;
      case '공지':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
