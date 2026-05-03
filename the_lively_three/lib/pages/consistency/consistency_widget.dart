import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/your_progress/your_progress_widget.dart';

class ConsistencyPage extends StatelessWidget {
  final String title;
  const ConsistencyPage({super.key, required this.title});

  static String routeName = 'Consistency';
  static String routePath = '/consistency';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Daily, Weekly, Monthly, Yearly
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              context
                  .pushNamed(ProgressPage.routeName, extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                    hasTransition: true,
                    transitionType: PageTransitionType.rightToLeft)
              });
            },
            child: const Icon(Icons.chevron_left, color: Colors.black),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 20),
                fontWeight: FontWeight.w700,
                color: FlutterFlowTheme.of(context).primaryText),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// Container for Tabs + ProgressBars
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2), // bg #f2f2f2
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  /// Tabs
                  ///
                  TabBar(
                    indicator: BoxDecoration(
                      color: Colors.orange.shade400,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelPadding: EdgeInsets.all(1),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicatorPadding: EdgeInsetsGeometry.symmetric(
                        vertical: 0, horizontal: 6),
                    tabs: [
                      Tab(
                        height: 30.0,
                        child: Text(
                          "DAILY",
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        height: 30.0,
                        child: Text(
                          "WEEKLY",
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        height: 30.0,
                        child: Text(
                          "MONTHLY",
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        height: 30.0,
                        child: Text(
                          "YEARLY",
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Tab Views (progressbars)
                  SizedBox(
                    height: 220, // fixed height for progress bars
                    child: TabBarView(
                      children: [
                        _buildConsistencyTab("Daily Consistency", _dailyData),
                        _buildConsistencyTab("Weekly Consistency", _weeklyData),
                        _buildConsistencyTab(
                            "Monthly Consistency", _monthlyData),
                        _buildConsistencyTab("Yearly Consistency", _yearlyData),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Info Cards
            _buildInfoCard(
              "Small Habits, Big Impact",
              "Building consistent eating habits is one of the most powerful ways to support long-term health and well-being.\n\n"
                  "Getting a wide range of nutrients consistently—like fiber, healthy fats, vitamins, and minerals—ensures that no system in your body is left unsupported. "
                  "It’s not just about what you eat in one day, but how you eat over weeks, months, and years. "
                  "This steady approach helps prevent nutrient deficiencies, supports a strong immune system, "
                  "and even improves your mood and energy levels. In the long run, small daily choices add up to lasting results.",
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              "Small Habits, Big Impact",
              "Building consistent eating habits is one of the most powerful ways to support long-term health and well-being.\n\n"
                  "Getting a wide range of nutrients consistently—like fiber, healthy fats, vitamins, and minerals—ensures that no system in your body is left unsupported. "
                  "It’s not just about what you eat in one day, but how you eat over weeks, months, and years. "
                  "This steady approach helps prevent nutrient deficiencies, supports a strong immune system, "
                  "and even improves your mood and energy levels. In the long run, small daily choices add up to lasting results.",
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable consistency section
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
        Expanded(
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

  /// Vertical progress bar widget
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

  /// Info card widget
  static Widget _buildInfoCard(String title, String content) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      color: Color(0xFFF2F2F2),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 16),
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF434343))),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 14),
                  color: Color(0xFF434343)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example data (can come from API later)
final List<Map<String, dynamic>> _dailyData = [
  {"percent": 70, "label": "MON"},
  {"percent": 40, "label": "TUE"},
  {"percent": 85, "label": "WED"},
  {"percent": 20, "label": "THU"},
  {"percent": 50, "label": "FRI"},
];

final List<Map<String, dynamic>> _weeklyData = [
  {"percent": 35, "label": "9-15\nJUL"},
  {"percent": 20, "label": "16-22\nJUL"},
  {"percent": 8, "label": "23-29\nJUL"},
  {"percent": 12, "label": "30 JUN\n6 JUL"},
  {"percent": 32, "label": "7-13\nJUL"},
  {"percent": 40, "label": "14-20\nJUL"},
];

final List<Map<String, dynamic>> _monthlyData = [
  {"percent": 50, "label": "JAN"},
  {"percent": 65, "label": "FEB"},
  {"percent": 80, "label": "MAR"},
  {"percent": 45, "label": "APR"},
];

final List<Map<String, dynamic>> _yearlyData = [
  {"percent": 60, "label": "2020"},
  {"percent": 70, "label": "2021"},
  {"percent": 55, "label": "2022"},
  {"percent": 75, "label": "2023"},
];
