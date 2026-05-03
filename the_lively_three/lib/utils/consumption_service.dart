import 'package:supabase_flutter/supabase_flutter.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConsumptionService {
  final supabase = Supabase.instance.client;

  Future<void> insertDailyConsumption({
    required String userId,
    required int? blueprintId,
    required double portionToInsert,
    required int quantity,
    required int week,
    required int year,
    required String consumptionOn,
    required int dayNumber,
    required int dietarySource,
    required int plantId,
    required int colorCode,
  }) async {
    final payload = {
      'user_id': userId,
      'plant_id': blueprintId,
      'portion_size': portionToInsert,
      'quantity': quantity,
      'calender_week': week,
      'calender_year': year,
      'consumptionon': consumptionOn,
      'createdby': userId,
      'day_number': dayNumber,
      'dietary_source': dietarySource,
      'localized_plant_id': plantId,
      'color': colorCode,
    };

    print('Inserting consumption: $payload');
    
    try {
      // Insert consumption record
      await supabase.from('dailyuserconsumption').insert(payload);
      print('Consumption inserted successfully');

      // Call the two notification functions
      await _callNotificationFunctions(userId);
      
    } catch (e) {
      print('Error in insertDailyConsumption: $e');
      rethrow;
    }
  }

  Future<void> _callNotificationFunctions(String userId) async {
    try {
      // Call check_and_insert_consumption_notification
      await supabase.rpc(
        'check_and_insert_consumption_notification',
        params: {'p_user': userId},
      );
      print('check_and_insert_consumption_notification called successfully');
    } catch (e) {
      print('Error calling check_and_insert_consumption_notification: $e');
      // Don't rethrow - we don't want notification failures to break consumption insertion
    }

    try {
      // Call check_and_insert_healthscore_notification
      await supabase.rpc(
        'check_and_insert_healthscore_notification',
        params: {'p_user': userId},
      );
      print('check_and_insert_healthscore_notification called successfully');
    } catch (e) {
      print('Error calling check_and_insert_healthscore_notification: $e');
      // Don't rethrow - we don't want notification failures to break consumption insertion
    }
  }

  DateTime isoWeekDate(int year, int week, int weekday) {
    final jan4 = DateTime(year, 1, 4);
    final jan4Weekday = jan4.weekday;
    final week1Monday = jan4.subtract(Duration(days: jan4Weekday - 1));
    final target =
        week1Monday.add(Duration(days: (week - 1) * 7 + (weekday - 1)));
    return target;
  }
}