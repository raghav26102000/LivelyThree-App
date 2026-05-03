// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:the_lively_three/components/consumption_card/consumption_card_widget.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart';
import 'package:the_lively_three/custom_code/widgets/f_f_wheel_picker.dart'
    as custom_widgets;
import 'package:the_lively_three/models/plant_consumption_row.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'your_consumption_model.dart';
export 'your_consumption_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/l10n/app_localizations.dart';

class YourConsumptionWidget extends StatefulWidget {
  const YourConsumptionWidget({super.key});

  @override
  State<YourConsumptionWidget> createState() => _YourConsumptionWidgetState();
}

class _YourConsumptionWidgetState extends State<YourConsumptionWidget> {
  late YourConsumptionModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlantConsumptionRow> _weekRows = [];
  bool _loading = false;
  String? _error;
  late List<PlantConsumptionRow> consumptionTodaySorted = [];
  late List<PlantConsumptionRow> consumptionSourceAnimal = [];
  late List<PlantConsumptionRow> consumptionSourceWater = [];
  late List<PlantConsumptionRow> consumptionSourceUPF = [];
  late List<PlantConsumptionRow> consumptionInThirdRule = [];
  late List<PlantConsumptionRow> weekConsumption = [];
  late DateTime _selectedDate;
  late DateTime _today;
  int mlPerGlass = 500;
  int gramsPerUnit = 200;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => YourConsumptionModel());
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = DateTime(now.year, now.month, now.day);
    _fetchWeeklyConsumption();
    fetchlookupValues();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Color colorFromTag(String? tag) {
    switch ((tag ?? '').toLowerCase()) {
      case 'red':
        return const Color(0xFFE53935);
      case 'orange':
        return const Color(0xFFF57C00);
      case 'yellow':
        return const Color(0xFFFBC02D);
      case 'green':
        return const Color(0xFF43A047);
      case 'purple':
        return const Color(0xFF8E24AA);
      case 'brown':
        return const Color(0xFF795548);
      case 'white':
        return const Color(0xFFBDBDBD);
      case 'grey':
      case 'gray':
        return const Color(0xFF9E9E9E);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Future<void> _fetchWeeklyConsumption() async {
    try {
      final client = Supabase.instance.client;
      final int calendarWeek = FFAppState().calendarWeek;
      final int calendarYear = FFAppState().calendarYear;

      final result = await client
          .from('vw_daily_plant_summary')
          .select('user_id, '
              'week, '
              'calendaryear, '
              'plantname, '
              'color, '
              'daynumber, '
              'portionsum, '
              'dateday, '
              'datemonth, '
              'uom, '
              'dietary_source,'
              'portionstaken,'
              'inthirdrule')
          .eq('calendaryear', calendarYear)
          .eq('week', calendarWeek)
          .eq('user_id', currentUserUid);

      final rows = result
          .map((e) => PlantConsumptionRow.fromMap(e))
          .where((row) =>
              (row.portionstaken ?? 0) >
                  0 && // Filter out negative/zero quantities
              (row.portionPlant ?? 0) > 0) // Filter out negative/zero portions
          .toList();

      print('mapped rows: ${rows.map((r) => r.toJson()).toList()}');

      // Check if showing weekly total or daily
      final isWeeklyView = FFAppState().currentDayNumber == 0;

      List<PlantConsumptionRow> filteredRows;
      if (isWeeklyView) {
        // Show all rows for the week
        filteredRows = rows;
      } else {
        // Show only selected day
        filteredRows = rows
            .where((e) => (e.dayNumber) == FFAppState().currentDayNumber)
            .toList();
      }

      // Sort by color
      const order = [
        'Red',
        'Orange',
        'Yellow',
        'Green',
        'Purple',
        'Brown',
        'White'
      ];
      final colorOrdered = order
          .expand((c) => filteredRows.where((e) => (e.color ?? '') == c))
          .toList();

      final consumptionSource2 =
          filteredRows.where((e) => e.dietary_source == 2).toList();
      final consumptionSource3 =
          filteredRows.where((e) => e.dietary_source == 3).toList();
      final consumptionSource4 =
          filteredRows.where((e) => e.dietary_source == 4).toList();

      // Filter items where inthirdrule is true and dietary_source is 1
      final consumptionThirdRule = filteredRows
          .where((e) => e.inthirdrule == true && e.dietary_source == 1)
          .toList();

      setState(() {
        _weekRows = rows;
        consumptionTodaySorted = colorOrdered;
        consumptionSourceAnimal = consumptionSource2;
        consumptionSourceWater = consumptionSource4;
        consumptionSourceUPF = consumptionSource3;
        consumptionInThirdRule = consumptionThirdRule;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print('fetch error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // Helper method to aggregate plants by name
  List<PlantConsumptionRow> _aggregatePlantsByName(
      List<PlantConsumptionRow> rows) {
    final Map<String, PlantConsumptionRow> aggregated = {};

    for (final row in rows) {
      final key = row.plantname;
      if (aggregated.containsKey(key)) {
        final existing = aggregated[key]!;
        aggregated[key] = existing.copyWith(
          portionPlant: existing.portionPlant + row.portionPlant,
          portionstaken: existing.portionstaken + row.portionstaken,
        );
      } else {
        aggregated[key] = row;
      }
    }

    return aggregated.values.toList();
  }

  double calculateTotalPortions(
    List<PlantConsumptionRow> data, {
    int? dietarySource,
  }) {
    double total = 0.0;
    for (final row in data) {
      if (row.dietary_source == dietarySource) {
        total += (row.portionPlant ?? 0.0);
      }
    }
    return total;
  }

  int calculateTotalQuantity(
    List<PlantConsumptionRow> data, {
    int? dietarySource,
  }) {
    int totalQuantity = 0;
    for (final row in data) {
      if (row.dietary_source == dietarySource) {
        totalQuantity += (row.portionstaken ?? 0);
      }
    }
    return totalQuantity;
  }

  (int week, int year) get _selectedIsoWeekYear {
    final d = _selectedDate;
    final thursday = d.add(Duration(days: 3 - ((d.weekday + 6) % 7)));
    final isoYear = thursday.year;
    final firstThursday = DateTime(isoYear, 1, 4);
    final firstWeekStart =
        firstThursday.subtract(Duration(days: (firstThursday.weekday + 6) % 7));
    final week = 1 + ((thursday.difference(firstWeekStart).inDays) ~/ 7);
    return (week, isoYear);
  }

  Future<String?> fetchCodeLookupValues(String lookupCode) async {
    try {
      final response = await Supabase.instance.client
          .from('codelkup')
          .select('key1')
          .eq('lkcode', lookupCode)
          .eq('status', 1) // Filter by active status
          .order('keycode', ascending: true)
          .limit(1) // Get only the first result
          .maybeSingle(); // Returns a single row or null

      if (response != null) {
        return response['key1'] as String?;
      } else {
        print("⚠️ No data returned for $lookupCode");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching codelookup values: $e");
      return null;
    }
  }

  void fetchlookupValues() async {
    final mlPerGlassStr = await fetchCodeLookupValues('glass_size');
    final gramsPerUnitStr = await fetchCodeLookupValues('upf');

    setState(() {
      mlPerGlass = int.tryParse(mlPerGlassStr ?? '500') ?? 500;
      gramsPerUnit = int.tryParse(gramsPerUnitStr ?? '200') ?? 200;
    });

    print("upfsize: $gramsPerUnit $mlPerGlass");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .primaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    final locale = AppLocalizations.of(context)!;
    context.watch<FFAppState>();
    final (isoWeek, isoYear) = _selectedIsoWeekYear;
    final isWeeklyView = FFAppState().currentDayNumber == 0;

    return Scaffold(
        key: scaffoldKey,
        // resizeToAvoidBottomInset: true,
        // extendBody: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                Text(
                  locale.yourConsumption,
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: FlutterFlowTheme.adjustScale(size: 18.0),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
                Text(
                  'Week $isoWeek',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: FlutterFlowTheme.adjustScale(size: 12.0),
                        letterSpacing: 0.0,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ]),
          backgroundColor: const Color(0xffffffff),
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.09),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 9,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    spacing: 16,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 24,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 0.0,
                          ),
                        ),
                        padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 20),
                        child: Column(
                          spacing: 20,
                          children: [
                            buildWeekHeader(context),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Your plant icon
                                SizedBox(
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 6,
                                    children: [
                                      Image.asset(
                                        "assets/images/plant_product.png",
                                        width: 26,
                                        height: 27,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 12.0),
                                                fontWeight: FontWeight.w400,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${calculateTotalPortions(consumptionTodaySorted, dietarySource: 1).toStringAsFixed(0)} g',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    fontSize: FlutterFlowTheme
                                                        .adjustScale(
                                                            size: 12.0),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color(0xffe7e7e7),
                                  width: 1,
                                  height: 50,
                                ),
                                // Animal products icon
                                SizedBox(
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 6,
                                    children: [
                                      Image.asset(
                                        "assets/images/animal_product.png",
                                        width: 28,
                                        height: 28,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 12.0),
                                                fontWeight: FontWeight.w400,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${calculateTotalPortions(consumptionSourceAnimal, dietarySource: 2).toStringAsFixed(0)} g',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    fontSize: FlutterFlowTheme
                                                        .adjustScale(
                                                            size: 12.0),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color(0xffe7e7e7),
                                  width: 1,
                                  height: 50,
                                ),
                                // UPF icon
                                SizedBox(
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 6,
                                    children: [
                                      Image.asset(
                                        "assets/images/ultra_processed_food.png",
                                        width: 26,
                                        height: 26,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 12.0),
                                                fontWeight: FontWeight.w400,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${calculateTotalPortions(consumptionSourceUPF, dietarySource: 3).toStringAsFixed(0)} g',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    fontSize: FlutterFlowTheme
                                                        .adjustScale(
                                                            size: 12.0),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Color(0xffe7e7e7),
                                  width: 1,
                                  height: 50,
                                ),
                                // Water icon
                                SizedBox(
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 6,
                                    children: [
                                      Image.asset(
                                        "assets/images/water.png",
                                        width: 26,
                                        height: 26,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 12.0),
                                                fontWeight: FontWeight.w400,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${calculateTotalPortions(consumptionSourceWater, dietarySource: 4).toStringAsFixed(0)} ml',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    fontSize: FlutterFlowTheme
                                                        .adjustScale(
                                                            size: 12.0),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // All your ConsumptionCard widgets go here...
                      ConsumptionCard(
                        hasFixedHeight: false,
                        dateText:
                            '${locale.healthScorePortions}: ${calculateTotalPortions(consumptionInThirdRule, dietarySource: 1).toStringAsFixed(0)} g ',
                        totalPortion:
                            '${calculateTotalPortions(consumptionInThirdRule, dietarySource: 1).toStringAsFixed(0)} g',
                        onPrev: () => print("Prev clicked"),
                        onNext: () => print("Next clicked"),
                        showDateChangeIcon: false,
                        children: [
                          ...(() {
                            if (isWeeklyView) {
                              return _aggregatePlantsByName(
                                      consumptionTodaySorted)
                                  .map((r) => buildConsumptionTextChip(
                                        r.plantname,
                                        r.portionPlant.round(),
                                        r.uom,
                                        colorFromTag(r.color),
                                      ))
                                  .toList();
                            }
                            return consumptionTodaySorted
                                .map((r) => buildConsumptionTextChip(
                                      r.plantname,
                                      r.portionPlant.round(),
                                      r.uom,
                                      colorFromTag(r.color),
                                    ))
                                .toList();
                          })(),
                        ],
                        showTotalPortion: false,
                      ),

                      ConsumptionCard(
                        hasFixedHeight: false,
                        dateText:
                            '${locale.totalAnimalProducts}: ${calculateTotalPortions(consumptionSourceAnimal, dietarySource: 2).toStringAsFixed(0)} g',
                        totalPortion: calculateTotalPortions(
                                consumptionSourceAnimal,
                                dietarySource: 2)
                            .toStringAsFixed(0),
                        onPrev: () => print("Prev clicked"),
                        onNext: () => print("Next clicked"),
                        showDateChangeIcon: false,
                        children: [
                          ...(() {
                            if (isWeeklyView) {
                              return _aggregatePlantsByName(
                                      consumptionSourceAnimal)
                                  .map((r) => buildConsumptionTextChip(
                                        r.plantname,
                                        r.portionPlant.round(),
                                        r.uom,
                                        colorFromTag(r.color),
                                      ))
                                  .toList();
                            }
                            return consumptionSourceAnimal
                                .map((r) => buildConsumptionTextChip(
                                      r.plantname,
                                      r.portionPlant.round(),
                                      r.uom,
                                      colorFromTag(r.color),
                                    ))
                                .toList();
                          })(),
                        ],
                        showTotalPortion: false,
                      ),

                      // Water consumption card
                      (() {
                        final todaysWater = isWeeklyView
                            ? consumptionSourceWater
                            : consumptionSourceWater
                                .where((e) =>
                                    (e.dayNumber ?? 0) ==
                                    FFAppState().currentDayNumber)
                                .toList();

                        final int totalMl = todaysWater.fold<int>(
                            0, (sum, r) => sum + r.portionPlant.round());
                        final double liters = totalMl / 1000.0;
                        final quantity = calculateTotalQuantity(todaysWater,
                            dietarySource: 4);
                        final int fullGlasses = totalMl ~/ mlPerGlass;
                        final int remainderMl = totalMl % mlPerGlass;
                        double partialFill = 0.0;
                        if (remainderMl > 0) {
                          partialFill = remainderMl / mlPerGlass;
                        }
                        final int totalGlasses =
                            fullGlasses + (remainderMl > 0 ? 1 : 0);
                        final int displaySlots =
                            totalGlasses > 8 ? totalGlasses : 8;

                        return ConsumptionCard(
                          dateText:
                              '${locale.waterConsumption}: ${liters.toStringAsFixed(2)} L (Qty: $quantity) ',
                          totalPortion:
                              '${liters.toStringAsFixed(2)} L (Qty: $quantity)',
                          showDateChangeIcon: false,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width - 24,
                              height: FlutterFlowTheme.adjustScale(size: 61),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 6,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 4,
                                      children:
                                          List.generate(displaySlots, (i) {
                                        if (i < fullGlasses) {
                                          return Image.asset(
                                            'assets/images/water_filled.png',
                                            width: 40,
                                            height: 40,
                                          );
                                        } else if (i == fullGlasses &&
                                            remainderMl > 0) {
                                          return buildPartialGlass(partialFill);
                                        } else {
                                          return Image.asset(
                                            'assets/images/water_consumption_empty.png',
                                            width: 40,
                                            height: 40,
                                          );
                                        }
                                      }),
                                    ),
                                  ),
                                  Text(
                                    '${locale.waterLabel} ${mlPerGlass} ml',
                                    style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          showTotalPortion: false,
                        );
                      })(),

                      // UPF consumption card
                      (() {
                        final todaysUpf = isWeeklyView
                            ? consumptionSourceUPF
                            : consumptionSourceUPF
                                .where((e) =>
                                    (e.dayNumber ?? 0) ==
                                    FFAppState().currentDayNumber)
                                .toList();

                        final int totalGrams = todaysUpf.fold<int>(
                            0, (sum, r) => sum + r.portionPlant.round());
                        final quantity =
                            calculateTotalQuantity(todaysUpf, dietarySource: 3);
                        final int fullUnits = totalGrams ~/ gramsPerUnit;
                        final int remainderGrams = totalGrams % gramsPerUnit;
                        double partialFill = 0.0;
                        if (remainderGrams > 0) {
                          partialFill = remainderGrams / gramsPerUnit;
                        }
                        final int totalUnits =
                            fullUnits + (remainderGrams > 0 ? 1 : 0);
                        final int displaySlots =
                            totalUnits > 8 ? totalUnits : 8;

                        return ConsumptionCard(
                          dateText:
                              '${locale.ultraProcessedFoods}: ${totalGrams}g (Qty: $quantity)',
                          totalPortion: '${totalGrams}g (Qty: $quantity)',
                          showDateChangeIcon: false,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width - 24,
                              height: FlutterFlowTheme.adjustScale(size: 61),
                              child: Column(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 4,
                                      children:
                                          List.generate(displaySlots, (i) {
                                        if (i < fullUnits) {
                                          return Image.asset(
                                            'assets/images/ultra_processed_food.png',
                                            width: 40,
                                            height: 40,
                                          );
                                        } else if (i == fullUnits &&
                                            remainderGrams > 0) {
                                          return buildPartialUpf(partialFill);
                                        } else {
                                          return Image.asset(
                                            'assets/images/upf_outlined.png',
                                            width: 40,
                                            height: 40,
                                          );
                                        }
                                      }),
                                    ),
                                  ),
                                  Text(
                                    '${locale.upfLabel} ${gramsPerUnit}g',
                                    style: TextStyle(
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                          showTotalPortion: false,
                        );
                      })(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // === Week header helpers ===
  DateTime _isoWeekStart(int isoYear, int isoWeek) {
    final jan4 = DateTime(isoYear, 1, 4);
    final mondayWeek1 = jan4.subtract(Duration(days: jan4.weekday - 1));
    return mondayWeek1.add(Duration(days: (isoWeek - 1) * 7));
  }

  String _twoLetterDow(DateTime d) {
    final e = DateFormat('E').format(d);
    return e.substring(0, 2);
  }

  Widget buildWeekHeader(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isoWeek = FFAppState().calendarWeek;
    final isoYear = FFAppState().calendarYear;
    final monday = _isoWeekStart(isoYear, isoWeek);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final selectedDayString = FFAppState().currentDay;
    final isWeeklyView = FFAppState().currentDayNumber == 0;
    DateTime? selectedDay;

    if (selectedDayString.isNotEmpty) {
      try {
        if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(selectedDayString)) {
          selectedDay = DateTime.parse(selectedDayString);
          selectedDay =
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
        } else {
          FFAppState().currentDay = DateFormat('yyyy-MM-dd').format(today);
          selectedDay = today;
        }
      } catch (_) {
        FFAppState().currentDay = DateFormat('yyyy-MM-dd').format(today);
        selectedDay = today;
      }
    }

    // Weekly Total pill
    Widget weeklyTotalPill = InkWell(
      onTap: () {
        FFAppState().currentDay = '';
        FFAppState().currentDayNumber = 0;
        _fetchWeeklyConsumption();

        if (mounted) setState(() {});
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: FFAppState().currentDay.isEmpty ? 54 : 50,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: FFAppState().currentDay.isEmpty
                ? Border.all(
                    color: const Color.fromRGBO(255, 95, 41, 1),
                    width: 2,
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: locale.weekTotal,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          )),
    );

    // Daily pills
    List<Widget> pills = List.generate(7, (i) {
      final d = monday.add(Duration(days: i));
      final dateOnly = DateTime(d.year, d.month, d.day);

      final isToday = dateOnly == today;
      final isFuture = dateOnly.isAfter(today);
      final isSelected = selectedDay != null && dateOnly == selectedDay;

      final primary = FlutterFlowTheme.of(context).primary;
      final textGrey = FlutterFlowTheme.of(context).textGrey;
      final bg = FlutterFlowTheme.of(context).secondaryBackground;

      final dow = _twoLetterDow(d);
      final dateLine = isToday
          ? locale.today
          : '${d.day} ${DateFormat('MMM').format(d).toUpperCase()}';

      return InkWell(
        onTap: () {
          if (isFuture) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.cannotSelectFutureDate),
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          int dayOfWeek = d.weekday;
          FFAppState().currentDayNumber = dayOfWeek;
          FFAppState().currentDay = DateFormat('yyyy-MM-dd').format(d);
          _fetchWeeklyConsumption();

          if (mounted) setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white, //isToday ? Colors.white : bg,
            borderRadius: BorderRadius.circular(12.0),
            border: isSelected
                ? Border.all(
                    color: const Color.fromRGBO(255, 95, 41, 1), width: 2)
                : (isToday && selectedDay == null && !isWeeklyView
                    ? Border.all(
                        color: const Color.fromRGBO(255, 95, 41, 1), width: 1.5)
                    : null),
          ),
          child: isFuture
              ? Opacity(
                  opacity: 0.5,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '$dow\n',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            color: textGrey.withOpacity(0.6),
                            fontSize: FlutterFlowTheme.adjustScale(size: 18.0),
                            fontWeight: FontWeight.w500,
                          ),
                      children: [
                        TextSpan(
                          text: dateLine,
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                color: textGrey.withOpacity(0.6),
                                fontSize: FlutterFlowTheme.adjustScale(size: 8),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: '$dow\n',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          color: isToday ? primary : textGrey,
                          fontSize: FlutterFlowTheme.adjustScale(size: 18.0),
                          fontWeight: FontWeight.w500,
                        ),
                    children: [
                      TextSpan(
                        text: dateLine,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              color: isToday ? primary : textGrey,
                              fontSize: FlutterFlowTheme.adjustScale(size: 8),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 6,
        children: [weeklyTotalPill, ...pills],
      ),
    );
  }

  Widget buildConsumptionTextChip(
      String name, int value, String? unit, Color dotColor) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 3, // Add spacing between items
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        // Remove Flexible wrapper - just use Text directly
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          "$value${unit ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Add this method inside _YourConsumptionWidgetState class
  Widget buildPartialGlass(double fillLevel) {
    // Determine which quarter of fill
    String assetPath;

    if (fillLevel >= 0.875) {
      // 87.5% or more - show full
      assetPath = 'assets/images/water_filled.png';
    } else if (fillLevel >= 0.625) {
      // 62.5% to 87.5% - show 3/4 filled
      assetPath = 'assets/images/water_consumption_75.png';
    } else if (fillLevel >= 0.375) {
      // 37.5% to 62.5% - show half filled
      assetPath = 'assets/images/water_consumption_50.png';
    } else if (fillLevel >= 0.125) {
      // 12.5% to 37.5% - show quarter filled
      assetPath = 'assets/images/water_consumption_25.png';
    } else {
      // Less than 12.5% - show empty
      assetPath = 'assets/images/water_consumption_empty.png';
    }

    return Image.asset(
      assetPath,
      width: 40,
      height: 40,
    );
  }

// Add this method inside _YourConsumptionWidgetState class
  Widget buildPartialUpf(double fillLevel) {
    String assetPath;

    if (fillLevel >= 0.875) {
      // 87.5% or more - show full
      assetPath = 'assets/images/upf.png';
    } else if (fillLevel >= 0.625) {
      // 62.5% to 87.5% - show 3/4 filled
      assetPath = 'assets/images/upf_75.png';
    } else if (fillLevel >= 0.375) {
      // 37.5% to 62.5% - show half filled
      assetPath = 'assets/images/upf_50.png';
    } else if (fillLevel >= 0.125) {
      // 12.5% to 37.5% - show quarter filled
      assetPath = 'assets/images/upf_25.png';
    } else {
      // Less than 12.5% - show empty
      assetPath = 'assets/images/upf_outlined.png';
    }

    return Image.asset(
      assetPath,
      width: 36,
      height: 36,
    );
  }
}
