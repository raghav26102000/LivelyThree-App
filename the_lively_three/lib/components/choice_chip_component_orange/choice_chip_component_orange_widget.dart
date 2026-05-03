import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'choice_chip_component_orange_model.dart';
export 'choice_chip_component_orange_model.dart';

class ChoiceChipComponentOrangeWidget extends StatefulWidget {
  const ChoiceChipComponentOrangeWidget({
    super.key,
    required this.labelCP,
    required this.unselectedColorCP,
    required this.selectedColorCP,
    required this.unselectedTextCP,
    required this.selectedTextCP,
    required this.unselectedBorderCP,
    required this.selectedBorderCP,
    required this.chipSelected,
    required this.updateChoiceChipsAction,
    this.initialSelection,
  });

  final List<String>? labelCP;
  final Color? unselectedColorCP;
  final Color? selectedColorCP;
  final Color? unselectedTextCP;
  final Color? selectedTextCP;
  final Color? unselectedBorderCP;
  final Color? selectedBorderCP;
  final bool? chipSelected;
  final Future Function(List<String> selectedChoiceChipsList)?
      updateChoiceChipsAction;
  final List<String>? initialSelection;

  @override
  State<ChoiceChipComponentOrangeWidget> createState() =>
      _ChoiceChipComponentOrangeWidgetState();
}

class _ChoiceChipComponentOrangeWidgetState
    extends State<ChoiceChipComponentOrangeWidget> {
  late ChoiceChipComponentOrangeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChoiceChipComponentOrangeModel());

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

    return FlutterFlowChoiceChips(
      options: widget!.labelCP!.map((label) => ChipData(label)).toList(),
      onChanged: (val) async {
        safeSetState(() => _model.orangeChoiceChipsValues = val);
        FFAppState().totalWeeklySelectedPlants = functions.totalSelectNumber(
            FFAppState().redWeeklySelectedPlants,
            _model.orangeChoiceChipsValues?.length,
            FFAppState().yellowWeeklySelectedPlants,
            FFAppState().greenWeeklySelectedPlants,
            FFAppState().purpleWeeklySelectedPlants,
            FFAppState().brownWeeklySelectedPlants,
            FFAppState().whiteWeeklySelectedPlants)!;
        FFAppState().orangeWeeklySelectedPlants =
            _model.orangeChoiceChipsValues!.length;
        _model.updatePage(() {});
        await widget.updateChoiceChipsAction?.call(
          _model.orangeChoiceChipsValues!,
        );
      },
      selectedChipStyle: ChipStyle(
        backgroundColor: widget!.selectedColorCP,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              color: widget!.selectedTextCP,
              fontSize: 12.0,
              letterSpacing: 0.0,
              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
            ),
        iconColor: FlutterFlowTheme.of(context).primaryText,
        iconSize: 18.0,
        elevation: 4.0,
        borderColor: widget!.selectedBorderCP,
        borderWidth: 2.0,
        borderRadius: BorderRadius.circular(24.0),
      ),
      unselectedChipStyle: ChipStyle(
        backgroundColor: widget!.unselectedColorCP,
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
              color: widget!.unselectedTextCP,
              fontSize: 12.0,
              letterSpacing: 0.0,
              useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
            ),
        iconColor: FlutterFlowTheme.of(context).secondaryText,
        iconSize: 18.0,
        elevation: 0.0,
        borderColor: widget!.unselectedBorderCP,
        borderWidth: 1.0,
        borderRadius: BorderRadius.circular(24.0),
      ),
      chipSpacing: 8.0,
      rowSpacing: 8.0,
      multiselect: true,
      initialized: _model.orangeChoiceChipsValues != null,
      alignment: WrapAlignment.start,
      controller: _model.orangeChoiceChipsValueController ??=
          FormFieldController<List<String>>(
        widget!.initialSelection,
      ),
      wrapped: true,
    );
  }
}
