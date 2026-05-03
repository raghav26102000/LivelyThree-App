// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

Future<dynamic> getNextIndicatorCalculationTime() async {
  final supabase = Supabase.instance.client;

  // 1) Fetch your cron‐expression JSON ({ job_name, schedule })
  final rpcResult = await supabase.rpc('get_indicators_schedule_json');
  if (rpcResult == null) return null;
  final data = rpcResult as Map<String, dynamic>;
  final jobName = data['job_name'] as String;
  final schedule = data['schedule'] as String;

  // 2) Compute the next “every 2-hour on the hour” run
  final now = DateTime.now();
  const periodHrs = 2;
  int nextHour = ((now.hour ~/ periodHrs) + 1) * periodHrs;
  DateTime candidate = DateTime(now.year, now.month, now.day, nextHour);
  if (!candidate.isAfter(now)) {
    final tomorrow = now.add(const Duration(days: 1));
    candidate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0);
  }

  // 3) Determine offset & map to CET/CEST (or fallback to UTC±)
  final offsetHrs = candidate.timeZoneOffset.inHours;
  String tzAbbrev;
  if (offsetHrs == 1) {
    tzAbbrev = 'CET';
  } else if (offsetHrs == 2) {
    tzAbbrev = 'CEST';
  } else {
    // fallback, e.g. UTC+3 or UTC-5
    final sign = offsetHrs >= 0 ? '+' : '-';
    tzAbbrev = 'UTC$sign${offsetHrs.abs()}';
  }

  // 4) Format just HH:mm
  final timeLabel = DateFormat('HH:mm').format(candidate);

  // 5) Assemble your label
  final nextRunLabel = '(Update: $timeLabel $tzAbbrev)';

  return {
    'job_name': jobName,
    'schedule': schedule,
    'next_run_iso': candidate.toIso8601String(),
    'next_run_label': nextRunLabel,
  };
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
