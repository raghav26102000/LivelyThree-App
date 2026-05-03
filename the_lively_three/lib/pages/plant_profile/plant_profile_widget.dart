import 'package:flutter_svg/svg.dart';
import 'package:the_lively_three/pages/plantselection/plantselection_widget.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'plant_profile_model.dart';
export 'plant_profile_model.dart';
import '/backend/supabase/supabase.dart';

import '/l10n/app_localizations.dart';
import '/providers/locale_provider.dart' as locale_provider;

class PlantProfileWidget extends StatefulWidget {
  const PlantProfileWidget({
    super.key,
    required this.userId,
    required this.categoryIcon,
    this.primaryColor = Colors.black,
    required this.locId,
    required this.week,
    required this.year,
  });
  final String userId; // assuming UUID stored as string
  final String categoryIcon;
  final int locId;
  final int week;
  final int year;
  final Color primaryColor;
  static String routeName = 'plantProfile';
  static String routePath = '/plantProfile';
  @override
  State<PlantProfileWidget> createState() => _PlantProfileWidgetState();
}

class MacronutrientData {
  final String plantName;
  final String plantDescription; // NEW
  final String nutrientName;
  final double nutrientValue;
  final double lowestNutrientValue;
  final String lowestNutrientFruit;
  final double highestNutrientValue;
  final String highestNutrientFruit;
  final double secondHighestNutrientValue;
  final String secondHighestNutrientFruit;
  final bool isMacronutrient;
  final int? rankWithinPlant;
  final int? rating1to7;
  final String goodFor; // NEW
  final String mitigatesRisk; // NEW
  final double? dailyRecommendedValue; // NEW
  final String unit;

  MacronutrientData(
      {required this.plantName,
      required this.plantDescription,
      required this.nutrientName,
      required this.nutrientValue,
      required this.lowestNutrientValue,
      required this.lowestNutrientFruit,
      required this.highestNutrientValue,
      required this.highestNutrientFruit,
      required this.secondHighestNutrientValue,
      required this.secondHighestNutrientFruit,
      required this.isMacronutrient,
      this.rankWithinPlant,
      this.rating1to7,
      required this.goodFor,
      required this.mitigatesRisk,
      this.dailyRecommendedValue,
      required this.unit});

  factory MacronutrientData.fromMap(Map<String, dynamic> map) {
    return MacronutrientData(
      plantName: map['plant_name'] ?? 'Unknown Plant',
      plantDescription: map['plant_description'] ?? '',
      nutrientName: map['nutrient_name'] ?? 'Unknown Nutrient',
      nutrientValue: _parseDouble(map['nutrient_value']),
      lowestNutrientValue: _parseNonNegative(map['lowest_nutrient_value']),
      lowestNutrientFruit: map['lowest_nutrient_fruit'] ?? 'Unknown',
      highestNutrientValue: _parseNonNegative(map['highest_nutrient_value']),
      highestNutrientFruit: map['highest_nutrient_fruit'] ?? 'Unknown',
      secondHighestNutrientValue:
          _parseNonNegative(map['second_highest_nutrient_value']),
      secondHighestNutrientFruit:
          map['second_highest_nutrient_fruit'] ?? 'Unknown',
      isMacronutrient: map['is_macronutrient'] == true,
      rankWithinPlant: _parseInt(map['rank_within_plant']),
      rating1to7: _parseInt(map['rating_1to7']),
      goodFor: (map['good_for'] ?? '').toString(),
      mitigatesRisk: (map['mitigates_risk'] ?? '').toString(),
      dailyRecommendedValue: map['daily_recommended_value'] != null
          ? _parseDouble(map['daily_recommended_value'])
          : null,
      unit: map['unit'] ?? '',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final s = v.trim();
      if (s.isEmpty) return null;
      final parsed = int.tryParse(s);
      return parsed;
    }
    return null;
  }

  static double _parseNonNegative(dynamic value) {
    final parsed = _parseDouble(value);
    return parsed < 0 ? 0.0 : parsed;
  }
}

class _PlantProfileWidgetState extends State<PlantProfileWidget> {
  late PlantProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = true;
  String? _loadError;
  Locale? currentLocale;
  List<MacronutrientData> _macronutrients = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlantProfileModel());
    // _fetchMacronutrientsForFruit(
    //     widget.locId, widget.userId, widget.week, widget.year);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access the FFAppState locale here
    currentLocale = Provider.of<locale_provider.FFAppState>(context).locale;
    print('Locale :- $currentLocale');
    _fetchMacronutrientsForFruit(
        widget.locId, widget.userId, currentLocale.toString());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _fetchMacronutrientsForFruit(
    int locId,
    String userId, // uuid comes as string
    String currentLocale,
  ) async {
    setState(() {
      _loading = true;
      _loadError = null;
      _macronutrients = [];
    });
    try {
      final data = await Supabase.instance.client.rpc(
        'get_macronutrients_for_fruit',
        params: {
          'p_id_loc': locId,
          'p_id_user': userId,
          'p_locale': currentLocale,
          // 'p_week': week,
          // 'p_year': year,
        },
      );

      print("Raw RPC response: $data (${data.runtimeType})");

      if (data != null && data is List) {
        final List<MacronutrientData> nutrients = [];
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            nutrients.add(MacronutrientData.fromMap(item));
          }
        }

        setState(() {
          _loading = false;
          _macronutrients = nutrients;
        });
      } else {
        throw Exception("No data received from RPC.");
      }
    } catch (e, st) {
      print("Exception in _fetchMacronutrientsForFruit: $e");
      print(st);
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!; // safe once MaterialApp is configured

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              // context.pushNamed(
              //   PlantselectionWidget.routeName,
              //   extra: <String, dynamic>{
              //     kTransitionInfoKey: const TransitionInfo(
              //       hasTransition: true,
              //       transitionType: PageTransitionType.fade,
              //     ),
              //   },
              // );
            },
            child: Icon(
              Icons.chevron_left,
              color: FlutterFlowTheme.of(context).primary,
              size: 24,
            ),
          ),
        ),
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/${widget.categoryIcon}', // Use dynamic icon
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                              widget.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(
                          _macronutrients.isNotEmpty
                              ? _macronutrients.first.plantName
                              : l10n.loading, // 👈 "Loading..."
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 18),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.botanically, // 👈 "Botanically:"
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.montserrat(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize:
                                          FlutterFlowTheme.adjustScale(size: 8),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                l10n.fruit, // 👈 "Fruit"
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize:
                                          FlutterFlowTheme.adjustScale(size: 8),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(const SizedBox(width: 4)),
                          ),
                        ),
                        Text(
                          l10n.alsoKnownAs, // 👈 "Also Known as:"
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: FlutterFlowTheme.adjustScale(size: 8),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                        Text(
                          '${l10n.na}\n', // 👈 "NA"
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: FlutterFlowTheme.adjustScale(size: 8),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w400,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                                lineHeight: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // ---------- Header Row ----------
                          Container(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8, bottom: 0),
                              child: Row(
                                children: [
                                  Text(
                                    l10n.macroNutrients,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 16),
                                        ),
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 8, right: 8, bottom: 8),
                                  alignment: Alignment.bottomRight,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        l10n.gramsPer100g, // 👈 "g /100g"
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.montserrat(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 8),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  width: 0.5,
                                  color: Colors.black.withValues(alpha: 0.1)),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    l10n.highestFirst, // 👈 "Highest (1st)"
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 12),
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                  width: 0.5,
                                  color: Colors.black.withValues(alpha: 0.1)),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    l10n.highestSecond, // 👈 "Highest (2nd)"
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize:
                                              FlutterFlowTheme.adjustScale(
                                                  size: 12),
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              height: 0.5,
                              color: Colors.black.withValues(alpha: 0.1)),

                          // ---------- Nutrient Rows ----------
                          ...[
                            l10n.fiber,
                            l10n.protein,
                            l10n.carbohydrate,
                            l10n.fat
                          ].map((nutrientKey) {
                            final n = _macronutrients.firstWhere(
                              (m) =>
                                  m.isMacronutrient &&
                                  m.nutrientName
                                      .toLowerCase()
                                      .contains(nutrientKey.toLowerCase()),
                              orElse: () => MacronutrientData(
                                plantName: '',
                                plantDescription: '',
                                nutrientName:
                                    nutrientKey, // could be localized in data if needed
                                nutrientValue: 0,
                                lowestNutrientValue: 0,
                                lowestNutrientFruit: '',
                                highestNutrientValue: 0,
                                highestNutrientFruit: '',
                                secondHighestNutrientValue: 0,
                                secondHighestNutrientFruit: '',
                                isMacronutrient: true,
                                rating1to7: null,
                                goodFor: '',
                                mitigatesRisk: '',
                                unit: '',
                              ),
                            );

                            final nameLower = n.nutrientName.toLowerCase();
                            final showRatingForThis = (nameLower
                                        .contains(l10n.protein.toLowerCase()) ||
                                    nameLower
                                        .contains(l10n.fiber.toLowerCase())) &&
                                n.rating1to7 != null;

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Left Column (nutrient + value + badge if any)
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        constraints: const BoxConstraints(
                                            minHeight: 56), // min height only
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${n.nutrientName.toUpperCase()}: ",
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size: 10),
                                                        ),
                                                  ),
                                                  Text(
                                                    n.nutrientValue
                                                        .toStringAsFixed(1),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size: 16),
                                                        ),
                                                  ),
                                                ]),
                                            if (showRatingForThis)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 4),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFFBA41),
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 6,
                                                    vertical: 4,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.star,
                                                          size: 12,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText),
                                                      const SizedBox(width: 2),
                                                      Text(
                                                        n.rating1to7.toString(),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size: 12),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                      Text(
                                                        '/7', // could be localized as a pattern if you prefer
                                                        style: TextStyle(
                                                          fontSize:
                                                              FlutterFlowTheme
                                                                  .adjustScale(
                                                                      size: 12),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Container(
                                        width: 0.5,
                                        color: Colors.black
                                            .withValues(alpha: 0.1)),

                                    /// Middle Column (Highest 1st)
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        constraints:
                                            const BoxConstraints(minHeight: 56),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${n.highestNutrientFruit}: ",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 8),
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            Text(
                                              n.highestNutrientValue
                                                  .toStringAsFixed(1),
                                              style: GoogleFonts.montserrat(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 16),
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Container(
                                        width: 0.5,
                                        color: Colors.black
                                            .withValues(alpha: 0.1)),

                                    /// Right Column (Highest 2nd)
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        constraints:
                                            const BoxConstraints(minHeight: 56),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${n.secondHighestNutrientFruit}: ",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 8),
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            Text(
                                              n.secondHighestNutrientValue
                                                  .toStringAsFixed(1),
                                              style: GoogleFonts.montserrat(
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 16),
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                    height: 0.5,
                                    color: Colors.black.withValues(alpha: 0.1)),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Title
                            Center(
                              child: Text(
                                l10n.microNutrients, // 👈
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 16)),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Row with top 3 micro nutrients (by rankWithinPlant)
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 4,
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 4,
                              children: (_macronutrients
                                      .where((n) =>
                                          !n.isMacronutrient &&
                                          n.rankWithinPlant != null)
                                      .toList()
                                    ..sort((a, b) => (a.rankWithinPlant ?? 999)
                                        .compareTo(b.rankWithinPlant ?? 999)))
                                  .take(3)
                                  .map((n) => _buildChip(n.nutrientName,
                                      '${n.nutrientValue % 1 == 0 ? n.nutrientValue.toInt().toString() : n.nutrientValue.toStringAsFixed(1)} ${n.unit}'))
                                  .toList(),
                            ),
                            const Divider(height: 32),

                            // Details for each micro nutrient
                            ...(_macronutrients
                                    .where((n) =>
                                        !n.isMacronutrient &&
                                        n.rankWithinPlant != null)
                                    .toList()
                                  ..sort((a, b) => (a.rankWithinPlant ?? 999)
                                      .compareTo(b.rankWithinPlant ?? 999)))
                                .map((n) => Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _buildNutrientDetail(
                                          context,
                                          title: n.nutrientName,
                                          value:
                                              '${n.nutrientValue.toStringAsFixed(1)} ${n.unit}',
                                          dailyValue: n.dailyRecommendedValue !=
                                                  null
                                              ? '${n.dailyRecommendedValue! % 1 == 0 ? n.dailyRecommendedValue!.toInt().toString() : n.dailyRecommendedValue!.toStringAsFixed(1)} ${n.unit}'
                                              : l10n.na,
                                          goodFor: n.goodFor.isNotEmpty
                                              ? n.goodFor
                                              : l10n.na,
                                          mitigates: n.mitigatesRisk.isNotEmpty
                                              ? n.mitigatesRisk
                                              : l10n.na,
                                        ),
                                        const Divider(height: 32),
                                      ],
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ---------- Environmental Footprint Section ----------
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.environmentalFootprint, // 👈
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize:
                                        FlutterFlowTheme.adjustScale(size: 16)),
                          ),
                          const SizedBox(height: 16),

                          // Row for Carbon / Water / Land Use
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildFootprintCard(
                                  context,
                                  l10n.carbon, // 👈
                                  "10",
                                  "7/10",
                                  Colors.blue,
                                  "Celery",
                                  5,
                                  "Oats",
                                  500),
                              _buildFootprintCard(
                                  context,
                                  l10n.water, // 👈
                                  "50",
                                  "7/10",
                                  Colors.blue,
                                  "Celery",
                                  5,
                                  "Oats",
                                  500),
                              _buildFootprintCard(
                                  context,
                                  l10n.landUse, // 👈
                                  "0.2",
                                  "9/10",
                                  Colors.teal,
                                  "Celery",
                                  5,
                                  "Oats",
                                  500),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildChip(String nutrientName, String nutrientValue) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xffefefef),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              nutrientName,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 8),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              nutrientValue,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 10),
                  fontWeight: FontWeight.w700,
                  color: FlutterFlowTheme.of(context).primaryText),
            ),
          ],
        ));
  }

  Widget _buildNutrientDetail(
    BuildContext context, {
    required String title,
    required String value,
    required String dailyValue,
    required String goodFor,
    required String mitigates,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Nutrient name (top row with daily recommended on right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nutrient name (expandable, wraps if too long)
                Expanded(
                  child: Text(
                    "$title:",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: FlutterFlowTheme.adjustScale(size: 12),
                        fontWeight: FontWeight.w500,
                        color: FlutterFlowTheme.of(context).primaryText,
                        height: 1),
                  ),
                ),

                const SizedBox(width: 8),

                // Daily Recommended (fixed on right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 4,
                  children: [
                    Text(
                      l10n.dailyRecommended(' '), // 👈 pattern
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(size: 8),
                          fontWeight: FontWeight.w500,
                          color: FlutterFlowTheme.of(context).primaryText,
                          height: 1),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      dailyValue, // 👈 pattern
                      style: TextStyle(
                          fontSize: FlutterFlowTheme.adjustScale(size: 16),
                          fontWeight: FontWeight.w700,
                          color: FlutterFlowTheme.of(context).primaryText,
                          height: 1),
                      textAlign: TextAlign.right,
                    ),
                  ],
                )
              ],
            ),

            // Nutrient value (below nutrient name, bold, left aligned)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                value,
                style: TextStyle(
                    fontSize: FlutterFlowTheme.adjustScale(size: 16),
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(46, 48, 50, 1),
                    height: 1),
              ),
            ),

            const SizedBox(height: 8),

            // Good For
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: l10n.goodFor, // 👈 "Good For: "
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 8),
                      fontWeight: FontWeight.w700,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  TextSpan(
                    text: goodFor,
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 8),
                      fontWeight: FontWeight.w400,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // Mitigates Risk
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: l10n.mitigatesRisk, // 👈 "Mitigates Risk: "
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 8),
                      fontWeight: FontWeight.w700,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  TextSpan(
                    text: mitigates,
                    style: TextStyle(
                      fontSize: FlutterFlowTheme.adjustScale(size: 8),
                      fontWeight: FontWeight.w400,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildFootprintCard(
      BuildContext context,
      String label,
      String value,
      String score,
      Color color,
      String minValueFood,
      int minValue,
      String maxValueFood,
      int maxValue) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Container(
            padding: const EdgeInsets.all(2),
            width: (MediaQuery.sizeOf(context).width * 0.33) - 15,
            child: Column(
              spacing: 6,
              children: [
                RichText(
                  text: TextSpan(
                    text: "$label: ",
                    style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.w500,
                        fontSize: FlutterFlowTheme.adjustScale(size: 12)),
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontWeight: FontWeight.w700,
                            fontSize: FlutterFlowTheme.adjustScale(size: 16)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 12, color: color),
                      const SizedBox(width: 4),
                      Text(
                        score, // If you want to localize score format, pass a localized string here.
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: FlutterFlowTheme.adjustScale(size: 12)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(216, 216, 216, 0.28),
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 2,
                        children: [
                          Text(
                            minValueFood, // domain text; localize if needed
                            style: TextStyle(
                                fontSize: FlutterFlowTheme.adjustScale(size: 8),
                                fontWeight: FontWeight.w500,
                                color:
                                    FlutterFlowTheme.of(context).primaryText),
                          ),
                          Text(
                            "$minValue",
                            style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 16),
                                fontWeight: FontWeight.w700,
                                color:
                                    FlutterFlowTheme.of(context).primaryText),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: const Color.fromRGBO(151, 151, 151, 0.2),
                      ),
                      Column(
                        spacing: 4,
                        children: [
                          Text(
                            maxValueFood, // domain text; localize if needed
                            style: TextStyle(
                                fontSize: FlutterFlowTheme.adjustScale(size: 8),
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            "$maxValue",
                            style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 16),
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
