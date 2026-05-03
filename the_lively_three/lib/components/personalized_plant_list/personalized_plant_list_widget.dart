// ignore_for_file: prefer_const_constructors

import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/components/consumption_card/consumption_card_widget.dart';
import 'package:the_lively_three/components/fluid_bg/setting_bg_widget.dart';
import 'package:the_lively_three/components/permissions_pages/data_permission.dart';
import 'package:the_lively_three/components/permissions_pages/get_permission_access.dart';
import 'package:the_lively_three/components/personalized_plant_list/detailed_recipe_widget.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart'
    as custom_widgets;
import 'package:the_lively_three/custom_code/widgets/weekly_item_card.dart';
import 'package:the_lively_three/pages/homepage/homepage_widget.dart';
import 'package:the_lively_three/pages/plantselection/plantselection_widget.dart';
import 'package:the_lively_three/pages/subscription/subscription_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'personalized_plant_list_model.dart';
export 'personalized_plant_list_model.dart';
import '/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_lively_three/pages/subscription/subscription_model.dart';

class WeeklyPlantMetrics {
  final int id;
  final int week;
  final int idLoc;
  final String plantname;
  final String? color;
  final double portionsize;
  final double portionsum;
  final double average4w;
  final double? fiber;
  final double? protein;
  final int localizedPlantId;
  final double weeklyTotal;
  final int blueprintId;
  final double timesConsumed;
  final int category;
  final String displayName;

  WeeklyPlantMetrics({
    required this.id,
    required this.week,
    required this.idLoc,
    required this.plantname,
    required this.color,
    required this.portionsize,
    required this.portionsum,
    required this.average4w,
    required this.fiber,
    required this.protein,
    required this.localizedPlantId,
    required this.weeklyTotal,
    required this.blueprintId,
    required this.timesConsumed,
    required this.category,
    required this.displayName,
  });

  factory WeeklyPlantMetrics.fromMap(Map<String, dynamic> m) {
    double _d(Object? v, [double fallback = 0.0]) {
      if (v == null) return fallback;
      if (v is num) return v.toDouble();
      final s = v.toString().trim();
      if (s.isEmpty) return fallback;
      return double.tryParse(s) ?? fallback;
    }

    double? _dn(Object? v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      return double.tryParse(s);
    }

    int _i(Object? v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? fallback;
    }

    return WeeklyPlantMetrics(
      id: _i(m['id']),
      week: _i(m['week']),
      idLoc: _i(m['id_loc']),
      blueprintId: _i(m['id_blueprint']),
      plantname: (m['plantname'] ?? 'Unknown') as String,
      color: m['color'] as String?,
      portionsize: _d(m['portionsize']),
      weeklyTotal: _d(m['weekly_total'] ?? 0.0),
      average4w: _d(m['avg_consumption_4weeks'] ?? 0.0),
      timesConsumed: _d(m['times_consumed'] ?? 0.0),
      fiber: _dn(m['fiber_value'] ?? m['fiber']),
      protein: _dn(m['protein_value'] ?? m['protein']),
      localizedPlantId: _i(m['original_localized_id'] ?? m['original_id']),
      portionsum: _d(m['portion_consumed'] ?? 0.0),
      displayName: (m['display_name'] ?? 'Unknown') as String,
      category: _i(m['category_code'] ?? 0),
    );
  }
}

class PersonalizedPlantListWidget extends StatefulWidget {
  static String routeName = 'smart-suggestions';
  static String routePath = '/smart-suggestions';
  const PersonalizedPlantListWidget({super.key});

  @override
  State<PersonalizedPlantListWidget> createState() =>
      _PersonalizedPlantListWidgetState();
}

class _PersonalizedPlantListWidgetState
    extends State<PersonalizedPlantListWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late PersonalizedPlantListModel _model;
  List<WeeklyPlantMetrics> _suggestedPlants = [];
  List<WeeklyPlantMetrics> _filtered = [];
  bool _loadingList = true;
  int _currentTabIndex = 0;
  String? _loadListError;
  bool _loading = false;
  String? _error;
  Locale? currentLocale;
  late DateTime _selectedDate;

  // Subscription and consent checking variables
  bool _checkingSubscription = true;
  bool _hasValidSubscription = false;
  bool _checkingConsent = false;
  bool _hasValidConsent = false;
  bool _initialLoadComplete = false;
  Map<int, String?> _categoryIcons = {};

  // Supabase client
  final supabase = Supabase.instance.client;

  DateTime _todayLocal() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PersonalizedPlantListModel());
    _selectedDate = _todayLocal();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserSubscriptionAndConsent();
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocale = Localizations.localeOf(context);

    if (!_initialLoadComplete && _hasValidSubscription && _hasValidConsent) {
      _fetchWeeklyPlantMetrics(
        currentUserUid,
        FFAppState().calendarWeek,
        FFAppState().calendarYear,
        null,
        currentLocale?.languageCode ?? 'en',
      );
    }
  }

  Future<void> _checkUserSubscriptionAndConsent() async {
    await _checkUserSubscription();

    if (_hasValidSubscription && mounted) {
      await _checkUserConsent();
    }

    if (_hasValidSubscription && _hasValidConsent && mounted) {
      currentLocale = Localizations.localeOf(context);
      await _fetchWeeklyPlantMetrics(
        currentUserUid,
        FFAppState().calendarWeek,
        FFAppState().calendarYear,
        null,
        currentLocale?.languageCode ?? 'en',
      );
    }
  }

  Future<void> _checkUserSubscription() async {
    currentLocale = Localizations.localeOf(context);
    setState(() {
      _checkingSubscription = true;
    });
    var l10n = AppLocalizations.of(context)!;

    try {
      final response = await supabase
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

      debugPrint('✅ Subscription check complete: $_hasValidSubscription');

      if (!isValid && mounted) {
        debugPrint('🔴 Subscription invalid - showing popup');
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => UpgradeSubscriptionPage(
              onSuccess: 'PersonalizedPlantListWidget',
              onFailure: 'Home',
              popupTitle: l10n.popupTitleSuggestion,
              popupSubTitle: l10n.popupSubTitleSuggestion,
            ),
          );

          if (mounted) {
            setState(() {
              _initialLoadComplete = true;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking subscription: $e');
      setState(() {
        _checkingSubscription = false;
        _hasValidSubscription = false;
        _initialLoadComplete = true;
      });

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => UpgradeSubscriptionPage(
              onSuccess: 'Home',
              onFailure: 'Home',
              popupTitle: l10n.popupTitleSuggestion,
              popupSubTitle: l10n.popupSubTitleSuggestion,
            ),
          );

          if (mounted) {
            setState(() {
              _initialLoadComplete = true;
            });
          }
        }
      }
    }
  }

  Future<void> _checkUserConsent() async {
    setState(() {
      _checkingConsent = true;
    });

    try {
      final hasConsent = await checkAgreementConsent(currentUserUid);

      setState(() {
        _hasValidConsent = hasConsent;
        _checkingConsent = false;
        _initialLoadComplete = true;
      });

      debugPrint('✅ Consent check complete: $_hasValidConsent');

      if (!hasConsent && mounted) {
        debugPrint('🔴 No valid consent - showing permission popup');
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          await showPermissionPopup(context);

          if (mounted) {
            await _recheckConsent();
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking consent: $e');
      setState(() {
        _checkingConsent = false;
        _hasValidConsent = false;
        _initialLoadComplete = true;
      });

      if (mounted) {
        await showPermissionPopup(context);
      }
    }
  }

  Future<bool> checkAgreementConsent(String userId) async {
    try {
      final partyRes = await supabase
          .from('party')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (partyRes == null) {
        debugPrint('❌ No party found for this user.');
        return false;
      }

      final partyId = partyRes['id'];
      debugPrint('✅ Party ID: $partyId');

      final agreementRes = await supabase
          .from('agreement')
          .select('id, name, status, effective_from, effective_to')
          .eq('code', 'PPS')
          .maybeSingle();

      if (agreementRes == null) {
        debugPrint('❌ Agreement "Personalized Plant Suggestions" not found.');
        return false;
      }

      final agreementId = agreementRes['id'];
      debugPrint('✅ Agreement ID: $agreementId');

      final approvalRes = await supabase
          .from('agreement_approval')
          .select('is_active, deactivated_at, occurred_at')
          .eq('agreement_id', agreementId)
          .eq('party_id', partyId)
          .order('occurred_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (approvalRes == null) {
        debugPrint('ℹ️ No approval record found - user has not consented yet');
        return false;
      }

      final bool isActive = approvalRes['is_active'] ?? false;
      final String? deactivatedAt = approvalRes['deactivated_at'];

      debugPrint('📋 Consent check:');
      debugPrint('   - is_active: $isActive');
      debugPrint('   - deactivated_at: $deactivatedAt');

      if (isActive) {
        debugPrint('✅ CONSENTED: is_active = true');
        return true;
      }

      if (!isActive) {
        if (deactivatedAt == null) {
          debugPrint(
              '❌ NOT CONSENTED: is_active = false, deactivated_at = null');
          return false;
        }

        try {
          final deactivatedDate = DateTime.parse(deactivatedAt);
          final now = DateTime.now();

          if (deactivatedDate.isAfter(now)) {
            debugPrint(
                '✅ CONSENTED: deactivated_at is in the future ($deactivatedAt)');
            return true;
          } else {
            debugPrint(
                '❌ NOT CONSENTED: deactivated_at is in the past ($deactivatedAt)');
            return false;
          }
        } catch (e) {
          debugPrint('⚠️ Error parsing deactivated_at: $e');
          return false;
        }
      }

      debugPrint('⚠️ Unexpected state - defaulting to NOT consented');
      return false;
    } catch (e) {
      debugPrint('❌ Error checking agreement consent: $e');
      return false;
    }
  }

  Future<void> _recheckConsent() async {
    try {
      final hasConsent = await checkAgreementConsent(currentUserUid);

      setState(() {
        _hasValidConsent = hasConsent;
      });

      debugPrint('🔄 Consent recheck result: $_hasValidConsent');

      if (hasConsent && mounted) {
        currentLocale = Localizations.localeOf(context);
        await _fetchWeeklyPlantMetrics(
          currentUserUid,
          FFAppState().calendarWeek,
          FFAppState().calendarYear,
          null,
          currentLocale?.languageCode ?? 'en',
        );
      }
    } catch (e) {
      debugPrint('❌ Error rechecking consent: $e');
    }
  }

  Future<void> _fetchWeeklyPlantMetrics(
    String userId,
    int week,
    int year,
    String? color,
    String currentLocale,
  ) async {
    setState(() {
      _loadingList = true;
      _loadListError = null;
      _suggestedPlants = [];
      _filtered = [];
    });

    final params = {
      'p_user_id': userId,
      'p_week': week,
      'p_year': year,
      'p_color': color,
      'p_locale': currentLocale,
    };

    try {
      final data =
          await supabase.rpc('get_user_suggested_plants_new', params: params);

      final rows = (data as List).cast<Map<String, dynamic>>();
      final plants = rows.map((m) => WeeklyPlantMetrics.fromMap(m)).toList();

      setState(() {
        _suggestedPlants = plants;
        _loadingList = false;
      });
      _loadCategoryIcons();
    } catch (e, st) {
      debugPrint('❌ RPC error: $e\n$st');
      setState(() {
        _loadingList = false;
        _loadListError = e.toString();
      });
    }
  }

  Future<void> _loadCategoryIcons() async {
    Set<int> categoryCodes = _suggestedPlants
        .where((plant) =>
            plant != null && plant.category != null && plant.category != 0)
        .map((plant) => plant.category!)
        .toSet();

    for (int categoryCode in categoryCodes) {
      try {
        final icon = await CategoryLookupService.getCategoryIcon(categoryCode);
        _categoryIcons[categoryCode] = icon;
      } catch (e) {
        debugPrint('❌ Error loading category icon for code $categoryCode: $e');
        _categoryIcons[categoryCode] = null;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onPortionAdded(String plantname, String colorTag, double delta) async {
    // Refresh logic here
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    Color _colorFor(String? name) {
      switch ((name ?? '').toLowerCase()) {
        case 'red':
          return Colors.red.shade700;
        case 'orange':
          return Colors.orange.shade700;
        case 'yellow':
          return Colors.yellow.shade700;
        case 'green':
          return Colors.green.shade700;
        case 'purple':
          return Colors.purple.shade700;
        case 'brown':
          return Colors.brown.shade700;
        case 'white':
          return Colors.grey.shade700;
        default:
          return FlutterFlowTheme.of(context).primary;
      }
    }

    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      extendBody: false,
      appBar: AppBar(
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: FlutterFlowTheme.of(context).textGrey,
            size: 24.0,
          ),
        ),
        centerTitle: true,
        titleSpacing: 16,
        title: Text(
          locale.personalizedPlantList,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primary,
                fontSize: FlutterFlowTheme.adjustScale(size: 18.0),
                letterSpacing: 0.0,
                fontWeight: FontWeight.bold,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
        ),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.0),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  left: -MediaQuery.sizeOf(context).width * 0.2,
                  top: -50,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.55,
                    width: MediaQuery.sizeOf(context).width * 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: RadialGradient(
                        colors: [
                          Color(0xfff6e0e1),
                          Color(0xfff6e0e1),
                          Color(0xfff6e0e1),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.sizeOf(context).width * 0.35,
                  right: -MediaQuery.sizeOf(context).width * 0.22,
                  top: -75,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: RadialGradient(
                        colors: [
                          Color(0xfff4e3f1),
                          Color(0xfff4e3f1),
                          Color(0xfff4e3f1),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -MediaQuery.sizeOf(context).width * 0.4,
                  bottom: -MediaQuery.sizeOf(context).height * 0.3,
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFf8eeef),
                          Color(0xFFf8eeef),
                          Color(0xFFf8eeef),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
                    child: Container(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
            child: Container(
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                _buildMainContent(locale, _colorFor),
                if (_checkingSubscription ||
                    _checkingConsent ||
                    !_hasValidSubscription ||
                    !_hasValidConsent)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                if (_checkingSubscription || _checkingConsent)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          _checkingSubscription
                              ? 'Checking subscription...'
                              : 'Checking permissions...',
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 14),
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      AppLocalizations locale, Color Function(String?) colorFor) {
    return SafeArea(
      child: Column(
        children: [
          // TOP STATIC PART
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildTabButton(
                        _currentTabIndex == 0,
                        'Plants For You',
                        () => setState(() => _currentTabIndex = 0),
                      ),
                    ),
                    Expanded(
                      child: buildTabButton(
                        _currentTabIndex == 1,
                        'Your Recipe Picks',
                        () => setState(() => _currentTabIndex = 1),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Color(0xffe1e1e1),
                ),
              ],
            ),
          ),

          // 🔥 SCROLLABLE TAB CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  buildPlantsForYou(locale, colorFor),
                  buildYourRecipePick(),
                ],
              ),
            ),
          ),

          // 🔥 BOTTOM CONTAINER FIXED
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Color.fromRGBO(230, 57, 73, 1),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color.fromRGBO(230, 57, 73, 1),
                  ),
                  child: const Icon(
                    Icons.warning_amber,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text:
                          'Nutrition suggestions provided in this app are based on general scientific guidelines. Every individual is different, and these recommendations may not suit everyone. ',
                      style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 8),
                        height: 1.625,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: ' Please consult your doctor',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                            text:
                                ' or a registered dietitian before making significant changes to your diet.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlantsForYou(
      AppLocalizations locale, Color Function(String?) colorFor) {
    return Column(children: [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12, 18, 12, 10),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                locale.personalizedPlantListDesc,
                style:
                    TextStyle(fontSize: FlutterFlowTheme.adjustScale(size: 12)),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: _loadingList
            ? const Center(child: CircularProgressIndicator())
            : (_loadListError != null)
                ? Center(child: Text('${locale.error}: $_loadListError'))
                : (_suggestedPlants.isEmpty)
                    ? Center(child: Text(locale.noPlantsFound))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _fetchWeeklyPlantMetrics(
                            currentUserUid,
                            FFAppState().calendarWeek,
                            FFAppState().calendarYear,
                            null,
                            currentLocale?.languageCode ?? 'en',
                          );
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _suggestedPlants.length,
                          itemBuilder: (context, index) {
                            final r = _suggestedPlants[index];
                            String categoryIcon =
                                _categoryIcons[r.category] ?? '';
                            return Column(
                              key: ValueKey(
                                  'row_${r.localizedPlantId}_${r.portionsum}'),
                              children: [
                                WeeklyItemCard(
                                    key: ValueKey(
                                        'row_${r.localizedPlantId}_${r.portionsum}'),
                                    primaryColor: colorFor(r.color),
                                    colorTag: r.color ?? '',
                                    title: r.plantname,
                                    onPortionAdded: _onPortionAdded,
                                    weeklyTotal: r.weeklyTotal.round(),
                                    portionSize: (r.portionsize * 100).toInt(),
                                    plantId: r.localizedPlantId,
                                    uom: 'g',
                                    userId: currentUserUid,
                                    weekdayNumber: _selectedDate.weekday,
                                    week: FFAppState().calendarWeek,
                                    year: FFAppState().calendarYear,
                                    blueprintId: r.blueprintId,
                                    dietarySource: 1,
                                    canModify: true,
                                    showMainMacro: true,
                                    boldTitle: false,
                                    categoryIcon: categoryIcon ?? '',
                                    displayName: r.displayName,
                                    bgColor: Colors.transparent),
                                const Divider(
                                  height: 2,
                                  color: Color(0xffd8d8d8),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
      ),
    ]);
  }

  Widget buildYourRecipePick() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 7,
                spreadRadius: 0,
                color: Color(0xff818181))
          ]),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/recipe-icon.png',
                width: 32,
                height: 32,
              ),
              Expanded(
                child: Text(
                  'Nutrient Targeted Recipes',
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      fontWeight: FontWeight.w700,
                      color: FlutterFlowTheme.of(context).primaryText,
                      height: 1.2),
                ),
              ),
            ],
          ),
          Column(
            spacing: 20,
            children: [
              buildRecipeCard(
                'Black Bean and Sweet Potato Tacos',
                'Fiber-Rich',
                Color(0xff886052),
                "This easy recipe is sure to become a repeat on your dinner roster. It takes a few cheap ingredients, a can of black beans and some sweet potatoes and turns them into hearty tacos that feel meaty and substantial, even… though there's no meat in sight. I encourage you to serve them with homemade guacamole (because well, you can never go wrong with guacamole), but if you're short on time, diced or sliced avocado is a fast substitute.",
              ),
              buildRecipeCard(
                'Cauliflower Lentil Soup',
                'Protein-Rich',
                Color(0xfff77f00),
                "If you've been craving a bowl of comfort that's as nourishing as it is delicious, let me introduce you to my cauliflower lentil soup. This is one of those recipes I make when I want a cozy dinner with minimal fuss, … still feel like I'm treating myself to something wholesome and hearty. It's creamy without the cream, packed with flavor from warm spices, and it just feels like a hug in a bowl.",
              ),
            ].divide(
              Container(
                height: 1.0,
                color: Color(0xffececec),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConsumptionTextChip(String name, double value, Color dotColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildRecipeCard(String dishName, String mainNutrient,
      Color nutrientColor, String dishDesc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 4,
          children: [
            Expanded(
              child: Text(
                dishName,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 13),
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: FlutterFlowTheme.of(context).primaryText),
              ),
            ),
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailedRecipeWidget(recipeName: dishName),
                  ),
                );
              },
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: FlutterFlowTheme.of(context).primaryText,
                weight: 700,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
          decoration: BoxDecoration(
              color: nutrientColor, borderRadius: BorderRadius.circular(4)),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                child: FaIcon(
                  FontAwesomeIcons.solidStar,
                  color: nutrientColor,
                  size: 9,
                ),
              ),
              Text(
                mainNutrient ?? 'Unknown',
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 11),
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        Text(
          dishDesc,
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 12),
              height: 1.667,
              color: FlutterFlowTheme.of(context).primaryText),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget buildTabButton(
      bool isSelected, String btnText, VoidCallback buttonFunction) {
    return InkWell(
      onTap: buttonFunction,
      child: Container(
        padding: const EdgeInsets.all(13.5),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).blackText
              : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Text(
          btnText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: FlutterFlowTheme.adjustScale(size: 12),
            height: 1.2,
            color: isSelected
                ? FlutterFlowTheme.of(context).primaryBackground
                : FlutterFlowTheme.of(context).primaryText,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
// // ignore_for_file: prefer_const_constructors

// import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
// import 'package:the_lively_three/components/consumption_card/consumption_card_widget.dart';
// import 'package:the_lively_three/components/fluid_bg/setting_bg_widget.dart';
// import 'package:the_lively_three/components/permissions_pages/data_permission.dart';
// import 'package:the_lively_three/components/permissions_pages/get_permission_access.dart';
// import 'package:the_lively_three/components/personalized_plant_list/detailed_recipe_widget.dart';
// import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart';
// import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart'
//     as custom_widgets;
// import 'package:the_lively_three/custom_code/widgets/weekly_item_card.dart';
// import 'package:the_lively_three/pages/homepage/homepage_widget.dart';
// import 'package:the_lively_three/pages/plantselection/plantselection_widget.dart';
// import 'package:the_lively_three/pages/subscription/subscription_widget.dart';

// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'dart:ui';
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'personalized_plant_list_model.dart';
// export 'personalized_plant_list_model.dart';
// import '/l10n/app_localizations.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:the_lively_three/pages/subscription/subscription_model.dart';

// class WeeklyPlantMetrics {
//   final int id; // weeklyselectedplant.id (anchor row)
//   final int week; // anchor week
//   final int idLoc;
//   final String plantname;
//   final String? color;
//   final double portionsize;
//   final double portionsum; // current week
//   final double average4w; // avg W-1..W-4
//   final double? fiber; // optional
//   final double? protein; // optional
//   final int localizedPlantId;
//   final double weeklyTotal;
//   final int blueprintId;
//   final double timesConsumed;
//   final int category;
//   final String displayName;

//   WeeklyPlantMetrics({
//     required this.id,
//     required this.week,
//     required this.idLoc,
//     required this.plantname,
//     required this.color,
//     required this.portionsize,
//     required this.portionsum,
//     required this.average4w,
//     required this.fiber,
//     required this.protein,
//     required this.localizedPlantId,
//     required this.weeklyTotal,
//     required this.blueprintId,
//     required this.timesConsumed,
//     required this.category,
//     required this.displayName,
//   });

//   factory WeeklyPlantMetrics.fromMap(Map<String, dynamic> m) {
//     double _d(Object? v, [double fallback = 0.0]) {
//       if (v == null) return fallback;
//       if (v is num) return v.toDouble();
//       final s = v.toString().trim();
//       if (s.isEmpty) return fallback;
//       return double.tryParse(s) ?? fallback;
//     }

//     double? _dn(Object? v) {
//       if (v == null) return null;
//       if (v is num) return v.toDouble();
//       final s = v.toString().trim();
//       if (s.isEmpty) return null;
//       return double.tryParse(s);
//     }

//     int _i(Object? v, [int fallback = 0]) {
//       if (v == null) return fallback;
//       if (v is int) return v;
//       return int.tryParse(v.toString()) ?? fallback;
//     }

//     return WeeklyPlantMetrics(
//       id: _i(m['id']),
//       week: _i(m['week']),
//       idLoc: _i(m['id_loc']),
//       blueprintId: _i(m['id_blueprint']),
//       plantname: (m['plantname'] ?? 'Unknown') as String,
//       color: m['color'] as String?,
//       portionsize: _d(m['portionsize']),
//       weeklyTotal: _d(m['weekly_total'] ?? 0.0),
//       average4w: _d(m['avg_consumption_4weeks'] ?? 0.0),
//       timesConsumed: _d(m['times_consumed'] ?? 0.0),
//       fiber: _dn(m['fiber_value'] ?? m['fiber']),
//       protein: _dn(m['protein_value'] ?? m['protein']),
//       localizedPlantId: _i(m['original_localized_id'] ?? m['original_id']),
//       portionsum: _d(m['portion_consumed'] ?? 0.0),
//       displayName: (m['display_name'] ?? 'Unknown') as String,
//       category: _i(m['category_code'] ?? 0),
//     );
//   }
// }

// class PersonalizedPlantListWidget extends StatefulWidget {
//   static String routeName = 'smart-suggestions';
//   static String routePath = '/smart-suggestions';
//   const PersonalizedPlantListWidget({super.key});

//   @override
//   State<PersonalizedPlantListWidget> createState() =>
//       _PersonalizedPlantListWidgetState();
// }

// // Updated PersonalizedPlantListWidget with subscription check

// class _PersonalizedPlantListWidgetState
//     extends State<PersonalizedPlantListWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   late PersonalizedPlantListModel _model;
//   List<WeeklyPlantMetrics> _suggestedPlants = [];
//   List<WeeklyPlantMetrics> _filtered = [];
//   bool _loadingList = true;
//   String? _loadListError;
//   bool _loading = false;
//   String? _error;
//   Locale? currentLocale;
//   late DateTime _selectedDate;

//   // Add subscription checking variables
//   bool _checkingSubscription = true;
//   bool _hasValidSubscription = false;
//   bool _initialLoadComplete = false;
//   Map<int, String?> _categoryIcons = {};

//   DateTime _todayLocal() {
//     final now = DateTime.now();
//     return DateTime(now.year, now.month, now.day);
//   }

//   @override
//   void setState(VoidCallback callback) {
//     super.setState(callback);
//     _model.onUpdate();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => PersonalizedPlantListModel());
//     _selectedDate = _todayLocal();

//     WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // showPermissionPopup(context);
//       // showSubscriptionPopup(context);
//       _checkUserSubscription();
//       print('hassubscription: $_hasValidSubscription');
//       // if(_hasValidSubscription) {
//       //   print('hassubscription: $_hasValidSubscription');
//       //   getPersonalizedPlantAgreementStatus(currentUserUid);
//       // }
//     });
//   }

//   @override
//   void dispose() {
//     _model.maybeDispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     currentLocale = Localizations.localeOf(context);

//     // Always fetch data (will be shown blurred if no subscription)
//     if (!_initialLoadComplete) {
//       _fetchWeeklyPlantMetrics(
//         currentUserUid,
//         FFAppState().calendarWeek,
//         FFAppState().calendarYear,
//         null,
//         currentLocale?.languageCode ?? 'en',
//       );
//     }
//   }

//   // New method to check subscription status
//   Future<void> _checkUserSubscription() async {
//     currentLocale = Localizations.localeOf(context);
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
//         _initialLoadComplete = true;
//       });
//       if (_hasValidSubscription) {
//         print('hassubscription: $_hasValidSubscription');
//         final status =
//             await getPersonalizedPlantAgreementStatus(currentUserUid);
//         print('status: $status');
//       }

//       // Show popup AFTER state is updated (so blur is visible)
//       if (!isValid && mounted) {
//         debugPrint('🔴 Subscription invalid - showing popup');
//         // Small delay to ensure blur is rendered
//         // await Future.delayed(const Duration(milliseconds: 100));

//         if (mounted) {
//           await showDialog(
//             context: context,
//             barrierDismissible: false, // Prevent dismissing without action
//             builder: (context) => UpgradeSubscriptionPage(
//               onSuccess: 'PersonalizedPlantListWidget',
//               onFailure: 'Home',
//               popupTitle: l10n.popupTitleSuggestion,
//               popupSubTitle: l10n.popupSubTitleSuggestion,
//             ),
//           );

//           // After dialog closes, check subscription again or handle accordingly
//           if (mounted) {
//             setState(() {
//               _initialLoadComplete = true;
//             });
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('Error checking subscription: $e');
//       setState(() {
//         _checkingSubscription = false;
//         _hasValidSubscription = false;
//         _initialLoadComplete = true;
//       });

//       if (mounted) {
//         await Future.delayed(const Duration(milliseconds: 100));

//         if (mounted) {
//           await showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) => UpgradeSubscriptionPage(
//               onSuccess: 'Home',
//               onFailure: 'Home',
//               popupTitle: l10n.popupTitleSuggestion,
//               popupSubTitle: l10n.popupSubTitleSuggestion,
//             ),
//           );

//           if (mounted) {
//             setState(() {
//               _initialLoadComplete = true;
//             });
//             _fetchWeeklyPlantMetrics(
//               currentUserUid,
//               FFAppState().calendarWeek,
//               FFAppState().calendarYear,
//               null,
//               currentLocale?.languageCode ?? 'en',
//             );
//           }
//         }
//       }
//     }
//   }

//   Future<Map<String, dynamic>?> getPersonalizedPlantAgreementStatus(
//       String userId) async {
//     // 1. Get party_id for this user
//     final partyRes = await Supabase.instance.client
//         .from('party')
//         .select('id')
//         .eq('user_id', userId)
//         .maybeSingle();

//     if (partyRes == null) {
//       print('No party found for this user.');
//       return null;
//     }

//     final partyId = partyRes['id'];
//     print('partid: $partyId');

//     // 2. Get the agreement record with given name
//     final agreementRes = await Supabase.instance.client
//         .from('agreement')
//         .select('id, name, status, effective_from, effective_to')
//         .eq('name', 'Personalized Plant Suggestions')
//         .maybeSingle();

//     if (agreementRes == null) {
//       print('Agreement not found.');
//       return null;
//     }

//     final agreementId = agreementRes['id'];
//     print('agreemantres: $agreementRes');

//     // 3. Check latest agreement_approval for this user-party pair
//     final approvalRes = await Supabase.instance.client
//         .from('agreement_approval')
//         .select('status, is_active, deactivated_at, occurred_at')
//         .eq('agreement_id', agreementId)
//         .eq('party_id', partyId)
//         .order('occurred_at', ascending: false)
//         .limit(1)
//         .maybeSingle();
//     print('approval response: $approvalRes');

//     return {
//       'agreement': agreementRes,
//       'approval': approvalRes, // may be null if user never approved/rejected
//     };
//   }

//   Future<void> _fetchWeeklyPlantMetrics(
//     String userId,
//     int week,
//     int year,
//     String? color,
//     String currentLocale,
//   ) async {
//     setState(() {
//       _loadingList = true;
//       _loadListError = null;
//       _suggestedPlants = [];
//       _filtered = [];
//     });

//     final params = {
//       'p_user_id': userId,
//       'p_week': week,
//       'p_year': year,
//       'p_color': color,
//       'p_locale': currentLocale,
//     };

//     try {
//       final data = await Supabase.instance.client
//           .rpc('get_user_suggested_plants_new', params: params);

//       final rows = (data as List).cast<Map<String, dynamic>>();
//       final plants = rows.map((m) => WeeklyPlantMetrics.fromMap(m)).toList();

//       setState(() {
//         _suggestedPlants = plants;
//         _loadingList = false;
//       });
//       _loadCategoryIcons();
//     } catch (e, st) {
//       debugPrint('RPC error: $e\n$st');
//       setState(() {
//         _loadingList = false;
//         _loadListError = e.toString();
//       });
//     }
//   }

//   Future<void> _loadCategoryIcons() async {
//     Set<int> categoryCodes = _suggestedPlants
//         .where((plant) =>
//             plant != null && plant.category != null && plant.category != 0)
//         .map((plant) => plant.category!)
//         .toSet();

//     for (int categoryCode in categoryCodes) {
//       try {
//         final icon = await CategoryLookupService.getCategoryIcon(categoryCode);
//         _categoryIcons[categoryCode] = icon;
//       } catch (e) {
//         print('Error loading category icon for code $categoryCode: $e');
//         _categoryIcons[categoryCode] = null;
//       }
//     }
//     print('381: $_categoryIcons');

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void _onPortionAdded(String plantname, String colorTag, double delta) async {
//     // Refresh logic here
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locale = AppLocalizations.of(context)!;

//     Color _colorFor(String? name) {
//       switch ((name ?? '').toLowerCase()) {
//         case 'red':
//           return Colors.red.shade700;
//         case 'orange':
//           return Colors.orange.shade700;
//         case 'yellow':
//           return Colors.yellow.shade700;
//         case 'green':
//           return Colors.green.shade700;
//         case 'purple':
//           return Colors.purple.shade700;
//         case 'brown':
//           return Colors.brown.shade700;
//         case 'white':
//           return Colors.grey.shade700;
//         default:
//           return FlutterFlowTheme.of(context).primary;
//       }
//     }

//     context.watch<FFAppState>();

//     return Scaffold(
//       key: scaffoldKey,
//       // backgroundColor: Colors.transparent,
//       resizeToAvoidBottomInset: true,
//       extendBody: false,
//       appBar: AppBar(
//         leading: InkWell(
//           splashColor: Colors.transparent,
//           focusColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           onTap: () async {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.chevron_left,
//             color: FlutterFlowTheme.of(context).textGrey,
//             size: 24.0,
//           ),
//         ),
//         centerTitle: true,
//         titleSpacing: 16,
//         title: Text(
//           locale.personalizedPlantList,
//           textAlign: TextAlign.center,
//           style: FlutterFlowTheme.of(context).bodyMedium.override(
//                 font: GoogleFonts.montserrat(
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
//                 ),
//                 color: FlutterFlowTheme.of(context).primary,
//                 fontSize: FlutterFlowTheme.adjustScale(size: 18.0),
//                 letterSpacing: 0.0,
//                 fontWeight: FontWeight.bold,
//                 fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
//               ),
//         ),
//         backgroundColor: const Color.fromARGB(0, 255, 255, 255),
//         shadowColor: const Color.fromRGBO(0, 0, 0, 0.0),
//       ),
//       body: SafeArea(
//         top: true,
//         bottom: true,
//         child: Stack(
//           children: [
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Colors.white,
//               child: Stack(
//                 children: [
//                   // Middle scoop - Red/Orange
//                   Positioned(
//                     left: -MediaQuery.sizeOf(context).width * 0.2,
//                     top: -50,
//                     child: Container(
//                       height: MediaQuery.sizeOf(context).height * 0.55,
//                       width: MediaQuery.sizeOf(context).width * 1.1,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(99),
//                         gradient: RadialGradient(
//                           colors: [
//                             Color(0xfff6e0e1),
//                             Color(0xfff6e0e1),
//                             Color(0xfff6e0e1),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Top scoop (smallest) - Green
//                   Positioned(
//                     left: MediaQuery.sizeOf(context).width * 0.35,
//                     right: -MediaQuery.sizeOf(context).width * 0.22,
//                     top: -75,
//                     child: Container(
//                       height: MediaQuery.sizeOf(context).height * 0.5,
//                       width: MediaQuery.sizeOf(context).width,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(99),
//                         gradient: RadialGradient(
//                           colors: [
//                             Color(0xfff4e3f1),
//                             Color(0xfff4e3f1),
//                             Color(0xfff4e3f1),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Bottom scoop (largest) - Purple/Magenta
//                   Positioned(
//                     left: -MediaQuery.sizeOf(context).width * 0.4,
//                     bottom: -MediaQuery.sizeOf(context).height * 0.3,
//                     child: Container(
//                       height: MediaQuery.sizeOf(context).height * 0.6,
//                       width: MediaQuery.sizeOf(context).width,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(99),
//                         gradient: RadialGradient(
//                           colors: [
//                             Color(0xFFf8eeef),
//                             Color(0xFFf8eeef),
//                             Color(0xFFf8eeef),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Blur effect overlay
//                   Positioned.fill(
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
//                       child: Container(
//                         color: Colors.white.withOpacity(0.05),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Blur effect overlay
//             BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 80.0, sigmaY: 80.0),
//               child: Container(
//                 color: Colors.white.withOpacity(0.05),
//               ),
//             ),
//             Stack(
//               children: [
//                 // Main content (always rendered)
//                 SizedBox(
//                     height: MediaQuery.sizeOf(context).height - 100,
//                     child: SingleChildScrollView(
//                       child: _buildMainContent(locale, _colorFor),
//                     )),

//                 // Blur overlay when checking subscription or no valid subscription
//                 if (_checkingSubscription || !_hasValidSubscription)
//                   Positioned.fill(
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                       child: Container(
//                         color: Colors.black.withOpacity(0.1),
//                       ),
//                     ),
//                   ),

//                 // Loading indicator when checking subscription
//                 if (_checkingSubscription)
//                   const Center(child: CircularProgressIndicator()),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Main content when subscription is valid
//   Widget _buildMainContent(
//       AppLocalizations locale, Color Function(String?) colorFor) {
//     return Container(
//       width: double.infinity,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Material(
//             color: Colors.transparent,
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(12, 18, 12, 10),
//                   child: Container(
//                     width: double.infinity,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Text(
//                           locale.personalizedPlantListDesc,
//                           style: TextStyle(
//                               fontSize: FlutterFlowTheme.adjustScale(size: 12)),
//                           textAlign: TextAlign.center,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 8),
//                   child: _loadingList
//                       ? const Center(child: CircularProgressIndicator())
//                       : (_loadListError != null)
//                           ? Center(
//                               child: Text('${locale.error}: $_loadListError'))
//                           : (_suggestedPlants.isEmpty)
//                               ? Center(child: Text(locale.noPlantsFound))
//                               : RefreshIndicator(
//                                   onRefresh: () async {
//                                     await _fetchWeeklyPlantMetrics(
//                                       currentUserUid,
//                                       FFAppState().calendarWeek,
//                                       FFAppState().calendarYear,
//                                       null,
//                                       currentLocale?.languageCode ?? 'en',
//                                     );
//                                   },
//                                   child: ListView.builder(
//                                     shrinkWrap: true,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: _suggestedPlants.length,
//                                     itemBuilder: (context, index) {
//                                       final r = _suggestedPlants[index];
//                                       String categoryIcon =
//                                           _categoryIcons[r.category] ?? '';
//                                       print('category icon: $categoryIcon');
//                                       return Column(
//                                         key: ValueKey(
//                                             'row_${r.localizedPlantId}_${r.portionsum}'),
//                                         children: [
//                                           WeeklyItemCard(
//                                               key: ValueKey(
//                                                   'row_${r.localizedPlantId}_${r.portionsum}'),
//                                               primaryColor: colorFor(r.color),
//                                               colorTag: r.color ?? '',
//                                               title: r.plantname,
//                                               onPortionAdded: _onPortionAdded,
//                                               weeklyTotal:
//                                                   r.weeklyTotal.round(),
//                                               portionSize:
//                                                   (r.portionsize * 100).toInt(),
//                                               plantId: r.localizedPlantId,
//                                               uom: 'g',
//                                               userId: currentUserUid,
//                                               weekdayNumber:
//                                                   _selectedDate.weekday,
//                                               week: FFAppState().calendarWeek,
//                                               year: FFAppState().calendarYear,
//                                               blueprintId: r.blueprintId,
//                                               dietarySource: 1,
//                                               canModify: true,
//                                               showMainMacro: true,
//                                               categoryIcon: categoryIcon ?? '',
//                                               displayName: r.displayName,
//                                               bgColor: Colors.transparent),
//                                           const Divider(
//                                             height: 2,
//                                             color: Color(0xffd8d8d8),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//                   decoration: BoxDecoration(
//                       color: FlutterFlowTheme.of(context).primaryBackground,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: const [
//                         BoxShadow(
//                             offset: Offset(0, 3),
//                             blurRadius: 7,
//                             spreadRadius: 0,
//                             color: Color(0xff818181))
//                       ]),
//                   child: Column(
//                     spacing: 20,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         spacing: 12,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/images/recipe-icon.png',
//                             width: 32,
//                             height: 32,
//                           ),
//                           Expanded(
//                             child: Text(
//                               'Nutrient Targeted Recipes',
//                               style: TextStyle(
//                                   fontSize:
//                                       FlutterFlowTheme.adjustScale(size: 16),
//                                   fontWeight: FontWeight.w700,
//                                   color:
//                                       FlutterFlowTheme.of(context).primaryText,
//                                   height: 1.2),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         spacing: 20,
//                         children: [
//                           buildRecipeCard(
//                             'Black Bean and Sweet Potato Tacos',
//                             'Fiber-Rich',
//                             Color(0xff886052),
//                             'This easy recipe is sure to become a repeat on your dinner roster. It takes a few cheap ingredients, a can of black beans and some sweet potatoes and turns them into hearty tacos that feel meaty and substantial, even… though there’s no meat in sight. I encourage you to serve them with homemade guacamole (because well, you can never go wrong with guacamole), but if you’re short on time, diced or sliced avocado is a fast substitute.',
//                           ),
//                           buildRecipeCard(
//                             'Cauliflower Lentil Soup',
//                             'Protein-Rich',
//                             Color(0xfff77f00),
//                             'If you’ve been craving a bowl of comfort that’s as nourishing as it is delicious, let me introduce you to my cauliflower lentil soup. This is one of those recipes I make when I want a cozy dinner with minimal fuss, … still feel like I’m treating myself to something wholesome and hearty. It’s creamy without the cream, packed with flavor from warm spices, and it just feels like a hug in a bowl.',
//                           ),
//                         ].divide(
//                           Container(
//                             height: 1.0,
//                             color: Color(0xffececec),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(
//                       top: 12, bottom: 12, left: 10, right: 10),
//                   margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                           width: 1,
//                           style: BorderStyle.solid,
//                           color: Color.fromRGBO(230, 57, 73, 1)),
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Row(
//                     spacing: 8,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         child: const Icon(Icons.warning_amber,
//                             color: Colors.white, size: 18),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: const Color.fromRGBO(
//                                     255, 255, 255, 1), // rgba(255, 255, 255, 1)
//                                 offset: const Offset(0, 0), // x=0, y=0
//                                 blurRadius: 0, // no blur
//                                 spreadRadius:
//                                     0.66, // equivalent to the 0.66px "outline" effect
//                               ),
//                               BoxShadow(
//                                 color: const Color.fromRGBO(129, 129, 129,
//                                     0.2), // rgba(129, 129, 129, 0.2)
//                                 offset: const Offset(0, 2), // x=0, y=2
//                                 blurRadius: 5, // blur radius
//                                 spreadRadius: 0, // no spread
//                               ),
//                             ],
//                             color: Color.fromRGBO(230, 57, 73, 1)),
//                       ),
//                       Expanded(
//                         child: RichText(
//                           text: TextSpan(
//                               text:
//                                   'Nutrition suggestions provided in this app are based on general scientific guidelines. Every individual is different, and these recommendations may not suit everyone. ',
//                               style: TextStyle(
//                                 fontSize: FlutterFlowTheme.adjustScale(size: 8),
//                                 height: 1.62,
//                                 color: Colors.black,
//                               ),
//                               children: [
//                                 TextSpan(
//                                   text: 'Please consult your doctor ',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text:
//                                       'or a registered dietitian before making significant changes to your diet.',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildConsumptionTextChip(String name, double value, Color dotColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: dotColor,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Flexible(
//             child: Text(
//               name,
//               overflow: TextOverflow.ellipsis,
//               softWrap: true,
//             ),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             value.toStringAsFixed(1),
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildRecipeCard(String dishName, String mainNutrient,
//       Color nutrientColor, String dishDesc) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       spacing: 4,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           spacing: 4,
//           children: [
//             Expanded(
//               child: Text(
//                 dishName,
//                 style: TextStyle(
//                     fontSize: FlutterFlowTheme.adjustScale(size: 13),
//                     height: 1.2,
//                     fontWeight: FontWeight.w700,
//                     color: FlutterFlowTheme.of(context).primaryText),
//               ),
//             ),
//             InkWell(
//               onTap: () async {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         DetailedRecipeWidget(recipeName: dishName),
//                   ),
//                 );
//               },
//               child: Icon(
//                 Icons.chevron_right,
//                 size: 20,
//                 color: FlutterFlowTheme.of(context).primaryText,
//                 weight: 700,
//               ),
//             ),
//           ],
//         ),
//         Container(
//           padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
//           decoration: BoxDecoration(
//               color: nutrientColor, borderRadius: BorderRadius.circular(4)),
//           child: Wrap(
//             crossAxisAlignment: WrapCrossAlignment.center,
//             spacing: 4,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4)),
//                 child: FaIcon(
//                   FontAwesomeIcons.solidStar,
//                   color: nutrientColor,
//                   size: 9,
//                 ),
//               ),
//               Text(
//                 mainNutrient ?? 'Unknown', //'Fiber-Rich',
//                 style: TextStyle(
//                     fontSize: FlutterFlowTheme.adjustScale(size: 11),
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700),
//               )
//             ],
//           ),
//         ),
//         Text(
//           dishDesc,
//           style: TextStyle(
//               fontSize: FlutterFlowTheme.adjustScale(size: 12),
//               height: 1.667,
//               color: FlutterFlowTheme.of(context).primaryText),
//           maxLines: 4,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
// }
