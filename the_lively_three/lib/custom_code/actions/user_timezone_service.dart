import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '/backend/supabase/supabase.dart';

/// Returns a map with userId, timezone identifier & localTime
Future<void> saveUserLocalTime(String userId) async {
  try {
    tz.initializeTimeZones();

    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();

    final String tzIdentifier = timezoneInfo.identifier; // e.g. "Asia/Kolkata"
    final String? localizedTzName = timezoneInfo.localizedName?.name; // maybe "India Standard Time" etc.

    final location = tz.getLocation(tzIdentifier);
    final now = tz.TZDateTime.now(location);

    final result = {
      "userId": userId,
      "timezoneIdentifier": tzIdentifier,
      "timezoneDisplayName": localizedTzName ?? tzIdentifier,
      "localTime": now.toIso8601String(),
    };

    try {
      await UsersTable().update(
        data: {
          'timezone': tzIdentifier,
        },
        matchingRows: (rows) => rows.eqOrNull('id', userId),
      );
      print('✅ User Timezone updated');
    } catch (e) {
      print('❌ Error in updating timezone: $e');
    }

    print("✅ Timezone result: $result");
    // return result;
  } catch (e) {
    print("⚠️ Error fetching timezone for user $userId: $e");
    // return {
    //   "userId": userId,
    //   "timezoneIdentifier": "Unknown",
    //   "timezoneDisplayName": "Unknown",
    //   "localTime": DateTime.now().toIso8601String(),
    // };
  }
}
