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

import 'package:intl/intl.dart'; // for DateFormat
import 'package:supabase_flutter/supabase_flutter.dart'; // for Supabase.instance.client

Future<void> getWeeklyCommunityIndicatorsFlat() async {
  // 1 · Initialize Supabase client
  final supabase = Supabase.instance.client;

  // 2 · Compute current & previous ISO week
  final now = DateTime.now();
  final int currentYear = now.year;
  final int currentWeek =
      ((int.parse(DateFormat('D').format(now)) - now.weekday + 10) / 7).floor();
  final int previousYear = currentWeek == 1 ? currentYear - 1 : currentYear;
  final int previousWeek = currentWeek == 1 ? 52 : currentWeek - 1;

  // 3 · Fetch both weeks from your view
  final rows = await supabase
      .from('view_community_indicators')
      .select()
      .or(
        'and(calendarweek.eq.$currentWeek,calendaryear.eq.$currentYear),'
        'and(calendarweek.eq.$previousWeek,calendaryear.eq.$previousYear)',
      )
      .order('calendaryear', ascending: false)
      .order('calendarweek', ascending: false);

  // 4 · Prepare containers for each week
  const simpleInds = [
    'averageplantsweekly_c',
    'averageportionsweekly_c',
    'consistencyscoreweekly_c',
    'fibertrackerweekly_c',
    'proteintrackerweekly_c',
    'healthscoreweekly_c',
  ];
  const complexInds = [
    'trendwatch_c',
    'rarefinds_c',
    'frequentfive_c',
    'colorgapsweekly_c',
  ];

  Map<String, Map<String, dynamic>> _initSimple() => {
        for (final k in simpleInds) k: {'value': 0.0, 'participant_count': 0}
      };
  final curSimple = _initSimple();
  final prevSimple = _initSimple();

  var curTrendwatch = DashboardTrendwatchDataTypeStruct();
  var prevTrendwatch = DashboardTrendwatchDataTypeStruct();

  List<DashboardPlantPortionDataTypeStruct> curRareFinds = [];
  List<DashboardPlantPortionDataTypeStruct> prevRareFinds = [];
  List<DashboardPlantPortionDataTypeStruct> curFrequentFive = [];
  List<DashboardPlantPortionDataTypeStruct> prevFrequentFive = [];
  List<DashboardPlantPortionDataTypeStruct> curColorGaps = [];
  List<DashboardPlantPortionDataTypeStruct> prevColorGaps = [];

  double _numOrZero(dynamic v) =>
      (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0.0;

  // 5 · Distribute rows into current/previous buckets
  for (final row in rows ?? []) {
    final bool isCurrent = row['calendarweek'] == currentWeek &&
        row['calendaryear'] == currentYear;
    final targetSimple = isCurrent ? curSimple : prevSimple;
    final String ind = row['indicatorname'] as String? ?? '';
    final rawValue = row['value'];
    final int partCount = row['participant_count'] as int? ?? 1;

    if (simpleInds.contains(ind)) {
      targetSimple[ind]!['value'] = _numOrZero(rawValue);
      targetSimple[ind]!['participant_count'] = partCount;
    } else if (complexInds.contains(ind)) {
      if (ind == 'trendwatch_c' && rawValue is Map<String, dynamic>) {
        final t = DashboardTrendwatchDataTypeStruct(
          trendRatio: _numOrZero(rawValue['trend_ratio']) * 100,
          currentHealthScore: _numOrZero(rawValue['current_healthscore']),
          previousHealthScore: _numOrZero(rawValue['previous_healthscore']),
        );
        if (isCurrent) {
          curTrendwatch = t;
        } else {
          prevTrendwatch = t;
        }
      } else if (rawValue is List) {
        final list = rawValue.map<DashboardPlantPortionDataTypeStruct>((e) {
          final int consumers = e['num_consumers'] as int? ?? 0;
          final double totalPortions = _numOrZero(e['total_portions']);
          // per-participant and per-consumer averages:
          final double avgPerParticipant =
              partCount > 0 ? (totalPortions / partCount) : 0.0;
          final double avgPerConsumer =
              consumers > 0 ? (totalPortions / consumers) : 0.0;
          return DashboardPlantPortionDataTypeStruct(
            color: e['color'] as String? ?? '',
            plantType: e['plant_type'] as String? ?? '',
            totalPortions: totalPortions,
            distinctPlantCount: e['distinct_plant_count'] as int? ?? 0,
            numConsumers: consumers,
            pctConsumers: partCount > 0 ? (consumers / partCount) : 0.0,
            avgPortionsPerPerson: avgPerParticipant,
            avgPortionsPerConsumer: avgPerConsumer, // ← new field
          );
        }).toList();

        switch (ind) {
          case 'rarefinds_c':
            if (isCurrent)
              curRareFinds = list;
            else
              prevRareFinds = list;
            break;
          case 'frequentfive_c':
            if (isCurrent)
              curFrequentFive = list;
            else
              prevFrequentFive = list;
            break;
          case 'colorgapsweekly_c':
            if (isCurrent)
              curColorGaps = list;
            else
              prevColorGaps = list;
            break;
        }
      }
    }
  }

  // 6 · Build final structs & save to state
  double _val(Map m, String k) => _numOrZero(m[k]!['value']);
  int _cnt(Map m, String k) => m[k]!['participant_count'] as int;

  DashboardComIndDataTypeStruct _buildWeek(
    Map<String, Map<String, dynamic>> simple,
    DashboardTrendwatchDataTypeStruct tw,
    List<DashboardPlantPortionDataTypeStruct> rf,
    List<DashboardPlantPortionDataTypeStruct> ff,
    List<DashboardPlantPortionDataTypeStruct> cg,
  ) =>
      DashboardComIndDataTypeStruct(
        averagePlantsValue: _val(simple, 'averageplantsweekly_c'),
        averagePlantsCount: _cnt(simple, 'averageplantsweekly_c'),
        averagePortionsValue: _val(simple, 'averageportionsweekly_c'),
        averagePortionsCount: _cnt(simple, 'averageportionsweekly_c'),
        consistencyScoreValue: _val(simple, 'consistencyscoreweekly_c'),
        consistencyScoreCount: _cnt(simple, 'consistencyscoreweekly_c'),
        fiberTrackerValue: _val(simple, 'fibertrackerweekly_c'),
        fiberTrackerCount: _cnt(simple, 'fibertrackerweekly_c'),
        proteinTrackerValue: _val(simple, 'proteintrackerweekly_c'),
        proteinTrackerCount: _cnt(simple, 'proteintrackerweekly_c'),
        healthScoreValue: _val(simple, 'healthscoreweekly_c'),
        healthScoreCount: _cnt(simple, 'healthscoreweekly_c'),
        trendwatch: tw,
        rareFinds: rf,
        frequentFive: ff,
        colorGaps: cg,
      );

  try {
    FFAppState().communityIndicators = DashboardComIndBundleDataTypeStruct(
      currentWeek: _buildWeek(
        curSimple,
        curTrendwatch,
        curRareFinds,
        curFrequentFive,
        curColorGaps,
      ),
      previousWeek: _buildWeek(
        prevSimple,
        prevTrendwatch,
        prevRareFinds,
        prevFrequentFive,
        prevColorGaps,
      ),
    );
    print('Community indicators updated');
  } catch (e) {
    print('getWeeklyCommunityIndicatorsFlat error: $e');
    FFAppState().communityIndicators = DashboardComIndBundleDataTypeStruct();
  }
}
