// =====================================================
// FILE: lib/models/explore_model.dart
// =====================================================

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Data model combining weekly indicators and streaks
class WeeklyIndicators {
  // Weekly indicators (from user_indicator_values)
  final double healthScoreWeekly;
  final double consistencyScoreWeekly;
  final double averagePortionsWeekly;

  // Current streaks (from userStreaks table)
  final int healthScoreCurrentStreak;
  final int portionCurrentStreak;
  final int colorCurrentStreak;
  final int diversityCurrentStreak;

  // Longest streaks (from userStreaks table)
  final int healthScoreLongestStreak;
  final int portionLongestStreak;
  final int colorLongestStreak;
  final int diversityLongestStreak;

  // Max values (from userStreaks table)
  final int maxDiversityValue;
  final int maxDiversityWeek;
  final int maxDiversityYear;
  final String maxDiversityWeekYear;
  final DateTime? maxPortionDay;
  final double maxPortionValue;

  WeeklyIndicators({
    required this.healthScoreWeekly,
    required this.consistencyScoreWeekly,
    required this.averagePortionsWeekly,
    required this.healthScoreCurrentStreak,
    required this.healthScoreLongestStreak,
    required this.portionCurrentStreak,
    required this.portionLongestStreak,
    required this.colorCurrentStreak,
    required this.colorLongestStreak,
    required this.diversityCurrentStreak,
    required this.diversityLongestStreak,
    required this.maxDiversityValue,
    required this.maxDiversityWeek,
    required this.maxDiversityYear,
    required this.maxDiversityWeekYear,
    this.maxPortionDay,
    required this.maxPortionValue,
  });

  factory WeeklyIndicators.empty() {
    return WeeklyIndicators(
      healthScoreWeekly: 0,
      consistencyScoreWeekly: 0,
      averagePortionsWeekly: 0,
      healthScoreCurrentStreak: 0,
      healthScoreLongestStreak: 0,
      portionCurrentStreak: 0,
      portionLongestStreak: 0,
      colorCurrentStreak: 0,
      colorLongestStreak: 0,
      diversityCurrentStreak: 0,
      diversityLongestStreak: 0,
      maxDiversityValue: 0,
      maxDiversityWeek: 0,
      maxDiversityYear: 0,
      maxDiversityWeekYear: '',
      maxPortionDay: null,
      maxPortionValue: 0,
    );
  }
}

/// Main model for the Explore page
class ExploreModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String? _error;
  WeeklyIndicators? _indicators;
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // ⭐ NEW: Community score tracking
  int? communityHealthScoreIndicatorId;
  double communityHealthScore = 0.0;
  Map<int, double> communityWeeklyScores = {}; // Week number -> Community score
  bool _communityScoresLoaded = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  WeeklyIndicators? get indicators => _indicators;
  bool get communityScoresLoaded => _communityScoresLoaded;

  /// Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Calculate ISO week number
  int getISOWeekNumber(DateTime date) {
    final thursday = date.add(Duration(days: 4 - date.weekday));
    final firstThursday = DateTime(thursday.year, 1, 1);
    final firstThursdayOfYear = firstThursday.add(
      Duration(days: (11 - firstThursday.weekday) % 7),
    );
    final weekNumber =
        1 + (thursday.difference(firstThursdayOfYear).inDays / 7).floor();
    return weekNumber;
  }

  /// ⭐ NEW: Load community indicator ID
  Future<void> loadCommunityIndicatorId({
    required int calendarWeek,
    required int calendarYear,
  }) async {
    try {
      print('🔍 Loading community indicator ID for healthscoreweekly_c...');

      // Get the GLOBAL community ID
      final communityResponse = await _supabase
          .from('community')
          .select('id')
          .eq('code', 'GLOBAL')
          .eq('status', 1)
          .maybeSingle();

      if (communityResponse == null) {
        print('⚠️ GLOBAL community not found');
        return;
      }

      final String communityId = communityResponse['id'];
      print('✅ Found GLOBAL community: $communityId');

      // Fetch community indicator values to get the indicator ID
      final response = await _supabase
          .from('community_indicator_values')
          .select('''
          id_indicator,
          value,
          userindicators(name)
        ''')
          .eq('community_id', communityId)
          .eq('calendarweek', calendarWeek)
          .eq('calendaryear', calendarYear);

      if (response is List && response.isNotEmpty) {
        for (var item in response) {
          final indicatorName = item['userindicators']?['name'];
          if (indicatorName == 'healthscoreweekly_c') {
            communityHealthScoreIndicatorId = item['id_indicator'] as int?;
            print('✅ Community indicator ID stored: $communityHealthScoreIndicatorId');
            break;
          }
        }
      } else {
        print('⚠️ No community indicator found for healthscoreweekly_c');
      }
    } catch (e) {
      print('❌ Error loading community indicator ID: $e');
    }
  }

  /// ⭐ NEW: Load community scores for all weeks in the year
  Future<void> loadCommunityScores({
    required String? communityId,
    required int calendarYear,
    Map<String, dynamic>? filterPreferences,
  }) async {
    try {
      _communityScoresLoaded = false;
      notifyListeners();

      print('🔍 Loading community scores for all weeks...');
      
      if (communityHealthScoreIndicatorId == null) {
        print('⚠️ Community indicator ID not loaded');
        _communityScoresLoaded = true;
        notifyListeners();
        return;
      }

      // Fetch all community scores for the year
      final response = await _supabase
          .from('community_indicator_values')
          .select('calendarweek, value')
          .eq('community_id', communityId ?? 'GLOBAL')
          .eq('id_indicator', communityHealthScoreIndicatorId!)
          .eq('calendaryear', calendarYear)
          .order('calendarweek');

      if (response is List) {
        communityWeeklyScores.clear();
        
        for (var item in response) {
          final week = item['calendarweek'] as int;
          final value = ((item['value'] as num?) ?? 0).toDouble();
          communityWeeklyScores[week] = value;
        }

        print('✅ Loaded ${communityWeeklyScores.length} weeks of community scores');
        print('📊 Community scores by week: $communityWeeklyScores');
      }

      _communityScoresLoaded = true;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading community scores: $e');
      _communityScoresLoaded = true;
      notifyListeners();
    }
  }

  /// Load indicators for the current week
  Future<void> loadCurrentWeekIndicators() async {
    await loadWeekIndicators();
  }

  /// Load indicators for a specific week
  Future<void> loadWeekIndicators({int? weekNumber, int? year}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final uid = currentUserId;
      if (uid == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();
      final week = weekNumber ?? getISOWeekNumber(now);
      final currentYear = year ?? now.year;

      print('=== Loading Explore Data ===');
      print('User: $uid');
      print('Week: $week, Year: $currentYear');

      // ⭐ NEW: Call calculate_user_streaks FIRST to update the userstreaks table
      print('📊 STEP 1: Calculating and updating streaks...');
      await _calculateUserStreaks(uid, week, currentYear);
      print('✅ Streaks calculated and stored in userstreaks table');

// STEP 2: Fetch updated streak data from userstreaks table (UNCHANGED)
      print('📊 STEP 2: Fetching streak data from userstreaks table...');
      final streakData = await _fetchStreakData(uid);

// STEP 3: Fetch weekly indicators (UNCHANGED)
      print('📊 STEP 3: Fetching weekly indicators...');
      final indicators = await _fetchWeeklyIndicators(uid, week, currentYear);

      // // Fetch streak data (ONE row per user, always available!)
      // final streakData = await _fetchStreakData(uid);
      // print('Streaks loaded successfully');

      // // Fetch weekly indicators (health score, consistency, avg portions)
      // final indicators = await _fetchWeeklyIndicators(uid, week, currentYear);
      print('Weekly indicators loaded successfully');

      _indicators = WeeklyIndicators(
        // Weekly indicators
        healthScoreWeekly: indicators['healthScore'] ?? 0,
        consistencyScoreWeekly: indicators['consistency'] ?? 0,
        averagePortionsWeekly: indicators['avgPortions'] ?? 0,

        // Current streaks (always available!)
        healthScoreCurrentStreak: streakData['healthScoreCurrentStreak'] ?? 0,
        portionCurrentStreak: streakData['portionCurrentStreak'] ?? 0,
        colorCurrentStreak: streakData['colorCurrentStreak'] ?? 0,
        diversityCurrentStreak: streakData['diversityCurrentStreak'] ?? 0,

        // Longest streaks
        healthScoreLongestStreak: streakData['healthScoreLongestStreak'] ?? 0,
        portionLongestStreak: streakData['portionLongestStreak'] ?? 0,
        colorLongestStreak: streakData['colorLongestStreak'] ?? 0,
        diversityLongestStreak: streakData['diversityLongestStreak'] ?? 0,

        // Max values
        maxDiversityValue: streakData['maxDiversityValue'] ?? 0,
        maxDiversityWeek: streakData['maxDiversityWeek'] ?? 0,
        maxDiversityYear: streakData['maxDiversityYear'] ?? 0,
        maxDiversityWeekYear:
            '${streakData['maxDiversityWeek']}, ${streakData['maxDiversityYear']}',
        maxPortionDay: streakData['maxPortionDay'],
        maxPortionValue: streakData['maxPortionValue'] ?? 0,
      );

      print('=== Data Loaded Successfully ===');
      print('Health Score: ${_indicators?.healthScoreWeekly}%');
      print('Consistency: ${_indicators?.consistencyScoreWeekly}%');
      print('Streaks - Portion: ${_indicators?.portionCurrentStreak}, '
          'Diversity: ${_indicators?.diversityCurrentStreak}, '
          'Color: ${_indicators?.colorCurrentStreak}, '
          'Health: ${_indicators?.healthScoreCurrentStreak}');
    } catch (e, stackTrace) {
      print('=== Error Loading Explore Data ===');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      _error = e.toString();
      _indicators = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ⭐ NEW METHOD: Call the calculate_user_streaks RPC function
  /// This function calculates streaks and UPDATES the userstreaks table
  Future<void> _calculateUserStreaks(String userId, int week, int year) async {
    try {
      print('🔄 Calling calculate_user_streaks RPC function...');
      print('   Parameters: user_id=$userId, week=$week, year=$year');

      // Call the RPC function
      // This function will calculate and UPDATE the userstreaks table
      await _supabase.rpc(
        'calculate_user_streaks',
        params: {
          'p_user_id': userId,
          // 'p_week': week,
          // 'p_year': year,
        },
      );

      print('✅ calculate_user_streaks completed successfully');
    } on PostgrestException catch (e) {
      print('❌ PostgrestException in calculate_user_streaks:');
      print('   Message: ${e.message}');
      print('   Details: ${e.details}');
      print('   Hint: ${e.hint}');
      print('   Code: ${e.code}');
      throw Exception('Failed to calculate streaks: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error in calculate_user_streaks: $e');
      throw Exception('Failed to calculate streaks: $e');
    }
  }

  /// Fetch streak data from userStreaks table (ONE row per user)
  Future<Map<String, dynamic>> _fetchStreakData(String userId) async {
    try {
      print('Fetching streak data from userstreaks table...');

      final response = await _supabase
          .from('userstreaks')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        print('No streak data found, returning defaults');
        return {
          'healthScoreCurrentStreak': 0,
          'healthScoreLongestStreak': 0,
          'portionCurrentStreak': 0,
          'portionLongestStreak': 0,
          'colorCurrentStreak': 0,
          'colorLongestStreak': 0,
          'diversityCurrentStreak': 0,
          'diversityLongestStreak': 0,
          'maxDiversityValue': 0,
          'maxDiversityWeek': 0,
          'maxDiversityYear': 0,
          'maxPortionDay': null,
          'maxPortionValue': 0.0,
        };
      }

      print('Streak data found: ${response.toString()}');

      return {
        'healthScoreCurrentStreak': response['healthscorestreakcurrent'] ?? 0,
        'healthScoreLongestStreak': response['healthscorestreaklongest'] ?? 0,
        'portionCurrentStreak': response['portionstreakcurrent'] ?? 0,
        'portionLongestStreak': response['portionstreaklongest'] ?? 0,
        'colorCurrentStreak': response['colorstreakcurrent'] ?? 0,
        'colorLongestStreak': response['colorstreaklongest'] ?? 0,
        'diversityCurrentStreak': response['diversitystreakcurrent'] ?? 0,
        'diversityLongestStreak': response['diversitystreaklongest'] ?? 0,
        'maxDiversityValue': response['maxdiversityvalue'] ?? 0,
        'maxDiversityWeek': response['maxdiversityweek'] ?? 0,
        'maxDiversityYear': response['maxdiversityyear'] ?? 0,
        'maxPortionDay': response['maxportionday'] != null
            ? DateTime.parse(response['maxportionday'])
            : null,
        'maxPortionValue':
            ((response['maxportionvalue'] as num?) ?? 0).toDouble(),
      };
    } catch (e) {
      print('Error fetching streak data: $e');
      rethrow;
    }
  }

  /// Fetch weekly indicators from user_indicator_values table
  Future<Map<String, double>> _fetchWeeklyIndicators(
      String userId, int week, int year) async {
    try {
      print('Fetching weekly indicators for week $week, year $year...');

      // Get indicator IDs
      final indicatorIds = await _supabase
          .from('userindicators')
          .select('id, name')
          .inFilter('name', [
        'healthscoreweekly_i',
        'consistencyscoreweekly_i',
        'averageportionsweekly_i',
      ]);

      print('Indicator IDs: $indicatorIds');

      // Create map of names to IDs
      final idMap = <String, int>{};
      for (var item in indicatorIds) {
        idMap[item['name'] as String] = item['id'] as int;
      }

      // Fetch values for current week
      final values = await _supabase
          .from('user_indicator_values')
          .select('id_indicator, value')
          .eq('id_user', userId)
          .eq('calendarweek', week)
          .eq('calendaryear', year)
          .inFilter('id_indicator', idMap.values.toList());

      print('Indicator values: $values');

      // Extract values
      double healthScore = 0.0;
      double consistency = 0.0;
      double avgPortions = 0.0;

      for (var item in values) {
        final indicatorId = item['id_indicator'] as int;
        final value = ((item['value'] as num?) ?? 0).toDouble();

        if (indicatorId == idMap['healthscoreweekly_i']) {
          healthScore = value;
        } else if (indicatorId == idMap['consistencyscoreweekly_i']) {
          consistency = value;
        } else if (indicatorId == idMap['averageportionsweekly_i']) {
          avgPortions = value;
        }
      }

      print(
          'Parsed - Health: $healthScore, Consistency: $consistency, Avg: $avgPortions');

      return {
        'healthScore': healthScore,
        'consistency': consistency,
        'avgPortions': avgPortions,
      };
    } catch (e) {
      print('Error fetching weekly indicators: $e');
      rethrow;
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadCurrentWeekIndicators();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
// import 'package:the_lively_three/backend/supabase/database/database.dart';
// import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
// import 'package:the_lively_three/models/weekly_indicators.dart';
// import 'package:the_lively_three/utils/indicators_service.dart';

// class ExploreModel with ChangeNotifier {
//   final IndicatorsService _indicatorsService = IndicatorsService();

//   WeeklyIndicators? _indicators;
//   bool _isLoading = false;
//   String? _error;

//   // Getters
//   WeeklyIndicators? get indicators => _indicators;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   ExploreModel() {
//     // Constructor - can be empty or initialize values
//   }

//   /// Load current week indicators
//   Future<void> loadCurrentWeekIndicators() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       print('Loading current week indicators...');
//       _indicators = await _indicatorsService.getCurrentWeekIndicators(
//           FFAppState().calendarWeek, FFAppState().calendarYear);
//       _error = null;
//       print('Indicators loaded successfully: $_indicators');
//     } catch (e) {
//       _error = e.toString();
//       _indicators = null;
//       print('Error loading indicators: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     print('ExploreModel disposed');
//     super.dispose();
//   }

//   static String getCurrentDate() {
//     final DateTime now = DateTime.now();
//     final DateFormat formatter = DateFormat('dd MMM - EEE');
//     return formatter.format(now);
//   }

//   // Add this helper method to safely convert numeric values
//   int? _toInt(dynamic value) {
//     if (value == null) return null;
//     if (value is int) return value;
//     if (value is double) return value.toInt();
//     return null;
//   }

//   double? _toDouble(dynamic value) {
//     if (value == null) return null;
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     return null;
//   }
// }


// // =====================================================
// // FILE: lib/models/explore_model.dart
// // =====================================================

// import 'package:carousel_slider/carousel_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// /// Data model combining weekly indicators and streaks
// class WeeklyIndicators {
//   // Weekly indicators (from user_indicator_values)
//   final double healthScoreWeekly;
//   final double consistencyScoreWeekly;
//   final double averagePortionsWeekly;

//   // Current streaks (from userStreaks table)
//   final int healthScoreCurrentStreak;
//   final int portionCurrentStreak;
//   final int colorCurrentStreak;
//   final int diversityCurrentStreak;

//   // Longest streaks (from userStreaks table)
//   final int healthScoreLongestStreak;
//   final int portionLongestStreak;
//   final int colorLongestStreak;
//   final int diversityLongestStreak;

//   // Max values (from userStreaks table)
//   final int maxDiversityValue;
//   final int maxDiversityWeek;
//   final int maxDiversityYear;
//   final String maxDiversityWeekYear;
//   final DateTime? maxPortionDay;
//   final double maxPortionValue;

//   WeeklyIndicators({
//     required this.healthScoreWeekly,
//     required this.consistencyScoreWeekly,
//     required this.averagePortionsWeekly,
//     required this.healthScoreCurrentStreak,
//     required this.healthScoreLongestStreak,
//     required this.portionCurrentStreak,
//     required this.portionLongestStreak,
//     required this.colorCurrentStreak,
//     required this.colorLongestStreak,
//     required this.diversityCurrentStreak,
//     required this.diversityLongestStreak,
//     required this.maxDiversityValue,
//     required this.maxDiversityWeek,
//     required this.maxDiversityYear,
//     required this.maxDiversityWeekYear,
//     this.maxPortionDay,
//     required this.maxPortionValue,
//   });

//   factory WeeklyIndicators.empty() {
//     return WeeklyIndicators(
//       healthScoreWeekly: 0,
//       consistencyScoreWeekly: 0,
//       averagePortionsWeekly: 0,
//       healthScoreCurrentStreak: 0,
//       healthScoreLongestStreak: 0,
//       portionCurrentStreak: 0,
//       portionLongestStreak: 0,
//       colorCurrentStreak: 0,
//       colorLongestStreak: 0,
//       diversityCurrentStreak: 0,
//       diversityLongestStreak: 0,
//       maxDiversityValue: 0,
//       maxDiversityWeek: 0,
//       maxDiversityYear: 0,
//       maxDiversityWeekYear: '',
//       maxPortionDay: null,
//       maxPortionValue: 0,
//     );
//   }
// }

// /// Main model for the Explore page
// class ExploreModel extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   bool _isLoading = false;
//   String? _error;
//   WeeklyIndicators? _indicators;
//   CarouselSliderController? carouselController;
//   int carouselCurrentIndex = 1;

//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   WeeklyIndicators? get indicators => _indicators;

//   /// Get current user ID
//   String? get currentUserId => _supabase.auth.currentUser?.id;

//   /// Calculate ISO week number
//   int getISOWeekNumber(DateTime date) {
//     final thursday = date.add(Duration(days: 4 - date.weekday));
//     final firstThursday = DateTime(thursday.year, 1, 1);
//     final firstThursdayOfYear = firstThursday.add(
//       Duration(days: (11 - firstThursday.weekday) % 7),
//     );
//     final weekNumber =
//         1 + (thursday.difference(firstThursdayOfYear).inDays / 7).floor();
//     return weekNumber;
//   }

//   /// Load indicators for the current week
//   Future<void> loadCurrentWeekIndicators() async {
//     await loadWeekIndicators();
//   }

//   /// Load indicators for a specific week
//   Future<void> loadWeekIndicators({int? weekNumber, int? year}) async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       final uid = currentUserId;
//       if (uid == null) {
//         throw Exception('User not authenticated');
//       }

//       final now = DateTime.now();
//       final week = weekNumber ?? getISOWeekNumber(now);
//       final currentYear = year ?? now.year;

//       print('=== Loading Explore Data ===');
//       print('User: $uid');
//       print('Week: $week, Year: $currentYear');

//       // ⭐ NEW: Call calculate_user_streaks FIRST to update the userstreaks table
//       print('📊 STEP 1: Calculating and updating streaks...');
//       await _calculateUserStreaks(uid, week, currentYear);
//       print('✅ Streaks calculated and stored in userstreaks table');

// // STEP 2: Fetch updated streak data from userstreaks table (UNCHANGED)
//       print('📊 STEP 2: Fetching streak data from userstreaks table...');
//       final streakData = await _fetchStreakData(uid);

// // STEP 3: Fetch weekly indicators (UNCHANGED)
//       print('📊 STEP 3: Fetching weekly indicators...');
//       final indicators = await _fetchWeeklyIndicators(uid, week, currentYear);

//       // // Fetch streak data (ONE row per user, always available!)
//       // final streakData = await _fetchStreakData(uid);
//       // print('Streaks loaded successfully');

//       // // Fetch weekly indicators (health score, consistency, avg portions)
//       // final indicators = await _fetchWeeklyIndicators(uid, week, currentYear);
//       print('Weekly indicators loaded successfully');

//       _indicators = WeeklyIndicators(
//         // Weekly indicators
//         healthScoreWeekly: indicators['healthScore'] ?? 0,
//         consistencyScoreWeekly: indicators['consistency'] ?? 0,
//         averagePortionsWeekly: indicators['avgPortions'] ?? 0,

//         // Current streaks (always available!)
//         healthScoreCurrentStreak: streakData['healthScoreCurrentStreak'] ?? 0,
//         portionCurrentStreak: streakData['portionCurrentStreak'] ?? 0,
//         colorCurrentStreak: streakData['colorCurrentStreak'] ?? 0,
//         diversityCurrentStreak: streakData['diversityCurrentStreak'] ?? 0,

//         // Longest streaks
//         healthScoreLongestStreak: streakData['healthScoreLongestStreak'] ?? 0,
//         portionLongestStreak: streakData['portionLongestStreak'] ?? 0,
//         colorLongestStreak: streakData['colorLongestStreak'] ?? 0,
//         diversityLongestStreak: streakData['diversityLongestStreak'] ?? 0,

//         // Max values
//         maxDiversityValue: streakData['maxDiversityValue'] ?? 0,
//         maxDiversityWeek: streakData['maxDiversityWeek'] ?? 0,
//         maxDiversityYear: streakData['maxDiversityYear'] ?? 0,
//         maxDiversityWeekYear:
//             '${streakData['maxDiversityWeek']}, ${streakData['maxDiversityYear']}',
//         maxPortionDay: streakData['maxPortionDay'],
//         maxPortionValue: streakData['maxPortionValue'] ?? 0,
//       );

//       print('=== Data Loaded Successfully ===');
//       print('Health Score: ${_indicators?.healthScoreWeekly}%');
//       print('Consistency: ${_indicators?.consistencyScoreWeekly}%');
//       print('Streaks - Portion: ${_indicators?.portionCurrentStreak}, '
//           'Diversity: ${_indicators?.diversityCurrentStreak}, '
//           'Color: ${_indicators?.colorCurrentStreak}, '
//           'Health: ${_indicators?.healthScoreCurrentStreak}');
//     } catch (e, stackTrace) {
//       print('=== Error Loading Explore Data ===');
//       print('Error: $e');
//       print('Stack trace: $stackTrace');
//       _error = e.toString();
//       _indicators = null;
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// ⭐ NEW METHOD: Call the calculate_user_streaks RPC function
//   /// This function calculates streaks and UPDATES the userstreaks table
//   Future<void> _calculateUserStreaks(String userId, int week, int year) async {
//     try {
//       print('🔄 Calling calculate_user_streaks RPC function...');
//       print('   Parameters: user_id=$userId, week=$week, year=$year');

//       // Call the RPC function
//       // This function will calculate and UPDATE the userstreaks table
//       await _supabase.rpc(
//         'calculate_user_streaks',
//         params: {
//           'p_user_id': userId,
//           // 'p_week': week,
//           // 'p_year': year,
//         },
//       );

//       print('✅ calculate_user_streaks completed successfully');
//     } on PostgrestException catch (e) {
//       print('❌ PostgrestException in calculate_user_streaks:');
//       print('   Message: ${e.message}');
//       print('   Details: ${e.details}');
//       print('   Hint: ${e.hint}');
//       print('   Code: ${e.code}');
//       throw Exception('Failed to calculate streaks: ${e.message}');
//     } catch (e) {
//       print('❌ Unexpected error in calculate_user_streaks: $e');
//       throw Exception('Failed to calculate streaks: $e');
//     }
//   }

//   /// Fetch streak data from userStreaks table (ONE row per user)
//   Future<Map<String, dynamic>> _fetchStreakData(String userId) async {
//     try {
//       print('Fetching streak data from userstreaks table...');

//       final response = await _supabase
//           .from('userstreaks')
//           .select('*')
//           .eq('user_id', userId)
//           .maybeSingle();

//       if (response == null) {
//         print('No streak data found, returning defaults');
//         return {
//           'healthScoreCurrentStreak': 0,
//           'healthScoreLongestStreak': 0,
//           'portionCurrentStreak': 0,
//           'portionLongestStreak': 0,
//           'colorCurrentStreak': 0,
//           'colorLongestStreak': 0,
//           'diversityCurrentStreak': 0,
//           'diversityLongestStreak': 0,
//           'maxDiversityValue': 0,
//           'maxDiversityWeek': 0,
//           'maxDiversityYear': 0,
//           'maxPortionDay': null,
//           'maxPortionValue': 0.0,
//         };
//       }

//       print('Streak data found: ${response.toString()}');

//       return {
//         'healthScoreCurrentStreak': response['healthscorestreakcurrent'] ?? 0,
//         'healthScoreLongestStreak': response['healthscorestreaklongest'] ?? 0,
//         'portionCurrentStreak': response['portionstreakcurrent'] ?? 0,
//         'portionLongestStreak': response['portionstreaklongest'] ?? 0,
//         'colorCurrentStreak': response['colorstreakcurrent'] ?? 0,
//         'colorLongestStreak': response['colorstreaklongest'] ?? 0,
//         'diversityCurrentStreak': response['diversitystreakcurrent'] ?? 0,
//         'diversityLongestStreak': response['diversitystreaklongest'] ?? 0,
//         'maxDiversityValue': response['maxdiversityvalue'] ?? 0,
//         'maxDiversityWeek': response['maxdiversityweek'] ?? 0,
//         'maxDiversityYear': response['maxdiversityyear'] ?? 0,
//         'maxPortionDay': response['maxportionday'] != null
//             ? DateTime.parse(response['maxportionday'])
//             : null,
//         'maxPortionValue':
//             ((response['maxportionvalue'] as num?) ?? 0).toDouble(),
//       };
//     } catch (e) {
//       print('Error fetching streak data: $e');
//       rethrow;
//     }
//   }

//   /// Fetch weekly indicators from user_indicator_values table
//   Future<Map<String, double>> _fetchWeeklyIndicators(
//       String userId, int week, int year) async {
//     try {
//       print('Fetching weekly indicators for week $week, year $year...');

//       // Get indicator IDs
//       final indicatorIds = await _supabase
//           .from('userindicators')
//           .select('id, name')
//           .inFilter('name', [
//         'healthscoreweekly_i',
//         'consistencyscoreweekly_i',
//         'averageportionsweekly_i',
//       ]);

//       print('Indicator IDs: $indicatorIds');

//       // Create map of names to IDs
//       final idMap = <String, int>{};
//       for (var item in indicatorIds) {
//         idMap[item['name'] as String] = item['id'] as int;
//       }

//       // Fetch values for current week
//       final values = await _supabase
//           .from('user_indicator_values')
//           .select('id_indicator, value')
//           .eq('id_user', userId)
//           .eq('calendarweek', week)
//           .eq('calendaryear', year)
//           .inFilter('id_indicator', idMap.values.toList());

//       print('Indicator values: $values');

//       // Extract values
//       double healthScore = 0.0;
//       double consistency = 0.0;
//       double avgPortions = 0.0;

//       for (var item in values) {
//         final indicatorId = item['id_indicator'] as int;
//         final value = ((item['value'] as num?) ?? 0).toDouble();

//         if (indicatorId == idMap['healthscoreweekly_i']) {
//           healthScore = value;
//         } else if (indicatorId == idMap['consistencyscoreweekly_i']) {
//           consistency = value;
//         } else if (indicatorId == idMap['averageportionsweekly_i']) {
//           avgPortions = value;
//         }
//       }

//       print(
//           'Parsed - Health: $healthScore, Consistency: $consistency, Avg: $avgPortions');

//       return {
//         'healthScore': healthScore,
//         'consistency': consistency,
//         'avgPortions': avgPortions,
//       };
//     } catch (e) {
//       print('Error fetching weekly indicators: $e');
//       rethrow;
//     }
//   }

//   /// Refresh all data
//   Future<void> refresh() async {
//     await loadCurrentWeekIndicators();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

// // import 'package:flutter/foundation.dart';
// // import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
// // import 'package:the_lively_three/backend/supabase/database/database.dart';
// // import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
// // import 'package:the_lively_three/models/weekly_indicators.dart';
// // import 'package:the_lively_three/utils/indicators_service.dart';

// // class ExploreModel with ChangeNotifier {
// //   final IndicatorsService _indicatorsService = IndicatorsService();

// //   WeeklyIndicators? _indicators;
// //   bool _isLoading = false;
// //   String? _error;

// //   // Getters
// //   WeeklyIndicators? get indicators => _indicators;
// //   bool get isLoading => _isLoading;
// //   String? get error => _error;

// //   ExploreModel() {
// //     // Constructor - can be empty or initialize values
// //   }

// //   /// Load current week indicators
// //   Future<void> loadCurrentWeekIndicators() async {
// //     _isLoading = true;
// //     _error = null;
// //     notifyListeners();

// //     try {
// //       print('Loading current week indicators...');
// //       _indicators = await _indicatorsService.getCurrentWeekIndicators(
// //           FFAppState().calendarWeek, FFAppState().calendarYear);
// //       _error = null;
// //       print('Indicators loaded successfully: $_indicators');
// //     } catch (e) {
// //       _error = e.toString();
// //       _indicators = null;
// //       print('Error loading indicators: $e');
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     print('ExploreModel disposed');
// //     super.dispose();
// //   }

// //   static String getCurrentDate() {
// //     final DateTime now = DateTime.now();
// //     final DateFormat formatter = DateFormat('dd MMM - EEE');
// //     return formatter.format(now);
// //   }

// //   // Add this helper method to safely convert numeric values
// //   int? _toInt(dynamic value) {
// //     if (value == null) return null;
// //     if (value is int) return value;
// //     if (value is double) return value.toInt();
// //     return null;
// //   }

// //   double? _toDouble(dynamic value) {
// //     if (value == null) return null;
// //     if (value is double) return value;
// //     if (value is int) return value.toDouble();
// //     return null;
// //   }
// // }
