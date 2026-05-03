import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/models/weekly_indicators.dart';

class IndicatorsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch current week indicators for the logged-in user
  Future<WeeklyIndicators> getCurrentWeekIndicators(week, year) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Calculate current ISO week and year
      final now = DateTime.now();
      final currentWeek = week; //_getISOWeekNumber(now);
      final currentYear = year; //_getISOYear(now);

      print(
          '21Fetching indicators for user: $userId, week: $currentWeek, year: $currentYear');

      // Call the function with 3 parameters
      final response = await _supabase.rpc('get_weekly_indicators', params: {
        'p_user_id': userId,
        'p_calendar_week': currentWeek,
        'p_calendar_year': currentYear,
      });

      print('Indicators Response: $response');

      if (response == null || (response is List && response.isEmpty)) {
        print('No indicators found, returning empty');
        return WeeklyIndicators.empty();
      }

      return WeeklyIndicators.fromJson(response);
    } catch (e) {
      print('Error fetching current week indicators: $e');
      rethrow;
    }
  }

  /// Fetch indicators for a specific week and year
  Future<WeeklyIndicators> getWeekIndicators({
    required int week,
    required int year,
  }) async {
    try {
      final userId = currentUserUid;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('Fetching indicators for user: $userId, week: $week, year: $year');

      // Call the function with 3 parameters
      final response = await _supabase.rpc('get_weekly_indicators', params: {
        'p_user_id': userId,
        'p_calendar_week': week,
        'p_calendar_year': year,
      });

      print('Indicators Response: $response');

      if (response == null || (response is List && response.isEmpty)) {
        print('No indicators found, returning empty');
        return WeeklyIndicators.empty();
      }

      return WeeklyIndicators.fromJson(response);
    } catch (e) {
      print('Error fetching indicators for week $week, year $year: $e');
      rethrow;
    }
  }

  /// Calculate ISO week number for a given date
  int _getISOWeekNumber(DateTime date) {
    // ISO 8601 week number calculation
    final thursday = date.add(Duration(days: 3 - date.weekday));
    final firstThursday = DateTime(thursday.year, 1, 4);
    final weekNumber =
        ((thursday.difference(firstThursday).inDays / 7).floor() + 1);
    return weekNumber;
  }

  /// Get ISO year for a given date
  /// (ISO year can be different from calendar year for dates in week 1 or 53)
  int _getISOYear(DateTime date) {
    final thursday = date.add(Duration(days: 3 - date.weekday));
    return thursday.year;
  }

  /// Helper method to get week number and year for any date
  Map<String, int> getWeekAndYear(DateTime date) {
    return {
      'week': _getISOWeekNumber(date),
      'year': _getISOYear(date),
    };
  }
}
