import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_lively_three/app_state.dart';
import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/components/filter_bottom_sheet/filter_bottom_sheet_widget.dart';
import 'package:the_lively_three/components/progress_scaler/progress_scaler_widget.dart';
import 'package:the_lively_three/components/spider_chart/spider_chart_widget.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/custom_code/widgets/weekly_item_card.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_widgets.dart';
import 'package:the_lively_three/pages/low_micronutrients/low_micronutrients_model.dart';
import '../../backend/supabase/supabase.dart';

class LowMicronutrientsPage extends StatefulWidget {
  final String exploreType;
  const LowMicronutrientsPage({super.key, required this.exploreType});
  static String routeName = 'LowMicronutrients';
  static String routePath = '/low-micronutrients';

  @override
  State<LowMicronutrientsPage> createState() => _LowMicronutrientsPageState();
}

class _LowMicronutrientsPageState extends State<LowMicronutrientsPage> {
  // ✅ Store selected nutrient info
  String? _currentValue;
  int? _selectedNutrientId;
  String _selectedNutrientDisplayName = 'Select Nutrient';
  int _tooltipMode = 0;
  double _selectedNutrientValue = 0.0;
  double _selectedNutrientRecommendedValue = 100.0; // ✅ Store recommended value

  // ✅ Store ALL micronutrient data from RPC call
  List<Map<String, dynamic>> _allNutrientData = [];

  // ✅ Store micronutrient options for dropdown
  List<Map<String, dynamic>> mirconutrientOptions = [];
  bool _isLoadingMicronutrients = false;

  // ✅ Top 5 for spider chart display
  List<String> features = [];
  List<double> data1 = [];
  bool _isNutrientDataLoading = true;

  // ✅ Store nutrient benefits
  List<Map<String, dynamic>> _nutrientBenefits = [];
  bool _isLoadingBenefits = false;

  int? _expandedIndex;

  late LowMicronutrientsModal _model;
  Timer? _tooltipTimer;

  @override
  void initState() {
    super.initState();
    _model = LowMicronutrientsModal();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.loadCurrentWeekIndicators();
      _initializeData();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// ✅ Initialize data in correct order
  Future<void> _initializeData() async {
    // Load micronutrient options first
    await loadMicronutrientOptions();
    // Then load nutrient data and auto-select lowest
    await loadNutrientData();
  }

  _setTooltipMode(int dataType) {
    setState(() {
      _tooltipMode = dataType;
    });
  }

  Future<void> loadNutrientData() async {
    setState(() {
      _isNutrientDataLoading = true;
    });

    try {
      final result = await fetchWeeklyNutrientIntake(
        userId: currentUserUid,
        year: FFAppState().calendarYear,
        week: FFAppState().calendarWeek,
        locale: "en",
        dayNo: FFAppState().currentDayNumber,
      );

      setState(() {
        _allNutrientData = List<Map<String, dynamic>>.from(result['allData']);

        features = List<String>.from(result['features']);
        data1 = List<double>.from(result['data1']);
        _isNutrientDataLoading = false;
      });

      await _autoSelectLowestNutrient();
      print('Features: $features');
      print('Data1: $data1');
    } catch (e) {
      print("Error loading nutrient data: $e");
      setState(() {
        // Set default values on error
        features = ['N/A', 'N/A', 'N/A', 'N/A', 'N/A'];
        data1 = [0, 0, 0, 0, 0];
        _allNutrientData = [];
        _isNutrientDataLoading = false;
      });
    }
  }

  /// ✅ Auto-select the first nutrient (lowest) from the sorted list
  Future<void> _autoSelectLowestNutrient() async {
    if (_allNutrientData.isEmpty) return;

    // ✅ Simply take the first nutrient since data is already sorted in ascending order
    Map<String, dynamic> lowestNutrient = _allNutrientData.first;
    print('lowest nutrient: $lowestNutrient');

    int nutrientId = lowestNutrient['nutrient_id'] ?? 0;
    String displayName = lowestNutrient['displayname'] ?? 'N/A';
    double percentValue =
        (lowestNutrient['percentage_consumption'] ?? 0).toDouble();
    double nutrientConsumed = (lowestNutrient['nutrientConsumption'] ?? 0);

    // ✅ Get recommended value from micronutrient options
    double recommendedValue = lowestNutrient['recommendedvalue']; // default
    if (mirconutrientOptions.isNotEmpty) {
      final nutrientOption = mirconutrientOptions.firstWhere(
        (n) => n['id'] == nutrientId,
        orElse: () => {},
      );

      if (nutrientOption.isNotEmpty) {
        recommendedValue =
            (nutrientOption['daily_recommend_value'] ?? 100).toDouble();
      }
    }

    setState(() {
      _selectedNutrientId = nutrientId;
      _selectedNutrientDisplayName = displayName;
      _selectedNutrientValue = nutrientConsumed;
      _selectedNutrientRecommendedValue = recommendedValue;
      _currentValue = nutrientId.toString();
      print(_selectedNutrientId);
    });

    // Load benefits for the auto-selected nutrient
    debugPrint('nutrient selected: $nutrientId');
    await loadNutrientBenefits(nutrientId);
  }

// Update fetchWeeklyNutrientIntake to clear lists first:
  Future<Map<String, dynamic>> fetchWeeklyNutrientIntake({
    required String userId,
    required int year,
    required int week,
    required String locale,
    required int dayNo,
  }) async {
    final supabase = Supabase.instance.client;

    final response = await supabase.rpc(
      'get_weekly_nutrient_intake',
      params: {
        'p_user_id': userId,
        'p_year': year,
        'p_week': week,
        'p_locale': locale,
        'v_day_no': dayNo,
      },
    );

    if (response == null) {
      throw Exception('Supabase RPC returned null');
    }

    final data = response as List<dynamic>;

    // Store ALL nutrient data
    List<Map<String, dynamic>> allData = [];
    List<String> newFeatures = [];
    List<double> newData1 = [];

    for (var item in data) {
      allData.add({
        'nutrient_id': item['id_nutrient'] ?? 0,
        'displayname': item['displayname'] ?? 'N/A',
        'percentage_consumption':
            (item['percentage_consumption'] ?? 0).toDouble(),
        'recommendedvalue': (item['recommended_value'] ?? 0).toDouble(),
        'nutrientConsumption': (item['nutrientConsumption'] ?? 0).round()
      });
    }

    // Take top 5 for spider chart
    for (var item in data.take(5)) {
      newFeatures.add(item['displayname'] ?? 'N/A');
      newData1.add((item['percentage_consumption'] ?? 0).round());
    }

    // Ensure we have exactly 5 items for spider chart
    while (newFeatures.length < 5) {
      newFeatures.add("N/A");
      newData1.add(0);
    }

    return {
      'allData': allData,
      'features': newFeatures,
      'data1': newData1,
    };
  }

  /// Fetches complete nutrient information where daily recommended value is not null
  Future<List<Map<String, dynamic>>> fetchNutrientsWithRecommendedValues({
    String locale = 'en',
    int? categoryCode,
  }) async {
    try {
      final supabase = Supabase.instance.client;

      var query = supabase
          .from('nutrient')
          .select(
              'id, name, display_name, daily_recommend_value, daily_recommend_value_female, category, category_code, uom')
          .eq('locale', locale)
          .not('daily_recommend_value', 'is', null)
          .order('display_name', ascending: true);

      final response = await query;

      if (response == null || response.isEmpty) {
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching nutrients: $e');
      throw Exception('Failed to fetch nutrients: $e');
    }
  }

  Future<void> loadMicronutrientOptions() async {
    setState(() {
      _isLoadingMicronutrients = true;
    });

    try {
      final nutrients = await fetchNutrientsWithRecommendedValues(
        locale: 'en',
      );

      setState(() {
        mirconutrientOptions = nutrients;
        _isLoadingMicronutrients = false;
      });

      print('Loaded ${mirconutrientOptions.length} micronutrient options');
    } catch (e) {
      print("Error loading micronutrient options: $e");
      setState(() {
        mirconutrientOptions = [];
        _isLoadingMicronutrients = false;
      });
    }
  }

  /// ✅ Fetch nutrient benefits by nutrient ID
  Future<List<Map<String, dynamic>>> fetchNutrientBenefits({
    required int nutrientId,
    String locale = 'en',
  }) async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('nutrient_benefits')
          .select('id, nutrient_id, benefit_type, description, detail, seq_no')
          .eq('nutrient_id', nutrientId)
          .eq('locale', locale)
          .eq('status', 1)
          .eq('benefit_type', 3)
          .order('seq_no', ascending: true);

      if (response == null || response.isEmpty) {
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching nutrient benefits: $e');
      throw Exception('Failed to fetch nutrient benefits: $e');
    }
  }

  /// ✅ Load benefits when a nutrient is selected
  Future<void> loadNutrientBenefits(int nutrientId) async {
    setState(() {
      _isLoadingBenefits = true;
    });

    try {
      final benefits = await fetchNutrientBenefits(
        nutrientId: nutrientId,
        locale: 'en',
      );

      setState(() {
        _nutrientBenefits = benefits;
        _isLoadingBenefits = false;
      });

      print('Loaded ${benefits.length} benefits for nutrient ID: $nutrientId');
    } catch (e) {
      print("Error loading nutrient benefits: $e");
      setState(() {
        _nutrientBenefits = [];
        _isLoadingBenefits = false;
      });
    }
  }

  /// ✅ Handle nutrient selection change
  void _onNutrientSelected(int nutrientId, String displayName) {
    // Find the selected nutrient's data from RPC results
    final selectedData = _allNutrientData.firstWhere(
      (item) => item['nutrient_id'] == nutrientId,
      orElse: () => {'percentage_consumption': 0.0},
    );

    // ✅ Get recommended value from micronutrient options
    double recommendedValue = 100.0; // default
    if (mirconutrientOptions.isNotEmpty) {
      final nutrientOption = mirconutrientOptions.firstWhere(
        (n) => n['id'] == nutrientId,
        orElse: () => {},
      );

      if (nutrientOption.isNotEmpty) {
        recommendedValue =
            (nutrientOption['daily_recommend_value'] ?? 100).toDouble();
      }
    }

    setState(() {
      _selectedNutrientId = nutrientId;
      _selectedNutrientDisplayName = displayName;
      _selectedNutrientValue =
          (selectedData['percentage_consumption'] ?? 0).toDouble();
      _selectedNutrientRecommendedValue = recommendedValue;
      _currentValue = nutrientId.toString();
    });

    // Load benefits for selected nutrient
    loadNutrientBenefits(nutrientId);

    print(
        'Selected: $displayName - Value: $_selectedNutrientValue% - Recommended: $_selectedNutrientRecommendedValue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Text(
          widget.exploreType,
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
                buttonFunction: () =>
                    showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => FilterBottomSheetWidget(),
                    ),
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
          child: ListenableBuilder(
        listenable: _model,
        builder: (context, child) {
          if (_model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFA8E6CF),
              ),
            );
          }

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
                      'Error loading data',
                      style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_model.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(size: 14)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _model.loadCurrentWeekIndicators(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA8E6CF),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Here are the 5 micronutrients your body's getting the least of right now. Tap below to see personalized food suggestions that can help you stay balanced and energized.",
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            height: 1.583,
                            color: FlutterFlowTheme.of(context).textGrey,
                          ),
                        ),
                        Row(
                          spacing: 12,
                          children: [
                            _sortChip(
                                label: 'Your Score',
                                selected: _tooltipMode == 1,
                                onTap: () {
                                  _setTooltipMode(1);
                                  // Cancel any existing timer
                                  _tooltipTimer?.cancel();

                                  // Start a new 5-second timer
                                  _tooltipTimer =
                                      Timer(Duration(seconds: 5), () {
                                    _setTooltipMode(0);
                                  });
                                },
                                onCancel: () {
                                  _setTooltipMode(0);
                                },
                                gradientColors: [
                                  Color(0xff00ECFF).withOpacity(0.3),
                                  Color(0xff00ECFF).withOpacity(0.3)
                                ],
                                doGradientColors: [
                                  Color(0xFF00ECFF),
                                  Color(0xFF3968E6),
                                ]),
                            _sortChip(
                                label: 'Community Score',
                                selected: _tooltipMode == 2,
                                onTap: () {
                                  _setTooltipMode(2);
                                  _tooltipTimer?.cancel();

                                  // Start a new 5-second timer
                                  _tooltipTimer =
                                      Timer(Duration(seconds: 5), () {
                                    _setTooltipMode(0);
                                  });
                                },
                                onCancel: () {
                                  _setTooltipMode(0);
                                },
                                gradientColors: [
                                  Color(0xffE400FF).withOpacity(0.3),
                                  Color(0xffE400FF).withOpacity(0.3)
                                ],
                                doGradientColors: [
                                  Color(0xFFE400FF),
                                  Color(0xFF2883DE),
                                ]),
                          ],
                        ),
                        Container(
                          height: MediaQuery.sizeOf(context).width - 120,
                          margin: const EdgeInsets.only(top: 45),
                          child: SpiderChart(
                            data1: [60, 80, 50, 70, 50],
                            data2: data1,
                            labels: features,
                            color1: const [
                              Color(0xFFE400FF),
                              Color(0xFF2883DE),
                            ],
                            color2: const [
                              Color(0xFF00ECFF),
                              Color(0xFF3968E6),
                            ],
                            backgroundColors: const [
                              Color(0xffbababa),
                              Color(0xffcecece),
                              Color(0xffe1e1e1),
                              Color(0xffececec),
                              Color(0xfff9f9f9),
                              Color(0xfff9f9f9),
                              Color(0xffececec),
                              Color(0xffe1e1e1),
                              Color(0xffcecece),
                              Color(0xffbababa),
                              Color(0xffbababa),
                            ],
                            layerCount: 11,
                            tooltipMode: _tooltipMode,
                            labelBg: [Colors.white, Color(0xffe0e0e0)],
                            onLabelTap: (index) {
                              print('Label tapped: ${features[index]}');
                              // Handle label click
                            },
                          ),
                        ),
                      ],
                    )),
                Text(
                  'Find Your Nutrient Balance',
                  style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 18),
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SilverButton(
                        buttonTitle: _selectedNutrientDisplayName,
                        buttonFunction: () =>
                            showModalBottomSheet<Map<String, dynamic>>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  MirconutrientsBottomSheetWidget(),
                            ),
                        iconPlacement: 'right',
                        hasIcon: true,
                        iconWidget: Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          size: 16,
                          color: FlutterFlowTheme.of(context).textGrey,
                        )),
                    // SilverButton(
                    //     circularShape: true,
                    //     buttonFunction: () =>
                    //         showModalBottomSheet<Map<String, dynamic>>(
                    //           context: context,
                    //           isScrollControlled: true,
                    //           backgroundColor: Colors.transparent,
                    //           builder: (context) =>
                    //               MirconutrientsBottomSheetWidget(),
                    //         ),
                    //     hasIcon: true,
                    //     iconWidget: Image.asset(
                    //       'assets/icons/filter_icon.png',
                    //       width: 16,
                    //       height: 16,
                    //     ),
                    //     paddingHorizontal: 4,
                    //     paddingVertical: 4),
                  ],
                ),
                // ✅ Display selected nutrient value
                ScoreRulerWidget(
                  userScore: _selectedNutrientValue,
                  communityScore: 0,
                  milestone: ((_selectedNutrientRecommendedValue ?? 100) *
                          FFAppState().currentDayNumber)
                      .round(),
                  milestoneLabel: 'Recommended: ',
                  hasConsent: true,
                  currentColor: Color(0xffff9a62),
                  graphBG: Colors.white,
                  showBoxShadow: false,
                  borderColor: Colors.transparent,
                  isDotted: false,
                  hasPadding: true,
                  height: 170,
                  textBG: FlutterFlowTheme.of(context).secondaryBackground,
                  communityColor: FlutterFlowTheme.of(context).commFiber,
                  userColor: FlutterFlowTheme.of(context).userFiber,
                ),
                // ✅ Display nutrient benefits
                if (_isLoadingBenefits)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(
                        color: Color(0xFFA8E6CF),
                      ),
                    ),
                  )
                else if (_nutrientBenefits.isNotEmpty)
                  Column(
                    spacing: 8,
                    children: [
                      ...List.generate(_nutrientBenefits.length, (index) {
                        final benefit = _nutrientBenefits[index];
                        final bool isExpanded = _expandedIndex == index;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                childrenPadding:
                                    const EdgeInsets.fromLTRB(14, 0, 14, 14),
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    _expandedIndex = expanded ? index : null;
                                  });
                                },
                                initiallyExpanded: isExpanded,
                                title: Text(
                                  benefit['description'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 16),
                                    height: 1.375,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                  ),
                                ),
                                trailing: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: FlutterFlowTheme.of(context).textGrey,
                                  size: 24,
                                ),
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      benefit['detail'] ??
                                          'No details available',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
                                        height: 1.83,
                                        color: FlutterFlowTheme.of(context)
                                            .textGrey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  )
                else if (_selectedNutrientId != null &&
                    _selectedNutrientId! > 0)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFFECAA),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFFFF9800),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No benefits available',
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 16),
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Benefit information for $_selectedNutrientDisplayName is not available in the database yet.',
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 14),
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select a nutrient to view benefits',
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 16),
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Choose a micronutrient from the dropdown above to see its health benefits and detailed information.',
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 14),
                            height: 1.6,
                            color: FlutterFlowTheme.of(context).textGrey,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      )),
    );
  }

  Widget MirconutrientsBottomSheetWidget() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return SafeArea(
            bottom: true,
            child: Container(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 1.0,
              decoration: BoxDecoration(
                color: Color(0x37000000),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 8.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.cancel,
                              color: FlutterFlowTheme.of(context).textGrey,
                              size: 24.0,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 24.0, 0.0),
                              child: Text(
                                "Micronutrients",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 16),
                                  fontWeight: FontWeight.w600,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  height: 1.2,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    decoration: BoxDecoration(
                      color: Color(0xFF979797),
                    ),
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.68,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Column(
                            spacing: 12,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Select a micronutrient to explore your intake, its benefits, and related insights.',
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 12),
                                  height: 1.67,
                                  color: FlutterFlowTheme.of(context).textGrey,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.68 -
                                        150,
                                child: SingleChildScrollView(
                                  child: _buildRadioButtonList(setModalState),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FFButtonWidget(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                text: 'Cancel',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50,
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  textStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                  ),
                                  elevation: 2.0,
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FFButtonWidget(
                                onPressed: _selectedNutrientId == null ||
                                        _selectedNutrientId == 0
                                    ? null
                                    : () async {
                                        Navigator.pop(context);
                                        if (_selectedNutrientId != null &&
                                            _selectedNutrientId! > 0) {
                                          // ✅ Benefits already loaded in _onNutrientSelected
                                          // Just close the modal
                                        }
                                      },
                                text: 'Apply',
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 50,
                                  color: (_selectedNutrientId == null ||
                                          _selectedNutrientId == 0)
                                      ? Colors.grey
                                      : FlutterFlowTheme.of(context)
                                          .primaryText,
                                  textStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 12),
                                  ),
                                  elevation: 2.0,
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildRadioButtonList(StateSetter setModalState) {
    if (_isLoadingMicronutrients) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Color(0xFFA8E6CF),
          ),
        ),
      );
    }

    if (mirconutrientOptions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No micronutrients available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mirconutrientOptions.length,
      itemBuilder: (context, index) {
        final nutrient = mirconutrientOptions[index];
        final displayName = (nutrient['display_name'] ?? '') as String;
        final nutrientId = (nutrient['id'] ?? 0) as int;
        final String uniqueValue = nutrientId.toString();

        return RadioListTile<String>(
          title: Text(
            displayName,
            style: TextStyle(
              fontSize: 14,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          value: uniqueValue,
          groupValue: _currentValue,
          activeColor: FlutterFlowTheme.of(context).primaryText,
          onChanged: (val) {
            // ✅ Update modal state
            setModalState(() {
              _currentValue = val;
            });

            // ✅ Update parent state and load benefits
            setState(() {
              _onNutrientSelected(nutrientId, displayName);
            });

            print('Selected: $displayName (ID: $nutrientId)');
          },
        );
      },
    );
  }

  Widget _sortChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    VoidCallback? onCancel,
    List<Color>? gradientColors,
    List<Color>? doGradientColors,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).alternate,
          border: selected
              ? Border.all(color: gradientColors![0], width: 1)
              : Border.all(color: Color.fromRGBO(206, 206, 206, 1), width: 1),
          borderRadius: BorderRadius.circular(16),
          gradient: selected
              ? LinearGradient(
                  colors: gradientColors!,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [
                    Color(0xffffffff),
                    Color(0xffe0e0e0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: (gradientColors != null)
                    ? LinearGradient(
                        colors: doGradientColors!,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
              ),
            ),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                    color: FlutterFlowTheme.of(context).textGrey,
                    height: 1.2,
                  ),
            ),
            if (selected)
              InkWell(
                onTap: onCancel,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xffececec)),
                  child: Icon(
                    Icons.close,
                    size: 8,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
