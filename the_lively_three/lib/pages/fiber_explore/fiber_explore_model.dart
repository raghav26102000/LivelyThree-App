import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_util.dart';
import 'package:the_lively_three/models/weekly_indicators.dart';
import 'package:the_lively_three/utils/indicators_service.dart';

class FiberExploreModal with ChangeNotifier {
  final IndicatorsService _indicatorsService = IndicatorsService();

  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  WeeklyIndicators? _indicators;
  bool _isLoading = false;
  String? _error;

  // Getters
  WeeklyIndicators? get indicators => _indicators;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FiberExploreModal() {
    // Constructor - can be empty or initialize values
  }

  /// Load current week indicators
  Future<void> loadCurrentWeekIndicators() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _indicators = await _indicatorsService.getCurrentWeekIndicators(
          FFAppState().calendarWeek, FFAppState().calendarYear);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _indicators = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
