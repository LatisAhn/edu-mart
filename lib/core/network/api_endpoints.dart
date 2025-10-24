/// API 엔드포인트 정의
class ApiEndpoints {
  // Base URL
  static const String baseApiUrl = 'https://api.edutripmart.com';
  static const String baseImageUrl = 'https://images.edutripmart.com';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User Endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String deleteAccount = '/users/account';
  static String userFavorites(String userId) => '/users/$userId/favorites';
  static String userReviews(String userId) => '/users/$userId/reviews';
  static String userBookings(String userId) => '/users/$userId/bookings';

  // Camp Endpoints
  static const String camps = '/camps';
  static const String featuredCamps = '/camps/featured';
  static const String popularCamps = '/camps/popular';
  static const String latestCamps = '/camps/latest';
  static const String recommendedCamps = '/camps/recommended';
  static String campById(String id) => '/camps/$id';
  static String campReviews(String campId) => '/camps/$campId/reviews';
  static String campImages(String campId) => '/camps/$campId/images';
  static String campAvailability(String campId) => '/camps/$campId/availability';
  static String campPricing(String campId) => '/camps/$campId/pricing';
  static const String searchCamps = '/camps/search';
  static const String filterCamps = '/camps/filter';

  // Category Endpoints
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';
  static String categoryCamps(String categoryId) => '/categories/$categoryId/camps';

  // Review Endpoints
  static const String reviews = '/reviews';
  static String reviewById(String id) => '/reviews/$id';
  static String createReview = '/reviews';
  static String updateReview(String id) => '/reviews/$id';
  static String deleteReview(String id) => '/reviews/$id';
  static String reviewHelpful(String id) => '/reviews/$id/helpful';

  // Booking Endpoints
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
  static String createBooking = '/bookings';
  static String updateBooking(String id) => '/bookings/$id';
  static String cancelBooking(String id) => '/bookings/$id/cancel';
  static String bookingPayment(String id) => '/bookings/$id/payment';

  // Payment Endpoints
  static const String payments = '/payments';
  static String paymentById(String id) => '/payments/$id';
  static String createPayment = '/payments';
  static String paymentMethods = '/payments/methods';
  static String paymentHistory = '/payments/history';

  // Search Endpoints
  static const String searchSuggestions = '/search/suggestions';
  static const String searchHistory = '/search/history';
  static const String popularSearches = '/search/popular';
  static const String trendingSearches = '/search/trending';

  // Notification Endpoints
  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';
  static const String markAllRead = '/notifications/read-all';
  static const String notificationSettings = '/notifications/settings';

  // Wishlist Endpoints
  static const String wishlist = '/wishlist';
  static String addToWishlist = '/wishlist/add';
  static String removeFromWishlist = '/wishlist/remove';
  static String toggleWishlist = '/wishlist/toggle';
  static const String favoriteCamps = '/camps/favorites';
  static String toggleFavorite(String campId) => '/camps/$campId/favorite';

  // Analytics Endpoints
  static const String analytics = '/analytics';
  static const String userAnalytics = '/analytics/user';
  static const String campAnalytics = '/analytics/camp';

  // Admin Endpoints
  static const String adminCamps = '/admin/camps';
  static const String adminUsers = '/admin/users';
  static const String adminBookings = '/admin/bookings';
  static const String adminReviews = '/admin/reviews';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminSettings = '/admin/settings';

  // File Upload Endpoints
  static const String uploadImage = '/upload/image';
  static const String uploadDocument = '/upload/document';
  static const String uploadAvatar = '/upload/avatar';

  // Health Check
  static const String health = '/health';
  static const String version = '/version';

  // External API Endpoints
  static const String weatherApi = '/external/weather';
  static const String currencyApi = '/external/currency';
  static const String translationApi = '/external/translation';

  // Helper methods
  static String buildImageUrl(String imagePath) {
    return '$baseImageUrl$imagePath';
  }

  static String buildApiUrl(String endpoint) {
    return '$baseApiUrl$endpoint';
  }

  static Map<String, String> buildQueryParams({
    int? page,
    int? limit,
    String? sort,
    String? order,
    Map<String, dynamic>? filters,
  }) {
    final params = <String, String>{};
    
    if (page != null) params['page'] = page.toString();
    if (limit != null) params['limit'] = limit.toString();
    if (sort != null) params['sort'] = sort;
    if (order != null) params['order'] = order;
    
    if (filters != null) {
      filters.forEach((key, value) {
        if (value != null) {
          params[key] = value.toString();
        }
      });
    }
    
    return params;
  }

  // Helper methods for API service
  static Map<String, String> paginationParams({
    required int page,
    required int limit,
    String? sortBy,
    String? sortOrder,
  }) {
    return {
      'page': page.toString(),
      'limit': limit.toString(),
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
    };
  }

  static Map<String, String> searchParams({
    required String query,
    int? page,
    int? limit,
    Map<String, dynamic>? filters,
  }) {
    final params = <String, String>{
      'q': query,
    };
    
    if (page != null) params['page'] = page.toString();
    if (limit != null) params['limit'] = limit.toString();
    
    if (filters != null) {
      filters.forEach((key, value) {
        if (value != null) {
          params[key] = value.toString();
        }
      });
    }
    
    return params;
  }

  static String withId(String endpoint, String id) {
    return '$endpoint/$id';
  }
}