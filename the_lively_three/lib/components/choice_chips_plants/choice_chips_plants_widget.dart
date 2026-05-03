import '/auth/supabase_auth/auth_util.dart';
import '/components/plant_details_bottom_sheet/plant_details_bottom_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'choice_chips_plants_model.dart';
export 'choice_chips_plants_model.dart';

class ChoiceChipsPlantsWidget extends StatefulWidget {
  const ChoiceChipsPlantsWidget({
    super.key,
    required this.plantname,
    required this.colorTextUntapped,
    required this.colorTextTapped,
    required this.colorChoiceChipsUntapped,
    required this.colorChoiceChipsTapped,
    required this.shadowColorUntapped,
    required this.shadowColorTapped,
    required this.color,
    required this.borderColorUntapped,
    required this.borderColorTapped,
    required this.idLoc,
    required this.listAreaTapped,
    required this.listAreaUntapped,
    required this.portionSize,
    bool? portionSizeLocked,
  }) : this.portionSizeLocked = portionSizeLocked ?? false;

  final String? plantname;
  final Color? colorTextUntapped;
  final Color? colorTextTapped;
  final Color? colorChoiceChipsUntapped;
  final Color? colorChoiceChipsTapped;
  final Color? shadowColorUntapped;
  final Color? shadowColorTapped;
  final String? color;
  final Color? borderColorUntapped;
  final Color? borderColorTapped;
  final int? idLoc;
  final Color? listAreaTapped;
  final Color? listAreaUntapped;
  final double? portionSize;
  final bool portionSizeLocked;

  @override
  State<ChoiceChipsPlantsWidget> createState() =>
      _ChoiceChipsPlantsWidgetState();
}

class _ChoiceChipsPlantsWidgetState extends State<ChoiceChipsPlantsWidget> {
  late ChoiceChipsPlantsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChoiceChipsPlantsModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return custom_widgets.CustomChoiceChip(
      width: valueOrDefault<double>(
        () {
          if (FFAppState().screenCategory == 'small') {
            return 130.0;
          } else if (FFAppState().screenCategory == 'medium') {
            return 150.0;
          } else {
            return 170.0;
          }
        }(),
        170.0,
      ),
      height: valueOrDefault<double>(
        () {
          if (MediaQuery.sizeOf(context).width < kBreakpointSmall) {
            return 24.0;
          } else if (MediaQuery.sizeOf(context).width < kBreakpointMedium) {
            return 27.0;
          } else if (MediaQuery.sizeOf(context).width < kBreakpointLarge) {
            return 30.0;
          } else {
            return 30.0;
          }
        }(),
        30.0,
      ),
      plantName: widget!.plantname!,
      colorTextUntapped: widget!.colorTextUntapped!,
      colorTextTapped: widget!.colorTextTapped!,
      colorChoiceChipUntapped: widget!.colorChoiceChipsUntapped!,
      colorChoiceChipTapped: widget!.colorChoiceChipsTapped!,
      shadowColorUntapped: widget!.shadowColorUntapped!,
      shadowColorTapped: widget!.shadowColorTapped!,
      color: widget!.color!,
      borderColorUntapped: widget!.borderColorUntapped!,
      borderColorTapped: widget!.borderColorTapped!,
      weekdayNumber: FFAppState().currentDayNumber,
      week: FFAppState().calendarWeek,
      year: FFAppState().calendarYear,
      userId: currentUserUid,
      listAreaTapped: widget!.listAreaTapped!,
      listAreaUntapped: widget!.listAreaUntapped!,
      screenSize: FFAppState().screenCategory,
      onRightSideTap: () async {
        await actions.getNutrientBoundsWeeklySelection(
          valueOrDefault<int>(
            widget!.idLoc,
            0,
          ),
          currentUserUid,
          FFAppState().calendarWeek,
          FFAppState().calendarYear,
        );
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor:
              widget!.color == 'White' ? Color(0xB9FFFFFF) : Color(0xD3B8F9FD),
          barrierColor: Color(0xB1B8F9FD),
          useSafeArea: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: PlantDetailsBottomSheetWidget(
                  plantname: valueOrDefault<String>(
                    widget!.plantname,
                    'n/a',
                  ),
                  color: valueOrDefault<String>(
                    widget!.color,
                    'n/a',
                  ),
                  locPlantId: valueOrDefault<int>(
                    widget!.idLoc,
                    0,
                  ),
                  fiberUpper: valueOrDefault<double>(
                    FFAppState().nutrientBounds.fiberUpper,
                    0.0,
                  ),
                  fiberActual: valueOrDefault<double>(
                    FFAppState().nutrientBounds.fiberActual,
                    0.0,
                  ),
                  fiberLower: valueOrDefault<double>(
                    FFAppState().nutrientBounds.fiberLower,
                    0.0,
                  ),
                  proteinUpper: valueOrDefault<double>(
                    FFAppState().nutrientBounds.proteinUpper,
                    0.0,
                  ),
                  proteinActual: valueOrDefault<double>(
                    FFAppState().nutrientBounds.proteinActual,
                    0.0,
                  ),
                  proteinLower: valueOrDefault<double>(
                    FFAppState().nutrientBounds.proteinLower,
                    0.0,
                  ),
                  fatUpper: valueOrDefault<double>(
                    FFAppState().nutrientBounds.fatUpper,
                    0.0,
                  ),
                  fatActual: valueOrDefault<double>(
                    FFAppState().nutrientBounds.fatActual,
                    0.0,
                  ),
                  fatLower: valueOrDefault<double>(
                    FFAppState().nutrientBounds.fatLower,
                    0.0,
                  ),
                  carbsUpper: valueOrDefault<double>(
                    FFAppState().nutrientBounds.carbsUpper,
                    0.0,
                  ),
                  carbsActual: valueOrDefault<double>(
                    FFAppState().nutrientBounds.carbsActual,
                    0.0,
                  ),
                  carbsLower: valueOrDefault<double>(
                    FFAppState().nutrientBounds.carbsLower,
                    0.0,
                  ),
                  fiberUpperPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.fiberPlantUpper,
                    'n/a',
                  ),
                  fiberLowerPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.fiberPlantLower,
                    'n/a',
                  ),
                  proteinUpperPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.proteinPlantUpper,
                    'n/a',
                  ),
                  proteinLowerPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.proteinPlantLower,
                    'n/a',
                  ),
                  fatUpperPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.fatPlantUpper,
                    'n/a',
                  ),
                  fatLowerPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.fiberPlantLower,
                    'n/a',
                  ),
                  carbsUpperPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.carbsPlantUpper,
                    'n/a',
                  ),
                  carbsLowerPlant: valueOrDefault<String>(
                    FFAppState().nutrientBounds.carbsPlantLower,
                    'n/a',
                  ),
                  fiberRating: valueOrDefault<int>(
                    FFAppState().nutrientBounds.fiberRating,
                    0,
                  ),
                  proteinRating: valueOrDefault<int>(
                    FFAppState().nutrientBounds.proteinRating,
                    0,
                  ),
                  inThirdRule: FFAppState().nutrientBounds.inThirdRule,
                  fiberValueReference: valueOrDefault<String>(
                    FFAppState().nutrientBounds.fiberValueReference,
                    'n/a',
                  ),
                  carbsValueReference: valueOrDefault<String>(
                    FFAppState().nutrientBounds.carbsValueReference,
                    'n/a',
                  ),
                  proteinValueReference: valueOrDefault<String>(
                    FFAppState().nutrientBounds.proteinValueReference,
                    'n/a',
                  ),
                  fatValueReference: valueOrDefault<String>(
                    FFAppState().nutrientBounds.fatValueReference,
                    'n/a',
                  ),
                  portionSize: widget!.portionSize!,
                  portionSizeLocked: widget!.portionSizeLocked,
                  showPortionSizeMenu: true,
                ),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));
      },
    );
  }
}
