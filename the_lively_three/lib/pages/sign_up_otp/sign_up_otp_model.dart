import 'package:flutter/src/widgets/framework.dart';
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/other_consumption/other_consumption_widget.dart';
import 'package:the_lively_three/pages/sign_up_otp/sign_up_otp_widget.dart';

class SignUpOtpModel extends FlutterFlowModel<SignUpOtpWidget> {
  late BottomNavbarModel bottomNavbarModel;
  String? verificationStatus;

  @override
  @override
  void initState(BuildContext context) {
    bottomNavbarModel = createModel(context, () => BottomNavbarModel());
  }

  @override
  void dispose() {
    bottomNavbarModel.dispose();
  }
}
