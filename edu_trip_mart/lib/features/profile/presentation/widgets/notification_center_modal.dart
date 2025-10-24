import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 알림 센터 모달
/// 사용자의 모든 알림을 표시하고 관리하는 모달
class NotificationCenterModal extends StatefulWidget {
  final Function(String) onNotificationTap;
  final VoidCallback onMarkAllRead;
  final VoidCallback onNotificationSettings;

  const NotificationCenterModal({
    super.key,
    required this.onNotificationTap,
    required this.onMarkAllRead,
    required this.onNotificationSettings,
  });

  @override
  State<NotificationCenterModal> createState() => _NotificationCenterModalState();
}

class _NotificationCenterModalState extends State<NotificationCenterModal> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 'notif_1',
      'type': 'reservation',
      'title': '결제 완료',
      'message': '세부 여름 영어 캠프 결제가 완료되었습니다.',
      'timestamp': '2시간 전',
      'isRead': false,
      'icon': Icons.payment,
      'color': AppColors.successGreen,
    },
    {
      'id': 'notif_2',
      'type': 'reservation',
      'title': '출발 안내',
      'message': '출발 7일 전 안내가 도착했습니다.',
      'timestamp': '1일 전',
      'isRead': false,
      'icon': Icons.flight_takeoff,
      'color': AppColors.primaryBlue500,
    },
    {
      'id': 'notif_3',
      'type': 'message',
      'title': '새 댓글',
      'message': '새 댓글이 달렸습니다.',
      'timestamp': '3일 전',
      'isRead': true,
      'icon': Icons.chat_bubble_outline,
      'color': AppColors.secondaryCoral400,
    },
    {
      'id': 'notif_4',
      'type': 'system',
      'title': '관리자 공지',
      'message': '환불 일정 안내',
      'timestamp': '1주일 전',
      'isRead': true,
      'icon': Icons.announcement,
      'color': AppColors.warningYellow,
    },
    {
      'id': 'notif_5',
      'type': 'system',
      'title': '앱 업데이트',
      'message': '앱 업데이트가 있습니다.',
      'timestamp': '2주일 전',
      'isRead': true,
      'icon': Icons.system_update,
      'color': AppColors.neutralGray500,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '알림',
                  style: AppTextTheme.headlineSmall.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                if (unreadCount > 0) ...[
                  const SizedBox(width: AppDimensions.spacingS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingS,
                      vertical: AppDimensions.spacingXS,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.errorRed500,
                      borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusS)),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: AppTextTheme.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                
                const Spacer(),
                
                // 전체 읽음 처리 버튼
                if (unreadCount > 0)
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: Text(
                      '전체 읽음',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppColors.primaryBlue500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                
                // 알림 설정 버튼
                IconButton(
                  onPressed: widget.onNotificationSettings,
                  icon: Icon(
                    Icons.settings,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          
          // 알림 목록
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationItem(notification, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight,
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          Text(
            '새 알림이 없습니다.',
            style: AppTextTheme.bodyLarge.copyWith(
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: notification['isRead']
            ? (isDark ? AppColors.surfaceDark : AppColors.backgroundWhite)
            : (isDark ? AppColors.primaryBlue50.withOpacity(0.1) : AppColors.primaryBlue50),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: notification['isRead']
              ? (isDark ? AppColors.borderDark : AppColors.borderLight)
              : AppColors.primaryBlue300,
        ),
      ),
      child: Row(
        children: [
          // 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Icon(
              notification['icon'],
              color: notification['color'],
              size: 20,
            ),
          ),
          
          const SizedBox(width: AppDimensions.spacingM),
          
          // 알림 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child:                         Text(
                          notification['title'],
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                    ),
                    
                    if (!notification['isRead'])
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryBlue500,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingXS),
                
                Text(
                  notification['message'],
                  style: AppTextTheme.bodySmall.copyWith(
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: AppDimensions.spacingXS),
                
                Text(
                  notification['timestamp'],
                  style: AppTextTheme.labelSmall.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          
          // 삭제 버튼
          IconButton(
            onPressed: () => _deleteNotification(notification['id']),
            icon: Icon(
              Icons.close,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    widget.onMarkAllRead();
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
  }
}
