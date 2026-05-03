// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({
    super.key,
    this.width,
    this.height,
    this.chartHeightRatio = 0.6, // Chart takes 60% of widget height
    required this.indicatorName,
    required this.userId,
    this.bottomSheetColor = Colors.blue,
    this.bottomSheetOpacity = 0.15,
    required this.isCommunity, // For community mode
    this.isPercentageScale =
        true, // New parameter: percentage (true) or dynamic numeric scaling (false)
  });

  final double? width;
  final double? height;
  final double chartHeightRatio;
  final String indicatorName;
  final String userId;
  final Color bottomSheetColor;
  final double bottomSheetOpacity;
  final bool isCommunity;
  final bool isPercentageScale;

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<FlSpot> allChartData = [];
  List<String> allWeekLabels = [];
  List<FlSpot> chartData = [];
  List<String> weekLabels = [];
  bool isLoading = true;
  String chartTitle = "";
  int currentSegment = 0;
  int totalSegments = 1;

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final supabase = Supabase.instance.client;

    try {
      // Choose the view and query parameters based on isCommunity.
      final response = widget.isCommunity
          ? await supabase
              .from('view_community_indicators')
              .select('value, calendarweek, calendaryear, displayname')
              .eq('indicatorname', widget.indicatorName)
              .order('calendaryear', ascending: false)
              .order('calendarweek', ascending: false)
              .limit(52)
          : await supabase
              .from('view_individual_indicators_values')
              .select('value, calendarweek, calendaryear, displayname')
              .eq('id_user', widget.userId)
              .eq('indicatorname', widget.indicatorName)
              .order('calendaryear', ascending: false)
              .order('calendarweek', ascending: false)
              .limit(52);

      if (response.isNotEmpty) {
        List<Map<String, dynamic>> rawData = response;
        chartTitle = rawData.first['displayname'] ?? "Indicator Chart";

        List<FlSpot> tempSpots = [];
        List<String> tempWeekLabels = [];

        int earliestYear = rawData.last['calendaryear'];
        Set<String> existingLabels = {};

        for (var row in rawData) {
          final int week = row['calendarweek'];
          final int year = row['calendaryear'];
          final double value = (row['value'] as num).toDouble();
          int adjustedWeek = (year - earliestYear) * 52 + week;

          tempSpots.add(FlSpot(adjustedWeek.toDouble(), value));
          String label = '$week/$year';
          tempWeekLabels.add(label);
          existingLabels.add(label);
        }

        // Ensure every expected week label exists (even if data is missing)
        int totalWeeks = 52;
        for (int i = 0; i < totalWeeks; i++) {
          String expectedLabel = '${i % 52 + 1}/${earliestYear + (i ~/ 52)}';
          if (!existingLabels.contains(expectedLabel)) {
            tempWeekLabels.add(expectedLabel);
          }
        }

        allChartData = tempSpots;
        allWeekLabels = tempWeekLabels;

        totalSegments = (allChartData.length / 12).ceil();
        currentSegment = 0;
        updateChartSegment();

        setState(() {
          isLoading = false;
        });
      } else {
        print('No data found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching chart data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateChartSegment() {
    int startIndex = currentSegment * 12;
    int endIndex = (startIndex + 12 > allChartData.length)
        ? allChartData.length
        : startIndex + 12;

    List<FlSpot> segmentData = allChartData.sublist(startIndex, endIndex);
    List<String> segmentLabels = allWeekLabels.sublist(startIndex, endIndex);

    setState(() {
      chartData = segmentData.reversed.toList();
      weekLabels = segmentLabels.reversed.toList();
    });

    print("DEBUG: Updated Week Labels:");
    print(weekLabels);
  }

  Widget getXLabel(double value, TitleMeta meta) {
    int index = value.toInt() - chartData.first.x.toInt();
    if (index < 0 || index >= weekLabels.length) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Transform.rotate(
        angle: -0.7854, // Rotates 45° for readability
        child: Text(
          weekLabels[index],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine y-axis scaling based on isPercentageScale.
    double computedMaxY;
    double tickInterval;
    if (widget.isPercentageScale) {
      computedMaxY = 100;
      tickInterval = 20;
    } else {
      if (allChartData.isNotEmpty) {
        double maxDataValue =
            allChartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
        computedMaxY = maxDataValue * 1.1; // add 10% margin
        tickInterval =
            computedMaxY / 5; // you can adjust the number of ticks as desired
      } else {
        computedMaxY = 100;
        tickInterval = 20;
      }
    }

    // Local function to generate y-axis labels based on tickInterval.
    Widget getDynamicYLabel(double value, TitleMeta meta) {
      // Show label if value is an integer multiple of tickInterval (with tolerance)
      if (((value / tickInterval) - (value / tickInterval).round()).abs() <
          0.001) {
        return Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 10),
        );
      }
      return const SizedBox();
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  chartTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: (widget.height ?? 250) * widget.chartHeightRatio,
                width: widget.width ?? double.infinity,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: computedMaxY,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: tickInterval,
                          getTitlesWidget: getDynamicYLabel,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: 1,
                          getTitlesWidget: getXLabel,
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        isCurved: true,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: widget.bottomSheetColor
                              .withOpacity(widget.bottomSheetOpacity),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.cyan,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        color: Colors.cyan,
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.white,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((touchedSpot) {
                            return LineTooltipItem(
                              '${touchedSpot.y.toStringAsFixed(1)}',
                              const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentSegment < totalSegments - 1
                        ? () {
                            setState(() {
                              currentSegment++;
                              updateChartSegment();
                            });
                          }
                        : null,
                  ),
                  Text('Week ${weekLabels.first} to ${weekLabels.last}'),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentSegment > 0
                        ? () {
                            setState(() {
                              currentSegment--;
                              updateChartSegment();
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          );
  }
}
