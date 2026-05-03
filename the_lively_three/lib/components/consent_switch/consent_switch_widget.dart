import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'consent_switch_model.dart';
export 'consent_switch_model.dart';

class ConsentSwitchWidget extends StatefulWidget {
  const ConsentSwitchWidget({
    super.key,
    required this.contractId,
    required this.userId,
    required this.onToggle,
  });

  final int? contractId;
  final String? userId;
  final Future Function(bool? toggleValue)? onToggle;

  @override
  State<ConsentSwitchWidget> createState() => _ConsentSwitchWidgetState();
}

class _ConsentSwitchWidgetState extends State<ConsentSwitchWidget> {
  late ConsentSwitchModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConsentSwitchModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsercontractsRow>>(
      future: UsercontractsTable().queryRows(
        queryFn: (q) => q,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 25.0,
              height: 25.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF0F26C0),
                ),
              ),
            ),
          );
        }
        List<UsercontractsRow> switchUsercontractsRowList = snapshot.data!;

        return Switch.adaptive(
          value: _model.switchValue ??= switchUsercontractsRowList
              .where((e) => e.idDatacontract == widget!.contractId)
              .toList()
              .firstOrNull!
              .currentConsent!,
          onChanged: (newValue) async {
            safeSetState(() => _model.switchValue = newValue!);
            if (newValue!) {
              await widget.onToggle?.call(
                _model.switchValue,
              );
              _model.contractNameToggleOn =
                  await actions.updateDataContractConsent(
                widget!.userId!,
                widget!.contractId!,
                _model.switchValue!,
              );

              safeSetState(() {});
            } else {
              await widget.onToggle?.call(
                _model.switchValue,
              );
              _model.contractNameToggleOff =
                  await actions.updateDataContractConsent(
                widget!.userId!,
                widget!.contractId!,
                _model.switchValue!,
              );

              safeSetState(() {});
            }
          },
          activeColor: FlutterFlowTheme.of(context).primary,
          activeTrackColor: FlutterFlowTheme.of(context).primary,
          inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
          inactiveThumbColor: FlutterFlowTheme.of(context).secondaryBackground,
        );
      },
    );
  }
}
