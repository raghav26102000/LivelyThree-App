import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class UserTimezoneService {
  static final UserTimezoneService _instance = UserTimezoneService._internal();
  factory UserTimezoneService() => _instance;
  UserTimezoneService._internal();

  String? _cachedTimezone;
  String? _cachedUserId;

  Future<void> initializeTimezones() async {
    tz.initializeTimeZones();
  }

  Future<String> getUserTimezone(String userId) async {
    // Return cached timezone if available for this user
    if (_cachedUserId == userId && _cachedTimezone != null) {
      return _cachedTimezone!;
    }

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('users')
          .select('timezone')
          .eq('id', userId)
          .single();

      if (response != null && response['timezone'] != null) {
        _cachedTimezone = response['timezone'] as String;
        _cachedUserId = userId;
        return _cachedTimezone!;
      }
    } catch (e) {
      print('Error fetching user timezone: $e');
    }

    // Fallback to UTC if timezone not found
    return 'UTC';
  }

  DateTime getUserNow(String userId, String timezone) {
    try {
      final location = tz.getLocation(timezone);
      return tz.TZDateTime.now(location);
    } catch (e) {
      print('Error getting timezone location: $e');
      return DateTime.now().toUtc();
    }
  }

  String formatDateForDB(DateTime dateTime) {
    // Returns YYYY-MM-DD format
    return dateTime.toIso8601String().split('T').first;
  }

  DateTime convertToUserTimezone(DateTime utcDateTime, String timezone) {
    try {
      final location = tz.getLocation(timezone);
      return tz.TZDateTime.from(utcDateTime, location);
    } catch (e) {
      print('Error converting to user timezone: $e');
      return utcDateTime;
    }
  }

  void clearCache() {
    _cachedTimezone = null;
    _cachedUserId = null;
  }
}