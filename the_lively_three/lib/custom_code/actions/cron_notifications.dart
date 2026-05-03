// import 'package:cron/cron.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tzdata;
// import '/backend/supabase/supabase.dart';

// Future<void> main() async {
//   // Initialize Supabase
//   final supabase = Supabase.instance.client;

//   // Initialize timezone data
//   tzdata.initializeTimeZones();

//   // Create cron job: check every 5 minutes
//   final cron = Cron();
//   cron.schedule(Schedule.parse('*/5 * * * *'), () async {
//     await checkAndSendNotifications(supabase);
//   });
// }

// Future<void> checkAndSendNotifications(SupabaseClient supabase) async {
//   // Fetch all users with devices
//   final response = await supabase
//       .from('user_devices')
//       .select('user_id, users(timezone)')
//       .eq('active', true); // if you have active flag

//   final users = response as List;

//   final nowUtc = DateTime.now().toUtc();

//   for (var u in users) {
//     final userId = u['user_id'];
//     final timezone = u['users']['timezone'];
//     if (timezone == null) continue;

//     try {
//       final location = tz.getLocation(timezone);
//       final userNow = tz.TZDateTime.from(nowUtc, location);

//       // Check if it's exactly 8 PM for this user
//       if (userNow.hour == 20 && userNow.minute < 5) {
//         // Check daily consumption
//         final today = DateTime(userNow.year, userNow.month, userNow.day);
//         final week = int.parse(DateFormat('w').format(today));
//         final year = today.year;
//         final dayNumber = today.weekday;

//         final existing = await supabase
//             .from('dailyuserconsumption')
//             .select('id')
//             .eq('user_id', userId)
//             .eq('calender_year', year)
//             .eq('calender_week', week)
//             .eq('day_number', dayNumber)
//             .maybeSingle();

//         if (existing == null) {
//           // Insert notification
//           await supabase.from('notifications').insert({
//             'title': 'Reminder',
//             'content': 'You haven’t logged your meals today!',
//             'target_user_id': userId,
//           });
//           print("Notification inserted for user $userId");
//         }
//       }
//     } catch (e) {
//       print("Error handling user $u: $e");
//     }
//   }
// }
