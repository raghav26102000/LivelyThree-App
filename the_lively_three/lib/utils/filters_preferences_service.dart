import 'package:supabase_flutter/supabase_flutter.dart';

class FilterPreferencesService {
  final _supabase = Supabase.instance.client;

  /// Save user's filter preferences
  Future<void> saveFilterPreferences({
    required String userId,
    required int ageCode,
    required int genderCode,
    required int locationCode,
    required int ethnicityCode,
    required bool applyToAllCommunity,
  }) async {
    try {
      // Check if preferences already exist
      final existingPrefs = await _supabase
          .from('user_filter_preferences')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      final data = {
        'user_id': userId,
        'age_code': ageCode,
        'gender_code': genderCode,
        'location_code': locationCode,
        'ethnicity_code': ethnicityCode,
        'apply_to_all_community': true,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (existingPrefs != null) {
        // Update existing preferences
        await _supabase
            .from('user_filter_preferences')
            .update(data)
            .eq('user_id', userId);
      } else {
        // Insert new preferences
        data['created_at'] = DateTime.now().toIso8601String();
        await _supabase.from('user_filter_preferences').insert(data);
      }
    } catch (e) {
      print('Error saving filter preferences: $e');
      rethrow;
    }
  }

  /// Load user's filter preferences
  Future<Map<String, dynamic>?> loadFilterPreferences(String userId) async {
    try {
      final response = await _supabase
          .from('user_filter_preferences')
          .select('age_code, gender_code, location_code, ethnicity_code, apply_to_all_community')
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error loading filter preferences: $e');
      return null;
    }
  }

  /// Clear user's filter preferences
  Future<void> clearFilterPreferences(String userId) async {
    try {
      await _supabase
          .from('user_filter_preferences')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      print('Error clearing filter preferences: $e');
      rethrow;
    }
  }
}