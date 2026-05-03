// =====================================================
// FILE: lib/pages/explore/explore_page.dart
// =====================================================

import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/backend/supabase/database/database.dart';
import 'package:the_lively_three/components/filter_bottom_sheet/filter_bottom_sheet_widget.dart';
import 'package:the_lively_three/custom_code/widgets/custom_bar_widget.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:intl/intl.dart';
import 'package:the_lively_three/pages/explore/explore_model.dart';
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';
import '/l10n/app_localizations.dart';
import 'package:the_lively_three/utils/filters_preferences_service.dart';
import 'package:the_lively_three/utils/create_community.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  static String routeName = 'Explore';
  static String routePath = '/explore';

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late ExploreModel _model;
  bool _isSwitched = false;
  // Add subscription checking variables
  bool _checkingSubscription = true;
  bool _hasValidSubscription = false;
  bool _initialLoadComplete = false;
  // ⭐ NEW: Loading overlay state
  bool _isLoadingOverlay = false;
  double communityScore = 0.0;
  double healthScoreWeeklyI = 0;
  bool _isUserLoading = true;
  List<Map<String, dynamic>> barData = [];
  double bestWeekValue = 0;
  double consistencyScoreWeeklyI = 0;
  final List<int> dummyCommunity = [80, 95, 88, 76, 90];

  // ⭐ NEW: Consent and filter tracking
  bool _hasAgreementConsent = false;
  bool _checkingConsent = true;
  bool _hasFilterPreferences = false;
  Map<String, dynamic>? _userFilterPreferences;
  String? _globalCommunityId;
  final filterPreferencesService = FilterPreferencesService();
  final createCommunity = CreateCommunityService();

  @override
  void initState() {
    super.initState();
    print('ExplorePage initState');
    _model = ExploreModel();
    // Load indicators when page initializes
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _model.loadCurrentWeekIndicators();
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // showPermissionPopup(context);
      // showSubscriptionPopup(context);
      _checkUserSubscription();
    });
  }

  @override
  void dispose() {
    print('ExplorePage dispose');
    _model.dispose();
    super.dispose();
  }

  _getprogressColorValue(double progressValue) {
    if (progressValue! < 25.0) {
      return Color(0xffF28B82);
    } else if (progressValue! < 50.0) {
      return Color(0xffF99964);
    } else if (progressValue! < 75.0) {
      return Color(0xffFDDC6C);
    } else {
      return Color(0xffFDDC6C);
    }
  }

  Future<void> _checkUserSubscription() async {
    setState(() {
      _checkingSubscription = true;
    });

    var l10n = AppLocalizations.of(context)!;

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('has_subscription, subscription_expires_at')
          .eq('id', currentUserUid)
          .single();

      final bool hasSubscription = response['has_subscription'] ?? false;
      final String? expiresAtStr = response['subscription_expires_at'];

      bool isValid = false;

      if (hasSubscription && expiresAtStr != null) {
        final expiresAt = DateTime.parse(expiresAtStr);
        final now = DateTime.now();
        isValid = expiresAt.isAfter(now);
      }

      setState(() {
        _hasValidSubscription = isValid;
        _checkingSubscription = false;
      });

      if (!isValid) {
        debugPrint('🔴 Subscription invalid - showing popup');

        if (mounted) {
          // Show subscription popup and wait for it to close
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => UpgradeSubscriptionPage(
              onSuccess: 'explore',
              onFailure: 'Home',
              popupTitle: l10n.popupTitleExplore,
              popupSubTitle: l10n.popupSubTitleExplore,
            ),
          );
        }
      }

      // Load indicators AFTER subscription check (and popup if shown)
      if (mounted) {
        // ⭐ NEW: Check consent and load community data
        await _checkAgreementConsent();

        if (_hasAgreementConsent) {
          final now = DateTime.now();
          final currentWeek = _model.getISOWeekNumber(now);
          final currentYear = now.year;

          await _model.loadCommunityIndicatorId(
            calendarWeek: currentWeek,
            calendarYear: currentYear,
          );

          await _loadSavedPreferences();
          await _loadCommunityScores(currentYear);
        }

        setState(() {
          _initialLoadComplete = true;
        });
        await _model.loadCurrentWeekIndicators();
        // Add this:
        final now = DateTime.now();
        await fetchUserIndicators(
          userId: currentUserUid,
          calendarYear: now.year,
          calendarWeek: _model.getISOWeekNumber(now),
        );
      }
    } catch (e) {
      debugPrint('Error checking subscription: $e');
      setState(() {
        _checkingSubscription = false; // ✅ Also set to false before error popup
        _hasValidSubscription = false;
      });

      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const UpgradeSubscriptionPage(
            onSuccess: 'explore',
            onFailure: 'Home',
            popupTitle: "Know Your Impact. Improve Your Choices.",
            popupSubTitle:
                "To explore the weekly health score, please subscribe and give permission to data access.",
          ),
        );

        // Load indicators after error popup
        if (mounted) {
          // ⭐ NEW: Check consent and load community data
          await _checkAgreementConsent();

          if (_hasAgreementConsent) {
            final now = DateTime.now();
            final currentWeek = _model.getISOWeekNumber(now);
            final currentYear = now.year;

            await _model.loadCommunityIndicatorId(
              calendarWeek: currentWeek,
              calendarYear: currentYear,
            );

            await _loadSavedPreferences();
            await _loadCommunityScores(currentYear);
          }

          setState(() {
            _initialLoadComplete = true;
          });
          await _model.loadCurrentWeekIndicators();
          // Add this:
          final now = DateTime.now();
          await fetchUserIndicators(
            userId: currentUserUid,
            calendarYear: now.year,
            calendarWeek: _model.getISOWeekNumber(now),
          );
        }
      }
    }
  }

  /// ⭐ NEW: Check agreement consent
  Future<void> _checkAgreementConsent() async {
    setState(() {
      _checkingConsent = true;
    });

    try {
      final supabase = Supabase.instance.client;

      // 1. Get party_id for this user
      final partyRes = await supabase
          .from('party')
          .select('id')
          .eq('user_id', currentUserUid)
          .maybeSingle();

      if (partyRes == null) {
        debugPrint('❌ No party found for this user');
        setState(() {
          _hasAgreementConsent = false;
          _checkingConsent = false;
        });
        // TODO: Show consent popup here if needed
        return;
      }

      final partyId = partyRes['id'];

      // 2. Get the agreement record
      final agreementRes = await supabase
          .from('agreement')
          .select('id')
          .eq('code', 'WCI')
          .maybeSingle();

      if (agreementRes == null) {
        debugPrint('❌ Agreement "Weekly Community Indicators" not found');
        setState(() {
          _hasAgreementConsent = false;
          _checkingConsent = false;
        });
        // TODO: Show consent popup here if needed
        return;
      }

      final agreementId = agreementRes['id'];

      // 3. Check latest agreement_approval
      final approvalRes = await supabase
          .from('agreement_approval')
          .select('is_active, deactivated_at')
          .eq('agreement_id', agreementId)
          .eq('party_id', partyId)
          .order('occurred_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (approvalRes == null) {
        debugPrint('ℹ️ No approval record found - user has not consented yet');
        setState(() {
          _hasAgreementConsent = false;
          _checkingConsent = false;
        });
        // TODO: Show consent popup here if needed
        return;
      }

      final bool isActive = approvalRes['is_active'] ?? false;
      final String? deactivatedAt = approvalRes['deactivated_at'];

      bool hasConsent = false;

      if (isActive) {
        hasConsent = true;
        debugPrint('✅ CONSENTED: is_active = true');
      } else if (!isActive && deactivatedAt != null) {
        try {
          final deactivatedDate = DateTime.parse(deactivatedAt);
          final now = DateTime.now();
          hasConsent = deactivatedDate.isAfter(now);
          if (hasConsent) {
            debugPrint('✅ CONSENTED: deactivated_at is in the future');
          }
        } catch (e) {
          debugPrint('⚠️ Error parsing deactivated_at: $e');
        }
      }

      setState(() {
        _hasAgreementConsent = hasConsent;
        _checkingConsent = false;
      });

      if (!hasConsent && mounted) {
        // TODO: Show consent popup here
        debugPrint('⚠️ User has not consented - consent popup should be shown');
      }
    } catch (e) {
      debugPrint('❌ Error checking agreement consent: $e');
      setState(() {
        _hasAgreementConsent = false;
        _checkingConsent = false;
      });
    }
  }

  /// ⭐ NEW: Load saved filter preferences
  Future<void> _loadSavedPreferences() async {
    if (!_hasAgreementConsent) {
      debugPrint('⚠️ No active consent - skipping preference loading');
      setState(() {
        _hasFilterPreferences = false;
        _userFilterPreferences = null;
      });
      return;
    }

    try {
      final preferences =
          await filterPreferencesService.loadFilterPreferences(currentUserUid);

      if (preferences != null) {
        debugPrint('✅ User has filter preferences');
        setState(() {
          _hasFilterPreferences = true;
          _userFilterPreferences = preferences;
        });
      } else {
        debugPrint('ℹ️ No filter preferences found');
        setState(() {
          _hasFilterPreferences = false;
          _userFilterPreferences = null;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading filter preferences: $e');
      setState(() {
        _hasFilterPreferences = false;
        _userFilterPreferences = null;
      });
    }
  }

  /// ⭐ NEW: Load community scores for all weeks
  Future<void> _loadCommunityScores(int year) async {
    try {
      String? communityId;

      // If user has filter preferences, create filtered community
      if (_hasFilterPreferences && _userFilterPreferences != null) {
        debugPrint('🔍 Creating filtered community...');

        final ageCode = _userFilterPreferences!['age_code'] ?? -1;
        final genderCode = _userFilterPreferences!['gender_code'] ?? -1;
        final locationCode = _userFilterPreferences!['location_code'] ?? -1;
        final ethnicityCode = _userFilterPreferences!['ethnicity_code'] ?? -1;

        final communityResult = await createCommunity.createCommunityWithUsers(
          age: ageCode,
          gender: genderCode,
          location: locationCode,
          ethnicity: ethnicityCode,
        );

        communityId = communityResult['communityId'];
        debugPrint('✅ Filtered community ID: $communityId');
      } else {
        // Use global community
        debugPrint('🌍 Using global community...');

        final globalResult = await createCommunity.createCommunityWithUsers(
          age: -1,
          gender: -1,
          location: -1,
          ethnicity: -1,
        );

        communityId = globalResult['communityId'];
        _globalCommunityId = communityId;
        debugPrint('✅ Global community ID: $communityId');
      }

      // Load community scores for all weeks
      await _model.loadCommunityScores(
        communityId: communityId,
        calendarYear: year,
        filterPreferences: _userFilterPreferences,
      );

      debugPrint('✅ Community scores loaded');
    } catch (e) {
      debugPrint('❌ Error loading community scores: $e');
    }
  }

  Future<void> fetchUserIndicators({
    required String userId,
    required int calendarYear,
    required int calendarWeek,
  }) async {
    final supabase = Supabase.instance.client;
    print(
        '🔍 Fetching indicator data for user: $userId, year: $calendarYear ...');

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
    final Map<String, dynamic> userIndicators = {};
    final Map<int, double> healthScoreByWeek = {}; // Week → Value

    //print('\n📊 ====== USER INDICATOR VALUES ======');
    for (final item in data) {
      final indicatorName =
          item['userindicators']?['name'] ?? 'unknown_indicator';
      final indicatorValue = item['value'];
      final idIndicator = item['id_indicator'];
      final calendarWeek = item['calendarweek'];
      final jsonbValue = item['jsonb_value'];
      final calendarYear = item['calendaryear'];
      // Store indicator for access
      currentWeekIndicators[indicatorName] = {
        'value': indicatorValue,
        'week': calendarWeek,
        'year': calendarYear,
        'jsonb': jsonbValue,
      };

      // ✅ Collect weekly consistency values
      if (indicatorName == 'healthscoreweekly_i') {
        final int weekNumber = (item['calendarweek'] is int)
            ? item['calendarweek']
            : int.tryParse(item['calendarweek'].toString()) ?? 0;

        final double value = (item['value'] is num)
            ? (item['value'] as num).toDouble()
            : double.tryParse(item['value'].toString()) ?? 0.0;

        healthScoreByWeek[weekNumber] = value;
      }

      // Print details
      print('----------------------------------------');
      print('🧩 Indicator Name : $indicatorName');
      print('🆔 ID Indicator   : $idIndicator');
      print('📅 Week           : $calendarWeek');
      print('📆 Year           : $calendarYear');
      print('💾 Value          : $indicatorValue');
      print('🧠 JSONB          : $jsonbValue');
    }
    print('----------------------------------------');
    print('✅ Total indicators fetched: ${userIndicators.length}\n');

    // ✅ Prepare barData for _showCustomDialogAt
    final List<Map<String, dynamic>> dynamicBarData =
        healthScoreByWeek.entries.map((e) {
      // ⭐ NEW: Get community value for this week
      double communityValue = 0.0;
      if (_hasAgreementConsent &&
          _model.communityWeeklyScores.containsKey(e.key)) {
        communityValue = _model.communityWeeklyScores[e.key] ?? 0.0;
      }

      return {
        'week': 'Week ${e.key}',
        'weekNumber': e.key,
        'totalValue': e.value,
        'communityValue': communityValue, // ⭐ NEW: Added community value
      };
    }).toList();

    // ✅ Find the highest consistency value to highlight with a star
    double highestValue = 0;
    if (dynamicBarData.isNotEmpty) {
      highestValue = dynamicBarData
          .map((e) => e['totalValue'] as double)
          .reduce((a, b) => a > b ? a : b);
    }

    // ✅ Assign fetched indicator values into state variables
    setState(() {
      healthScoreWeeklyI =
          (currentWeekIndicators['healthscoreweekly_i']?['value'] ?? 0)
              .toDouble();
      consistencyScoreWeeklyI =
          (currentWeekIndicators['consistencyscoreweekly_i']?['value'] ?? 0)
              .toDouble();

      // ⭐ NEW: Set community score for current week
      if (_hasAgreementConsent &&
          _model.communityWeeklyScores.containsKey(calendarWeek)) {
        communityScore = _model.communityWeeklyScores[calendarWeek] ?? 0.0;
        print('✅ Community score for week $calendarWeek: $communityScore');
      } else {
        communityScore = 0.0;
        print('ℹ️ Community score set to 0 (consent: $_hasAgreementConsent)');
      }

      // new: all-week bar data
      barData = dynamicBarData;
      bestWeekValue = highestValue;

      _isUserLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .secondaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    var l10n = AppLocalizations.of(context);
    return Scaffold(
        // key: scaffoldKey,
        // backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        extendBody: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
          title: Text(
            l10n.weeklyHealthScore, //"Weekly Health Score",
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 20),
              fontWeight: FontWeight.w700,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SilverButton(
                  circularShape: true,
                  buttonFunction: () async {
                    print('🔘 Opening filter bottom sheet...');

                    final result =
                        await showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => FilterBottomSheetWidget(),
                    );

                    print('🔙 Filter sheet closed. Result: $result');

                    // ⭐ UPDATED: Use loading overlay instead of _isUserLoading
                    if (result != null) {
                      // ⭐ NEW: Show loading overlay
                      setState(() {
                        _isLoadingOverlay = true;
                      });

                      print('🔄 Filter applied, reloading community data...');

                      try {
                        // Option 1: If FilterBottomSheet returns community values, use them
                        if (result.containsKey('communityValue') &&
                            result['communityValue'] != null) {
                          print('✅ Using community values from filter sheet');

                          final communityValueMap =
                              result['communityValue'] as Map;

                          // Update from returned values if available
                          if (_model.communityHealthScoreIndicatorId != null) {
                            final newScore = communityValueMap[
                                _model.communityHealthScoreIndicatorId];
                            if (newScore != null) {
                              communityScore = (newScore as num).toDouble();
                              print(
                                  '✅ Updated community score: $communityScore');
                            }
                          }
                        }

                        // Option 2: Always reload from database to get all weeks
                        // (This ensures bar chart is also updated for all weeks)
                        print(
                            '🔄 Reloading all community data from database...');

                        // Reload filter preferences
                        await _loadSavedPreferences();

                        // Reload community scores with new filters
                        final now = DateTime.now();
                        final currentYear = now.year;
                        final currentWeek = _model.getISOWeekNumber(now);

                        await _loadCommunityScores(currentYear);

                        // Reload user indicators to update barData with new community values
                        await fetchUserIndicators(
                          userId: currentUserUid,
                          calendarYear: currentYear,
                          calendarWeek: currentWeek,
                        );

                        print('✅ Community data reloaded with new filters');
                      } finally {
                        // ⭐ NEW: Hide loading overlay
                        if (mounted) {
                          setState(() {
                            _isLoadingOverlay = false;
                          });
                        }
                      }
                    } else {
                      print('ℹ️ Filter cancelled or no changes made');
                    }
                  },
                  hasIcon: true,
                  iconWidget: Image.asset(
                    'assets/icons/filter_icon.png',
                    width: 16,
                    height: 16,
                  ),
                  paddingHorizontal: 4,
                  paddingVertical: 4),
            )
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // ⭐ Original content
              _checkingSubscription
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFFA8E6CF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.checkingSubscription,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 14),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListenableBuilder(
                      listenable: _model,
                      builder: (context, child) {
                        print(
                            'Building with isLoading: ${_model.isLoading}, error: ${_model.error}');

                        // Loading state (after subscription check)
                        if (_model.isLoading) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: Color(0xFFA8E6CF),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.loadinghealthData,
                                  // 'Loading your health data...',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 14),
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Error state
                        if (_model.error != null) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline,
                                      size: 48, color: Colors.red),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.errorLoadingData,
                                    // 'Error loading data',
                                    style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 18),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${_model.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 14)),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _model.loadCurrentWeekIndicators(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFA8E6CF),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Text(l10n.retry), //'Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Get indicator values
                        final indicators = _model.indicators;

                        // If no data yet, show loading spinner
                        if (indicators == null || _isUserLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFA8E6CF),
                            ),
                          );
                        }

                        final healthScore = indicators.healthScoreWeekly;

                        // Streak values
                        final healthScoreCurrentStreak =
                            indicators.healthScoreCurrentStreak;
                        final healthScoreLongestStreak =
                            indicators.healthScoreLongestStreak;
                        final portionCurrentStreak =
                            indicators.portionCurrentStreak;
                        final portionLongestStreak =
                            indicators.portionLongestStreak;
                        final colorCurrentStreak =
                            indicators.colorCurrentStreak;
                        final colorLongestStreak =
                            indicators.colorLongestStreak;
                        final diversityCurrentStreak =
                            indicators.diversityCurrentStreak;
                        final diversityLongestStreak =
                            indicators.diversityLongestStreak;

                        // Max values
                        final maxDiversityValue = indicators.maxDiversityValue;
                        final maxDiversityWeekYear =
                            indicators.maxDiversityWeekYear;
                        final maxPortionValue = indicators.maxPortionValue;
                        final maxPortionDay = indicators.maxPortionDay;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // --- Circular Indicators ---
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: _buildCircularIndicator(
                                        l10n.healthScore, //"Health Score",
                                        healthScore.toInt(),
                                        _getprogressColorValue(healthScore)),
                                  ),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 24),
                                        child: _buildCircularIndicator(
                                            l10n.community, //"Community",
                                            communityScore.round(),
                                            _getprogressColorValue(
                                                communityScore)),
                                      ),
                                      // Positioned(
                                      //   top: 0,
                                      //   right: 0,
                                      //   child: InkWell(
                                      //       onTap: () async {
                                      //         final result = await showModalBottomSheet<
                                      //             Map<String, dynamic>>(
                                      //           context: context,
                                      //           isScrollControlled: true,
                                      //           backgroundColor: Colors.transparent,
                                      //           builder: (context) =>
                                      //               FilterBottomSheetWidget(),
                                      //         );
                                      //         if (result != null &&
                                      //             result
                                      //                 .containsKey('communityValue')) {
                                      //           setState(() {
                                      //             communityScore = result[
                                      //                 'communityValue']; // update your circular indicator
                                      //           });

                                      //           print(
                                      //               '🎯 Updated community score: $communityScore');
                                      //         }
                                      //       },
                                      //       child: Container(
                                      //         width: 30,
                                      //         height: 30,
                                      //         decoration: BoxDecoration(
                                      //           color: Colors.transparent,
                                      //         ),
                                      //         child: Icon(
                                      //           Icons.filter_alt,
                                      //           size: 24,
                                      //         ),
                                      //       )),
                                      // )
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                              Text(
                                l10n.weeklyHealthScore,
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 16),
                                  fontWeight: FontWeight.w700,
                                  color: FlutterFlowTheme.of(context).textGrey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 18),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(0, 0),
                                          blurRadius: 1)
                                    ]),
                                child: Column(
                                  spacing: 20,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: CarouselSlider(
                                            items: (barData == null ||
                                                    barData!.isEmpty)
                                                ? [
                                                    const Center(
                                                        child: Text(
                                                            "No data available")),
                                                  ]
                                                : List.generate(barData.length,
                                                    (index) {
                                                    final item = barData[index];
                                //                      final double maxValue = barData.isNotEmpty
                                //     ? (barData
                                //         .map((e) =>
                                //             (e['totalValue'] ?? 0).toDouble())
                                //         .reduce((a, b) => a > b ? a : b))
                                //     : 1.0; // avoid empty reduce error

                                // final double safeMaxValue =
                                //     maxValue > 0 ? maxValue : 1.0;
                                                    final yourScore = (barData[
                                                                    index]
                                                                ['totalValue']
                                                            as num)
                                                        .round();
// ⭐ CHANGED: Use real community value instead of dummy data
                                                    final communityScore =
                                                        _hasAgreementConsent
                                                            ? (barData[index][
                                                                    'communityValue'])
                                                                .round()
                                                            : 0;
                                                    final int maxValue = barData
                                                            .isNotEmpty
                                                        ? (barData
                                                            .map((e) =>
                                                                (e['totalValue'] ??
                                                                        0)
                                                                    .round())
                                                            .reduce((a, b) =>
                                                                a > b ? a : b))
                                                        : 1; // avoid empty reduce error

                                                    final double safeMaxValue =
                                                        maxValue.toDouble() > 0
                                                            ? maxValue.toDouble()
                                                            : 1.0;

                                                    return Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Column(
                                                          spacing: 6,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                DoubleBarWidget(
                                                                  totalValue:
                                                                      yourScore
                                                                          .toDouble(),
                                                                  maxBarHeight:
                                                                      safeMaxValue,
                                                                  lowerColor:
                                                                      const Color(
                                                                          0xFFFFA552),
                                                                  upperColor:
                                                                      const Color(
                                                                          0xFFFFA552),
                                                                  showStar: (item[
                                                                              'totalValue'] ==
                                                                          bestWeekValue) &&
                                                                      (bestWeekValue >
                                                                          0), // keep original logic
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                DoubleBarWidget(
                                                                  totalValue:
                                                                      communityScore
                                                                          .toDouble(),
                                                                  maxBarHeight:
                                                                      safeMaxValue,
                                                                  lowerColor:
                                                                      const Color(
                                                                          0xFFE38B42),
                                                                  upperColor:
                                                                      const Color(
                                                                          0xFFE38B42),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              item[
                                                                  'week'], // you can update with actual week label
                                                              style: TextStyle(
                                                                fontSize: FlutterFlowTheme
                                                                    .adjustScale(
                                                                        size:
                                                                            8),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xff434343),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          height: 151,
                                                          width: 2,
                                                          color: const Color(
                                                              0xffececec),
                                                        )
                                                      ],
                                                    );
                                                  }),
                                            carouselController:
                                                _model.carouselController ??=
                                                    CarouselSliderController(),
                                            options: CarouselOptions(
                                              height:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 168),
                                              initialPage: 1,
                                              viewportFraction: 86 /
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      84),
                                              enlargeCenterPage: false,
                                              enlargeFactor: 0,
                                              enableInfiniteScroll: false,
                                              scrollDirection: Axis.horizontal,
                                              autoPlay: false,
                                              onPageChanged: (index, _) =>
                                                  _model.carouselCurrentIndex =
                                                      index,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: -18,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8.0, 0.0, 0.0, 0.0),
                                            child: InkWell(
                                              child: Icon(
                                                Icons.chevron_left,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              onTap: () async {
                                                await _model.carouselController
                                                    ?.previousPage(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: -18,
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 8.0, 0.0),
                                            child: InkWell(
                                              child: Icon(
                                                Icons.chevron_right_sharp,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 24.0,
                                              ),
                                              onTap: () async {
                                                await _model.carouselController
                                                    ?.nextPage(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 12,
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Wrap(
                                          spacing: 4,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.circle,
                                              size: 12,
                                              color: Color(0xFFFFA552),
                                            ),
                                            Text(
                                              l10n.yourScore,
                                              style: TextStyle(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 8),
                                                height: 1.2,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .textGrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          spacing: 4,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.circle,
                                              size: 12,
                                              color: Color(0xFFE38B42),
                                            ),
                                            Text(
                                              l10n.communityScore,
                                              style: TextStyle(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 8),
                                                height: 1.2,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .textGrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          spacing: 4,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.stars,
                                              size: 12,
                                              color: Color(0xFFFFA552),
                                            ),
                                            Text(
                                              l10n.highestHealthScore,
                                              style: TextStyle(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 8),
                                                height: 1.2,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .textGrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // --- Health Score Streak ---
                              _buildInfoCard(
                                title: l10n
                                    .healthSoreStreak, //"HEALTH SCORE STREAK",
                                leftValue: healthScoreCurrentStreak,
                                leftLabel:
                                    l10n.currentStreak, //"Current Streak",
                                rightValue: healthScoreLongestStreak,
                                rightLabel:
                                    l10n.longestStreak, //"Longest Streak",
                                themeColor: const Color(0xff74d9fa),
                                totalWeeks: healthScoreLongestStreak,
                                isWeeklyStreak: true,
                              ),

                              const SizedBox(height: 16),

                              // --- Diversity Streak---
                              _buildInfoCard(
                                title: l10n
                                    .plantDiversityStreak, //"PLANT DIVERSITY STREAK",
                                leftValue: diversityCurrentStreak,
                                leftLabel: l10n.currentStreak,
                                rightValue: diversityLongestStreak,
                                rightLabel: l10n.longestStreak,
                                themeColor: const Color(0xffE463F2),
                                totalWeeks: diversityLongestStreak,
                                isWeeklyStreak: true,
                                highestInfo:
                                    l10n.highestStreak, //'Highest Diversity',
                                highestWeekYearText: maxDiversityWeekYear,
                                highestValueFor: l10n.plants, //'Plants',
                                highestConsumendValue:
                                    maxDiversityValue.toDouble(),
                              ),

                              const SizedBox(height: 16),

                              // --- Color Streak ---
                              _buildInfoCard(
                                title: l10n.colorStreak, //"COLOR STREAK",
                                leftValue: colorCurrentStreak,
                                leftLabel: l10n.currentStreak,
                                rightValue: colorLongestStreak,
                                rightLabel: l10n.longestStreak,
                                themeColor: const Color(0xffF6B14A),
                                totalWeeks: colorLongestStreak,
                                isWeeklyStreak: true,
                              ),

                              const SizedBox(height: 16),

                              // --- Portion Streak (DAILY STREAK) ---
                              _buildInfoCard(
                                title: l10n.portionStreak, //"PORTION STREAK",
                                leftValue: portionCurrentStreak,
                                leftLabel: l10n.currentStreak,
                                rightValue: portionLongestStreak,
                                rightLabel: l10n.longestStreak,
                                themeColor: const Color(0xff84D6C0),
                                totalWeeks: portionLongestStreak,
                                isWeeklyStreak: false,
                                highestInfo: l10n.highestStreak,
                                highestDate: maxPortionDay,
                                highestValueFor: l10n.grams, //'Grams',
                                highestConsumendValue:
                                    maxPortionValue.toDouble(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              if (_isLoadingOverlay)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFFA8E6CF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading Community Data...',
                            // l10n.loadinghealthData,
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 14),
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
// ),
        ));
  }

  Widget _buildCircularIndicator(String label, int percent, Color color) {
    return CircularPercentIndicator(
      radius: 51,
      lineWidth: 12,
      percent: (percent / 100).clamp(0.0, 1.0),
      progressColor: color,
      backgroundColor: const Color(0xFFE5E5E5),
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label:",
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 8),
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          Text(
            " $percent%",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FlutterFlowTheme.adjustScale(size: 14),
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required int leftValue,
    required String leftLabel,
    required int rightValue,
    required int totalWeeks,
    required String rightLabel,
    required Color themeColor,
    bool isWeeklyStreak = true, // NEW: Distinguish weekly vs daily streaks
    String highestInfo = '',
    String highestWeekYearText = '',
    DateTime? highestDate,
    String highestValueFor = '',
    double highestConsumendValue = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FlutterFlowTheme.adjustScale(size: 16),
                letterSpacing: 1,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.info_rounded,
              size: 24,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreakWidget(
          currentStreak: leftValue,
          longestStreak: rightValue,
          activeColor: themeColor,
          totalWeeks: totalWeeks,
          isWeeklyStreak: isWeeklyStreak,
          highestInfo: highestInfo,
          highestWeekYearText: highestWeekYearText,
          highestDate: highestDate,
          highestValueFor: highestValueFor,
          highestConsumendValue: highestConsumendValue,
        )
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selected) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            width: 100,
            height: 32,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(245, 245, 246, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selected,
                items: items
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 14)),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {},
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(57, 60, 83, 1),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StreakWidget extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int totalWeeks;
  final Color activeColor;
  final Color inactiveColor;
  final Color textColor;
  final bool isWeeklyStreak; // NEW: true for weekly, false for daily
  final String highestInfo;
  final String highestWeekYearText;
  final DateTime? highestDate;
  final String highestValueFor;
  final double highestConsumendValue;

  const StreakWidget({
    Key? key,
    required this.currentStreak,
    required this.longestStreak,
    this.totalWeeks = 0,
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.textColor = Colors.black,
    this.isWeeklyStreak = true,
    this.highestInfo = '',
    this.highestWeekYearText = '',
    this.highestDate,
    this.highestValueFor = '',
    this.highestConsumendValue = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if this is days or weeks
    final streakUnit = isWeeklyStreak ? 'Week' : 'Day';
    final streakUnits = isWeeklyStreak ? 'Weeks' : 'Days';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Current Streak
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 2,
            children: [
              Text(
                '${AppLocalizations.of(context)!.currentStreak}:',
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              Text(
                '$currentStreak',
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 14),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                currentStreak == 1 ? streakUnit : streakUnits,
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 12),
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),

          // Show "No Streaks Available" if longestStreak is 0
          if (longestStreak == 0) ...[
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.noStreakAvailable}',
              style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 14),
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
          ] else ...[
            // Normal streak display when longestStreak > 0
            const SizedBox(height: 24),

            // Streak Indicators
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: [
                  if (currentStreak > 1)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        height: 30,
                        width: (38 * (currentStreak - 1)) + 15.0,
                        decoration: BoxDecoration(
                            color: activeColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: _buildStreakIndicators(),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          // Longest Streak
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: const Color(0xfff9f9f9),
                borderRadius: BorderRadius.circular(99)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.longestStreak}:',
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                Text(
                  '$longestStreak',
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 14),
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  longestStreak == 1 ? streakUnit : streakUnits,
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 12),
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),

          // Highest value section
          if (highestConsumendValue > 0)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              color: Color(0xffe1e1e1),
              height: 1,
            ),
          if (highestConsumendValue > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                Text(
                  '$highestInfo',
                  style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 16),
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                // Show week number OR date depending on what's available
                if (highestWeekYearText.isNotEmpty)
                  Text(
                    'Week $highestWeekYearText', // Will display as "Week 41, 2025"
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 12),
                      color: textColor,
                    ),
                  ),
                if (highestDate != null)
                  Text(
                    DateFormat('dd MMM yyyy').format(highestDate!),
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 12),
                      color: textColor,
                    ),
                  ),
                _highesetStatStar(
                    text: highestValueFor,
                    highestValue: highestConsumendValue.toInt(),
                    primaryColor: activeColor,
                    secondaryColor: activeColor)
              ],
            )
        ],
      ),
    );
  }

  Widget _buildStreakIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 12,
      children: List.generate(totalWeeks, (index) {
        final number = index + 1;
        final isActive = number <= currentStreak;

        return _buildStreakIndicator(
          number: number,
          isActive: isActive,
        );
      }),
    );
  }

  Widget _buildStreakIndicator({required int number, required bool isActive}) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: isActive ? activeColor : Color(0xfff9f9f9),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: const Color.fromRGBO(249, 249, 249, 1),
                  spreadRadius: 0.89,
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                ),
                const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.inner,
                ),
                const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.inner,
                ),
              ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xffbababa),
            fontSize: FlutterFlowTheme.adjustScale(size: 16),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _highesetStatStar({
    required String text,
    required int highestValue, // Changed to int (non-nullable)
    Color primaryColor = const Color(0xFF6A11CB),
    Color secondaryColor = const Color(0xFF2575FC),
    double width = 50,
    double height = 50,
  }) {
    return SizedBox(
      width: width + 5,
      height: height + 5,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Transform.rotate(
              angle: 35 * 3.1415926535 / 180,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: primaryColor,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Transform.rotate(
              angle: -15 * 3.1415926535 / 180,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: primaryColor,
                ),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$highestValue',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// // =====================================================
// // FILE: lib/pages/explore/explore_page.dart
// // =====================================================

// import 'dart:math';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
// import 'package:the_lively_three/backend/supabase/database/database.dart';
// import 'package:the_lively_three/components/filter_bottom_sheet/filter_bottom_sheet_widget.dart';
// import 'package:the_lively_three/custom_code/widgets/custom_bar_widget.dart';
// import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
// import 'package:the_lively_three/custom_code/widgets/switchButton.dart';
// import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
// import 'package:intl/intl.dart';
// import 'package:the_lively_three/pages/explore/explore_model.dart';
// import 'package:the_lively_three/pages/subscription/subscription_widget.dart';
// import '/l10n/app_localizations.dart';

// class ExplorePage extends StatefulWidget {
//   const ExplorePage({super.key});
//   static String routeName = 'Explore';
//   static String routePath = '/explore';

//   @override
//   State<ExplorePage> createState() => _ExplorePageState();
// }

// class _ExplorePageState extends State<ExplorePage> {
//   late ExploreModel _model;
//   bool _isSwitched = false;
//   // Add subscription checking variables
//   bool _checkingSubscription = true;
//   bool _hasValidSubscription = false;
//   bool _initialLoadComplete = false;
//   double communityScore = 0.0;
//   double healthScoreWeeklyI = 0;
//   bool _isUserLoading = true;
//   List<Map<String, dynamic>> barData = [];
//   double bestWeekValue = 0;
//   double consistencyScoreWeeklyI = 0;
//   final List<int> dummyCommunity = [80, 95, 88, 76, 90];

//   @override
//   void initState() {
//     super.initState();
//     print('ExplorePage initState');
//     _model = ExploreModel();
//     // Load indicators when page initializes
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   _model.loadCurrentWeekIndicators();
//     // });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // showPermissionPopup(context);
//       // showSubscriptionPopup(context);
//       _checkUserSubscription();
//     });
//   }

//   @override
//   void dispose() {
//     print('ExplorePage dispose');
//     _model.dispose();
//     super.dispose();
//   }

//   _getprogressColorValue(double progressValue) {
//     if (progressValue! < 25.0) {
//       return Color(0xffF28B82);
//     } else if (progressValue! < 50.0) {
//       return Color(0xffF99964);
//     } else if (progressValue! < 75.0) {
//       return Color(0xffFDDC6C);
//     } else {
//       return Color(0xffFDDC6C);
//     }
//   }

//   Future<void> _checkUserSubscription() async {
//     setState(() {
//       _checkingSubscription = true;
//     });

//     var l10n = AppLocalizations.of(context)!;

//     try {
//       final response = await Supabase.instance.client
//           .from('users')
//           .select('has_subscription, subscription_expires_at')
//           .eq('id', currentUserUid)
//           .single();

//       final bool hasSubscription = response['has_subscription'] ?? false;
//       final String? expiresAtStr = response['subscription_expires_at'];

//       bool isValid = false;

//       if (hasSubscription && expiresAtStr != null) {
//         final expiresAt = DateTime.parse(expiresAtStr);
//         final now = DateTime.now();
//         isValid = expiresAt.isAfter(now);
//       }

//       setState(() {
//         _hasValidSubscription = isValid;
//         _checkingSubscription = false;
//       });

//       if (!isValid) {
//         debugPrint('🔴 Subscription invalid - showing popup');

//         if (mounted) {
//           // Show subscription popup and wait for it to close
//           await showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) => UpgradeSubscriptionPage(
//               onSuccess: 'explore',
//               onFailure: 'Home',
//               popupTitle: l10n.popupTitleExplore,
//               popupSubTitle: l10n.popupSubTitleExplore,
//             ),
//           );
//         }
//       }

//       // Load indicators AFTER subscription check (and popup if shown)
//       if (mounted) {
//         setState(() {
//           _initialLoadComplete = true;
//         });
//         await _model.loadCurrentWeekIndicators();
//         // Add this:
//         final now = DateTime.now();
//         await fetchUserIndicators(
//           userId: currentUserUid,
//           calendarYear: now.year,
//           calendarWeek: _model.getISOWeekNumber(now),
//         );
//       }
//     } catch (e) {
//       debugPrint('Error checking subscription: $e');
//       setState(() {
//         _checkingSubscription = false; // ✅ Also set to false before error popup
//         _hasValidSubscription = false;
//       });

//       if (mounted) {
//         await showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => const UpgradeSubscriptionPage(
//             onSuccess: 'explore',
//             onFailure: 'Home',
//             popupTitle: "Know Your Impact. Improve Your Choices.",
//             popupSubTitle:
//                 "To explore the weekly health score, please subscribe and give permission to data access.",
//           ),
//         );

//         // Load indicators after error popup
//         if (mounted) {
//           setState(() {
//             _initialLoadComplete = true;
//           });
//           await _model.loadCurrentWeekIndicators();
//           // Add this:
//           final now = DateTime.now();
//           await fetchUserIndicators(
//             userId: currentUserUid,
//             calendarYear: now.year,
//             calendarWeek: _model.getISOWeekNumber(now),
//           );
//         }
//       }
//     }
//   }

//   Future<void> fetchUserIndicators({
//     required String userId,
//     required int calendarYear,
//     required int calendarWeek,
//   }) async {
//     final supabase = Supabase.instance.client;
//     print(
//         '🔍 Fetching indicator data for user: $userId, year: $calendarYear ...');

//     final response = await supabase
//         .from('user_indicator_values')
//         .select('''
//         id_indicator,
//         value,
//         calendarweek,
//         calendaryear,
//         jsonb_value,
//         userindicators(name)
//       ''')
//         .eq('id_user', userId)
//         .eq('calendaryear', calendarYear)
//         .order('calendarweek', ascending: true);

//     if (response is! List) {
//       print('❌ Unexpected response format: $response');
//       throw Exception('Unexpected response format from Supabase');
//     }

//     final List<Map<String, dynamic>> data =
//         (response as List).cast<Map<String, dynamic>>();

//     // Map to store indicators by name
//     final Map<String, dynamic> currentWeekIndicators = {};
//     final Map<String, dynamic> userIndicators = {};
//     final Map<int, double> healthScoreByWeek = {}; // Week → Value

//     //print('\n📊 ====== USER INDICATOR VALUES ======');
//     for (final item in data) {
//       final indicatorName =
//           item['userindicators']?['name'] ?? 'unknown_indicator';
//       final indicatorValue = item['value'];
//       final idIndicator = item['id_indicator'];
//       final calendarWeek = item['calendarweek'];
//       final jsonbValue = item['jsonb_value'];
//       final calendarYear = item['calendaryear'];
//       // Store indicator for access
//       currentWeekIndicators[indicatorName] = {
//         'value': indicatorValue,
//         'week': calendarWeek,
//         'year': calendarYear,
//         'jsonb': jsonbValue,
//       };

//       // ✅ Collect weekly consistency values
//       if (indicatorName == 'healthscoreweekly_i') {
//         final int weekNumber = (item['calendarweek'] is int)
//             ? item['calendarweek']
//             : int.tryParse(item['calendarweek'].toString()) ?? 0;

//         final double value = (item['value'] is num)
//             ? (item['value'] as num).toDouble()
//             : double.tryParse(item['value'].toString()) ?? 0.0;

//         healthScoreByWeek[weekNumber] = value;
//       }

//       // Print details
//       print('----------------------------------------');
//       print('🧩 Indicator Name : $indicatorName');
//       print('🆔 ID Indicator   : $idIndicator');
//       print('📅 Week           : $calendarWeek');
//       print('📆 Year           : $calendarYear');
//       print('💾 Value          : $indicatorValue');
//       print('🧠 JSONB          : $jsonbValue');
//     }
//     print('----------------------------------------');
//     print('✅ Total indicators fetched: ${userIndicators.length}\n');

//     // ✅ Prepare barData for _showCustomDialogAt
//     final List<Map<String, dynamic>> dynamicBarData = healthScoreByWeek.entries
//         .map((e) => {
//               'week': 'Week ${e.key}',
//               'totalValue': e.value,
//             })
//         .toList();

//     // ✅ Find the highest consistency value to highlight with a star
//     double highestValue = 0;
//     if (dynamicBarData.isNotEmpty) {
//       highestValue = dynamicBarData
//           .map((e) => e['totalValue'] as double)
//           .reduce((a, b) => a > b ? a : b);
//     }

//     // ✅ Assign fetched indicator values into state variables
//     setState(() {
//       healthScoreWeeklyI =
//           (currentWeekIndicators['healthscoreweekly_i']?['value'] ?? 0)
//               .toDouble();
//       consistencyScoreWeeklyI =
//           (currentWeekIndicators['consistencyscoreweekly_i']?['value'] ?? 0)
//               .toDouble();
//       // new: all-week bar data
//       barData = dynamicBarData;
//       bestWeekValue = highestValue;

//       _isUserLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: FlutterFlowTheme.of(context)
//           .secondaryBackground, // Set this to your app's background color
//       statusBarIconBrightness: Brightness.dark, // For light icons in status bar
//     ));
//     var l10n = AppLocalizations.of(context);
//     return Scaffold(
//         // key: scaffoldKey,
//         // backgroundColor: Colors.transparent,
//         resizeToAvoidBottomInset: true,
//         extendBody: false,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
//           centerTitle: false,
//           title: Text(
//             l10n.weeklyHealthScore, //"Weekly Health Score",
//             style: TextStyle(
//               fontSize: FlutterFlowTheme.adjustScale(size: 20),
//               fontWeight: FontWeight.w700,
//               color: FlutterFlowTheme.of(context).primaryText,
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 16),
//               child: SilverButton(
//                   circularShape: true,
//                   buttonFunction: () async {
//                     final result =
//                         await showModalBottomSheet<Map<String, dynamic>>(
//                       context: context,
//                       isScrollControlled: true,
//                       backgroundColor: Colors.transparent,
//                       builder: (context) => FilterBottomSheetWidget(),
//                     );
//                     if (result != null &&
//                         result.containsKey('communityValue')) {
//                       setState(() {
//                         communityScore = result[
//                             'communityValue']; // update your circular indicator
//                       });

//                       print('🎯 Updated community score: $communityScore');
//                     }
//                   },
//                   hasIcon: true,
//                   iconWidget: Image.asset(
//                     'assets/icons/filter_icon.png',
//                     width: 16,
//                     height: 16,
//                   ),
//                   paddingHorizontal: 4,
//                   paddingVertical: 4),
//             )
//           ],
//         ),
//         body: SafeArea(
//           child: _checkingSubscription
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const CircularProgressIndicator(
//                         color: Color(0xFFA8E6CF),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         l10n.checkingSubscription, //'Checking subscription...',
//                         style: TextStyle(
//                           fontSize: FlutterFlowTheme.adjustScale(size: 14),
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListenableBuilder(
//                   listenable: _model,
//                   builder: (context, child) {
//                     print(
//                         'Building with isLoading: ${_model.isLoading}, error: ${_model.error}');

//                     // Loading state (after subscription check)
//                     if (_model.isLoading) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const CircularProgressIndicator(
//                               color: Color(0xFFA8E6CF),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               l10n.loadinghealthData,
//                               // 'Loading your health data...',
//                               style: TextStyle(
//                                 fontSize:
//                                     FlutterFlowTheme.adjustScale(size: 14),
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     // Error state
//                     if (_model.error != null) {
//                       return Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(24.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.error_outline,
//                                   size: 48, color: Colors.red),
//                               const SizedBox(height: 16),
//                               Text(
//                                 l10n.errorLoadingData,
//                                 // 'Error loading data',
//                                 style: TextStyle(
//                                   fontSize:
//                                       FlutterFlowTheme.adjustScale(size: 18),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 '${_model.error}',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize:
//                                         FlutterFlowTheme.adjustScale(size: 14)),
//                               ),
//                               const SizedBox(height: 16),
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     _model.loadCurrentWeekIndicators(),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFFA8E6CF),
//                                   foregroundColor: Colors.black,
//                                 ),
//                                 child: Text(l10n.retry), //'Retry'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }

//                     // Get indicator values
//                     final indicators = _model.indicators;

//                     // If no data yet, show empty state
//                     if (indicators == null) {
//                       return Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.info_outline,
//                                 size: 48, color: Colors.grey),
//                             const SizedBox(height: 16),
//                             Text(l10n
//                                 .noDataAvailable), //'No data available yet'),
//                             const SizedBox(height: 16),
//                             ElevatedButton(
//                               onPressed: () =>
//                                   _model.loadCurrentWeekIndicators(),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFFA8E6CF),
//                                 foregroundColor: Colors.black,
//                               ),
//                               child: Text(l10n.loadData), //'Load Data'),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     final healthScore = indicators.healthScoreWeekly;

//                     // Streak values
//                     final healthScoreCurrentStreak =
//                         indicators.healthScoreCurrentStreak;
//                     final healthScoreLongestStreak =
//                         indicators.healthScoreLongestStreak;
//                     final portionCurrentStreak =
//                         indicators.portionCurrentStreak;
//                     final portionLongestStreak =
//                         indicators.portionLongestStreak;
//                     final colorCurrentStreak = indicators.colorCurrentStreak;
//                     final colorLongestStreak = indicators.colorLongestStreak;
//                     final diversityCurrentStreak =
//                         indicators.diversityCurrentStreak;
//                     final diversityLongestStreak =
//                         indicators.diversityLongestStreak;

//                     // Max values
//                     final maxDiversityValue = indicators.maxDiversityValue;
//                     final maxDiversityWeekYear =
//                         indicators.maxDiversityWeekYear;
//                     final maxPortionValue = indicators.maxPortionValue;
//                     final maxPortionDay = indicators.maxPortionDay;

//                     return SingleChildScrollView(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           // --- Circular Indicators ---
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 24),
//                                 child: _buildCircularIndicator(
//                                     l10n.healthScore, //"Health Score",
//                                     healthScore.toInt(),
//                                     _getprogressColorValue(healthScore)),
//                               ),
//                               Stack(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 24),
//                                     child: _buildCircularIndicator(
//                                         l10n.community, //"Community",
//                                         communityScore.toInt(),
//                                         _getprogressColorValue(communityScore)),
//                                   ),
//                                   // Positioned(
//                                   //   top: 0,
//                                   //   right: 0,
//                                   //   child: InkWell(
//                                   //       onTap: () async {
//                                   //         final result = await showModalBottomSheet<
//                                   //             Map<String, dynamic>>(
//                                   //           context: context,
//                                   //           isScrollControlled: true,
//                                   //           backgroundColor: Colors.transparent,
//                                   //           builder: (context) =>
//                                   //               FilterBottomSheetWidget(),
//                                   //         );
//                                   //         if (result != null &&
//                                   //             result
//                                   //                 .containsKey('communityValue')) {
//                                   //           setState(() {
//                                   //             communityScore = result[
//                                   //                 'communityValue']; // update your circular indicator
//                                   //           });

//                                   //           print(
//                                   //               '🎯 Updated community score: $communityScore');
//                                   //         }
//                                   //       },
//                                   //       child: Container(
//                                   //         width: 30,
//                                   //         height: 30,
//                                   //         decoration: BoxDecoration(
//                                   //           color: Colors.transparent,
//                                   //         ),
//                                   //         child: Icon(
//                                   //           Icons.filter_alt,
//                                   //           size: 24,
//                                   //         ),
//                                   //       )),
//                                   // )
//                                 ],
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 24),
//                           Text(
//                             l10n.weeklyHealthScore,
//                             style: TextStyle(
//                               fontSize: FlutterFlowTheme.adjustScale(size: 16),
//                               fontWeight: FontWeight.w700,
//                               color: FlutterFlowTheme.of(context).textGrey,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 12, horizontal: 18),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: FlutterFlowTheme.of(context)
//                                     .primaryBackground,
//                                 boxShadow: const [
//                                   BoxShadow(
//                                       color: Colors.white,
//                                       offset: Offset(0, 0),
//                                       blurRadius: 1)
//                                 ]),
//                             child: Column(
//                               spacing: 20,
//                               children: [
//                                 Stack(
//                                   clipBehavior: Clip.none,
//                                   alignment: AlignmentDirectional.center,
//                                   children: [
//                                     Align(
//                                       alignment: AlignmentDirectional(0.0, 0.0),
//                                       child: CarouselSlider(
//                                         items: (barData == null ||
//                                                 barData!.isEmpty)
//                                             ? [
//                                                 const Center(
//                                                     child: Text(
//                                                         "No data available")),
//                                               ]
//                                             : List.generate(barData.length,
//                                                 (index) {
//                                                 final item = barData[index];
//                                                 final yourScore =
//                                                     (barData[index]
//                                                                 ['totalValue']
//                                                             as num)
//                                                         .round();
//                                                 final communityScore =
//                                                     dummyCommunity[index %
//                                                             dummyCommunity
//                                                                 .length]
//                                                         .round();
//                                                 final double maxValue = barData
//                                                         .isNotEmpty
//                                                     ? (barData
//                                                         .map((e) =>
//                                                             (e['totalValue'] ??
//                                                                     0)
//                                                                 .toDouble())
//                                                         .reduce((a, b) =>
//                                                             a > b ? a : b))
//                                                     : 1.0; // avoid empty reduce error

//                                                 final double safeMaxValue =
//                                                     maxValue > 0
//                                                         ? maxValue
//                                                         : 1.0;

//                                                 return Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.end,
//                                                   children: [
//                                                     Column(
//                                                       spacing: 6,
//                                                       children: [
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             DoubleBarWidget(
//                                                               totalValue:
//                                                                   yourScore
//                                                                       .toDouble(),
//                                                               maxBarHeight:
//                                                                   safeMaxValue,
//                                                               lowerColor:
//                                                                   const Color(
//                                                                       0xFFFFA552),
//                                                               upperColor:
//                                                                   const Color(
//                                                                       0xFFFFA552),
//                                                               showStar: (item[
//                                                                           'totalValue'] ==
//                                                                       bestWeekValue) &&
//                                                                   (bestWeekValue >
//                                                                       0), // keep original logic
//                                                             ),
//                                                             const SizedBox(
//                                                                 width: 4),
//                                                             DoubleBarWidget(
//                                                               totalValue:
//                                                                   communityScore
//                                                                       .toDouble(),
//                                                               maxBarHeight:
//                                                                   safeMaxValue,
//                                                               lowerColor:
//                                                                   const Color(
//                                                                       0xFFE38B42),
//                                                               upperColor:
//                                                                   const Color(
//                                                                       0xFFE38B42),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Text(
//                                                           item[
//                                                               'week'], // you can update with actual week label
//                                                           style: TextStyle(
//                                                             fontSize:
//                                                                 FlutterFlowTheme
//                                                                     .adjustScale(
//                                                                         size:
//                                                                             8),
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                             color: Color(
//                                                                 0xff434343),
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Container(
//                                                       margin: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 20),
//                                                       height: 151,
//                                                       width: 2,
//                                                       color: const Color(
//                                                           0xffececec),
//                                                     )
//                                                   ],
//                                                 );
//                                               }),
//                                         carouselController:
//                                             _model.carouselController ??=
//                                                 CarouselSliderController(),
//                                         options: CarouselOptions(
//                                           height: FlutterFlowTheme.adjustScale(
//                                               size: 168),
//                                           initialPage: 1,
//                                           viewportFraction: 86 /
//                                               (MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   84),
//                                           enlargeCenterPage: false,
//                                           enlargeFactor: 0,
//                                           enableInfiniteScroll: false,
//                                           scrollDirection: Axis.horizontal,
//                                           autoPlay: false,
//                                           onPageChanged: (index, _) => _model
//                                               .carouselCurrentIndex = index,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       left: -18,
//                                       child: Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             8.0, 0.0, 0.0, 0.0),
//                                         child: InkWell(
//                                           child: Icon(
//                                             Icons.chevron_left,
//                                             color: FlutterFlowTheme.of(context)
//                                                 .secondaryText,
//                                             size: 24.0,
//                                           ),
//                                           onTap: () async {
//                                             await _model.carouselController
//                                                 ?.previousPage(
//                                               duration:
//                                                   Duration(milliseconds: 300),
//                                               curve: Curves.ease,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       right: -18,
//                                       child: Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             0.0, 0.0, 8.0, 0.0),
//                                         child: InkWell(
//                                           child: Icon(
//                                             Icons.chevron_right_sharp,
//                                             color: FlutterFlowTheme.of(context)
//                                                 .secondaryText,
//                                             size: 24.0,
//                                           ),
//                                           onTap: () async {
//                                             await _model.carouselController
//                                                 ?.nextPage(
//                                               duration:
//                                                   Duration(milliseconds: 300),
//                                               curve: Curves.ease,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Wrap(
//                                   spacing: 8,
//                                   runSpacing: 12,
//                                   runAlignment: WrapAlignment.center,
//                                   crossAxisAlignment: WrapCrossAlignment.center,
//                                   alignment: WrapAlignment.center,
//                                   children: [
//                                     Wrap(
//                                       spacing: 4,
//                                       crossAxisAlignment:
//                                           WrapCrossAlignment.center,
//                                       children: [
//                                         const Icon(
//                                           Icons.circle,
//                                           size: 12,
//                                           color: Color(0xFFFFA552),
//                                         ),
//                                         Text(
//                                           l10n.yourScore,
//                                           style: TextStyle(
//                                             fontSize:
//                                                 FlutterFlowTheme.adjustScale(
//                                                     size: 8),
//                                             height: 1.2,
//                                             color: FlutterFlowTheme.of(context)
//                                                 .textGrey,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Wrap(
//                                       spacing: 4,
//                                       crossAxisAlignment:
//                                           WrapCrossAlignment.center,
//                                       children: [
//                                         const Icon(
//                                           Icons.circle,
//                                           size: 12,
//                                           color: Color(0xFFE38B42),
//                                         ),
//                                         Text(
//                                           l10n.communityScore,
//                                           style: TextStyle(
//                                             fontSize:
//                                                 FlutterFlowTheme.adjustScale(
//                                                     size: 8),
//                                             height: 1.2,
//                                             color: FlutterFlowTheme.of(context)
//                                                 .textGrey,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Wrap(
//                                       spacing: 4,
//                                       crossAxisAlignment:
//                                           WrapCrossAlignment.center,
//                                       children: [
//                                         const Icon(
//                                           Icons.stars,
//                                           size: 12,
//                                           color: Color(0xFFFFA552),
//                                         ),
//                                         Text(
//                                           l10n.highestHealthScore,
//                                           style: TextStyle(
//                                             fontSize:
//                                                 FlutterFlowTheme.adjustScale(
//                                                     size: 8),
//                                             height: 1.2,
//                                             color: FlutterFlowTheme.of(context)
//                                                 .textGrey,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           // --- Health Score Streak ---
//                           _buildInfoCard(
//                             title:
//                                 l10n.healthSoreStreak, //"HEALTH SCORE STREAK",
//                             leftValue: healthScoreCurrentStreak,
//                             leftLabel: l10n.currentStreak, //"Current Streak",
//                             rightValue: healthScoreLongestStreak,
//                             rightLabel: l10n.longestStreak, //"Longest Streak",
//                             themeColor: const Color(0xff74d9fa),
//                             totalWeeks: healthScoreLongestStreak,
//                             isWeeklyStreak: true,
//                           ),

//                           const SizedBox(height: 16),

//                           // --- Diversity Streak---
//                           _buildInfoCard(
//                             title: l10n
//                                 .plantDiversityStreak, //"PLANT DIVERSITY STREAK",
//                             leftValue: diversityCurrentStreak,
//                             leftLabel: l10n.currentStreak,
//                             rightValue: diversityLongestStreak,
//                             rightLabel: l10n.longestStreak,
//                             themeColor: const Color(0xffE463F2),
//                             totalWeeks: diversityLongestStreak,
//                             isWeeklyStreak: true,
//                             highestInfo:
//                                 l10n.highestStreak, //'Highest Diversity',
//                             highestWeekYearText: maxDiversityWeekYear,
//                             highestValueFor: l10n.plants, //'Plants',
//                             highestConsumendValue: maxDiversityValue.toDouble(),
//                           ),

//                           const SizedBox(height: 16),

//                           // --- Color Streak ---
//                           _buildInfoCard(
//                             title: l10n.colorStreak, //"COLOR STREAK",
//                             leftValue: colorCurrentStreak,
//                             leftLabel: l10n.currentStreak,
//                             rightValue: colorLongestStreak,
//                             rightLabel: l10n.longestStreak,
//                             themeColor: const Color(0xffF6B14A),
//                             totalWeeks: colorLongestStreak,
//                             isWeeklyStreak: true,
//                           ),

//                           const SizedBox(height: 16),

//                           // --- Portion Streak (DAILY STREAK) ---
//                           _buildInfoCard(
//                             title: l10n.portionStreak, //"PORTION STREAK",
//                             leftValue: portionCurrentStreak,
//                             leftLabel: l10n.currentStreak,
//                             rightValue: portionLongestStreak,
//                             rightLabel: l10n.longestStreak,
//                             themeColor: const Color(0xff84D6C0),
//                             totalWeeks: portionLongestStreak,
//                             isWeeklyStreak: false,
//                             highestInfo: l10n.highestStreak,
//                             highestDate: maxPortionDay,
//                             highestValueFor: l10n.grams, //'Grams',
//                             highestConsumendValue: maxPortionValue.toDouble(),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//         ));
//   }

//   Widget _buildCircularIndicator(String label, int percent, Color color) {
//     return CircularPercentIndicator(
//       radius: 51,
//       lineWidth: 12,
//       percent: (percent / 100).clamp(0.0, 1.0),
//       progressColor: color,
//       backgroundColor: const Color(0xFFE5E5E5),
//       circularStrokeCap: CircularStrokeCap.round,
//       center: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "$label:",
//             style: TextStyle(
//               fontSize: FlutterFlowTheme.adjustScale(size: 8),
//               color: FlutterFlowTheme.of(context).primaryText,
//             ),
//           ),
//           Text(
//             " $percent%",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: FlutterFlowTheme.adjustScale(size: 14),
//               color: FlutterFlowTheme.of(context).primaryText,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required String title,
//     required int leftValue,
//     required String leftLabel,
//     required int rightValue,
//     required int totalWeeks,
//     required String rightLabel,
//     required Color themeColor,
//     bool isWeeklyStreak = true, // NEW: Distinguish weekly vs daily streaks
//     String highestInfo = '',
//     String highestWeekYearText = '',
//     DateTime? highestDate,
//     String highestValueFor = '',
//     double highestConsumendValue = 0,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: FlutterFlowTheme.adjustScale(size: 16),
//                 letterSpacing: 1,
//                 color: FlutterFlowTheme.of(context).primaryText,
//               ),
//             ),
//             const SizedBox(width: 4),
//             Icon(
//               Icons.info_rounded,
//               size: 24,
//               color: FlutterFlowTheme.of(context).primaryText,
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         StreakWidget(
//           currentStreak: leftValue,
//           longestStreak: rightValue,
//           activeColor: themeColor,
//           totalWeeks: totalWeeks,
//           isWeeklyStreak: isWeeklyStreak,
//           highestInfo: highestInfo,
//           highestWeekYearText: highestWeekYearText,
//           highestDate: highestDate,
//           highestValueFor: highestValueFor,
//           highestConsumendValue: highestConsumendValue,
//         )
//       ],
//     );
//   }

//   Widget _buildDropdown(String label, List<String> items, String selected) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: FlutterFlowTheme.adjustScale(size: 16),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Container(
//             width: 100,
//             height: 32,
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//             decoration: BoxDecoration(
//               color: const Color.fromRGBO(245, 245, 246, 1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: selected,
//                 items: items
//                     .map((e) => DropdownMenuItem(
//                           value: e,
//                           child: Text(
//                             e,
//                             style: TextStyle(
//                                 fontSize:
//                                     FlutterFlowTheme.adjustScale(size: 14)),
//                           ),
//                         ))
//                     .toList(),
//                 onChanged: (val) {},
//                 icon: Icon(
//                   Icons.keyboard_arrow_down,
//                   size: 20,
//                   color: FlutterFlowTheme.of(context).primaryText,
//                 ),
//                 style: TextStyle(
//                   fontSize: FlutterFlowTheme.adjustScale(size: 12),
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromRGBO(57, 60, 83, 1),
//                 ),
//                 dropdownColor: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StreakWidget extends StatelessWidget {
//   final int currentStreak;
//   final int longestStreak;
//   final int totalWeeks;
//   final Color activeColor;
//   final Color inactiveColor;
//   final Color textColor;
//   final bool isWeeklyStreak; // NEW: true for weekly, false for daily
//   final String highestInfo;
//   final String highestWeekYearText;
//   final DateTime? highestDate;
//   final String highestValueFor;
//   final double highestConsumendValue;

//   const StreakWidget({
//     Key? key,
//     required this.currentStreak,
//     required this.longestStreak,
//     this.totalWeeks = 0,
//     this.activeColor = const Color(0xFF4CAF50),
//     this.inactiveColor = const Color(0xFFE0E0E0),
//     this.textColor = Colors.black,
//     this.isWeeklyStreak = true,
//     this.highestInfo = '',
//     this.highestWeekYearText = '',
//     this.highestDate,
//     this.highestValueFor = '',
//     this.highestConsumendValue = 0,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Determine if this is days or weeks
//     final streakUnit = isWeeklyStreak ? 'Week' : 'Day';
//     final streakUnits = isWeeklyStreak ? 'Weeks' : 'Days';

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Current Streak
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             spacing: 2,
//             children: [
//               Text(
//                 '${AppLocalizations.of(context)!.currentStreak}:',
//                 style: TextStyle(
//                   fontSize: FlutterFlowTheme.adjustScale(size: 12),
//                   fontWeight: FontWeight.w500,
//                   color: textColor,
//                 ),
//               ),
//               Text(
//                 '$currentStreak',
//                 style: TextStyle(
//                   fontSize: FlutterFlowTheme.adjustScale(size: 14),
//                   fontWeight: FontWeight.bold,
//                   color: textColor,
//                 ),
//               ),
//               Text(
//                 currentStreak == 1 ? streakUnit : streakUnits,
//                 style: TextStyle(
//                   fontSize: FlutterFlowTheme.adjustScale(size: 12),
//                   fontWeight: FontWeight.w500,
//                   color: textColor,
//                 ),
//               ),
//             ],
//           ),

//           // Show "No Streaks Available" if longestStreak is 0
//           if (longestStreak == 0) ...[
//             const SizedBox(height: 16),
//             Text(
//               '${AppLocalizations.of(context)!.noStreakAvailable}',
//               style: TextStyle(
//                 fontSize: FlutterFlowTheme.adjustScale(size: 14),
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//           ] else ...[
//             // Normal streak display when longestStreak > 0
//             const SizedBox(height: 24),

//             // Streak Indicators
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Stack(
//                 children: [
//                   if (currentStreak > 1)
//                     Positioned(
//                       left: 0,
//                       top: 0,
//                       child: Container(
//                         height: 30,
//                         width: (38 * (currentStreak - 1)) + 15.0,
//                         decoration: BoxDecoration(
//                             color: activeColor.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(13)),
//                       ),
//                     ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2),
//                     child: _buildStreakIndicators(),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//           ],
//           // Longest Streak
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//             decoration: BoxDecoration(
//                 color: const Color(0xfff9f9f9),
//                 borderRadius: BorderRadius.circular(99)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisSize: MainAxisSize.min,
//               spacing: 2,
//               children: [
//                 Text(
//                   '${AppLocalizations.of(context)!.longestStreak}:',
//                   style: TextStyle(
//                     fontSize: FlutterFlowTheme.adjustScale(size: 12),
//                     fontWeight: FontWeight.w500,
//                     color: textColor,
//                   ),
//                 ),
//                 Text(
//                   '$longestStreak',
//                   style: TextStyle(
//                     fontSize: FlutterFlowTheme.adjustScale(size: 14),
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ),
//                 ),
//                 Text(
//                   longestStreak == 1 ? streakUnit : streakUnits,
//                   style: TextStyle(
//                     fontSize: FlutterFlowTheme.adjustScale(size: 12),
//                     fontWeight: FontWeight.w500,
//                     color: textColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Highest value section
//           if (highestConsumendValue > 0)
//             Container(
//               margin: const EdgeInsets.symmetric(vertical: 24),
//               color: Color(0xffe1e1e1),
//               height: 1,
//             ),
//           if (highestConsumendValue > 0)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               spacing: 8,
//               children: [
//                 Text(
//                   '$highestInfo',
//                   style: TextStyle(
//                     fontSize: FlutterFlowTheme.adjustScale(size: 16),
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ),
//                 ),
//                 // Show week number OR date depending on what's available
//                 if (highestWeekYearText.isNotEmpty)
//                   Text(
//                     'Week $highestWeekYearText', // Will display as "Week 41, 2025"
//                     style: TextStyle(
//                       fontSize: FlutterFlowTheme.adjustScale(size: 12),
//                       color: textColor,
//                     ),
//                   ),
//                 if (highestDate != null)
//                   Text(
//                     DateFormat('dd MMM yyyy').format(highestDate!),
//                     style: TextStyle(
//                       fontSize: FlutterFlowTheme.adjustScale(size: 12),
//                       color: textColor,
//                     ),
//                   ),
//                 _highesetStatStar(
//                     text: highestValueFor,
//                     highestValue: highestConsumendValue.toInt(),
//                     primaryColor: activeColor,
//                     secondaryColor: activeColor)
//               ],
//             )
//         ],
//       ),
//     );
//   }

//   Widget _buildStreakIndicators() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       spacing: 12,
//       children: List.generate(totalWeeks, (index) {
//         final number = index + 1;
//         final isActive = number <= currentStreak;

//         return _buildStreakIndicator(
//           number: number,
//           isActive: isActive,
//         );
//       }),
//     );
//   }

//   Widget _buildStreakIndicator({required int number, required bool isActive}) {
//     return Container(
//       width: 26,
//       height: 26,
//       decoration: BoxDecoration(
//         color: isActive ? activeColor : Color(0xfff9f9f9),
//         shape: BoxShape.circle,
//         boxShadow: isActive
//             ? [
//                 BoxShadow(
//                   color: activeColor.withOpacity(0.3),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ]
//             : [
//                 BoxShadow(
//                   color: const Color.fromRGBO(249, 249, 249, 1),
//                   spreadRadius: 0.89,
//                   blurRadius: 0,
//                   offset: const Offset(0, 0),
//                 ),
//                 const BoxShadow(
//                   color: Color.fromRGBO(0, 0, 0, 0.25),
//                   offset: Offset(0, 1),
//                   blurRadius: 4,
//                   spreadRadius: 0,
//                   blurStyle: BlurStyle.inner,
//                 ),
//                 const BoxShadow(
//                   color: Color.fromRGBO(0, 0, 0, 0.25),
//                   offset: Offset(0, 1),
//                   blurRadius: 2,
//                   spreadRadius: 0,
//                   blurStyle: BlurStyle.inner,
//                 ),
//               ],
//       ),
//       child: Center(
//         child: Text(
//           number.toString(),
//           style: TextStyle(
//             color: isActive ? Colors.white : const Color(0xffbababa),
//             fontSize: FlutterFlowTheme.adjustScale(size: 16),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _highesetStatStar({
//     required String text,
//     required int highestValue, // Changed to int (non-nullable)
//     Color primaryColor = const Color(0xFF6A11CB),
//     Color secondaryColor = const Color(0xFF2575FC),
//     double width = 50,
//     double height = 50,
//   }) {
//     return SizedBox(
//       width: width + 5,
//       height: height + 5,
//       child: Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Transform.rotate(
//               angle: 35 * 3.1415926535 / 180,
//               child: Container(
//                 width: width,
//                 height: height,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: primaryColor,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Transform.rotate(
//               angle: -15 * 3.1415926535 / 180,
//               child: Container(
//                 width: width,
//                 height: height,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: primaryColor,
//                 ),
//                 child: Center(
//                   child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           '$highestValue',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           text,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ]),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
