/// 커뮤니티 게시물 엔티티
class PostEntity {
  final String id;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String category;
  final String title;
  final String contentPreview;
  final List<String> tags;
  final int likes;
  final int comments;
  final bool isBookmarked;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.category,
    required this.title,
    required this.contentPreview,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.isBookmarked,
    required this.createdAt,
  });

  PostEntity copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatarUrl,
    String? category,
    String? title,
    String? contentPreview,
    List<String>? tags,
    int? likes,
    int? comments,
    bool? isBookmarked,
    DateTime? createdAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      category: category ?? this.category,
      title: title ?? this.title,
      contentPreview: contentPreview ?? this.contentPreview,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
