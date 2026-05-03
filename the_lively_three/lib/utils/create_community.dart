import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_user_to_communities.dart';
import 'package:intl/intl.dart';

class CreateCommunityService {
  final SupabaseClient supabase = Supabase.instance.client;
  final updateCommunities = UpdateCommunityService();

  /// 🔹 Creates a community if one with the same filters doesn't exist
  Future<Map<String, dynamic>> createCommunityWithUsers({
    required int age,
    required int gender,
    required int location,
    required int ethnicity,
  }) async {
    try {
      String? genderValue;
      String? ageKey1;
      final genderLookup = await supabase
          .from('codelkup')
          .select('key1')
          .eq('lkcode', 'Gender')
          .eq('keycode', gender)
          .maybeSingle();

      if (genderLookup != null && genderLookup['key1'] != null) {
        genderValue = genderLookup['key1'] as String;
        print('👥 Gender code $gender → "$genderValue"');
      } else {
        print(
            '⚠️ No Gender found for keycode $gender, ignoring gender filter.');
      }

      final ageLookup = await supabase
          .from('codelkup')
          .select('key1')
          .eq('lkcode', 'age_group')
          .eq('keycode', age)
          .maybeSingle();
      if (ageLookup != null && ageLookup['key1'] != null) {
        ageKey1 = ageLookup['key1'] as String;
        print('🎂 Age group code $age → "$ageKey1"');
      }
      // 1️⃣ Generate code and name based on filters
      final String communityCode = '$genderValue-$ageKey1';
      final String communityName =
          communityCode; // Same as code (you can change if needed)

      print('🔍 Checking for community: code=$communityCode');

      // 2️⃣ Check if community already exists
      final existingCommunity = await supabase
          .from('community')
          .select('id, name, code')
          .eq('age', age)
          .eq('gender', gender)
          .eq('location', location)
          .eq('ethnicity', ethnicity)
          .maybeSingle();

      if (existingCommunity != null) {
        print(
            '✅ Community already exists: ${existingCommunity['name']} (${existingCommunity['id']})');

        final now = DateTime.now();

        // Calculate ISO week number properly
        final isoWeek = _getISOWeekNumber(now);
        final isoYear = _getISOWeekYear(now);

        final existingValue = await supabase
                .from('community_indicator_values')
                .select('id_indicator, value')
                .eq('community_id', existingCommunity['id'])
                //.eq('id_indicator', 17)
                .eq('calendarweek', isoWeek)
                .eq('calendaryear', isoYear) ??
            [];

        final Map<int, double> allIndicators = {};

        for (var row in existingValue) {
          final indicatorId = row['id_indicator'] as int;

          final dynamic rawValue = row['value'];
          double parsedValue = 0.0;

          if (rawValue is num) {
            parsedValue = rawValue.toDouble();
          } else if (rawValue is String) {
            parsedValue = double.tryParse(rawValue) ?? 0.0;
          } else {
            // if it's a map or something unexpected
            parsedValue = 0.0;
          }

          allIndicators[indicatorId] = parsedValue;
        }

        print(
            '✅ Value for community ${existingCommunity['name']} (${existingCommunity['id']}): $existingValue');

        final String communityId = existingCommunity['id'];

        return {"communityId": communityId, "indicators": allIndicators};
      }

      // 3️⃣ Create new community since it doesn't exist
      print('🆕 Creating new community → $communityName');
      final newCommunity = await supabase
          .from('community')
          .insert({
            'code': communityCode,
            'name': communityName,
            'description':
                'Auto-created community for filters (location:$location, ethnicity:$ethnicity, age:$age, gender:$gender)',
            'age': age,
            'gender': gender,
            'location': location,
            'ethnicity': ethnicity,
            'created_at': DateTime.now().toUtc().toIso8601String(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
            'status': 1,
          })
          .select('id, name, code')
          .single();

      print(
          '✅ Created new community: ${newCommunity['name']} (${newCommunity['id']})');
      await updateCommunities
          .updateUserCommunitiesForCommunity(newCommunity['id']);
      return {};
    } catch (e) {
      print('❌ Error creating/checking community: $e');
      return {};
    }
  }

  int _getISOWeekNumber(DateTime date) {
    // ISO 8601 week starts on Monday
    final dayOfYear = int.parse(DateFormat("D").format(date));
    final weekDay = date.weekday; // Monday = 1, Sunday = 7

    // Thursday of the current week determines the week number
    final thursdayOfWeek = dayOfYear + (4 - weekDay);

    return ((thursdayOfWeek - 1) / 7).ceil();
  }

// Helper function to get the ISO week year
  int _getISOWeekYear(DateTime date) {
    final week = _getISOWeekNumber(date);
    final year = date.year;

    // If week is 53 or 52 and it's early January, it belongs to previous year
    if (date.month == 1 && week >= 52) {
      return year - 1;
    }
    // If week is 1 and it's late December, it belongs to next year
    if (date.month == 12 && week == 1) {
      return year + 1;
    }

    return year;
  }
}
