import 'package:flutter/services.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_icon_button.dart';
import 'package:the_lively_three/pages/other_consumption/other_consumption_model.dart';

import '../../custom_code/widgets/weekly_item_card.dart' show WeeklyItemCard;
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/choice_chips_plants/choice_chips_plants_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/plant_selection.dart';
import 'dart:ui';
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/portion_size_modifier/portion_size_modifier_widget.dart';

class OtherConsumptionWidget extends StatefulWidget {
  const OtherConsumptionWidget({super.key});

  static String routeName = 'OtherConsumption';
  static String routePath = '/otherConsumption';

  @override
  State<OtherConsumptionWidget> createState() => _OtherConsumptionWidgetState();
}

class FoodType {
  final String name;
  final Color color;

  const FoodType({required this.name, required this.color});
}

class _OtherConsumptionWidgetState extends State<OtherConsumptionWidget> {
  late OtherConsumptionModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedFoodType = 'Meat';
  final List<FoodType> foodType = [
    const FoodType(name: "Meat", color: Color(0xfffe5f7b)),
    const FoodType(name: "Dairy", color: Color(0xff73cdff)),
    const FoodType(name: "UPF", color: Color(0xff2ec4b1)),
  ];

  Color _colorFor(String? name) {
    switch ((name ?? '').toLowerCase()) {
      case 'meat':
        return Color(0xfffe5f7b);
      case 'dairy':
        return Color(0xff73cdff);
      case 'upf':
        return Color(0xff2ec4b1);
      default:
        return FlutterFlowTheme.of(context).primary;
    }
  }

  Color colorFromTag(String? tag) {
    switch ((tag ?? '').toLowerCase()) {
      case 'meat':
        return Color(0xfffe5f7b);
      case 'dairy':
        return Color(0xff73cdff);
      case 'upf':
        return Color(0xff2ec4b1);
      default:
        return FlutterFlowTheme.of(context).primary;
    }
  }

  Map<String, String> dayToField = {
    "Monday": "monportion",
    "Tuesday": "tueportion",
    "Wednesday": "wedportion",
    "Thursday": "thuportion",
    "Friday": "friportion",
    "Saturday": "satportion",
    "Sunday": "sunportion",
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OtherConsumptionModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  List<WeeklyselectedplantRow> weeklyItems = [];

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            context.safePop();
                            print('Icon tapped');
                            // Add your custom onTap logic here
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24,
                          ),
                        ),
                      ].divide(SizedBox(width: 8)),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12.0, 10.0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Align(
                                alignment: Alignment
                                    .topCenter, //AlignmentDirectional(0.0, 1.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4.0, 15.0, 4.0, 0.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.98,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 0.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 20.0, 0.0, 10.0),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 8.0,
                                                    color: Color(0x17000000),
                                                    offset: Offset(
                                                      0.0,
                                                      3.0,
                                                    ),
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 20.0, 8.0, 4.0),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    maxHeight: 60.0,
                                                  ),
                                                  decoration: BoxDecoration(),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Wrap(
                                                            spacing: 2.0,
                                                            runSpacing: 4.0,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            direction:
                                                                Axis.horizontal,
                                                            runAlignment:
                                                                WrapAlignment
                                                                    .start,
                                                            verticalDirection:
                                                                VerticalDirection
                                                                    .down,
                                                            clipBehavior:
                                                                Clip.none,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    width: 6,
                                                                    height: 6,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: colorFromTag(
                                                                          'meat'), // or hexToColor(p.colorHex)
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text('Pork'),
                                                                  const SizedBox(
                                                                      width: 4),
                                                                  Text(
                                                                    (1).toStringAsFixed(
                                                                        1),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    width: 6,
                                                                    height: 6,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: colorFromTag(
                                                                          'dairy'), // or hexToColor(p.colorHex)
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text('Milk'),
                                                                  const SizedBox(
                                                                      width: 4),
                                                                  Text(
                                                                    (2).toStringAsFixed(
                                                                        1),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    width: 6,
                                                                    height: 6,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: colorFromTag(
                                                                          'upf'), // or hexToColor(p.colorHex)
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text(
                                                                      'Ultaprocessed Food'),
                                                                  const SizedBox(
                                                                      width: 4),
                                                                  Text(
                                                                    (4).toStringAsFixed(
                                                                        1),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ]),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.5,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(99.0),
                                  ),
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.chevron_left,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        Text(
                                          OtherConsumptionModel
                                              .getCurrentDate(),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: FlutterFlowTheme
                                                    .adjustScale(size: 15.0),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: foodType.map((p) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFoodType = p.name;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 9, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: selectedFoodType == p.name
                                      ? p.color
                                      : Color(0xfff9f9f9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  p.name,
                                  style: TextStyle(
                                      color: selectedFoodType == p.name
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                      fontWeight: FontWeight.w500),
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
