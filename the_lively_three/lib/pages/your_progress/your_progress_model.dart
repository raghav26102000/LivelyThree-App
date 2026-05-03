import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_lively_three/components/bottom_navbar/bottom_navbar_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_model.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/pages/other_consumption/other_consumption_widget.dart';
import 'package:the_lively_three/pages/your_progress/your_progress_widget.dart';

class YourProgressModel extends FlutterFlowModel<ProgressPage> {
  late BottomNavbarModel bottomNavbarModel;
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;
  @override
  @override
  void initState(BuildContext context) {
    bottomNavbarModel = createModel(context, () => BottomNavbarModel());
  }

  @override
  void dispose() {
    bottomNavbarModel.dispose();
  }

  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMM - EEE');
    return formatter.format(now);
  }
}
