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

import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Named color strings → Flutter [Color].
final Map<String, Color> namedColors = {
  'red': Colors.red,
  'orange': Colors.orange,
  'yellow': Colors.yellow,
  'green': Colors.green,
  'purple': Colors.purple,
  'brown': Colors.brown,
  'white': Colors.white,
};

/// Bottom-to-top color priority for stacked rods.
final List<String> colorPriority = [
  'red',
  'orange',
  'yellow',
  'green',
  'purple',
  'brown',
  'white',
];

/// Convert named string (e.g. "Brown") → Flutter color, or grey if unknown.
Color parseNamedColor(String colorName) {
  final lower = colorName.toLowerCase().trim();
  return namedColors[lower] ?? Colors.grey;
}

class IndicatorBarChartWidget extends StatefulWidget {
  const IndicatorBarChartWidget({
    Key? key,
    this.width,
    this.height,
    this.chartHeightRatio = 0.6,
    required this.indicatorName,
    required this.userId,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double chartHeightRatio;
  final String indicatorName;
  final String userId;

  @override
  State<IndicatorBarChartWidget> createState() =>
      _IndicatorBarChartWidgetState();
}

class _IndicatorBarChartWidgetState extends State<IndicatorBarChartWidget> {
  /// numeric `missing_count` in oldest→newest order.
  final List<double> _weeklyValues = [];

  /// each row → raw named colors from JSON (["Brown","Green","Orange",...]).
  final List<List<String>> _weeklyColorNames = [];

  /// whether row's `jsonb_value` was NULL.
  final List<bool> _isDataNull = [];

  /// "week/year" labels.
  final List<String> _weeklyLabels = [];

  /// The displayName from your query (for chart title).
  String _displayName = '';

  bool _isLoading = true;

  // For paging: each segment can display up to 12 bars.
  int _currentSegment = 0;
  int _totalSegments = 1;
  int _remainder = 0;
  int _chunkCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Fetch up to 52 rows from Supabase, reversed to oldest→newest.
  Future<void> _fetchData() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('view_individual_indicators_values')
          .select('jsonb_value, calendarweek, calendaryear, displayname')
          .eq('id_user', widget.userId)
          .eq('indicatorname', widget.indicatorName)
          .order('calendaryear', ascending: false)
          .order('calendarweek', ascending: false)
          .limit(52);

      if (response is List && response.isNotEmpty) {
        // Reverse so oldest is index 0
        final data = response.reversed.toList();

        // Take displayName from the first reversed row (the oldest).
        _displayName = data.first['displayname'] ?? '';

        for (var row in data) {
          final dynamic jsonVal = row['jsonb_value'];
          final bool isNull = (jsonVal == null);
          _isDataNull.add(isNull);

          Map<String, dynamic> jsonData = {};
          if (!isNull) {
            if (jsonVal is String) {
              jsonData = jsonDecode(jsonVal);
            } else if (jsonVal is Map) {
              jsonData = Map<String, dynamic>.from(jsonVal);
            }
          }

          double missingCount = 0;
          if (jsonData['missing_count'] != null) {
            missingCount = (jsonData['missing_count'] as num).toDouble();
          }
          _weeklyValues.add(missingCount);

          List<String> colorNames = [];
          if (jsonData['missing_colors'] is List) {
            colorNames = (jsonData['missing_colors'] as List)
                .map((c) => c.toString())
                .toList();
          }
          _weeklyColorNames.add(colorNames);

          final int week = row['calendarweek'];
          final int year = row['calendaryear'];
          _weeklyLabels.add('$week/$year');
        }

        setState(() {
          // Segment logic
          _remainder = _weeklyValues.length % 12;
          _chunkCount = (_weeklyValues.length / 12).floor();
          _totalSegments = (_remainder > 0) ? _chunkCount + 1 : _chunkCount;
          // Show newest segment
          _currentSegment = _totalSegments - 1;
          _isLoading = false;
        });
      } else {
        // No data
        setState(() {
          _displayName = '';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
      setState(() {
        _displayName = '';
        _isLoading = false;
      });
    }
  }

  //--- Segment slicing (12 items each) ---
  List<double> _getSegmentValues(int segmentIndex) {
    if (_totalSegments == 1) return _weeklyValues;
    if (_remainder > 0) {
      if (segmentIndex == 0) {
        return _weeklyValues.sublist(0, _remainder);
      } else {
        final offset = _remainder + (segmentIndex - 1) * 12;
        return _weeklyValues.sublist(offset, offset + 12);
      }
    } else {
      final offset = segmentIndex * 12;
      return _weeklyValues.sublist(offset, offset + 12);
    }
  }

  List<List<String>> _getSegmentColorNames(int segmentIndex) {
    if (_totalSegments == 1) return _weeklyColorNames;
    if (_remainder > 0) {
      if (segmentIndex == 0) {
        return _weeklyColorNames.sublist(0, _remainder);
      } else {
        final offset = _remainder + (segmentIndex - 1) * 12;
        return _weeklyColorNames.sublist(offset, offset + 12);
      }
    } else {
      final offset = segmentIndex * 12;
      return _weeklyColorNames.sublist(offset, offset + 12);
    }
  }

  List<bool> _getSegmentIsNull(int segmentIndex) {
    if (_totalSegments == 1) return _isDataNull;
    if (_remainder > 0) {
      if (segmentIndex == 0) {
        return _isDataNull.sublist(0, _remainder);
      } else {
        final offset = _remainder + (segmentIndex - 1) * 12;
        return _isDataNull.sublist(offset, offset + 12);
      }
    } else {
      final offset = segmentIndex * 12;
      return _isDataNull.sublist(offset, offset + 12);
    }
  }

  List<String> _getSegmentLabels(int segmentIndex) {
    if (_totalSegments == 1) return _weeklyLabels;
    if (_remainder > 0) {
      if (segmentIndex == 0) {
        return _weeklyLabels.sublist(0, _remainder);
      } else {
        final offset = _remainder + (segmentIndex - 1) * 12;
        return _weeklyLabels.sublist(offset, offset + 12);
      }
    } else {
      final offset = segmentIndex * 12;
      return _weeklyLabels.sublist(offset, offset + 12);
    }
  }

  // Current segment data
  List<double> get _currentSegmentValues => _getSegmentValues(_currentSegment);
  List<List<String>> get _currentSegmentColorNames =>
      _getSegmentColorNames(_currentSegment);
  List<bool> get _currentSegmentIsNull => _getSegmentIsNull(_currentSegment);
  List<String> get _currentSegmentLabels => _getSegmentLabels(_currentSegment);

  /// Build stacked rods from bottom→top in a fixed colorPriority.
  List<Color> _buildOrderedColors(
      double missingCount, List<String> colorNames) {
    final int needed = missingCount.floor();
    final Set<String> provided =
        colorNames.map((e) => e.toLowerCase().trim()).toSet();

    final List<Color> finalColors = [];
    for (final c in colorPriority) {
      if (provided.contains(c)) {
        finalColors.add(parseNamedColor(c));
      }
      if (finalColors.length == needed) break;
    }
    while (finalColors.length < needed) {
      finalColors.add(Colors.grey);
    }
    return finalColors;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final segValues = _currentSegmentValues;
    final segColorNames = _currentSegmentColorNames;
    final segIsNull = _currentSegmentIsNull;

    final List<BarChartGroupData> groups = [];

    for (int i = 0; i < segValues.length; i++) {
      final double missingCount = segValues[i];
      final bool isNull = segIsNull[i];
      final List<String> colorNames = segColorNames[i];

      if (isNull) {
        // short bar => circle in dark grey
        groups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: 0.25,
                width: 12,
                color: Colors.grey[800] ?? Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        );
      } else if (missingCount == 0) {
        // short bar => circle in blue
        groups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: 0.25,
                width: 12,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        );
      } else {
        // missing_count > 0 => stacked rods
        final List<BarChartRodStackItem> stackItems = [];
        double lower = 0;
        final List<Color> ordered =
            _buildOrderedColors(missingCount, colorNames);
        for (final c in ordered) {
          final double upper = lower + 1;
          stackItems.add(BarChartRodStackItem(lower, upper, c));
          lower = upper;
        }

        groups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: missingCount,
                rodStackItems: stackItems,
                width: 16,
                color: Colors.transparent,
              ),
            ],
          ),
        );
      }
    }

    return Column(
      children: [
        // Display the chart title if any
        if (_displayName.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _displayName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        SizedBox(
          height: 300,
          width: widget.width ?? MediaQuery.of(context).size.width,
          child: BarChart(
            BarChartData(
              barGroups: groups,
              // We keep maxY=8 so bars can rise to 8, but we'll hide the "8" label
              minY: 0,
              maxY: 8,
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      // Hide label if it's exactly 8
                      final int val = value.toInt();
                      if (val == 8) {
                        return const SizedBox();
                      }
                      return Text(
                        val.toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= _currentSegmentLabels.length) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Transform.rotate(
                          angle: -0.7854,
                          child: Text(
                            _currentSegmentLabels[index],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.white,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final double mc = segValues[groupIndex];
                    final bool isNull = segIsNull[groupIndex];

                    // Tooltips logic
                    if (isNull) {
                      return BarTooltipItem(
                        'Missing data',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    if (mc == 0) {
                      return BarTooltipItem(
                        'Bravo!',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    final double val = rod.toY - rod.fromY;
                    return BarTooltipItem(
                      'Colors missed: ${val.toStringAsFixed(0)}',
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        // Navigation row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentSegment > 0
                  ? () => setState(() => _currentSegment--)
                  : null,
            ),
            Text(
              _currentSegmentLabels.isNotEmpty
                  ? '${_currentSegmentLabels.first} - ${_currentSegmentLabels.last}'
                  : '',
              style: const TextStyle(fontSize: 12),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _currentSegment < _totalSegments - 1
                  ? () => setState(() => _currentSegment++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
