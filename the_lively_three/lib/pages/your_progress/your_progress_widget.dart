import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_widget.dart';
import 'package:the_lively_three/custom_code/widgets/custom_bar_widget.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/your_progress/your_progress_model.dart';
import '/backend/supabase/supabase.dart';
import 'package:intl/intl.dart';
import '/l10n/app_localizations.dart';
import '/providers/locale_provider.dart' as locale_provider;
import 'package:provider/provider.dart';
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';
import '/auth/supabase_auth/auth_util.dart';

class ChartData {
  final int x;
  final double y;
  ChartData(this.x, this.y);
}

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});
  static String routeName = 'YourProgress';
  static String routePath = '/your-progress';
  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class ConsistencyScoreData {
  final int calendarWeek;
  final int calendarYear;
  final double value;
  final DateTime weekStartDate;

  ConsistencyScoreData({
    required this.calendarWeek,
    required this.calendarYear,
    required this.value,
    required this.weekStartDate,
  });
}

class WeeklyColorData {
  final int calendarWeek;
  final int calendarYear;
  final List<String> missingColors;
  final Map<String, int> colorCounts;

  WeeklyColorData({
    required this.calendarWeek,
    required this.calendarYear,
    required this.missingColors,
    required this.colorCounts,
  });
}

class ColorStatData {
  final String colorName;
  final Color color;
  final int count;
  final double percentage;

  ColorStatData({
    required this.colorName,
    required this.color,
    required this.count,
    required this.percentage,
  });
}

class PlantConsumptionData {
  final int plantId;
  final String plantName;
  final double totalPortionSize;

  PlantConsumptionData({
    required this.plantId,
    required this.plantName,
    required this.totalPortionSize,
  });
}

class _ProgressPageState extends State<ProgressPage> {
  late YourProgressModel _model;
  bool _isLoading = true;
  bool _isUserLoading = true;
  List<WeeklyColorData> _weeklyColorData = [];
  List<ConsistencyScoreData> _consistencyScores = [];
  List<ColorStatData> _leastConsumedColors = [];
  List<PlantConsumptionData> _topConsumedPlants = [];
  List<PlantConsumptionData> _lowConsumedPlants = [];
  late String _userTimezone;
  int _selectedWeekIndex = 0;
  bool _hasSubscription = false;
  // 🧩 Community Indicator Variables
  dynamic healthScoreWeeklyC;
  dynamic averagePlantsWeeklyC;
  dynamic averagePortionsWeeklyC;
  dynamic colorGapsWeeklyC;
  dynamic frequentFiveC;
  dynamic rareFindsC;
  dynamic weekendDivergenceC;
  dynamic trendWatchC;
  dynamic fiberTrackerWeeklyC;
  dynamic proteinTrackerWeeklyC;
  // 🧍‍♂️ USER INDICATOR VARIABLES
  double healthScoreWeeklyI = 0;
  double averagePlantsWeeklyI = 0;
  double averagePortionsWeeklyI = 0;
  double fiberTrackerWeeklyI = 0;
  double proteinTrackerWeeklyI = 0;
  double consistencyScoreWeeklyI = 0;

  double progressTrackerHealthScoreI = 0;
  double progressTrackerConsistencyI = 0;

  double healthScore4WeeklyI = 0;
  double averagePlants4WeeklyI = 0;
  double averagePortions4WeeklyI = 0;

  int globalCurrentWeek = 0;
  int globalCurrentYear = 0;

  List<Map<String, dynamic>> weeklyConsistencyData = [];

// 🧩 Complex data indicators (stored as JSON)
  List<String> colorGapsWeeklyI = [];
  Map<String, dynamic> weekendDivergenceI = {};
  Map<String, dynamic> trendWatchI = {};

// 🌿 List-type indicators (if any exist later)
  List<dynamic> frequentFiveI = [];
  List<dynamic> rareFindsI = [];
  List<Map<String, dynamic>> topThree = [];
  List<Map<String, dynamic>> topThreeRareFinds = [];
  List<Map<String, dynamic>> leastColorConsumedC = [];
  int currentWeekNumber = 0;
  List<Map<String, dynamic>> barData = [];
  double bestWeekValue = 0;
  List<Map<String, dynamic>> userAvgPortionData = [];
  List<Map<String, dynamic>> userPlantDiversityData = [];
  List<Map<String, dynamic>> communityPlantDiversityData = [];
  List<Map<String, dynamic>> communityAvgPortionData = [];

  List<Map<String, dynamic>> barDataMissingColor = [];
  Locale? currentLocale;
  double waterPercentageWeekly = 0.0;
  List<Map<String, dynamic>> waterBarData = [];
  // bool _checkingSubscription = true;
  bool _hasValidSubscription = false;
  // bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => YourProgressModel());
    // showPermissionPopup(context);
    // showSubscriptionPopup(context);
    _initializeData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the FFAppState locale here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentLocale =
          Provider.of<locale_provider.FFAppState>(context, listen: false)
              .locale;
    });
  }

  Future<void> _initializeData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    print('Community id $globalCommunityId');
    await _fetchUserTimezone();
    await _fetchUserSubscription();
    await _fetchCommunityIndicators(
      communityId: globalCommunityId!,
      calendarWeek: globalCurrentWeek,
      calendarYear: globalCurrentYear,
    );

    if (userId != null) {
      await fetchUserIndicators(
          userId: userId,
          calendarYear: globalCurrentYear,
          calendarWeek: globalCurrentWeek);
    }

    await calculateAndSaveWeeklyWaterIndicator(userId: userId!);

    // ✅ Reset values to 0 if current week has no data
    setState(() {
      if (!_hasDataForCurrentWeek()) {
        waterPercentageWeekly = 0.0;
        averagePortionsWeeklyI = 0.0;
        averagePlantsWeeklyI = 0.0;
        colorGapsWeeklyI = [
          'Red',
          'Orange',
          'Yellow',
          'Green',
          'Purple',
          'Brown',
          'White'
        ];
      }
    });
  }

// ✅ Helper method to check if current week has data
  bool _hasDataForCurrentWeek() {
    // Check if any of the weekly data exists for current week
    final hasWaterData =
        waterBarData.any((item) => item['week'] == 'Week $currentWeekNumber');

    final hasUserPlantData = userPlantDiversityData
        .any((item) => item['week'] == 'Week $currentWeekNumber');

    final hasUserPortionData = userAvgPortionData
        .any((item) => item['week'] == 'Week $currentWeekNumber');

    return hasWaterData || hasUserPlantData || hasUserPortionData;
  }

  Future<void> _fetchUserSubscription() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .select('has_subscription')
          .eq('id', userId)
          .single();

      _hasSubscription = response['has_subscription'] as bool? ?? false;
    } catch (e, st) {
      _hasSubscription = false; // Default to false if error
    }
  }

  Future<void> _checkUserSubscription() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        _hasValidSubscription = false;
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .select('has_subscription, subscription_expires_at')
          .eq('id', userId)
          .single();

      final bool hasSubscription = response['has_subscription'] ?? false;
      final String? expiresAtStr = response['subscription_expires_at'];
      bool isValid = false;

      if (hasSubscription && expiresAtStr != null) {
        final expiresAt = DateTime.parse(expiresAtStr);
        final now = DateTime.now();
        isValid = expiresAt.isAfter(now);
      }

      _hasValidSubscription = isValid;

      if (!isValid && mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const UpgradeSubscriptionPage(
            onSuccess: 'Dashboard',
            onFailure: 'Home',
            popupTitle: "Know Your Impact. Improve Your Choices.",
            popupSubTitle:
                "To access dashboard insights, please subscribe and give permission to data access.",
          ),
        );
      }
    } catch (e, st) {
      _hasValidSubscription = false;

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const UpgradeSubscriptionPage(
            onSuccess: 'Dashboard',
            onFailure: 'Home',
            popupTitle: "Know Your Impact. Improve Your Choices.",
            popupSubTitle:
                "To access dashboard insights, please subscribe and give permission to data access.",
          ),
        );
      }
    }
  }

  Future<void> _fetchUserTimezone() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return;
      }

      final response = await Supabase.instance.client
          .from('users')
          .select('timezone')
          .eq('id', userId)
          .single();

      _userTimezone = response['timezone'] as String;

      final nowUtc = DateTime.now().toUtc();
      final localOffset = _getTimezoneOffset(_userTimezone);
      final nowLocal = nowUtc.add(localOffset);

      currentWeekNumber = _getWeekNumber(nowLocal);

      // ✅ FIX: Set globalCurrentWeek as well
      globalCurrentWeek = currentWeekNumber;
      globalCurrentYear = nowLocal.year;
    } catch (e, st) {
      _userTimezone = 'UTC';

      // ✅ Set defaults even on error
      final now = DateTime.now();
      currentWeekNumber = _getWeekNumber(now);
      globalCurrentWeek = currentWeekNumber;
      globalCurrentYear = now.year;
    }
  }

  DateTime _getWeekStartDate(int year, int week) {
    final jan1 = DateTime(year, 1, 1);
    final firstMonday = jan1.weekday == DateTime.monday
        ? jan1
        : jan1.add(Duration(days: (DateTime.monday - jan1.weekday + 7) % 7));
    return firstMonday.add(Duration(days: (week - 1) * 7));
  }

  Future<void> fetchUserIndicators({
    required String userId,
    required int calendarYear,
    required int calendarWeek,
  }) async {
    final supabase = Supabase.instance.client;
    print(
        '🔍 Fetching indicator data for user: $userId, year: $calendarYear, week: $calendarWeek');

    final response = await supabase
        .from('user_indicator_values')
        .select('''
        id_indicator,
        value,
        calendarweek,
        calendaryear,
        jsonb_value,
        userindicators(name)
      ''')
        .eq('id_user', userId)
        .eq('calendaryear', calendarYear)
        .order('calendarweek', ascending: true);

    if (response is! List) {
      print('❌ Unexpected response format: $response');
      throw Exception('Unexpected response format from Supabase');
    }

    final List<Map<String, dynamic>> data =
        (response as List).cast<Map<String, dynamic>>();

    // Map to store indicators by name
    final Map<String, dynamic> currentWeekIndicators = {};
    final Map<int, double> consistencyByWeek = {}; // Week → Value
    final Map<int, List<String>> missingColorsByWeek =
        {}; // week → missing colors
    final Map<int, double> plantDiversityByWeek = {};
    final Map<int, double> avgPortionsByWeek = {};

    // ✅ Track if current week has SPECIFIC data
    bool hasCurrentWeekColorData = false;
    bool hasCurrentWeekConsistencyData = false;
    bool hasCurrentWeekPlantData = false;
    bool hasCurrentWeekPortionData = false;

    for (final item in data) {
      final indicatorName =
          item['userindicators']?['name'] ?? 'unknown_indicator';
      final indicatorValue = item['value'];
      final itemCalendarWeek = item['calendarweek'];
      final jsonbValue = item['jsonb_value'];
      final itemCalendarYear = item['calendaryear'];

      final int weekNumber = (itemCalendarWeek is int)
          ? itemCalendarWeek
          : int.tryParse(itemCalendarWeek.toString()) ?? 0;

      final bool isCurrentWeek =
          (weekNumber == calendarWeek && itemCalendarYear == calendarYear);

      // Collect missing colors by week
      if (indicatorName == 'colorgapsweekly_i') {
        final missingList =
            (jsonbValue?['missing_colors'] ?? []).cast<String>();
        missingColorsByWeek[weekNumber] = missingList;

        if (isCurrentWeek) {
          hasCurrentWeekColorData = true;
          currentWeekIndicators[indicatorName] = {
            'value': indicatorValue,
            'week': itemCalendarWeek,
            'year': itemCalendarYear,
            'jsonb': jsonbValue,
          };
        }
      }

      // Collect weekly consistency values
      if (indicatorName == 'consistencyscoreweekly_i') {
        final double value = (item['value'] is num)
            ? (item['value'] as num).toDouble()
            : double.tryParse(item['value'].toString()) ?? 0.0;
        consistencyByWeek[weekNumber] = value;

        if (isCurrentWeek) {
          hasCurrentWeekConsistencyData = true;
          currentWeekIndicators[indicatorName] = {
            'value': indicatorValue,
            'week': itemCalendarWeek,
            'year': itemCalendarYear,
            'jsonb': jsonbValue,
          };
        }
      }

      // Collect plant diversity by week
      if (indicatorName == 'averageplantsweekly_i') {
        final double value = (item['value'] is num)
            ? (item['value'] as num).toDouble()
            : double.tryParse(item['value'].toString()) ?? 0.0;
        plantDiversityByWeek[weekNumber] = value;

        if (isCurrentWeek) {
          hasCurrentWeekPlantData = true;
          currentWeekIndicators[indicatorName] = {
            'value': indicatorValue,
            'week': itemCalendarWeek,
            'year': itemCalendarYear,
            'jsonb': jsonbValue,
          };
        }
      }

      // Collect average portions by week
      if (indicatorName == 'averageportionsweekly_i') {
        final double value = (item['value'] is num)
            ? (item['value'] as num).toDouble()
            : double.tryParse(item['value'].toString()) ?? 0.0;
        final double formattedValue = value * 100 * 7;
        avgPortionsByWeek[weekNumber] = formattedValue;

        if (isCurrentWeek) {
          hasCurrentWeekPortionData = true;
          currentWeekIndicators[indicatorName] = {
            'value': indicatorValue,
            'week': itemCalendarWeek,
            'year': itemCalendarYear,
            'jsonb': jsonbValue,
          };
        }
      }

      // Store other current week indicators
      if (isCurrentWeek &&
          ![
            'colorgapsweekly_i',
            'consistencyscoreweekly_i',
            'averageplantsweekly_i',
            'averageportionsweekly_i'
          ].contains(indicatorName)) {
        currentWeekIndicators[indicatorName] = {
          'value': indicatorValue,
          'week': itemCalendarWeek,
          'year': itemCalendarYear,
          'jsonb': jsonbValue,
        };
      }
    }

    // Prepare barData for dialogs
    final List<Map<String, dynamic>> dynamicBarData = consistencyByWeek.entries
        .map((e) => {
              'week': 'Week ${e.key}',
              'totalValue': e.value,
            })
        .toList();

    final List<Map<String, dynamic>> dynamicBarDataMissingColor =
        missingColorsByWeek.entries
            .map((e) => {
                  'week': 'Week ${e.key}',
                  'colorsMissing': e.value,
                })
            .toList();

    userPlantDiversityData = plantDiversityByWeek.entries
        .map((e) => {
              'week': 'Week ${e.key}',
              'score': e.value,
            })
        .toList();

    userAvgPortionData = avgPortionsByWeek.entries
        .map((e) => {
              'week': 'Week ${e.key}',
              'score': e.value,
            })
        .toList();

    // Find the highest consistency value
    double highestValue = 0;
    if (dynamicBarData.isNotEmpty) {
      highestValue = dynamicBarData
          .map((e) => e['totalValue'] as double)
          .reduce((a, b) => a > b ? a : b);
    }

    // ✅ Assign values with specific checks for each indicator
    setState(() {
      // Health Score
      healthScoreWeeklyI =
          (currentWeekIndicators['healthscoreweekly_i']?['value'] ?? 0)
              .toDouble();

      // Fiber Tracker
      fiberTrackerWeeklyI =
          (currentWeekIndicators['fibertrackerweekly_i']?['value'] ?? 0)
              .toDouble();

      // ✅ Color Gaps - check specific flag
      if (hasCurrentWeekColorData) {
        colorGapsWeeklyI = (currentWeekIndicators['colorgapsweekly_i']?['jsonb']
                    ?['missing_colors'] ??
                [])
            .cast<String>();
      } else {
        colorGapsWeeklyI = [
          'Red',
          'Orange',
          'Yellow',
          'Green',
          'Purple',
          'Brown',
          'White'
        ];
      }

      // ✅ Consistency Score - check specific flag
      consistencyScoreWeeklyI = hasCurrentWeekConsistencyData
          ? (currentWeekIndicators['consistencyscoreweekly_i']?['value'] ?? 0)
              .toDouble()
          : 0.0;

      // ✅ Average Portions - check specific flag
      averagePortionsWeeklyI = hasCurrentWeekPortionData
          ? (currentWeekIndicators['averageportionsweekly_i']?['value'] ?? 0)
              .toDouble()
          : 0.0;

      // ✅ Average Plants - check specific flag
      averagePlantsWeeklyI = hasCurrentWeekPlantData
          ? (currentWeekIndicators['averageplantsweekly_i']?['value'] ?? 0)
              .toDouble()
          : 0.0;

      // Other indicators
      progressTrackerHealthScoreI =
          (currentWeekIndicators['progresstracker_healthscore_i']?['value'] ??
                  0)
              .toDouble();
      healthScore4WeeklyI =
          (currentWeekIndicators['healthscore4weekly_i']?['value'] ?? 0)
              .toDouble();
      averagePlants4WeeklyI =
          (currentWeekIndicators['averageplants4weekly_i']?['value'] ?? 0)
              .toDouble();
      averagePortions4WeeklyI =
          (currentWeekIndicators['averageportions4weekly_i']?['value'] ?? 0)
              .toDouble();

      // Always set bar data (for all weeks)
      barData = dynamicBarData;
      bestWeekValue = highestValue;
      barDataMissingColor = dynamicBarDataMissingColor;
      _isUserLoading = false;
    });
  }

  Future<void> _fetchCommunityIndicators({
    required String communityId,
    required int calendarWeek,
    required int calendarYear,
  }) async {
    final supabase = Supabase.instance.client;

    // Fetch joined data with indicator names
    final response = await supabase
        .from('community_indicator_values')
        .select(
            'id, id_indicator, value,calendarweek,calendaryear, participant_count, updated_at, userindicators(name)')
        .eq('community_id', communityId)
        .eq('calendaryear', calendarYear)
        .order('calendarweek', ascending: true);

    final List<Map<String, dynamic>> data =
        (response as List).cast<Map<String, dynamic>>();

    // ✅ Fetch rainbow color map just once
    final colorLookupResponse = await supabase
        .from('codelkup')
        .select('keycode, key1')
        .eq('lkcode', 'rainbow_color');

    final Map<int, String> colorMap = {
      for (final row in colorLookupResponse)
        row['keycode'] as int: row['key1'] as String
    };

    // Create a map for easy access by indicator name
    final Map<String, dynamic> communityIndicators = {};
    // ✅ NEW: Track community values by week
    final Map<int, double> communityPlantsByWeek = {};
    final Map<int, double> communityPortionsByWeek = {};

    for (final item in data) {
      final indicatorName =
          item['userindicators']?['name'] ?? 'unknown_indicator';
      final indicatorValue = item['value'];
      final participantCount = item['participant_count'];
      final updatedAt = item['updated_at'];
      final idIndicator = item['id_indicator'];

      // Store in map for later use
      communityIndicators[indicatorName] = indicatorValue;
      // ✅ Average Portions (Community)
      if (indicatorName == 'averageplantsweekly_c') {
        final int weekNumber = (item['calendarweek'] is int)
            ? item['calendarweek']
            : int.tryParse(item['calendarweek'].toString()) ?? 0;

        final double value = (item['value'] is num)
            ? (item['value'] as num).toDouble()
            : double.tryParse(item['value'].toString()) ?? 0.0;

        communityPlantsByWeek[weekNumber] = value;
      }

      // ✅ NEW: Collect community average portions by week
      if (indicatorName == 'averageportionsweekly_c') {
        final int weekNumber = (item['calendarweek'] is int)
            ? item['calendarweek']
            : int.tryParse(item['calendarweek'].toString()) ?? 0;

        final double value = (item['value'] is num)
            ? (item['value'] as num).toDouble()
            : double.tryParse(item['value'].toString()) ?? 0.0;

        final double formattedValue = value * 100 * 7;
        communityPortionsByWeek[weekNumber] = formattedValue;
      }
    }

    final frequentFiveData = communityIndicators['frequentfive_c'];
    final rareFindsData = communityIndicators['rarefinds_c'];
    final leastColorConsumedData =
        communityIndicators['leastcolorconsumedweekly_c'];
    List<String> frequentPlantNames = [];

    if (frequentFiveData is List && frequentFiveData.isNotEmpty) {
      // Sort by total_portions descending
      frequentFiveData.sort((a, b) =>
          (b['total_portions'] ?? 0).compareTo(a['total_portions'] ?? 0));

      final topThreeItems = frequentFiveData.take(3).toList();

      for (final item in topThreeItems) {
        final colorCode = item['color'] ?? 0;
        final colorName = colorMap[colorCode] ?? 'grey';
        final plantName = item['plant_name'] ?? 'Unknown';
        final plantId = item['plant_id'] ?? 0;
        frequentPlantNames.add(plantName);

        topThree.add({
          'plantId': plantId,
          'plantName': item['plant_name'] ?? 'Unknown',
          'numberOfPeople': item['distinct_user_count'] ?? 0,
          'value':
              '${((item['total_portions'] ?? 0) * 100).toStringAsFixed(0)} g',
          'colorName': colorName,
        });
      }
    }

    // --- 🍒 Rare Finds (fixed: dedupe + ascending sort for least consumed) ---
    if (rareFindsData is List && rareFindsData.isNotEmpty) {
      // Build a set of frequent plant names normalized (trim + lowercase)
      final Set<String> frequentNamesSet = frequentPlantNames
          .map((p) => p.toString().trim().toLowerCase())
          .toSet();

      // Normalize and filter out plants already in frequent list
      final filteredRare = rareFindsData.where((r) {
        final rawName = (r['plant_name'] ?? '').toString();
        final normName = rawName.trim().toLowerCase();
        return !frequentNamesSet.contains(normName);
      }).toList();

      // Sort ascending by total_portions => least consumed first
      filteredRare.sort((a, b) =>
          (a['total_portions'] ?? 0).compareTo(b['total_portions'] ?? 0));

      // Take first 3 (least consumed)
      final topThreeRareItems = filteredRare.take(3).toList();

      topThreeRareFinds.clear();
      for (final item in topThreeRareItems) {
        final colorCode = item['color'] ?? 0;
        final colorName = colorMap[colorCode] ?? 'grey';
        final plantName = (item['plant_name'] ?? 'Unknown').toString().trim();
        final plantId = item['plant_id'] ?? 0;
        topThreeRareFinds.add({
          'plantId': plantId,
          'plantName': plantName,
          'numberOfPeople': item['distinct_user_count'] ?? 0,
          // convert portions to grams and format without decimals
          'value':
              '${((item['total_portions'] ?? 0) * 100).toStringAsFixed(0)} g',
          'colorName': colorName,
        });
      }

      // print(
      //     '\n🌿 Rare Finds (after filtering & least-first): ${topThreeRareFinds.length}');
      for (var i = 0; i < topThreeRareFinds.length; i++) {
        final r = topThreeRareFinds[i];
        // print(
        //     '  ${i + 1}. ${r['plantName']} - ${r['value']} - people: ${r['numberOfPeople']} - color: ${r['colorName']}');
      }
    }

    // --- 🎨 Least Color Consumed ---
    List<Map<String, dynamic>> leastColorConsumedList = [];

    if (leastColorConsumedData is List && leastColorConsumedData.isNotEmpty) {
      // Sort ascending — least consumed first
      leastColorConsumedData.sort((a, b) => (a['percentage_consumed'] ?? 0)
          .compareTo(b['percentage_consumed'] ?? 0));

      // Pick the 3 least consumed colors
      final leastThree = leastColorConsumedData.take(3).toList();

      for (final item in leastThree) {
        final colorName = item['color_name'] ?? 'Unknown';
        final percentage = item['percentage_consumed'] ?? 0.0;

        leastColorConsumedList.add({
          'colorName': colorName,
          'percentage': percentage.toStringAsFixed(2),
        });
      }
    }

    communityPlantDiversityData = communityPlantsByWeek.entries
        .map((e) => {
              'week': 'Week ${e.key}',
              'score': e.value,
            })
        .toList();

    communityAvgPortionData = communityPortionsByWeek.entries
        .map((e) => {
              'week': 'Week ${e.key}',
              'score': e.value,
            })
        .toList();

    setState(() {
      healthScoreWeeklyC = communityIndicators['healthscoreweekly_c'] ?? 0;
      averagePlantsWeeklyC = communityIndicators['averageplantsweekly_c'] ?? 0;
      averagePortionsWeeklyC =
          communityIndicators['averageportionsweekly_c'] ?? 0;
      colorGapsWeeklyC = communityIndicators['colorgapsweekly_c'] ?? [];
      frequentFiveC = frequentFiveData ?? [];
      rareFindsC = rareFindsData ?? [];
      leastColorConsumedC = leastColorConsumedList; // ✅ NEW
      weekendDivergenceC = communityIndicators['weekenddivergence_c'] ?? {};
      trendWatchC = communityIndicators['trendwatch_c'] ?? {};
      fiberTrackerWeeklyC = communityIndicators['fibertrackerweekly_c'] ?? 0;
      proteinTrackerWeeklyC =
          communityIndicators['proteintrackerweekly_c'] ?? 0;
      _isLoading = false;
    });

    // ✅ Now translate the names in-place
    await _localizePlantNames();
  }

  Future<void> _localizePlantNames() async {
    if (currentLocale == 'en') return; // ✅ No change for English

    final supabase = Supabase.instance.client;

    // Merge both plant lists that need translation
    final List<Map<String, dynamic>> allPlants = [
      ...topThree,
      ...topThreeRareFinds,
    ];

    for (var item in allPlants) {
      final String plantName = item['plantName'].toString();
      final int? plantId = item['plantId'] ?? item['id']; // plant_id must exist
      if (plantId == null) continue;

      // ✅ Fetch blueprint id using plantId
      // final blueprintResponse = await supabase
      //     .from('blueprintfooditem')
      //     .select('id')
      //     .eq('id', plantId)
      //     .maybeSingle();

      // if (blueprintResponse == null) continue;
      // final int blueprintId = blueprintResponse['id'];
      // print('blueprintId $blueprintId');

      // ✅ Check if localized name exists for current locale
      final localizedResponse = await supabase
          .from('localizedfooditem')
          .select('name')
          .eq('id_blueprint', plantId)
          .eq('locale', currentLocale.toString())
          .maybeSingle();
      print('Localized response ${localizedResponse?.length}');
      // ✅ Replace name if translation found
      if (localizedResponse != null && localizedResponse['name'] != null) {
        item['plantName'] = localizedResponse['name'];
        print('Localized name ${localizedResponse['name']}');
      }
    }

    setState(() {}); // ✅ Refresh UI after update
  }

  /// ✅ One-time full function – calculate + save + prepare for UI
  Future<void> calculateAndSaveWeeklyWaterIndicator({
    required String userId,
  }) async {
    final supabase = Supabase.instance.client;

    // Fetch all user water logs from dailyuserconsumption
    final response = await supabase
        .from('dailyuserconsumption')
        .select('portion_size, calender_week, calender_year')
        .eq('user_id', userId)
        .eq('dietary_source', 4)
        .order('calender_year', ascending: true)
        .order('calender_week', ascending: true);

    if (response.isEmpty) {
      print("⚠ No water consumption data found for user.");
      setState(() {
        waterPercentageWeekly = 0.0;
        waterBarData = [];
      });
      return;
    }

    // Sum litres week-wise: { '2025-45': 6.2L }
    Map<String, double> litresByWeek = {};
    for (final row in response) {
      final int week = row['calender_week'] ?? 0;
      final int year = row['calender_year'] ?? 0;
      final double litres =
          ((row['portion_size'] ?? 0) as num).toDouble() / 1000;
      final key = "$year-$week";
      litresByWeek[key] = (litresByWeek[key] ?? 0) + litres;
    }

    print("📊 Water data by week:");
    for (var entry in litresByWeek.entries) {
      print("  ${entry.key}: ${entry.value.toStringAsFixed(1)}L");
    }

    // Convert all to {week: 'Week 45', totalValue: litres}
    waterBarData = litresByWeek.entries.map((e) {
      final parts = e.key.split('-');
      final year = int.parse(parts[0]);
      final week = int.parse(parts[1]);
      return {
        'week': 'Week $week',
        'totalValue': double.parse(e.value.toStringAsFixed(1)),
      };
    }).toList();

    // ✅ Get current week value - if doesn't exist, use 0.0
    final String currentKey = "$globalCurrentYear-$globalCurrentWeek";
    double currentLitres = litresByWeek[currentKey] ?? 0.0;

    if (currentLitres == 0.0) {
      print("⚠ No water data for current week ($currentKey) - showing 0.0L");
    } else {
      print(
          "✅ Water data for current week ($currentKey): ${currentLitres.toStringAsFixed(1)}L");
    }

    setState(() {
      waterPercentageWeekly = double.parse(currentLitres.toStringAsFixed(1));
    });
  }

  /// Approximate offset for common timezones
  Duration _getTimezoneOffset(String tz) {
    final lower = tz.toLowerCase();
    if (lower.contains('kolkata') || lower.contains('india')) {
      return const Duration(hours: 5, minutes: 30);
    } else if (lower.contains('utc')) {
      return const Duration(hours: 0);
    } else if (lower.contains('pst')) {
      return const Duration(hours: -8);
    } else if (lower.contains('est')) {
      return const Duration(hours: -5);
    } else if (lower.contains('cet')) {
      return const Duration(hours: 1);
    } else if (lower.contains('aest')) {
      return const Duration(hours: 10);
    } else {
      return const Duration(hours: 0);
    }
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return ((daysSinceFirstDay + firstDayOfYear.weekday) / 7).ceil();
  }

  List<String> _sortColorsByRainbow(List<String> colors) {
    // Define rainbow order
    const rainbowOrder = [
      'red',
      'orange',
      'yellow',
      'green',
      'blue',
      'purple',
      'white',
      'brown',
      'black'
    ];

    // Sort colors based on rainbow order
    colors.sort((a, b) {
      int indexA =
          rainbowOrder.indexWhere((c) => c.toLowerCase() == a.toLowerCase());
      int indexB =
          rainbowOrder.indexWhere((c) => c.toLowerCase() == b.toLowerCase());

      // If color not found in rainbow order, put it at the end
      if (indexA == -1) indexA = rainbowOrder.length;
      if (indexB == -1) indexB = rainbowOrder.length;

      return indexA.compareTo(indexB);
    });

    return colors;
  }

  String _formatRoundedValue(double value) {
    // Round to nearest integer
    final rounded = value.round();

    // Return without decimal points
    return rounded.toString();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  double _calculateOffset(userValue, commValue) {
    if ((userValue - commValue).abs() < 24) {
      if (userValue > 50) {
        return userValue - 24 - (userValue - commValue);
      } else {
        return userValue + 48 - (userValue - commValue);
      }
    } else {
      return userValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .secondaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    final localisation = AppLocalizations.of(context)!;
    // if (_checkingSubscription || !_initialLoadComplete) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // if (!_hasValidSubscription) {
    //   // Optionally return an empty container or subscription screen
    //   return const SizedBox.shrink();
    // }
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      resizeToAvoidBottomInset: true,
      extendBody: false,
      body: SafeArea(
        child: Stack(alignment: AlignmentDirectional(0.0, -1.0), children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              Text(
                textAlign: TextAlign.center,
                localisation.yourProgress,
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Weekly Consistency
              _buildProgressCard(
                title: localisation.yourWeeklyConsistency,
                subtitle: '${localisation.evenlyEatPlants}'
                    '${localisation.moreBalanceScore}',
                dateRange: _getDateRangeText(),
                showHabits: () => {
                  _showCustomDialogAt(
                      weekNumber: 'Week $currentWeekNumber',
                      upperColor: Color.fromRGBO(76, 175, 80, 1),
                      lowerColor: Color.fromRGBO(244, 196, 0, 1),
                      barData: barData,
                      hasGradient: true)
                },
                trailing: SizedBox(
                  width: 82,
                  child: Stack(
                    children: [
                      _buildProgressBar(
                        percent: consistencyScoreWeeklyI,
                        gradientList: const [
                          Color.fromRGBO(76, 175, 80, 1),
                          Color.fromRGBO(244, 196, 0, 1)
                        ],
                      ),
                      _buildProgressText(
                          boldText:
                              '${consistencyScoreWeeklyI.toStringAsFixed(1)}%',
                          simpleText: '${localisation.week} $currentWeekNumber',
                          topPosition: consistencyScoreWeeklyI,
                          dashColor: const Color.fromRGBO(76, 175, 80, 1),
                          dashWidth: 30),
                    ],
                  ),
                ),
              ),

              // Weekly Missing Colors (dynamic) - NOW REVERSED
              _buildProgressCard(
                  title: localisation.yourMissingColors,
                  subtitle: localisation.colorsYouCanAdd,
                  dateRange: _getDateRangeText(),
                  showNavigationArrows: true,
                  showHabits: () => {
                        _showMissingColorsDialog(
                          weekNumber: '${localisation.week} $currentWeekNumber',
                          barData: barDataMissingColor,
                        )
                      },
                  trailing: _isUserLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      : (colorGapsWeeklyI.isEmpty)
                          // ✅ Case 1: Community least empty & missing empty → Show all 7 colors dynamically
                          ? Container(
                              width: 84,
                              child: Stack(
                                children: [
                                  _buildMissing(
                                    missingColorName: _sortColorsByRainbow([
                                      'Red',
                                      'Orange',
                                      'Yellow',
                                      'Green',
                                      'Purple',
                                      'Brown',
                                      'White',
                                    ]),
                                  ),
                                  _buildProgressText(
                                      boldText:
                                          colorGapsWeeklyI.length.toString(),
                                      simpleText:
                                          '${localisation.week} $currentWeekNumber',
                                      topPosition:
                                          16.0 * colorGapsWeeklyI.length,
                                      additionalText: ' ${localisation.colors}',
                                      dashColor: _mapColorNameToColor('orange'),
                                      dashWidth: 30),
                                ],
                              ),
                            )

                          // ✅ Case 2: Missing empty but community least not empty → Completed
                          : (colorGapsWeeklyI.isEmpty)
                              ? Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 82,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 249, 249, 249),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: 5,
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            size: 32,
                                            color: Color(0xff88d1a5),
                                          ),
                                          Text(
                                            '${localisation.completed}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .textGrey,
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 10),
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -9,
                                      right: -5,
                                      child: Text(
                                        '🎉',
                                        style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 18)),
                                      ),
                                    ),
                                  ],
                                )

                              // ✅ Case 3: Missing colors exist → show the missing color visualization
                              : Container(
                                  width: 84,
                                  child: Stack(
                                    children: [
                                      _buildMissing(
                                          missingColorName:
                                              _sortColorsByRainbow(
                                                  colorGapsWeeklyI)),
                                      _buildProgressText(
                                          boldText: colorGapsWeeklyI.length
                                              .toString(),
                                          simpleText:
                                              '${localisation.week} $currentWeekNumber',
                                          topPosition:
                                              16.0 * colorGapsWeeklyI.length,
                                          additionalText:
                                              ' ${localisation.colors}',
                                          dashColor:
                                              _mapColorNameToColor('orange'),
                                          dashWidth: 30),
                                    ],
                                  ),
                                )),

              // Weekly Least Eaten Colors
              // Weekly Least Eaten Colors
              _buildProgressCard(
                title: localisation.communityWeeklyLeastEatenColors,
                subtitle: localisation.leastConsumedColors,
                dateRange: _getSelectedWeekRange(),
                showNavigationArrows: true,
                showButton: false,
                showHabits: () => {},
                trailing: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : leastColorConsumedC.isEmpty
                        ? Container(
                            width: 84,
                            height: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xfff9f9f9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xffe1e1e1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.hourglass_empty,
                                  size: 24,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${localisation.waiting}\n${localisation.communityData}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 9),
                                    color: Colors.grey.shade600,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                // Background vertical bar
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 100,
                                    width: 14,
                                    margin: const EdgeInsets.only(left: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffe1e1e1),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                  ),
                                ),
                                // List of least-consumed colors
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: leastColorConsumedC.map((item) {
                                    final colorName =
                                        item['colorName'] ?? 'grey';
                                    final percentage =
                                        item['percentage'] ?? '0';
                                    final color =
                                        _mapColorNameToColor(colorName);

                                    return _buildColorStat(
                                      color,
                                      "$percentage%",
                                      "",
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
              ),

              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: '${localisation.topPlants}\n',
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 16),
                        fontWeight: FontWeight.w700,
                        color: FlutterFlowTheme.of(context).primaryText,
                        height: 1.2),
                    children: [
                      TextSpan(
                        text: localisation.topPlantsDesc,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.w400,
                            color: FlutterFlowTheme.of(context).primaryText,
                            height: 1.2),
                      ),
                    ]),
              ),
              const SizedBox(height: 10),
// ✅ Check if topThree is empty
              topThree.isEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xfff9f9f9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffe1e1e1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.eco_outlined,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${localisation.waiting}\n${localisation.communityData}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 13),
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      height: 150,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: List.generate(topThree.length, (index) {
                          final plant = topThree[index];
                          final angle = index == 0
                              ? -pi / 18
                              : index == 2
                                  ? pi / 18
                                  : 0.0;

                          return Positioned(
                            left:
                                MediaQuery.sizeOf(context).width * 0.28 * index,
                            top: index == 0
                                ? 15.0
                                : index == 0
                                    ? 5
                                    : 0.0,
                            child: Transform.rotate(
                              angle: angle,
                              child: _buildFeaturedCard(
                                primaryColor:
                                    _mapColorNameToColor(plant['colorName']),
                                numberOfPeople: plant['numberOfPeople'],
                                plantName: plant['plantName'],
                                isTopPlant: true,
                                topPosition: index + 1,
                                value: plant['value'],
                              ),
                            ),
                          );
                        }).reversed.toList(),
                      ),
                    ),
              const SizedBox(height: 10),
              // Container(
              //   // padding:
              //   //     const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              //   height: 150,
              //   child: Stack(
              //     clipBehavior: Clip.none,
              //     children: List.generate(topThree.length, (index) {
              //       final plant = topThree[index];
              //       final angle = index == 0
              //           ? -pi / 18
              //           : index == 2
              //               ? pi / 18
              //               : 0.0;

              //       return Positioned(
              //         left: MediaQuery.sizeOf(context).width * 0.28 * index,
              //         top: index == 0
              //             ? 15.0
              //             : index == 0
              //                 ? 5
              //                 : 0.0,
              //         child: Transform.rotate(
              //           angle: angle,
              //           child: _buildFeaturedCard(
              //             primaryColor:
              //                 _mapColorNameToColor(plant['colorName']),
              //             numberOfPeople: plant['numberOfPeople'],
              //             plantName: plant['plantName'],
              //             isTopPlant: true,
              //             topPosition: index + 1,
              //             value: plant['value'],
              //           ),
              //         ),
              //       );
              //     })
              //         .reversed
              //         .toList(), // 👈 reverses the list so index 0 is painted last (on top)
              //   ),
              // ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: '${localisation.lowPlants}\n',
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 16),
                        fontWeight: FontWeight.w700,
                        color: FlutterFlowTheme.of(context).primaryText,
                        height: 1.2),
                    children: [
                      TextSpan(
                        text: localisation.lowPlantsDesc,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.w400,
                            color: FlutterFlowTheme.of(context).primaryText,
                            height: 1.2),
                      ),
                    ]),
              ),
              const SizedBox(height: 10),
// ✅ Check if topThreeRareFinds is empty
              topThreeRareFinds.isEmpty
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xfff9f9f9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffe1e1e1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.spa_outlined,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${localisation.waiting}\n${localisation.communityData}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 13),
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        topThreeRareFinds.length,
                        (index) {
                          final plant = topThreeRareFinds[index];
                          return _buildFeaturedCard(
                            primaryColor:
                                _mapColorNameToColor(plant['colorName']),
                            numberOfPeople: plant['numberOfPeople'],
                            plantName: plant['plantName'],
                            value: plant['value'],
                          );
                        },
                      ),
                    ),
              // const SizedBox(height: 10),
              // Row(
              //   spacing: 4,
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: List.generate(
              //     topThreeRareFinds.length,
              //     (index) {
              //       final plant = topThreeRareFinds[index];
              //       return _buildFeaturedCard(
              //         primaryColor: _mapColorNameToColor(plant['colorName']),
              //         numberOfPeople: plant['numberOfPeople'],
              //         plantName: plant['plantName'],
              //         value: plant['value'],
              //       );
              //     },
              //   ),
              // ),

              const SizedBox(height: 10),

              _buildProgressCard(
                title: localisation.weeklyPlantDiversityAverage,
                subtitle: localisation.youAndCommunityPlantAvg,
                dateRange: "29 JUL - 3 AUG",
                showHabits: () => {
                  _showAvgPlantDiversityDialog(
                    individualData: userPlantDiversityData,
                    communityData: communityPlantDiversityData,
                    yourColor: Color.fromRGBO(228, 99, 242, 1),
                    communityColor: Color.fromRGBO(196, 176, 198, 1),
                  )
                },
                trailing: SizedBox(
                  width: 82,
                  child: Stack(
                    children: [
                      Row(spacing: 4, children: [
                        _buildProgressBar(
                          percent: (averagePlantsWeeklyI ?? 0).toDouble(),
                          gradientList: const [
                            Color.fromRGBO(228, 99, 242, 1),
                            Color.fromRGBO(228, 99, 242, 1)
                          ],
                        ),
                        _buildProgressBar(
                          percent: (averagePlantsWeeklyC ?? 0).toDouble(),
                          gradientList: const [
                            Color.fromRGBO(196, 176, 198, 1),
                            Color.fromRGBO(196, 176, 198, 1)
                          ],
                        ),
                      ]),
                      _buildProgressText(
                        boldText:
                            ((averagePlantsWeeklyI ?? 0).toStringAsFixed(2)),
                        simpleText: localisation.you,
                        topPosition: _calculateOffset(
                            (averagePlantsWeeklyI ?? 0).toDouble(),
                            (averagePlantsWeeklyC ?? 0).toDouble()),
                        dashColor: Color.fromRGBO(228, 99, 242, 1),
                        dashWidth: 50,
                      ),
                      _buildProgressText(
                        boldText:
                            ((averagePlantsWeeklyC ?? 0).toStringAsFixed(2)),
                        simpleText: localisation.community,
                        topPosition: (averagePlantsWeeklyC ?? 0).toDouble(),
                        dashColor: Color.fromRGBO(196, 176, 198, 1),
                        dashWidth: 24,
                      ),
                    ],
                  ),
                ),
              ),
              // Weekly Plant Diversity
              _buildProgressCard(
                title: localisation.weeklyAveragePortion,
                subtitle: localisation.portionAverageDesc,
                dateRange: "29 JUL - 3 AUG",
                showHabits: () => {
                  _showAvgPlantPortionDialog(
                    individualData:
                        userAvgPortionData, // [{week: 'Week 1', score: 120}]
                    communityData:
                        communityAvgPortionData, // [{week: 'Week 1', score: 90}]
                    yourColor: Color.fromRGBO(132, 214, 192, 1),
                    communityColor: Color.fromRGBO(178, 201, 195, 1),
                    hasGradient: true,
                  )
                },
                trailing: SizedBox(
                  width: 82,
                  child: Builder(
                    builder: (context) {
                      final double yourValue =
                          ((averagePortionsWeeklyI ?? 0).toDouble()) * 100 * 7;
                      final double commValue =
                          ((averagePortionsWeeklyC ?? 0).toDouble()) * 100 * 7;

                      // find the highest value for normalization
                      final double maxValue = [yourValue, commValue]
                          .reduce((a, b) => a > b ? a : b);

                      late double yourFixedPercent;

                      final double yourPercent =
                          maxValue == 0 ? 0 : (yourValue / maxValue) * 100;

                      final double commPercent =
                          maxValue == 0 ? 0 : (commValue / maxValue) * 100;

                      return Stack(
                        children: [
                          Row(spacing: 4, children: [
                            _buildProgressBar(
                              percent: yourPercent,
                              gradientList: const [
                                Color.fromRGBO(132, 214, 192, 1),
                                Color.fromRGBO(132, 214, 192, 1)
                              ],
                            ),
                            _buildProgressBar(
                              percent: commPercent,
                              gradientList: const [
                                Color.fromRGBO(178, 201, 195, 1),
                                Color.fromRGBO(178, 201, 195, 1)
                              ],
                            ),
                          ]),
                          _buildProgressText(
                            boldText:
                                '${_formatRoundedValue(((averagePortionsWeeklyI ?? 0).toDouble()) * 100 * 7)} g',
                            simpleText: 'You:',
                            topPosition:
                                _calculateOffset(yourPercent, commPercent),
                            dashColor: Color.fromRGBO(132, 214, 192, 1),
                            dashWidth: 50,
                          ),
                          _buildProgressText(
                            boldText:
                                '${_formatRoundedValue(((averagePortionsWeeklyC ?? 0).toDouble()) * 100 * 7)} g',
                            simpleText: 'Comm:',
                            topPosition: commPercent,
                            dashColor: Color.fromRGBO(178, 201, 195, 1),
                            dashWidth: 24,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              _buildProgressCard(
                title: localisation.yourTotalWeeklyWater(3.4),
                subtitle: localisation.yourWaterSubtitle,
                dateRange: _getDateRangeText(),
                showHabits: () => {
                  _showWaterDialog(
                    weekNumber: 'Week $currentWeekNumber',
                    upperColor: Color.fromRGBO(95, 196, 248, 1),
                    lowerColor: Color.fromRGBO(95, 196, 248, 1),
                    barData: waterBarData,
                  )
                },
                trailing: SizedBox(
                  width: 82,
                  child: Builder(
                    builder: (context) {
                      final double waterPercent =
                          (waterPercentageWeekly / 20) * 100;
                      return Stack(
                        children: [
                          _buildProgressBar(
                            percent: waterPercent,
                            gradientList: const [
                              Color.fromRGBO(95, 196, 248, 1),
                              Color.fromRGBO(95, 196, 248, 1)
                            ],
                          ),
                          _buildProgressText(
                              boldText: '${waterPercentageWeekly.toString()} L',
                              simpleText: 'Week $currentWeekNumber',
                              topPosition: waterPercent,
                              dashColor: const Color.fromRGBO(95, 196, 248, 1),
                              dashWidth: 30),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              color: Colors.transparent,
              height: 88.0,
              child: Align(
                alignment: AlignmentDirectional(-1.0, 0.0),
                child: wrapWithModel(
                  model: _model.bottomNavbarModel,
                  updateCallback: () => {},
                  child: BottomNavbarWidget(),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ---------------- Helper Methods ----------------

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _getDateRangeText() {
    if (_weeklyColorData.isEmpty) return "No data found";
    if (_selectedWeekIndex >= _weeklyColorData.length) return "No data found";
    final selectedWeek = _weeklyColorData[_selectedWeekIndex];
    return "Week ${selectedWeek.calendarWeek}, ${selectedWeek.calendarYear}";
  }

  String _getSelectedWeekRange() {
    if (_weeklyColorData.isEmpty ||
        _selectedWeekIndex >= _weeklyColorData.length) {
      return "No data found";
    }
    final selectedWeek = _weeklyColorData[_selectedWeekIndex];
    return "Week ${selectedWeek.calendarWeek}, ${selectedWeek.calendarYear}";
  }

  String _getCurrentWeekRange() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final format = DateFormat('d MMM');
    return "${format.format(startOfWeek).toUpperCase()} - ${format.format(endOfWeek).toUpperCase()}";
  }

  // ---------------- Helper Widgets ----------------

  Widget _buildProgressCard({
    required String title,
    required String subtitle,
    required String dateRange,
    required Widget trailing,
    bool showButton = true,
    bool showNavigationArrows = false,
    VoidCallback? onBackPressed,
    VoidCallback? onForwardPressed,
    required VoidCallback showHabits,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color(0xffececec),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 18,
            children: [
              // LEFT SIDE — Title + Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date Row
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     if (showNavigationArrows)
                  //       GestureDetector(
                  //         onTap: onBackPressed,
                  //         child: Icon(
                  //           Icons.chevron_left,
                  //           size: 18.0,
                  //           color: onBackPressed != null
                  //               ? Colors.black
                  //               : Colors.grey.shade400,
                  //         ),
                  //       ),
                  //     Text(
                  //       dateRange,
                  //       style: TextStyle(
                  //           fontSize: FlutterFlowTheme.adjustScale(size:
// 12), color: Colors.grey.shade600),
                  //     ),
                  //     if (showNavigationArrows)
                  //       GestureDetector(
                  //         onTap: onForwardPressed,
                  //         child: Icon(
                  //           Icons.chevron_right,
                  //           size: 18.0,
                  //           color: onForwardPressed != null
                  //               ? Colors.black
                  //               : Colors.grey.shade400,
                  //         ),
                  //       )
                  //     else
                  //       const Icon(Icons.chevron_right, size: 18.0),
                  //   ],
                  // ),

                  // const SizedBox(height: 8),

                  // Trailing aligned to bottom with spacing push
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child:
                  trailing,
                  // ),
                ],
              ),

              // RIGHT SIDE — Date Range + Trailing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                    if (showButton)
                      SilverButton(
                        buttonFunction: () async {
                          // ✅ Check subscription before showing dialog
                          await _checkUserSubscription();
                          if (_hasValidSubscription) {
                            showHabits();
                          }
                        },
                        buttonTitle:
                            AppLocalizations.of(context)!.seeYourHabits,
                        paddingVertical: 4,
                        paddingHorizontal: 10,
                        hasIcon: true,
                        borderRadius: 99,
                        iconWidget: const Icon(Icons.bar_chart, size: 16),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _mapColorNameToColor(String name) {
    switch (name.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'brown':
        return Colors.brown;
      case 'white':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSuggestionCard(
      {required String title, required List<String> items}) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 13),
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...items.map((e) => Text(e,
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 12)))),
              ],
            ),
          ),
        ));
  }

  Widget _buildColorStat(Color color, String percent, String value) {
    return Container(
      width: 84,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 6,
        children: [
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Add perspective depth effect
              ..rotateX(0.1) // Rotate along X-axis for 3D effect
              ..rotateY(0.1), // Rotate along Y-axis for 3D effect
            alignment: Alignment.center,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                    color: Color(0xff4c4c4c).withOpacity(0.15),
                    width: 0.5,
                    style: BorderStyle.solid),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(76, 76, 76, 0.15),
                    blurRadius: 0,
                    spreadRadius: 0.5,
                    offset: Offset(0, 0), // Shadow direction (bottom-right)
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 3,
                    offset: Offset(-0, -1), // Highlight direction (top-left)
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.85),
                    color,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Text(percent,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  fontWeight: FontWeight.w700,
                  color: FlutterFlowTheme.of(context).textGrey)),
          Text(value,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 10),
                  color: FlutterFlowTheme.of(context).textGrey)),
        ],
      ),
    );
  }

  Widget _buildBlackCard(
    BuildContext context, {
    required String title,
    required List<PlantConsumptionData> plants,
  }) {
    final content = plants.isEmpty
        ? "No data found"
        : plants
            .map((e) =>
                "${e.plantName} ${e.totalPortionSize.toStringAsFixed(1)}g")
            .join(" - ");

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 12),
                color: plants.isEmpty ? Colors.grey.shade600 : Colors.white),
          ),
        ),
        Positioned(
          top: -12,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.5,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 13),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildProgressBar({
    required double percent,
    bool isTodayData = false,
    List<Color> gradientList = const [Colors.transparent],
  }) {
    // define height range
    const double maxHeight = 100;
    const double minHeight = 0; // always visible base

    // calculate fill height
    final double fillHeight = percent > 0
        ? (maxHeight * (percent / 100)).clamp(minHeight, maxHeight)
        : minHeight;

    return Container(
      height: maxHeight,
      width: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffe1e1e1),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          height: fillHeight,
          width: 14,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientList,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressText({
    required double dashWidth,
    required String simpleText,
    required String boldText,
    String additionalText = '',
    Color dashColor = Colors.black,
    double topPosition = 24.0,
  }) {
    const double maxHeight = 100;
    double minHeight = 24; // always visible base

    // calculate fill height
    final double fillHeight = topPosition > 0
        ? (maxHeight * (topPosition / 100)).clamp(minHeight, maxHeight)
        : minHeight;
    final double marginTop = maxHeight * (topPosition / 100) < minHeight
        ? minHeight - maxHeight * (topPosition / 100)
        : 4;
    return Positioned(
        right: 0,
        bottom: fillHeight - 26,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(top: marginTop),
                child: DottedLine(
                  width: dashWidth,
                  height: 1,
                  color: dashColor,
                  spacing: 1,
                  dotRadius: 1,
                )),
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                text: '$simpleText\n',
                style: TextStyle(
                  fontSize: 10,
                  color: FlutterFlowTheme.of(context).textGrey,
                ),
                children: [
                  TextSpan(
                    text: boldText,
                    style: TextStyle(
                        fontSize: 12,
                        color: FlutterFlowTheme.of(context).textGrey,
                        fontWeight: FontWeight.w700),
                    children: [
                      TextSpan(
                        text: additionalText,
                        style: TextStyle(
                          fontSize: 10,
                          color: FlutterFlowTheme.of(context).textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildMissing({
    required List<String> missingColorName,
  }) {
    return Container(
      height: 100,
      width: 14,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffe1e1e1),
      ),
      child: Column(
        spacing: 2,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: missingColorName.map((missingColor) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Add perspective depth effect
              ..rotateX(0.1) // Rotate along X-axis for 3D effect
              ..rotateY(0.1), // Rotate along Y-axis for 3D effect
            alignment: Alignment.center,
            child: Container(
              width: 12, // Size of the container
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _mapColorNameToColor(missingColor),
                border: Border.all(
                    color: Color(0xff4c4c4c).withOpacity(0.15),
                    width: 0.5,
                    style: BorderStyle.solid),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(76, 76, 76, 0.15),
                    blurRadius: 0,
                    spreadRadius: 0.5,
                    offset: Offset(0, 0), // Shadow direction (bottom-right)
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 3,
                    offset: Offset(-0, -1), // Highlight direction (top-left)
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    _mapColorNameToColor(missingColor).withOpacity(0.85),
                    _mapColorNameToColor(missingColor),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedCard({
    required Color primaryColor,
    required int numberOfPeople,
    required String plantName,
    required String value,
    bool isTopPlant = false,
    int topPosition = 0,
  }) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.29,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              // First shadow (a thin white border shadow)
              const BoxShadow(
                color: Colors.white, // rgba(255, 255, 255, 1)
                offset: Offset(0, 0),
                blurRadius: 0,
                spreadRadius: 1, // Equivalent to the 1px spread in CSS
              ),
              // Second shadow (a subtle dark shadow)
              BoxShadow(
                color: Colors.black.withOpacity(0.08), // rgba(0, 0, 0, 0.08)
                offset: Offset(0, 2),
                blurRadius: 7,
                spreadRadius: 0,
              ),
            ],
            color: Color(0xfff2f2f2),
            gradient: LinearGradient(
                colors: isTopPlant
                    ? [
                        Color(0xfff5eef4),
                        Color(0xffeef1ea),
                      ]
                    : [
                        Color(0xfff2f2f2),
                        Color(0xfff2f2f2),
                      ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.3, 1.0]),
          ),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.2),
                  border: Border.all(
                      color: primaryColor.withOpacity(0.4),
                      width: 2,
                      style: BorderStyle.solid),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$numberOfPeople\n',
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 22),
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            height: 0.5),
                      ),
                      Text(
                        'People',
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 10),
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            height: 0.2),
                      ),
                    ]),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$plantName\n',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 14),
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        overflow: TextOverflow.ellipsis,
                        height: 1.286),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Total: ',
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 10),
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                            height: 1.8),
                        children: [
                          TextSpan(
                            text: value,
                            style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 10),
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                                height: 1.8),
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isTopPlant)
          Positioned(
            top: 4,
            left: 6,
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/icons/ribbon.svg', // Use dynamic icon
                  width: 16,
                  height: 19,
                  colorFilter: ColorFilter.mode(
                    primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
                Positioned(
                  top: 1.5,
                  left: 2,
                  child: Container(
                    width: 11,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid)),
                    child: Text(
                      topPosition.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showCustomDialogAt(
      {required String weekNumber,
      required Color upperColor,
      required Color lowerColor,
      required barData,
      bool hasGradient = false}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // no background dim
      builder: (context) {
        final CarouselSliderController _controller = CarouselSliderController();
        int _currentIndex = 0;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // close dialog
                },
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              right: 14,
              left: 14,
              top: 250,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 20,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.yourWeeklyConsistency,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 16),
                            fontWeight: FontWeight.w700,
                            height: 1.2),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                height: 168,
                                initialPage: 0,
                                viewportFraction: 86 /
                                    (MediaQuery.of(context).size.width - 84),
                                enlargeCenterPage: false,
                                enableInfiniteScroll: false,
                                scrollDirection: Axis.horizontal,
                                autoPlay: false,
                                onPageChanged: (index, _) {
                                  setState(() => _currentIndex = index);
                                },
                              ),
                              items: List.generate(barData.length, (index) {
                                final item = barData[index];
                                final isLast = index == barData.length - 1;
                                final double maxValue = barData.isNotEmpty
                                    ? (barData
                                        .map((e) =>
                                            (e['totalValue'] ?? 0).toDouble())
                                        .reduce((a, b) => a > b ? a : b))
                                    : 1.0; // avoid empty reduce error

                                final double safeMaxValue =
                                    maxValue > 0 ? maxValue : 1.0;

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      spacing: 6,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            DoubleBarWidget(
                                              totalValue: item['totalValue'],
                                              maxBarHeight: safeMaxValue,
                                              lowerColor: lowerColor,
                                              upperColor: upperColor,
                                              showStar: (item['totalValue'] ==
                                                      bestWeekValue) &&
                                                  (bestWeekValue > 0),
                                              hasGradient: hasGradient,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          item['week'],
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 8),
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff434343),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Divider — hidden for last item
                                    if (!isLast)
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          Positioned(
                            left: -18,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.chevron_left,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  await _model.carouselController?.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: -18,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 8.0, 0.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.chevron_right_sharp,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  await _model.carouselController?.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWaterDialog(
      {required String weekNumber,
      required Color upperColor,
      required Color lowerColor,
      required barData,
      bool hasGradient = false}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // no background dim
      builder: (context) {
        final CarouselSliderController _controller = CarouselSliderController();
        int _currentIndex = 0;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // close dialog
                },
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              right: 14,
              left: 14,
              top: 250,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 20,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.yourTotalWeeklyWater(3.4),
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 16),
                            fontWeight: FontWeight.w700,
                            height: 1.2),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                height: 168,
                                initialPage: 0,
                                viewportFraction: 86 /
                                    (MediaQuery.of(context).size.width - 84),
                                enlargeCenterPage: false,
                                enableInfiniteScroll: false,
                                scrollDirection: Axis.horizontal,
                                autoPlay: false,
                                onPageChanged: (index, _) {
                                  setState(() => _currentIndex = index);
                                },
                              ),
                              items: List.generate(barData.length, (index) {
                                final item = barData[index];
                                final isLast = index == barData.length - 1;
                                final double maxValue = 14.0;
                                // final double maxValue = barData.isNotEmpty
                                //     ? (barData
                                //         .map((e) =>
                                //             (e['totalValue'] ?? 0).toDouble())
                                //         .reduce((a, b) => a > b ? a : b))
                                //     : 1.0; // avoid empty reduce error

                                final double safeMaxValue =
                                    maxValue > 0 ? maxValue : 1.0;

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      spacing: 6,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            DoubleBarWidget(
                                              totalValue: item['totalValue'],
                                              maxBarHeight: safeMaxValue,
                                              lowerColor: lowerColor,
                                              upperColor: upperColor,
                                              showStar: (item['totalValue'] ==
                                                      bestWeekValue) &&
                                                  (bestWeekValue > 0),
                                              hasGradient: hasGradient,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          item['week'],
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 8),
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff434343),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Divider — hidden for last item
                                    if (!isLast)
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          Positioned(
                            left: -18,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.chevron_left,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  await _model.carouselController?.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: -18,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 8.0, 0.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.chevron_right_sharp,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  await _model.carouselController?.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAvgPlantDiversityDialog({
    required List<Map<String, dynamic>>
        individualData, // e.g. [{week:'Week 43',score:1.4},...]
    required List<Map<String, dynamic>>
        communityData, // e.g. [{week:'Week 44',score:1.19},...]
    required Color yourColor,
    required Color communityColor,
    bool hasGradient = false,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        final CarouselSliderController _controller = CarouselSliderController();
        int _currentIndex = 0;

        /// ✅ Step 1: Merge all unique week numbers from both lists
        final Set<String> allWeeks = {
          ...individualData.map((e) => e['week']),
          ...communityData.map((e) => e['week']),
        };

        /// ✅ Step 2: Sort weeks like Week 40 → Week 41 → Week 42...
        final List<String> sortedWeeks = allWeeks.toList()
          ..sort((a, b) {
            int w1 = int.tryParse(a.replaceAll('Week', '').trim()) ?? 0;
            int w2 = int.tryParse(b.replaceAll('Week', '').trim()) ?? 0;
            return w1.compareTo(w2);
          });

        /// ✅ Step 3: Find max value for scaling (safe for missing weeks)
        final double maxValue = [
          ...individualData.map((e) => e["score"] as double),
          ...communityData.map((e) => e["score"] as double),
        ].reduce((a, b) => a > b ? a : b);

        /// ✅ Highest user score for star marker
        final double yourMaxValue = individualData
            .map((e) => e["score"] as double)
            .reduce((a, b) => a > b ? a : b);

        return Stack(
          children: [
            /// Background tap to close
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.black.withOpacity(0.15)),
              ),
            ),

            /// Main popup
            Positioned(
              right: 14,
              left: 14,
              top: 250,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 20,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .weeklyPlantDiversityAverage,
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 16),
                            fontWeight: FontWeight.w700,
                            height: 1.2),
                      ),

                      /// ✅ Bar Chart Section
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.center,
                        children: [
                          CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              height: 168,
                              initialPage: 0,
                              viewportFraction:
                                  86 / (MediaQuery.of(context).size.width - 84),
                              enlargeCenterPage: false,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, _) {
                                setState(() => _currentIndex = index);
                              },
                            ),
                            items: List.generate(sortedWeeks.length, (index) {
                              final String week = sortedWeeks[index];

                              // ✅ Safe lookup → If community doesn't have this week → return 0
                              final user = individualData.firstWhere(
                                (e) => e['week'] == week,
                                orElse: () => <String, Object>{
                                  'week': week,
                                  'score': 0.0,
                                },
                              );

                              final community = communityData.firstWhere(
                                (e) => e['week'] == week,
                                orElse: () => <String, Object>{
                                  'week': week,
                                  'score': 0.0,
                                },
                              );

                              final bool isLast =
                                  index == sortedWeeks.length - 1;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    spacing: 6,
                                    children: [
                                      Row(
                                        spacing: 4,
                                        children: [
                                          DoubleBarWidget(
                                            totalValue: user['score'],
                                            maxBarHeight: maxValue,
                                            lowerColor: yourColor,
                                            upperColor: yourColor,
                                            showStar:
                                                user['score'] == yourMaxValue,
                                            hasGradient: hasGradient,
                                          ),
                                          DoubleBarWidget(
                                            totalValue: community['score'],
                                            maxBarHeight: maxValue,
                                            lowerColor: communityColor,
                                            upperColor: communityColor,
                                            hasGradient: hasGradient,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        week,
                                        style: TextStyle(
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 8),
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff434343),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isLast)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 151,
                                      width: 2,
                                      color: const Color(0xffececec),
                                    ),
                                ],
                              );
                            }),
                          ),

                          /// Left Arrow
                          Positioned(
                            left: -18,
                            child: InkWell(
                              onTap: () => _controller.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              ),
                              child: Icon(
                                Icons.chevron_left,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                            ),
                          ),

                          /// Right Arrow
                          Positioned(
                            right: -18,
                            child: InkWell(
                              onTap: () => _controller.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// ✅ Legends
                      Wrap(
                        spacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          _legendDot(yourColor,
                              AppLocalizations.of(context)!.yourScore),
                          _legendDot(communityColor,
                              AppLocalizations.of(context)!.communityScore),
                          _legendDot(yourColor,
                              AppLocalizations.of(context)!.highestScore,
                              icon: Icons.stars),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Legend builder
  Widget _legendDot(Color color, String label, {IconData icon = Icons.circle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: FlutterFlowTheme.adjustScale(size: 8))),
      ],
    );
  }

  /// ✅ Reusable legend icon widget
  Widget _buildLegend(Color color, String label,
      {IconData icon = Icons.circle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: FlutterFlowTheme.adjustScale(size: 8))),
      ],
    );
  }

  void _showAvgPlantPortionDialog({
    required List<Map<String, dynamic>>
        individualData, // [{week: 'Week 40', score: 1020}]
    required List<Map<String, dynamic>>
        communityData, // [{week: 'Week 44', score: 676}]
    required Color yourColor,
    required Color communityColor,
    bool hasGradient = false,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        final CarouselSliderController _controller = CarouselSliderController();
        int _currentIndex = 0;

        /// ✅ 1. Collect all unique weeks from both datasets
        final Set<String> allWeeks = {
          ...individualData.map((e) => e['week']),
          ...communityData.map((e) => e['week']),
        };

        /// ✅ 2. Sort weeks numerically
        final List<String> sortedWeeks = allWeeks.toList()
          ..sort((a, b) {
            int w1 = int.tryParse(a.replaceAll('Week', '').trim()) ?? 0;
            int w2 = int.tryParse(b.replaceAll('Week', '').trim()) ?? 0;
            return w1.compareTo(w2);
          });

        /// ✅ 3. Get max value for consistent bar height scaling
        final double maxValue = [
          ...individualData.map((e) => e['score'] as double),
          ...communityData.map((e) => e['score'] as double),
        ].reduce((a, b) => a > b ? a : b);

        /// ✅ 4. Highest user score for star indicator
        final double yourMaxValue = individualData
            .map((e) => e['score'] as double)
            .reduce((a, b) => a > b ? a : b);

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.black.withOpacity(0.15)),
              ),
            ),
            Positioned(
              right: 14,
              left: 14,
              top: 250,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 20,
                    children: [
                      Text(
                        'Weekly Average Portion',
                        style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(size: 16),
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.center,
                        children: [
                          CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              height: 168,
                              initialPage: 0,
                              viewportFraction:
                                  86 / (MediaQuery.of(context).size.width - 84),
                              enlargeCenterPage: false,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, _) {
                                setState(() => _currentIndex = index);
                              },
                            ),
                            items: List.generate(sortedWeeks.length, (index) {
                              final String week = sortedWeeks[index];

                              // ✅ Ensure safe fallback values if week missing in either list
                              final user = individualData.firstWhere(
                                (e) => e['week'] == week,
                                orElse: () => <String, Object>{
                                  'week': week,
                                  'score': 0.0,
                                },
                              );
                              final community = communityData.firstWhere(
                                (e) => e['week'] == week,
                                orElse: () => <String, Object>{
                                  'week': week,
                                  'score': 0.0,
                                },
                              );

                              final bool isLast =
                                  index == sortedWeeks.length - 1;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    spacing: 6,
                                    children: [
                                      Row(
                                        spacing: 4,
                                        children: [
                                          // ✅ User bar
                                          DoubleBarWidget(
                                            totalValue: (user['score'] as num)
                                                .roundToDouble(),
                                            maxBarHeight: maxValue,
                                            lowerColor: yourColor,
                                            upperColor: yourColor,
                                            showStar:
                                                user['score'] == yourMaxValue,
                                            hasGradient: hasGradient,
                                          ),
                                          // ✅ Community bar
                                          DoubleBarWidget(
                                            totalValue:
                                                (community['score'] as num)
                                                    .roundToDouble(),
                                            maxBarHeight: maxValue,
                                            lowerColor: communityColor,
                                            upperColor: communityColor,
                                            hasGradient: hasGradient,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        week,
                                        style: TextStyle(
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 8),
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff434343),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isLast)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 151,
                                      width: 2,
                                      color: const Color(0xffececec),
                                    ),
                                ],
                              );
                            }),
                          ),
                          // Navigation arrows
                          Positioned(
                            left: -18,
                            child: InkWell(
                              onTap: () => _controller.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              ),
                              child: Icon(Icons.chevron_left,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText),
                            ),
                          ),
                          Positioned(
                            right: -18,
                            child: InkWell(
                              onTap: () => _controller.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              ),
                              child: Icon(Icons.chevron_right,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText),
                            ),
                          ),
                        ],
                      ),
                      // ✅ Legends
                      Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildLegendIcon(yourColor, 'Your Score'),
                          _buildLegendIcon(communityColor, 'Community Score'),
                          _buildLegendIcon(yourColor, 'Highest Health Score',
                              icon: Icons.stars),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Reusable legend widget
  Widget _buildLegendIcon(Color color, String label,
      {IconData icon = Icons.circle}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: FlutterFlowTheme.adjustScale(size: 8))),
      ],
    );
  }

  void _showMissingColorsDialog(
      {required String weekNumber,
      required barData,
      bool hasGradient = false}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // no background dim
      builder: (context) {
        final CarouselSliderController _controller = CarouselSliderController();
        int _currentIndex = 0;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // close dialog
                },
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              right: 14,
              left: 14,
              top: 250,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 20,
                    children: [
                      Text(
                        'Your Weekly Missing Colors',
                        style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 16),
                            fontWeight: FontWeight.w700,
                            height: 1.2),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: AlignmentDirectional.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                height: 132,
                                initialPage: 0,
                                viewportFraction: 86 /
                                    (MediaQuery.of(context).size.width - 84),
                                enlargeCenterPage: false,
                                enableInfiniteScroll: false,
                                scrollDirection: Axis.horizontal,
                                autoPlay: false,
                                onPageChanged: (index, _) {
                                  setState(() => _currentIndex = index);
                                },
                              ),
                              items: List.generate(barData.length, (index) {
                                final item = barData[index];
                                final isLast = index == barData.length - 1;

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      spacing: 6,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            _buildMissing(
                                                missingColorName:
                                                    _sortColorsByRainbow(
                                                        item['colorsMissing'])),
                                          ],
                                        ),
                                        Text(
                                          item['week'],
                                          style: TextStyle(
                                            fontSize:
                                                FlutterFlowTheme.adjustScale(
                                                    size: 8),
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff434343),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Divider — hidden for last item
                                    if (!isLast)
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 116,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          Positioned(
                            left: -18,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.chevron_left,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  await _model.carouselController?.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: -18,
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 8.0, 0.0),
                              child: InkWell(
                                child: Icon(
                                  Icons.chevron_right_sharp,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onTap: () async {
                                  await _model.carouselController?.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DottedLine extends StatelessWidget {
  final double width; // Total line width
  final double height; // Dot thickness
  final Color color; // Dot color
  final double spacing; // Space between dots
  final double dotRadius; // Dot radius
  final bool isVertical; // Orientation

  const DottedLine({
    super.key,
    this.width = 200,
    this.height = 2,
    this.color = Colors.black,
    this.spacing = 4,
    this.dotRadius = 2,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: isVertical
          ? Size(height, width) // swap for vertical
          : Size(width, height),
      painter: _DottedLinePainter(
        color: color,
        spacing: spacing,
        dotRadius: dotRadius,
        isVertical: isVertical,
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double dotRadius;
  final bool isVertical;

  _DottedLinePainter({
    required this.color,
    required this.spacing,
    required this.dotRadius,
    required this.isVertical,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final maxLength = isVertical ? size.height : size.width;
    double current = 0;

    while (current < maxLength) {
      final dx = isVertical ? size.width / 2 : current + dotRadius;
      final dy = isVertical ? current + dotRadius : size.height / 2;

      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);

      current += (dotRadius * 2) + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
