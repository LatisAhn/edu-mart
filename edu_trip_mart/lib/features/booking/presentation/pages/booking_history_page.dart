import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_dimensions.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/animated_fade_in.dart';
import '../providers/booking_history_provider.dart';

/// 예약 내역 페이지
/// 사용자의 모든 예약 내역을 조회하고 관리하는 화면
class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingHistoryProvider>().loadBookingHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 내역'),
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryBlue500,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryBlue500,
          tabs: const [
            Tab(text: '전체'),
            Tab(text: '예정'),
            Tab(text: '완료'),
            Tab(text: '취소'),
          ],
        ),
      ),
      body: Consumer<BookingHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
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

  Widget _buildContent(BookingHistoryProvider provider) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildBookingList(provider.allBookings),
        _buildBookingList(provider.upcomingBookings),
        _buildBookingList(provider.completedBookings),
        _buildBookingList(provider.cancelledBookings),
      ],
    );
  }

  Widget _buildBookingList(List<dynamic> bookings) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BookingHistoryProvider>().loadBookingHistory();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return AnimatedFadeIn(
            delay: Duration(milliseconds: index * 100),
            child: _buildBookingCard(bookings[index]),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(dynamic booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookingHeader(booking),
          _buildBookingContent(booking),
          _buildBookingActions(booking),
        ],
      ),
    );
  }

  Widget _buildBookingHeader(dynamic booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(booking.status).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _getStatusText(booking.status),
              style: AppTextTheme.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '예약번호: ${booking.id}',
            style: AppTextTheme.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingContent(dynamic booking) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  booking.camp?.imageUrls?.isNotEmpty == true 
                      ? booking.camp.imageUrls.first 
                      : '',
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
                        size: 20,
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
                      booking.camp?.title ?? '캠프명',
                      style: AppTextTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${booking.camp?.city}, ${booking.camp?.country}',
                      style: AppTextTheme.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${booking.camp?.duration}일 • ${booking.camp?.minAge}-${booking.camp?.maxAge}세',
                      style: AppTextTheme.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${booking.camp?.currency} ${booking.camp?.price.toStringAsFixed(0)}',
                    style: AppTextTheme.titleMedium.copyWith(
                      color: AppColors.primaryBlue500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '1인 기준',
                    style: AppTextTheme.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildBookingInfo(booking),
        ],
      ),
    );
  }

  Widget _buildBookingInfo(dynamic booking) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoRow('출발일', _formatDate(booking.startDate)),
          const SizedBox(height: 8),
          _buildInfoRow('도착일', _formatDate(booking.endDate)),
          const SizedBox(height: 8),
          _buildInfoRow('참가자', '${booking.participantCount}명'),
          const SizedBox(height: 8),
          _buildInfoRow('결제수단', _getPaymentMethodText(booking.paymentMethod)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextTheme.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingActions(dynamic booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          if (booking.status == 'confirmed' || booking.status == 'pending') ...[
            Expanded(
              child: CustomButton(
                text: '상세보기',
                type: CustomButtonType.outlined,
                onPressed: () {
                  _showBookingDetail(booking);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: '취소하기',
                type: CustomButtonType.outlined,
                onPressed: () {
                  _cancelBooking(booking);
                },
              ),
            ),
          ] else if (booking.status == 'completed') ...[
            Expanded(
              child: CustomButton(
                text: '상세보기',
                type: CustomButtonType.outlined,
                onPressed: () {
                  _showBookingDetail(booking);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: '후기작성',
                onPressed: () {
                  _writeReview(booking);
                },
              ),
            ),
          ] else ...[
            Expanded(
              child: CustomButton(
                text: '상세보기',
                type: CustomButtonType.outlined,
                onPressed: () {
                  _showBookingDetail(booking);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_online,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '예약 내역이 없습니다',
              style: AppTextTheme.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '새로운 캠프를 예약해보세요!',
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: '캠프 둘러보기',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetail(dynamic booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingDetailSheet(booking: booking),
    );
  }

  void _cancelBooking(dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 취소'),
        content: const Text('정말로 이 예약을 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BookingHistoryProvider>().cancelBooking(booking.id);
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  void _writeReview(dynamic booking) {
    Navigator.pushNamed(
      context,
      '/review',
      arguments: {
        'campId': booking.camp?.id,
        'bookingId': booking.id,
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      case 'completed':
        return AppColors.primaryBlue500;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return '확정';
      case 'pending':
        return '대기중';
      case 'cancelled':
        return '취소됨';
      case 'completed':
        return '완료';
      default:
        return status;
    }
  }

  String _getPaymentMethodText(String method) {
    switch (method) {
      case 'card':
        return '신용카드';
      case 'bank':
        return '계좌이체';
      case 'kakao':
        return '카카오페이';
      case 'naver':
        return '네이버페이';
      default:
        return method;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}

/// 예약 상세 정보 시트
class _BookingDetailSheet extends StatelessWidget {
  final dynamic booking;

  const _BookingDetailSheet({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '예약 상세 정보',
                    style: AppTextTheme.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 상세 정보 내용
                  Text(
                    '예약 상세 정보가 여기에 표시됩니다.',
                    style: AppTextTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

