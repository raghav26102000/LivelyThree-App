// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:the_lively_three/auth/supabase_auth/auth_util.dart';
import 'package:the_lively_three/custom_code/widgets/weekly_item_card.dart';
import 'package:the_lively_three/index.dart';
import 'package:the_lively_three/utils/consumption_service.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'portion_size_modifier_model.dart';
export 'portion_size_modifier_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/l10n/app_localizations.dart';
import '/providers/locale_provider.dart' as locale_provider;
import 'package:intl/intl.dart';

class PortionSizeModifierWidget extends StatefulWidget {
  final int plantId;
  final String? userId;
  final int? blueprintId;
  final Color primaryColor;
  final String? uom;
  final String? colorTag;
  final int? dietarySource;

  const PortionSizeModifierWidget({
    Key? key,
    required this.plantId,
    this.userId,
    this.blueprintId,
    required this.primaryColor,
    this.uom,
    this.colorTag,
    this.dietarySource,
  }) : super(key: key);

  @override
  State<PortionSizeModifierWidget> createState() =>
      _PortionSizeModifierWidgetState();
}

class _PortionSizeModifierWidgetState extends State<PortionSizeModifierWidget> {
  late PortionSizeModifierModel _model;
  final supabase = Supabase.instance.client;
  final _consumptionService = ConsumptionService();

  Locale? currentLocale;
  bool _loading = true;
  String? _loadError;
  String plantName = 'Loading...';
  int totalConsumption = 0;
  Map<int, int> dailyConsumption = {};
  Map<int, int> dailyConsumptionPreviousWeek = {};
  bool _hasInitialized = false;
  int colorCode = 0;
  double portionsize = 0.0;
  int currentDayOfWeek = DateTime.now().weekday;
  String? plantColorTag;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PortionSizeModifierModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized && mounted) {
      try {
        final appState = context.read<locale_provider.FFAppState>();
        currentLocale = appState.locale ?? const Locale('en');

        _hasInitialized = true;

        Future.microtask(() async {
          if (!mounted) return;

          await _fetchPlantConsumption(widget.plantId);

          if (!mounted) return;

          if (currentDayOfWeek == 1) {
            await _fetchPreviousWeekPlantConsumption(widget.plantId);
          }

          if (!mounted) return;

          if (widget.blueprintId != null) {
            await _fetchPlantName(widget.blueprintId!);
          } else if (mounted) {
            setState(() {
              plantName = 'Unknown Plant';
            });
          }
          if (mounted) {
            setState(() {
              _loading = false;
            });
          }
        });
      } catch (e) {
        print('Error in didChangeDependencies: $e');
        if (mounted) {
          setState(() {
            _loadError = e.toString();
            _loading = false;
            plantName = 'Unknown Plant';
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // Add this helper method to your class
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return null;
  }

  Future<void> _fetchPlantConsumption(int plantId) async {
    if (!mounted) return;
    try {
      final data = await supabase
          .from('dailyuserconsumption')
          .select('*')
          .eq('localized_plant_id', plantId)
          .eq('user_id', widget.userId ?? currentUserUid)
          .eq('calender_week', FFAppState().calendarWeek)
          .eq('calender_year', FFAppState().calendarYear);

      if (!mounted) return;

      Map<int, int> tempDaily = {for (var i = 1; i <= 7; i++) i: 0};
      double totalConsumptionSum = 0.0;

      for (var item in data) {
        // ✅ Use the helper method
        final int? maybeDay = _toInt(item['day_number']);
        final int? maybePortion = _toInt(item['portion_size']);
        final int? maybeQuantity = _toInt(item['quantity']);

        if (maybeDay != null &&
            maybePortion != null &&
            maybeQuantity != null &&
            maybeDay >= 1 &&
            maybeDay <= 7) {
          double portionConsumed = (maybePortion * maybeQuantity).toDouble();
          tempDaily[maybeDay] = tempDaily[maybeDay]! + portionConsumed.toInt();
          totalConsumptionSum += portionConsumed;
        }
      }

      int total = totalConsumptionSum.toInt();

      if (mounted) {
        setState(() {
          dailyConsumption = tempDaily;
          totalConsumption = total;
          _loading = false;
          _loadError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _fetchPreviousWeekPlantConsumption(int plantId) async {
    try {
      int previousWeek = FFAppState().calendarWeek - 1;
      int previousYear = FFAppState().calendarYear;

      if (previousWeek <= 0) {
        previousYear = FFAppState().calendarYear - 1;
        previousWeek = 52;
      }

      final data = await supabase
          .from('dailyuserconsumption')
          .select('*')
          .eq('localized_plant_id', plantId)
          .eq('user_id', widget.userId ?? currentUserUid)
          .eq('calender_week', previousWeek)
          .eq('calender_year', previousYear);

      if (!mounted) return;

      Map<int, int> tempDaily = {for (var i = 1; i <= 7; i++) i: 0};

      for (var item in data) {
        final int? maybeDay = _toInt(item['day_number']);
        final int? maybePortion = _toInt(item['portion_size']);
        final int? maybeQuantity = _toInt(item['quantity']);

        if (maybeDay != null &&
            maybePortion != null &&
            maybeQuantity != null &&
            maybeDay >= 1 &&
            maybeDay <= 7) {
          double portionConsumed = (maybePortion * maybeQuantity).toDouble();
          tempDaily[maybeDay] = tempDaily[maybeDay]! + portionConsumed.toInt();
        }
      }

      if (mounted) {
        setState(() {
          dailyConsumptionPreviousWeek = tempDaily;
        });
      }
    } catch (e) {
      print('Error fetching previous week data: $e');
    }
  }

  Future<void> _fetchPlantName(int blueprintId) async {
    try {
      final result = await supabase
          .from('blueprintfooditem')
          .select('name, color_keycode, portionsize') // ✅ Add color_tag
          .eq('id', blueprintId)
          .maybeSingle();

      if (!mounted) return;

      print('251 plant color code: $result');

      final String? nameFetched = result?['name'] as String?;
      final int? colorKeyCode = result?['color_keycode'] as int?;
      final dynamic portionSizeFromDB = result?['portionsize'];
      // final int? colorTag =
      //     result?['color_keycode'] as int?; // ✅ Get color_tag
      if (mounted) {
        setState(() {
          plantName = nameFetched ?? 'Unknown Plant';
          colorCode = colorKeyCode ?? 0;
          portionsize = (portionSizeFromDB is int)
              ? portionSizeFromDB.toDouble()
              : (portionSizeFromDB as double?) ?? 0.0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          plantName = 'Unknown Plant';
          colorCode = 0;
          portionsize = 0.0;
          plantColorTag = null; // ✅ Set to null on error
        });
      }
    }
  }

  int getPortionForDay(int dayNumber) {
    return dailyConsumption[dayNumber] ?? 0;
  }

  int getPortionForPreviousWeek(int dayNumber) {
    return dailyConsumptionPreviousWeek[dayNumber] ?? 0;
  }

  int getTotalConsumption() {
    return totalConsumption;
  }

  String _getDayName(int dayNum) {
    switch (dayNum) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  // NEW: Helper to get date for a specific day in the current week
  DateTime _getDateForDayInWeek(int dayNumber) {
    final int calendarWeek = FFAppState().calendarWeek;
    final int calendarYear = FFAppState().calendarYear;

    // ISO week calculation
    final jan4 = DateTime(calendarYear, 1, 4);
    final jan4Weekday = jan4.weekday;
    final week1Monday = jan4.subtract(Duration(days: jan4Weekday - 1));
    final targetDate = week1Monday
        .add(Duration(days: (calendarWeek - 1) * 7 + (dayNumber - 1)));

    return targetDate;
  }

  // NEW: Helper to get date for previous week's day
  DateTime _getDateForPreviousWeekDay(int dayNumber) {
    int previousWeek = FFAppState().calendarWeek - 1;
    int previousYear = FFAppState().calendarYear;

    if (previousWeek <= 0) {
      previousYear = FFAppState().calendarYear - 1;
      previousWeek = 52;
    }

    final jan4 = DateTime(previousYear, 1, 4);
    final jan4Weekday = jan4.weekday;
    final week1Monday = jan4.subtract(Duration(days: jan4Weekday - 1));
    final targetDate = week1Monday
        .add(Duration(days: (previousWeek - 1) * 7 + (dayNumber - 1)));

    return targetDate;
  }

  // NEW: Format date as "DAYNAME - DD MMM"
  String _formatDayTitle(String dayName, DateTime date) {
    final dayUpper = dayName.toUpperCase();
    final formattedDate = DateFormat('dd MMM').format(date).toUpperCase();
    return '$dayUpper - $formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 1.0,
        decoration: const BoxDecoration(
          color: Color(0x37000000),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 1.0,
        decoration: const BoxDecoration(
          color: Color(0x37000000),
        ),
        child: Center(child: Text('Error: $_loadError')),
      );
    }

    int todayConsumption = getPortionForDay(currentDayOfWeek);

    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * 1.0,
      decoration: BoxDecoration(
        color: Color(0x37000000),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.9,
            ),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
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
                            if (!mounted) return;
                            try {
                              Navigator.of(context).pop();
                            } catch (e) {
                              print('Navigation error: $e');
                            }
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Color.fromRGBO(129, 129, 129, 1),
                            size: 24.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 24.0, 0.0),
                            child: Text(
                              plantName,
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: FlutterFlowTheme.adjustScale(
                                        size: 18.0),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
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

                // Total Consumption Section
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16.0, 0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Consumption: ${getTotalConsumption()}g',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize:
                                  FlutterFlowTheme.adjustScale(size: 18.0),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Today: ${todayConsumption}g',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize:
                                  FlutterFlowTheme.adjustScale(size: 12.0),
                              letterSpacing: 0.0,
                              lineHeight: 1.75,
                            ),
                      ),
                    ],
                  ),
                ),

                // Days List
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: buildDayRows(),
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

  List<Widget> buildDayRows() {
    List<Widget> rows = [];

    // Add previous week Sunday if it's Monday
    if (currentDayOfWeek == 1) {
      int previousSundayConsumption = getPortionForPreviousWeek(7);
      DateTime previousSundayDate = _getDateForPreviousWeekDay(7);
      String formattedTitle =
          _formatDayTitle('Sunday (Previous Week)', previousSundayDate);

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          child: WeeklyItemCard(
            key: ValueKey('row_Sunday_Previous_Week'),
            primaryColor: widget.primaryColor,
            colorTag: widget.colorTag,
            title: formattedTitle,
            weeklyTotal: previousSundayConsumption,
            portionSize: previousSundayConsumption,
            plantId: widget.plantId,
            uom: widget.uom ?? 'g',
            userId: widget.userId ?? currentUserUid,
            weekdayNumber: 7,
            week: FFAppState().calendarWeek - 1,
            year: FFAppState().calendarYear,
            blueprintId: widget.blueprintId ?? 0,
            dietarySource: widget.dietarySource!,
            canModify: true,
            categoryIcon: '',
            actionIcon: 'delete',
            showIcon: false,
            boldTitle: false,
            hideAddIcon: widget.dietarySource! <= 0,
            modifierIcon: Icons.check,
            calledFrom: 'Portion_Modifier',
            originalConsumption: previousSundayConsumption,
            isModificationMode: true,
            onConsumptionModified: () {
              _fetchPreviousWeekPlantConsumption(widget.plantId);
              _fetchPlantConsumption(widget.plantId);
            },
          ),
        ),
      );
      rows.add(
        Container(
          height: 1,
          color: Color(0xffececec),
          margin: const EdgeInsets.symmetric(horizontal: 12),
        ),
      );
    }

    // Add all days of current week
    for (int dayNum = 1; dayNum <= 7; dayNum++) {
      String dayName = _getDayName(dayNum);
      int consumption = getPortionForDay(dayNum);
      DateTime dayDate = _getDateForDayInWeek(dayNum);
      String formattedTitle = _formatDayTitle(dayName, dayDate);

      rows.add(
        Padding(
          // 👈 ADD THIS
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),

          child: WeeklyItemCard(
            key: ValueKey('row_$dayName'),
            primaryColor: widget.primaryColor,
            colorTag: widget.colorTag,
            title: formattedTitle,
            weeklyTotal: consumption,
            portionSize: consumption,
            plantId: widget.plantId,
            uom: widget.uom ?? 'g',
            userId: widget.userId ?? currentUserUid,
            weekdayNumber: dayNum,
            week: FFAppState().calendarWeek,
            year: FFAppState().calendarYear,
            blueprintId: widget.blueprintId ?? 0,
            dietarySource: widget.dietarySource!,
            canModify: dayNum <= currentDayOfWeek,
            categoryIcon: '',
            actionIcon: 'delete',
            showIcon: false,
            boldTitle: dayNum == currentDayOfWeek,
            hideAddIcon: widget.dietarySource! <= 0,
            modifierIcon: Icons.check,
            calledFrom: 'Portion_Modifier',
            originalConsumption: consumption,
            isModificationMode: true,
            onConsumptionModified: () {
              _fetchPlantConsumption(widget.plantId);
            },
          ),
        ),
      );

      if (dayNum < 7) {
        rows.add(
          Container(
            height: 1,
            color: Color(0xffececec),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
        );
      }
    }

    return rows;
  }
}
