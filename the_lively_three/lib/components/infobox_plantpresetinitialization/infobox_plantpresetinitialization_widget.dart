import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'infobox_plantpresetinitialization_model.dart';
export 'infobox_plantpresetinitialization_model.dart';

class InfoboxPlantpresetinitializationWidget extends StatefulWidget {
  const InfoboxPlantpresetinitializationWidget({super.key});

  @override
  State<InfoboxPlantpresetinitializationWidget> createState() =>
      _InfoboxPlantpresetinitializationWidgetState();
}

class _InfoboxPlantpresetinitializationWidgetState
    extends State<InfoboxPlantpresetinitializationWidget> {
  late InfoboxPlantpresetinitializationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => InfoboxPlantpresetinitializationModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        decoration: BoxDecoration(
          color: Color(0xFFB8DBF8),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).secondary,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: FlutterFlowTheme.of(context).secondary,
                size: 24.0,
              ),
              Text(
                'Your plant selection is being created.',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      color: FlutterFlowTheme.of(context).secondary,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}
