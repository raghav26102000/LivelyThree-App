import 'package:flutter/src/widgets/framework.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/other_consumption/other_consumption_widget.dart';

class OtherConsumptionModel extends FlutterFlowModel<OtherConsumptionWidget> {
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void initState(BuildContext context) {
    // TODO: implement initState
  }
  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM - EEE');
    return formatter.format(now);
  }
}
