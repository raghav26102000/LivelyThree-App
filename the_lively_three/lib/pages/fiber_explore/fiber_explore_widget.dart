import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_lively_three/app_state.dart';
import 'package:the_lively_three/components/filter_bottom_sheet/filter_bottom_sheet_widget.dart';
import 'package:the_lively_three/components/personalized_plant_list/personalized_plant_list_widget.dart';
import 'package:the_lively_three/components/progress_scaler/progress_scaler_widget.dart';
import 'package:the_lively_three/custom_code/widgets/custom_bar_widget.dart';
import 'package:the_lively_three/custom_code/widgets/silver_button_widget.dart';
import 'package:the_lively_three/custom_code/widgets/weekly_item_card.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/pages/fiber_explore/fiber_explore_model.dart';

class FiberExplorePage extends StatefulWidget {
  final String exploreType;
  const FiberExplorePage({super.key, required this.exploreType});
  static String routeName = 'FiberExplore';
  static String routePath = '/fiber-explore';

  @override
  State<FiberExplorePage> createState() => _FiberExplorePageState();
}

class _FiberExplorePageState extends State<FiberExplorePage> {
  final List<Map<String, dynamic>> _weeklyData = [
    {"percent": 35, "label": "9-15\nJUL"},
    {"percent": 20, "label": "16-22\nJUL"},
    {"percent": 8, "label": "23-29\nJUL"},
    {"percent": 12, "label": "30 JUN\n6 JUL"},
    {"percent": 32, "label": "7-13\nJUL"},
    {"percent": 40, "label": "14-20\nJUL"},
  ];
  final List<Map<String, dynamic>> _faq = [
    {
      "query": 'How does eating more fiber help the environment?',
      "description": ""
    },
    {"query": 'Why track your fiber?', "description": ""},
    {
      "query": 'Small Habits, Big Impact',
      "description":
          "Building consistent eating habits is one of the most powerful ways to support long-term health and well-being.\n\nGetting a wide range of nutrients consistently—like fiber, healthy fats, vitamins, and minerals—ensures that no system in your body is left unsupported. It’s not just about what you eat in one day, but how you eat over weeks, months, and years. This steady approach helps prevent nutrient deficiencies, supports a strong immune system, and even improves your mood and energy levels. In the long run, small daily choices add up to lasting results."
    },
  ];
  int? _expandedIndex;

  final features = [
    'Iodine',
    'Zinc',
    'Folate',
    'Vit C',
    'M G',
  ];

  // Dataset A (e.g., User)
  final userData = [4.0, 3.5, 4.5, 2.0, 3.0];

  // Dataset B (e.g., Community)
  final communityData = [3.0, 4.0, 3.0, 4.0, 4.5];

  double angleValue = 0;
  bool relativeAngleMode = true;

  final List<WeeklyPlantMetrics> _suggestedPlants = [
    WeeklyPlantMetrics(
      id: 1,
      week: 42,
      idLoc: 101,
      plantname: "Spinach",
      color: "yellow",
      portionsize: 50.0,
      portionsum: 200.0,
      average4w: 150.0,
      fiber: 3.5,
      protein: 2.9,
      localizedPlantId: 101,
      weeklyTotal: 0,
      blueprintId: 10,
      timesConsumed: 5.0,
      category: -1,
      displayName: "Spinach (Cooked)",
    ),
    WeeklyPlantMetrics(
      id: 2,
      week: 42,
      idLoc: 102,
      plantname: "Broccoli",
      color: "orange",
      portionsize: 60.0,
      portionsum: 180.0,
      average4w: 120.0,
      fiber: 4.2,
      protein: 3.1,
      localizedPlantId: 102,
      weeklyTotal: 0,
      blueprintId: 12,
      timesConsumed: 4.0,
      category: -1,
      displayName: "Broccoli (Steamed)",
    ),
    WeeklyPlantMetrics(
      id: 3,
      week: 42,
      idLoc: 103,
      plantname: "Chickpeas",
      color: "red",
      portionsize: 70.0,
      portionsum: 300.0,
      average4w: 250.0,
      fiber: 6.0,
      protein: 7.5,
      localizedPlantId: 103,
      weeklyTotal: 0,
      blueprintId: 14,
      timesConsumed: 6.0,
      category: -1,
      displayName: "Chickpeas (Boiled)",
    ),
  ];

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

  void _onPortionAdded(String plantname, String colorTag, double delta) async {
    // Refresh logic here
  }

  DateTime _todayLocal() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  late DateTime _selectedDate;

  late FiberExploreModal _model;
  @override
  void initState() {
    super.initState();
    _model = FiberExploreModal();

    _selectedDate = _todayLocal();
    // Load indicators when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _model.loadCurrentWeekIndicators();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .primaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: false,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                      context: context, // ✅ Correct - named parameter
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
          print(
              'Building with isLoading: ${_model.isLoading}, error: ${_model.error}');

          // Loading state
          if (_model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFA8E6CF),
              ),
            );
          }

          // Error state
          if (_model.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
            padding: const EdgeInsets.all(8),
            child: Column(
              spacing: 16,
              children: [
                if (widget.exploreType == 'Fiber Challenge')
                  ScoreRulerWidget(
                    userScore: 20,
                    communityScore: 30,
                    milestone: 50,
                    milestoneLabel: '2nd Day Milestone',
                    hasConsent: true,
                    currentColor: Color(0xffff9a62),
                    graphBG: FlutterFlowTheme.of(context).secondaryBackground,
                    borderColor: Colors.transparent,
                    showBoxShadow: false,
                    isDotted: false,
                    hasPadding: true,
                    height: 170,
                    textBG: FlutterFlowTheme.of(context).secondaryBackground,
                    communityColor: FlutterFlowTheme.of(context).commFiber,
                    userColor: FlutterFlowTheme.of(context).userFiber,
                  ),
                if (widget.exploreType == 'Protein Challenge')
                  ScoreRulerWidget(
                    userScore: 45.0,
                    communityScore: 60.0,
                    milestone: 50,
                    currentColor: Colors.blueAccent,
                    hasConsent: true,
                    containerPaddingBottom: 128,
                    milestoneLabel: "Weekly Milestone",
                    height: 276,
                    userPlantBasedScore: 35.0,
                    communityPlantBasedScore: 55.0,
                    heightMilestone: 130,
                    heightUser: 86,
                    graphBG: FlutterFlowTheme.of(context).secondaryBackground,
                    heightCommunity: 80,
                    showPlantBasedDetails: true,
                    borderColor: Colors.transparent,
                    showBoxShadow: false,
                    userPlantBasedColor:
                        FlutterFlowTheme.of(context).userPlantProtein,
                    communityPlantBasedColor:
                        FlutterFlowTheme.of(context).commPlantProtein,
                    userColor: FlutterFlowTheme.of(context).userAnimalProtein,
                    communityColor:
                        FlutterFlowTheme.of(context).commAnimalProtein,
                    isDotted: false,
                    userTextWidth: 124, // optional
                    communityTextWidth: 140, // optional
                    userPlantBasedTextWidth: 124, // optional
                    communityPlantBasedTextWidth: 140,
                    hasPadding: true,
                    textBG: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                if (widget.exploreType == 'Fiber Challenge')
                  Text(
                    'Weekly Fiber Total',
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      fontWeight: FontWeight.w700,
                      color: FlutterFlowTheme.of(context).textGrey,
                    ),
                  ),
                if (widget.exploreType == 'Fiber Challenge')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: CarouselSlider(
                                items: [
                                  Row(
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
                                                totalValue: 135,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFFDE8A74),
                                                upperColor:
                                                    const Color(0xFFDE8A74),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                showStar: true,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 124,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFF9A5208),
                                                upperColor:
                                                    const Color(0xFF9A5208),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 34,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFFDE8A74),
                                                upperColor:
                                                    const Color(0xFFDE8A74),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 23,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFF9A5208),
                                                upperColor:
                                                    const Color(0xFF9A5208),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 53,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFFDE8A74),
                                                upperColor:
                                                    const Color(0xFFDE8A74),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 87,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFF9A5208),
                                                upperColor:
                                                    const Color(0xFF9A5208),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 36,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFFDE8A74),
                                                upperColor:
                                                    const Color(0xFFDE8A74),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 63,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFF9A5208),
                                                upperColor:
                                                    const Color(0xFF9A5208),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 16,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFFDE8A74),
                                                upperColor:
                                                    const Color(0xFFDE8A74),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 80,
                                                maxBarHeight: 135,
                                                lowerColor:
                                                    const Color(0xFF9A5208),
                                                upperColor:
                                                    const Color(0xFF9A5208),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                ],
                                carouselController:
                                    _model.carouselController ??=
                                        CarouselSliderController(),
                                options: CarouselOptions(
                                  height:
                                      FlutterFlowTheme.adjustScale(size: 168),
                                  initialPage: 1,
                                  viewportFraction: 86 /
                                      (MediaQuery.of(context).size.width - 84),
                                  enlargeCenterPage: false,
                                  enlargeFactor: 0,
                                  enableInfiniteScroll: false,
                                  scrollDirection: Axis.horizontal,
                                  autoPlay: false,
                                  onPageChanged: (index, _) =>
                                      _model.carouselCurrentIndex = index,
                                ),
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
                                    await _model.carouselController
                                        ?.previousPage(
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 12,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: [
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Color(0xFFDE8A74),
                                ),
                                Text(
                                  'Your Score',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Color(0xFF9A5208),
                                ),
                                Text(
                                  'Community Score',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.stars,
                                  size: 12,
                                  color: Color(0xFFDE8A74),
                                ),
                                Text(
                                  'Highest Fiber Intake',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
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
                if (widget.exploreType == 'Protein Challenge')
                  Text(
                    'Weekly Protein Total',
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      fontWeight: FontWeight.w700,
                      color: FlutterFlowTheme.of(context).textGrey,
                    ),
                  ),
                if (widget.exploreType == 'Protein Challenge')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: CarouselSlider(
                                items: [
                                  Row(
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
                                                totalValue: 70,
                                                upperValue: 20,
                                                lowerColor:
                                                    const Color(0xFF36b4ad),
                                                upperColor:
                                                    const Color(0xFFc15374),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 50,
                                                upperValue: 20,
                                                lowerColor:
                                                    const Color(0xFF8ad0cc),
                                                upperColor:
                                                    const Color(0xFFf2d0de),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 70,
                                                upperValue: 20,
                                                lowerColor:
                                                    const Color(0xFF36b4ad),
                                                upperColor:
                                                    const Color(0xFFc15374),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 50,
                                                lowerColor:
                                                    const Color(0xFF8ad0cc),
                                                upperColor:
                                                    const Color(0xFFf2d0de),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 70,
                                                upperValue: 20,
                                                lowerColor:
                                                    const Color(0xFF36b4ad),
                                                upperColor:
                                                    const Color(0xFFc15374),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 50,
                                                lowerColor:
                                                    const Color(0xFF8ad0cc),
                                                upperColor:
                                                    const Color(0xFFf2d0de),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 70,
                                                upperValue: 20,
                                                lowerColor: Color(0xFF36b4ad),
                                                upperColor: Color(0xFFc15374),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 50,
                                                lowerColor: Color(0xFF8ad0cc),
                                                upperColor: Color(0xFFf2d0de),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                  Row(
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
                                                totalValue: 70,
                                                upperValue: 20,
                                                lowerColor:
                                                    const Color(0xFF36b4ad),
                                                upperColor:
                                                    const Color(0xFFc15374),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                              const SizedBox(width: 4),
                                              DoubleBarWidget(
                                                totalValue: 50,
                                                lowerColor:
                                                    const Color(0xFF8ad0cc),
                                                upperColor:
                                                    const Color(0xFFf2d0de),
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'Week 00',
                                            style: TextStyle(
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 151,
                                        width: 2,
                                        color: const Color(0xffececec),
                                      )
                                    ],
                                  ),
                                ],
                                carouselController:
                                    _model.carouselController ??=
                                        CarouselSliderController(),
                                options: CarouselOptions(
                                  height:
                                      FlutterFlowTheme.adjustScale(size: 168),
                                  initialPage: 1,
                                  viewportFraction: 86 /
                                      (MediaQuery.of(context).size.width - 84),
                                  enlargeCenterPage: false,
                                  enlargeFactor: 0,
                                  enableInfiniteScroll: false,
                                  scrollDirection: Axis.horizontal,
                                  autoPlay: false,
                                  onPageChanged: (index, _) =>
                                      _model.carouselCurrentIndex = index,
                                ),
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
                                    await _model.carouselController
                                        ?.previousPage(
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
                        Wrap(
                          spacing: 2,
                          runSpacing: 12,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: [
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Color(0xFF36b4ad),
                                ),
                                Text(
                                  'Your Plant Base Score',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Color(0xFFc15374),
                                ),
                                Text(
                                  'Your Animal Base Score',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.stars,
                                  size: 12,
                                  color: Color(0xFF36b4ad),
                                ),
                                Text(
                                  'Your Highest Fiber Score',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Color(0xFF8ad0cc),
                                ),
                                Text(
                                  'Community Plant Base Score',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Color(0xFFf2d0de),
                                ),
                                Text(
                                  'Community Animal Base Score',
                                  style: TextStyle(
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 8),
                                    height: 1.2,
                                    color:
                                        FlutterFlowTheme.of(context).textGrey,
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
                if (widget.exploreType == 'Fiber Challenge')
                  Text(
                    'Your Top Fiber Sources:',
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      fontWeight: FontWeight.w700,
                      color: FlutterFlowTheme.of(context).textGrey,
                    ),
                  ),
                if (widget.exploreType == 'Protein Challenge')
                  Text(
                    'Your Top Plant-based Protein Sources:',
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 16),
                      fontWeight: FontWeight.w700,
                      color: FlutterFlowTheme.of(context).textGrey,
                    ),
                  ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  height: 150,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: List.generate(
                      _suggestedPlants.length,
                      (index) {
                        final plant = _suggestedPlants[index];
                        final angle = index == 0
                            ? -pi / 18
                            : index == 2
                                ? pi / 18
                                : 0.0;

                        return Positioned(
                          left: (MediaQuery.sizeOf(context).width *
                                  0.28 *
                                  index) +
                              12,
                          top: index == 1 ? -15 : 0.0,
                          child: Transform.rotate(
                            angle: angle,
                            child: _buildFeaturedCard(
                                primaryColor: _mapColorNameToColor(plant.color),
                                icon: '',
                                plantName: plant.displayName,
                                isTopPlant: true,
                                topPosition: index + 1,
                                value: '${plant.portionsize} g',
                                topNutrient: 'Fiber-Rich'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ...List.generate(_faq.length, (index) {
                  final query = _faq[index];
                  final bool isExpanded = _expandedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                              const EdgeInsets.fromLTRB(14, 4, 14, 14),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedIndex = expanded ? index : null;
                            });
                          },
                          initiallyExpanded: isExpanded,
                          title: Text(
                            query['query'] ?? 'N/A',
                            style: TextStyle(
                              fontSize: FlutterFlowTheme.adjustScale(size: 16),
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              color: FlutterFlowTheme.of(context).textGrey,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24,
                          ),
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                query['description'] ?? 'No details available',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 12),
                                  height: 1.83,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
            ),
          );
        },
      )),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String statType1,
    required int statValue1,
    required String statType2,
    required int statValue2,
    required String statType3,
    required int statValue3,
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
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                  spreadRadius: 1),
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4,
            children: [
              SizedBox(
                width: (MediaQuery.sizeOf(context).width * 0.33) - 25,
                child: Expanded(
                  child: _buildInfoDetail(
                      statType: statType1, statValue: statValue1),
                ),
              ),
              Container(
                color: Color(0xffe1e1e1),
                width: 1,
                height: 69,
              ),
              SizedBox(
                width: (MediaQuery.sizeOf(context).width * 0.33) - 25,
                child: Expanded(
                  child: _buildInfoDetail(
                      statType: statType2, statValue: statValue2),
                ),
              ),
              Container(
                color: Color(0xffe1e1e1),
                width: 1,
                height: 69,
              ),
              SizedBox(
                width: (MediaQuery.sizeOf(context).width * 0.33) - 25,
                child: Expanded(
                  child: _buildInfoDetail(
                      statType: statType3, statValue: statValue3),
                ),
              ),
            ],
          ),
        )
      ],
    );
    ;
  }

  Widget _buildInfoDetail({
    required String statType,
    required int statValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 8,
      children: [
        Text(
          statType,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 12),
              color: FlutterFlowTheme.of(context).textGrey,
              height: 1.2),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffeca02d),
          ),
          child: Text(
            '$statValue',
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 18),
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2),
          ),
        )
      ],
    );
  }

  Widget _buildSuggestionCard(
      {required String title, required List<String> items}) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.5 - 28,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 16),
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

  static Widget _buildConsistencyTab(
      String title, List<Map<String, dynamic>> data) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: FlutterFlowTheme.adjustScale(size: 16),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        /// Progress bars row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 32,
              mainAxisAlignment: MainAxisAlignment.center,
              children: data
                  .map((item) => _buildProgressBar(
                        percent: item["percent"],
                        label: item["label"],
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildProgressBar(
      {required int percent, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          /// % text on top
          Text(
            "$percent%",
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 14),
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),

          /// Vertical progress bar
          Container(
            height: 100,
            width: 23,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100 * (percent / 100),
                width: 23,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),

          /// Label below
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 11),
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard({
    required Color primaryColor,
    required String icon,
    required String plantName,
    required String topNutrient,
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
              CircleAvatar(
                backgroundColor: const Color(0xfff6f6f6),
                radius: 28,
                child: icon != ''
                    ? SvgPicture.asset(
                        'assets/icons/$icon', // Use dynamic icon
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                          primaryColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          primaryColor,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/images/LOGO.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.solidStar,
                            color: primaryColor,
                            size: 9,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            topNutrient ?? 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.2,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
            top: 5,
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

  Color _mapColorNameToColor(String? name) {
    switch (name!.toLowerCase()) {
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
}
