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

Future<dynamic> fetchTopTwoCommunityIndicatorValues() async {
  final supabaseClient = Supabase.instance.client;

  int currentYear = 0;
  int currentWeek = 0;
  int previousYear = 0;
  int previousWeek = 0;

  try {
    // Determine the current and previous week
    final now = DateTime.now();
    currentYear = now.year;
    currentWeek =
        ((int.parse(DateFormat("D").format(now)) - now.weekday + 10) / 7)
            .floor();

    if (currentWeek == 1) {
      previousYear = currentYear - 1;
      previousWeek = 52;
    } else {
      previousYear = currentYear;
      previousWeek = currentWeek - 1;
    }

    // Query rows for the two most recent weeks
    final rows = await supabaseClient
        .from('view_community_indicators')
        .select()
        .or(
          'and(calendarweek.eq.$currentWeek, calendaryear.eq.$currentYear),'
          'and(calendarweek.eq.$previousWeek, calendaryear.eq.$previousYear)',
        )
        .order('calendaryear', ascending: false)
        .order('calendarweek', ascending: false);

    final List<dynamic> fetchedRows = rows ?? [];

    // Fetch all unique community indicator names with complexity information
    final indicatorResponse = await supabaseClient
        .from('userindicators')
        .select('name, has_complex_values')
        .eq('is_community', true);

    final List<dynamic> indicatorRows = indicatorResponse ?? [];
    final Map<String, bool> indicatorComplexity = {
      for (var e in indicatorRows)
        if (e['name'] != null && e['has_complex_values'] != null)
          e['name']: e['has_complex_values'] as bool
    };

    // Initialize the default JSON structure
    Map<String, dynamic> result = {
      'current_week': {
        'calendarweek': currentWeek,
        'calendaryear': currentYear,
        'indicators': {}
      },
      'previous_week': {
        'calendarweek': previousWeek,
        'calendaryear': previousYear,
        'indicators': {}
      }
    };

    // Populate default values for all indicators
    for (final indicator in indicatorComplexity.keys) {
      if (indicatorComplexity[indicator] == true) {
        result['current_week']['indicators']
            [indicator] = {'value': [], 'participant_count': 0};
        result['previous_week']['indicators']
            [indicator] = {'value': [], 'participant_count': 0};
      } else {
        result['current_week']['indicators']
            [indicator] = {'value': 0.0, 'participant_count': 0};
        result['previous_week']['indicators']
            [indicator] = {'value': 0.0, 'participant_count': 0};
      }
    }

    // Update with actual data
    for (final row in fetchedRows) {
      final weekKey = (row['calendarweek'] == currentWeek &&
              row['calendaryear'] == currentYear)
          ? 'current_week'
          : 'previous_week';

      final indicatorName = row['indicatorname'] as String?;
      final dynamic rawValue = row['value'];
      final int participantCount = row['participant_count'] ?? 0;

      if (indicatorName != null &&
          indicatorComplexity.containsKey(indicatorName)) {
        final bool isComplex = indicatorComplexity[indicatorName]!;

        if (isComplex) {
          // Parse complex JSON structure dynamically
          if (rawValue is List<dynamic>) {
            result[weekKey]['indicators'][indicatorName] = {
              'value': rawValue,
              'participant_count': participantCount
            };
          } else if (rawValue is Map<String, dynamic>) {
            result[weekKey]['indicators'][indicatorName] = {
              'value': rawValue,
              'participant_count': participantCount
            };
          } else {
            // Unexpected format for complex values
            result[weekKey]['indicators'][indicatorName] = {
              'value': [],
              'participant_count': participantCount
            };
          }
        } else {
          // Parse simple numeric values
          if (rawValue is num || rawValue is String) {
            final double numericValue = rawValue is num
                ? rawValue.toDouble()
                : double.tryParse(rawValue) ?? 0.0;

            result[weekKey]['indicators'][indicatorName] = {
              'value': numericValue,
              'participant_count': participantCount
            };
          } else {
            // Default value for unexpected simple types
            result[weekKey]['indicators'][indicatorName] = {
              'value': 0.0,
              'participant_count': participantCount
            };
          }
        }
      }
    }

    return result;
  } catch (error) {
    print('Error in fetchTopTwoCommunityIndicatorValues: $error');
    return {
      'current_week': {
        'calendarweek': currentWeek,
        'calendaryear': currentYear,
        'indicators': {}
      },
      'previous_week': {
        'calendarweek': previousWeek,
        'calendaryear': previousYear,
        'indicators': {}
      }
    };
  }
}
