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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

/// Fetches current- & previous-week KPIs and stores them in
/// FFAppState().weeklyIndicators (type: WeeklyIndicatorsDataTypeStruct).
///
/// Fields expected in the struct (20 total):
///   • cwColorGapsMissingCount      • pwColorGapsMissingCount
///   • cwColorGapsMissingColors     • pwColorGapsMissingColors
///   • cwHealthScoreValue           • pwHealthScoreValue
///   • cwFiberTrackerValue          • pwFiberTrackerValue
///   • cwAveragePlantsValue         • pwAveragePlantsValue
///   • cwProteinTrackerValue        • pwProteinTrackerValue
///   • cwAveragePortionsValue       • pwAveragePortionsValue
///   • cwConsistencyScoreValue      • pwConsistencyScoreValue
///   • cwProgressConsistencyValue   • pwProgressConsistencyValue
///   • cwProgressHealthScoreValue   • pwProgressHealthScoreValue
//
Future<void> getWeeklyIndividualIndicatorsFlat(String userId) async {
  /* 1 ─ Validate input */
  if (userId.isEmpty) {
    throw ArgumentError('getWeeklyIndicatorsFlat: userId must be provided.');
  }

  final supabase = Supabase.instance.client;

  try {
    /* 2 ─ RPC call */
    final data = await supabase.rpc(
      'fetch_top_two_individual_indicator_values',
      params: {'p_user_id': userId},
    );
    if (data == null) {
      throw Exception(
          'RPC fetch_top_two_individual_indicator_values returned null.');
    }

    /* 3 ─ Map JSON → WeeklyIndicatorsDataTypeStruct (20 named params) */
    final individualIndicators = WeeklyIndicatorsDataTypeStruct(
      // ── Color-Gaps metadata (no value) ──
      cwColorGapsMissingCount: data['current_week']['indicators']
              ['colorgapsweekly_i']['jsonb_value']?['missing_count'] as int? ??
          0,
      cwColorGapsMissingColors: List<String>.from(data['current_week']
                  ['indicators']['colorgapsweekly_i']['jsonb_value']
              ?['missing_colors'] ??
          const []),
      pwColorGapsMissingCount: data['previous_week']['indicators']
              ['colorgapsweekly_i']['jsonb_value']?['missing_count'] as int? ??
          0,
      pwColorGapsMissingColors: List<String>.from(data['previous_week']
                  ['indicators']['colorgapsweekly_i']['jsonb_value']
              ?['missing_colors'] ??
          const []),

      // ── Remaining indicators: value only (8 × 2) ──
      cwHealthScoreValue: (data['current_week']['indicators']
                  ['healthscoreweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwHealthScoreValue: (data['previous_week']['indicators']
                  ['healthscoreweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,

      cwFiberTrackerValue: (data['current_week']['indicators']
                  ['fibertrackerweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwFiberTrackerValue: (data['previous_week']['indicators']
                  ['fibertrackerweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,

      cwAveragePlantsValue: (data['current_week']['indicators']
                  ['averageplantsweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwAveragePlantsValue: (data['previous_week']['indicators']
                  ['averageplantsweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,

      cwProteinTrackerValue: (data['current_week']['indicators']
                  ['proteintrackerweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwProteinTrackerValue: (data['previous_week']['indicators']
                  ['proteintrackerweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,

      cwAveragePortionsValue: (data['current_week']['indicators']
                  ['averageportionsweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwAveragePortionsValue: (data['previous_week']['indicators']
                  ['averageportionsweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,

      cwConsistencyScoreValue: (data['current_week']['indicators']
                  ['consistencyscoreweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwConsistencyScoreValue: (data['previous_week']['indicators']
                  ['consistencyscoreweekly_i']['value'] as num?)
              ?.toDouble() ??
          0.0,

      cwProgressConsistencyValue: (data['current_week']['indicators']
                  ['progresstracker_consistency_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwProgressConsistencyValue: (data['previous_week']['indicators']
                  ['progresstracker_consistency_i']['value'] as num?)
              ?.toDouble() ??
          0.0,

      cwProgressHealthScoreValue: (data['current_week']['indicators']
                  ['progresstracker_healthscore_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
      pwProgressHealthScoreValue: (data['previous_week']['indicators']
                  ['progresstracker_healthscore_i']['value'] as num?)
              ?.toDouble() ??
          0.0,
    );

    /* 4 ─ Store in global state */
    FFAppState().individualIndicators = individualIndicators;
    print('Weekly indicators updated successfully: ${jsonEncode(data)}');
  } catch (e) {
    /* 5 ─ Fallback: empty struct */
    print('getWeeklyIndicatorsFlat error: $e');
    FFAppState().individualIndicators = WeeklyIndicatorsDataTypeStruct();
  }
}
