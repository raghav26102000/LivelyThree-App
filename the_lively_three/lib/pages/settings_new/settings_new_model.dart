import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/settings_new/settings_new_widget.dart';

class SettingsNewModel extends FlutterFlowModel<SettingsNewPage> {
  late BottomNavbarModel bottomNavbarModel;
  @override
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;
  void initState(BuildContext context) {
    bottomNavbarModel = createModel(context, () => BottomNavbarModel());
  }

  @override
  void dispose() {
    bottomNavbarModel.dispose();
  }
}
