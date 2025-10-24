// Edu Trip Mart Widget Tests
//
// This file contains widget tests for the Edu Trip Mart app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:edu_trip_mart/main.dart';
import 'package:edu_trip_mart/features/home/presentation/providers/home_provider.dart';
import 'package:edu_trip_mart/features/home/domain/usecases/get_featured_camps.dart';
import 'package:edu_trip_mart/features/home/domain/usecases/get_popular_camps.dart';
import 'package:edu_trip_mart/features/home/domain/usecases/get_camp_categories.dart';
import 'package:edu_trip_mart/features/home/domain/usecases/search_camps.dart';
import 'package:edu_trip_mart/features/home/domain/usecases/get_camp_by_id.dart';
import 'package:edu_trip_mart/core/network/api_client.dart';
import 'package:edu_trip_mart/core/network/api_endpoints.dart';
import 'package:edu_trip_mart/features/home/data/services/camp_api_service.dart';
import 'package:edu_trip_mart/features/home/data/datasources/camp_remote_datasource.dart';
import 'package:edu_trip_mart/features/home/data/datasources/camp_local_datasource.dart';
import 'package:edu_trip_mart/features/home/data/repositories/camp_repository_impl.dart';

void main() {
  group('Edu Trip Mart Widget Tests', () {
    late HomeProvider homeProvider;
    late GetFeaturedCamps getFeaturedCamps;
    late GetPopularCamps getPopularCamps;
    late GetCampCategories getCampCategories;
    late SearchCamps searchCamps;
    late GetCampById getCampById;

    setUpAll(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      // Mock HTTP client
      final httpClient = http.Client();

      // Initialize API client
      final apiClient = ApiClient(
        client: httpClient,
        baseUrl: ApiEndpoints.baseApiUrl,
        defaultHeaders: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Initialize API service
      final campApiService = CampApiService(apiClient: apiClient);

      // Initialize data sources
      final remoteDataSource = CampRemoteDataSourceImpl(
        apiService: campApiService,
      );
      final localDataSource = CampLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );

      // Initialize repository
      final campRepository = CampRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );

      // Initialize use cases
      getFeaturedCamps = GetFeaturedCamps(campRepository);
      getPopularCamps = GetPopularCamps(campRepository);
      getCampCategories = GetCampCategories(campRepository);
      searchCamps = SearchCamps(campRepository);
      getCampById = GetCampById(campRepository);

      // Initialize provider
      homeProvider = HomeProvider(
        getFeaturedCamps: getFeaturedCamps,
        getPopularCamps: getPopularCamps,
        getCampCategories: getCampCategories,
        searchCamps: searchCamps,
        getCampById: getCampById,
      );
    });

    testWidgets('App should start without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: homeProvider),
          ],
          child: const MyApp(),
        ),
      );

      // Verify that the app starts without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Home page should display correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: homeProvider),
          ],
          child: const MyApp(),
        ),
      );

      // Wait for the app to load
      await tester.pumpAndSettle();

      // Verify that the home page elements are present
      expect(find.text('Edu Trip Market'), findsOneWidget);
      expect(find.text('해외 영어 캠프를 찾아보세요'), findsOneWidget);
    });
  });
}
