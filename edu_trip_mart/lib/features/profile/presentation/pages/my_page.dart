import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../widgets/notification_center_modal.dart';

/// 마이페이지 메인 화면
/// 사용자의 예약 내역과 알림을 관리하는 대시보드
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _unreadNotificationCount = 3; // TODO: 실제 알림 개수로 교체

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            // 사용자 프로필 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 프로필 아바타
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue100,
                      border: Border.all(
                        color: AppColors.primaryBlue500,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primaryBlue500,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 사용자 이름
                  Text(
                    '안진호 님',
                    style: AppTextTheme.headlineSmall.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 예약 상태
                  Text(
                    '3개의 예약이 진행 중입니다.',
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 내 정보 수정 버튼
                  ElevatedButton(
                    onPressed: _onEditProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primaryBlue500,
                      side: BorderSide(color: AppColors.primaryBlue500),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('내 정보 수정'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 예약 탭
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                onTap: _onTabChanged,
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(
                    width: 3,
                    color: AppColors.primaryBlue500,
                  ),
                  insets: const EdgeInsets.symmetric(horizontal: 24),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppColors.primaryBlue500,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: AppTextTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: AppTextTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: '진행 중'),
                  Tab(text: '완료됨'),
                  Tab(text: '취소됨'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 예약 카드 리스트
            Container(
              height: 400, // 고정 높이로 설정
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReservationList('진행 중'),
                  _buildReservationList('완료됨'),
                  _buildReservationList('취소됨'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 빠른 액션 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
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
                  Text(
                    '빠른 액션',
                    style: AppTextTheme.headlineSmall.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 액션 버튼 그리드
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildActionItem(Icons.payment, '결제 내역', _onPaymentHistory),
                      _buildActionItem(Icons.receipt, '영수증', _onReceipts),
                      _buildActionItem(Icons.chat_bubble_outline, '문의내역', _onInquiries),
                      _buildActionItem(Icons.settings, '설정', _onSettings),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 고객 지원 섹션
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16),
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
                  Text(
                    '도움이 필요하신가요?',
                    style: AppTextTheme.headlineSmall.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 1:1 문의 버튼
                  ElevatedButton(
                    onPressed: _onOneOnOneInquiry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('1:1 문의'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // FAQ 링크
                  GestureDetector(
                    onTap: _onViewFAQ,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: AppColors.primaryBlue500,
                            size: 20,
                          ),
                          
                          const SizedBox(width: 8),
                          
                          Text(
                            'FAQ 보기',
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.primaryBlue500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 긴급 연락처
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: AppColors.errorRed500,
                        size: 20,
                      ),
                      
                      const SizedBox(width: 8),
                      
                      Text(
                        '긴급 연락처: ',
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: _onEmergencyContact,
                        child: Text(
                          '010-1234-5678',
                          style: AppTextTheme.bodyMedium.copyWith(
                            color: AppColors.errorRed500,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
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
      centerTitle: true,
      title: Text(
        '마이페이지',
        style: AppTextTheme.headlineSmall.copyWith(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // 알림 버튼
        Stack(
          children: [
            IconButton(
              onPressed: _onNotificationTap,
              icon: Icon(
                Icons.notifications_outlined,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            if (_unreadNotificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed500,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    _unreadNotificationCount.toString(),
                    style: AppTextTheme.labelSmall.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        
        // 설정 버튼
        IconButton(
          onPressed: _onSettingsTap,
          icon: Icon(
            Icons.settings_outlined,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _onRefresh() async {
    // TODO: 실제 데이터 새로고침 로직 구현
    await Future.delayed(const Duration(seconds: 1));
  }

  void _onTabChanged(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void _onNotificationTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationCenterModal(
        onNotificationTap: _onNotificationItemTap,
        onMarkAllRead: _onMarkAllRead,
        onNotificationSettings: _onNotificationSettings,
      ),
    );
  }

  void _onSettingsTap() {
    // TODO: 설정 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설정 페이지로 이동')),
    );
  }

  void _onEditProfile() {
    // TODO: 프로필 편집 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프로필 편집 페이지로 이동')),
    );
  }

  void _onViewReservationDetails(String reservationId) {
    Navigator.pushNamed(context, '/reservation-detail', arguments: reservationId);
  }

  void _onWriteReview(String reservationId) {
    Navigator.pushNamed(context, '/review-write', arguments: {
      'campId': reservationId,
      'campName': '필리핀 세부 영어 캠프 (1주 과정)',
      'campImageUrl': 'https://picsum.photos/400/250?random=3',
      'dateRange': '2025.06.01 ~ 2025.06.08',
      'location': '필리핀 세부',
    });
  }

  void _onViewReceipt(String reservationId) {
    // TODO: 영수증 보기 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('영수증 보기: $reservationId')),
    );
  }

  void _onContactSupport(String reservationId) {
    // TODO: 문의하기 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('문의하기: $reservationId')),
    );
  }

  void _onPaymentHistory() {
    // TODO: 결제 내역 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('결제 내역 페이지로 이동')),
    );
  }

  void _onReceipts() {
    // TODO: 영수증 목록 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('영수증 목록 페이지로 이동')),
    );
  }

  void _onInquiries() {
    // TODO: 문의 내역 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('문의 내역 페이지로 이동')),
    );
  }

  void _onSettings() {
    // TODO: 설정 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설정 페이지로 이동')),
    );
  }

  void _onOneOnOneInquiry() {
    // TODO: 1:1 문의 모달 열기
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('1:1 문의 모달 열기')),
    );
  }

  void _onViewFAQ() {
    // TODO: FAQ 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FAQ 페이지로 이동')),
    );
  }

  void _onEmergencyContact() {
    // TODO: 긴급 연락처 모달 열기
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('긴급 연락처 모달 열기')),
    );
  }

  void _onNotificationItemTap(String notificationId) {
    // TODO: 알림 항목 클릭 처리
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('알림 클릭: $notificationId')),
    );
  }

  void _onMarkAllRead() {
    setState(() {
      _unreadNotificationCount = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('모든 알림을 읽음 처리했습니다')),
    );
  }

  void _onNotificationSettings() {
    // TODO: 알림 설정 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알림 설정 페이지로 이동')),
    );
  }

  Widget _buildReservationList(String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
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
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.neutralGray100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: AppColors.textDisabledLight,
                    size: 48,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 캠프 제목
                Text(
                  '세부 여름 영어 캠프 (2주 과정)',
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 날짜
                Text(
                  '2025.07.10 ~ 2025.07.24',
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 상태 배지와 액션 버튼들
                Row(
                  children: [
                    // 상태 배지
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: AppTextTheme.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // 액션 버튼들
                    ElevatedButton(
                      onPressed: () => _onViewReservationDetails('test_id'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.primaryBlue500,
                        side: BorderSide(color: AppColors.primaryBlue500),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('상세보기'),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // 후기 작성 버튼 (완료된 예약에만 표시)
                    if (status == '완료됨')
                      ElevatedButton(
                        onPressed: () => _onWriteReview('test_id'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue500,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text('후기 작성'),
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

  Widget _buildActionItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderLight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primaryBlue500,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              label,
              style: AppTextTheme.bodySmall.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
}
