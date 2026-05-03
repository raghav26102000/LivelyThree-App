import '/auth/supabase_auth/auth_util.dart';
import '/components/plant_details_bottom_sheet/plant_details_bottom_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_choice_chip_model.dart';
export 'settings_choice_chip_model.dart';

class SettingsChoiceChipWidget extends StatefulWidget {
  const SettingsChoiceChipWidget({
    super.key,
    required this.plantname,
    required this.color,
    this.borderColorTapped,
    this.borderColorUntapped,
    required this.colorTextUntapped,
    required this.colorTextTapped,
    required this.colorContainerTapped,
    required this.colorContainerUntapped,
    required this.shadowColorUntapped,
    required this.shadowColorTapped,
    required this.locId,
    bool? isSelected,
    required this.listAreaTapped,
    required this.listAreaUntapped,
    required this.portionSum,
    required this.isPreset,
    required this.plantCount,
    required this.portionSize,
  }) : this.isSelected = isSelected ?? false;

  final String? plantname;
  final String? color;
  final Color? borderColorTapped;
  final Color? borderColorUntapped;
  final Color? colorTextUntapped;
  final Color? colorTextTapped;
  final Color? colorContainerTapped;
  final Color? colorContainerUntapped;
  final Color? shadowColorUntapped;
  final Color? shadowColorTapped;
  final int? locId;
  final bool isSelected;
  final Color? listAreaTapped;
  final Color? listAreaUntapped;
  final double? portionSum;
  final bool? isPreset;
  final Future Function(int? plantCounter)? plantCount;
  final double? portionSize;

  @override
  State<SettingsChoiceChipWidget> createState() =>
      _SettingsChoiceChipWidgetState();
}

class _SettingsChoiceChipWidgetState extends State<SettingsChoiceChipWidget> {
  late SettingsChoiceChipModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsChoiceChipModel());

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

    return custom_widgets.SettingsSelectionChoiceChip(
      width: MediaQuery.sizeOf(context).width * 0.2,
      height: MediaQuery.sizeOf(context).height * 0.042,
      plantName: widget!.plantname!,
      colorTextUntapped: widget!.colorTextUntapped!,
      colorTextTapped: widget!.colorTextTapped!,
      colorChoiceChipUntapped: widget!.colorContainerUntapped!,
      colorChoiceChipTapped: widget!.colorContainerTapped!,
      shadowColorUntapped: widget!.shadowColorUntapped!,
      shadowColorTapped: widget!.shadowColorTapped!,
      color: widget!.color!,
      borderColorUntapped: widget!.borderColorUntapped!,
      borderColorTapped: widget!.borderColorTapped!,
      week: FFAppState().calendarWeek,
      year: FFAppState().calendarYear,
      userId: currentUserUid,
      listAreaTapped: widget!.listAreaTapped!,
      listAreaUntapped: widget!.listAreaUntapped!,
      idLoc: widget!.locId!,
      isSelected: widget!.isSelected,
      portionSum: widget!.portionSum!,
      screenSize: FFAppState().screenCategory,
      portionSize: valueOrDefault<double>(
        widget!.portionSize,
        1.0,
      ),
      onRightSideTap: () async {
        await actions.getNutrientBoundsLocalizedSelection(
          widget!.locId!,
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
                  plantname: widget!.plantname!,
                  color: widget!.color!,
                  locPlantId: widget!.locId!,
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
                  portionSize: 0.0,
                  portionSizeLocked: false,
                  showPortionSizeMenu: false,
                ),
              ),
            );
          },
        ).then((value) => safeSetState(() {}));
      },
      onCannotRemoveNonZeroPortion: () async {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Portions Alert'),
              content: Text(
                  'Portions for this plant detected in this week. Change to 0 or wait for next Monday to deselect.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      },
      onSelectionCountUpdated: (newCount) async {
        await widget.plantCount?.call(
          newCount,
        );
      },
    );
  }
}
