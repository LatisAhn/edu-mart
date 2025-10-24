import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/theme/app_theme.dart';
import 'presentation/pages/main_page.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/booking/presentation/providers/booking_provider.dart';
import 'features/booking/presentation/providers/payment_provider.dart';
import 'features/booking/presentation/providers/booking_history_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/review/presentation/providers/review_provider.dart';
import 'features/camp_detail/presentation/providers/camp_detail_provider.dart';
import 'features/camp_detail/presentation/pages/camp_detail_page.dart';
import 'features/search/presentation/pages/search_results_page.dart';
import 'features/booking/presentation/pages/booking_page.dart';
import 'features/booking/presentation/pages/reservation_confirmation_page.dart';
import 'features/booking/presentation/pages/reservation_detail_page.dart';
import 'features/profile/presentation/pages/my_page.dart';
import 'features/review/presentation/pages/review_write_page.dart';
import 'features/review/presentation/pages/review_success_page.dart';
import 'core/network/api_client.dart';
import 'core/network/api_endpoints.dart';
import 'features/home/data/services/camp_api_service.dart';
import 'features/home/data/datasources/camp_remote_datasource.dart';
import 'features/home/data/datasources/camp_local_datasource.dart';
import 'features/home/data/repositories/camp_repository_impl.dart';
import 'features/camp_detail/data/repositories/camp_review_repository_impl.dart';
import 'features/home/domain/usecases/get_featured_camps.dart';
import 'features/home/domain/usecases/get_popular_camps.dart';
import 'features/home/domain/usecases/get_camp_categories.dart';
import 'features/home/domain/usecases/search_camps.dart';
import 'features/home/domain/usecases/get_camp_by_id.dart';
import 'features/camp_detail/domain/usecases/get_camp_reviews.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // SharedPreferences 초기화
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // HTTP 클라이언트 초기화
  final httpClient = http.Client();
  
  // API 클라이언트 초기화
  final apiClient = ApiClient(
    client: httpClient,
    baseUrl: ApiEndpoints.baseApiUrl,
    defaultHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  
  // API 서비스 초기화
  final campApiService = CampApiService(apiClient: apiClient);
  
  // 데이터소스 초기화
  final remoteDataSource = CampRemoteDataSourceImpl(
    apiService: campApiService,
  );
  final localDataSource = CampLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );
  
  // 레포지토리 초기화
  final campRepository = CampRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  final campReviewRepository = CampReviewRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  // Use Case 초기화
  final getFeaturedCamps = GetFeaturedCamps(campRepository);
  final getPopularCamps = GetPopularCamps(campRepository);
  final getCampCategories = GetCampCategories(campRepository);
  final searchCamps = SearchCamps(campRepository);
  final getCampById = GetCampById(campRepository);
  final getCampReviews = GetCampReviews(campReviewRepository);
  
  runApp(MyApp(
    getFeaturedCamps: getFeaturedCamps,
    getPopularCamps: getPopularCamps,
    getCampCategories: getCampCategories,
    searchCamps: searchCamps,
    getCampById: getCampById,
    getCampReviews: getCampReviews,
  ));
}

class MyApp extends StatelessWidget {
  final GetFeaturedCamps getFeaturedCamps;
  final GetPopularCamps getPopularCamps;
  final GetCampCategories getCampCategories;
  final SearchCamps searchCamps;
  final GetCampById getCampById;
  final GetCampReviews getCampReviews;

  const MyApp({
    super.key,
    required this.getFeaturedCamps,
    required this.getPopularCamps,
    required this.getCampCategories,
    required this.searchCamps,
    required this.getCampById,
    required this.getCampReviews,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(
            getFeaturedCamps: getFeaturedCamps,
            getPopularCamps: getPopularCamps,
            getCampCategories: getCampCategories,
            searchCamps: searchCamps,
            getCampById: getCampById,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BookingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookingHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CampDetailProvider(
            getCampById: getCampById,
            getCampReviews: getCampReviews,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Edu Trip Market',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const MainPage(),
          '/search': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is String) {
              return SearchResultsPage(query: args);
            } else if (args is Map<String, dynamic>) {
              return SearchResultsPage(filters: args);
            }
            return const SearchResultsPage();
          },
          '/bookings': (context) => const MainPage(),
          '/profile': (context) => const MainPage(),
          '/camp-detail': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is String) {
              return CampDetailPage(campId: args);
            }
            return const Scaffold(
              body: Center(child: Text('캠프 ID가 필요합니다')),
            );
          },
          '/booking': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is String) {
              return BookingPage(campId: args);
            }
            return const Scaffold(
              body: Center(child: Text('캠프 ID가 필요합니다')),
            );
          },
          '/reservation-confirmation': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is Map<String, dynamic>) {
              return ReservationConfirmationPage(
                reservationId: args['reservationId'] ?? '',
                reservationData: args['reservationData'] ?? {},
              );
            }
            return const Scaffold(
              body: Center(child: Text('예약 데이터가 필요합니다')),
            );
          },
          '/reservation-detail': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is String) {
              return ReservationDetailPage(reservationId: args);
            }
            return const Scaffold(
              body: Center(child: Text('예약 ID가 필요합니다')),
            );
          },
          '/my-page': (context) => const MyPage(),
          '/review-write': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is Map<String, dynamic>) {
              return ReviewWritePage(
                campId: args['campId'] ?? '',
                campName: args['campName'] ?? '',
                campImageUrl: args['campImageUrl'] ?? '',
                dateRange: args['dateRange'] ?? '',
                location: args['location'] ?? '',
              );
            }
            return const Scaffold(
              body: Center(child: Text('후기 작성 데이터가 필요합니다')),
            );
          },
          '/review-success': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            if (args is Map<String, dynamic>) {
              return ReviewSuccessPage(
                campId: args['campId'] ?? '',
                campName: args['campName'] ?? '',
                campImageUrl: args['campImageUrl'] ?? '',
                pointsEarned: args['pointsEarned'] ?? 3000,
              );
            }
            return const Scaffold(
              body: Center(child: Text('후기 성공 데이터가 필요합니다')),
            );
          },
        },
      ),
    );
  }
}