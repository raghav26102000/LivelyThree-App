// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlantsSummarySchemaStruct extends FFFirebaseStruct {
  PlantsSummarySchemaStruct({
    int? totalDistinctPlantsSelected,
    int? totalDistinctPlantsConsumed,
    int? totalPlantsSelectedRedConsumed,
    int? totalPlantsSelectedOrangeConsumed,
    int? totalPlantsSelectedYellowConsumed,
    int? totalPlantsSelectedGreenConsumed,
    int? totalPlantsSelectedPurpleConsumed,
    int? totalPlantsSelectedBrownConsumed,
    int? totalPlantsSelectedWhiteConsumed,
    int? colorsConsumed,
    int? plantsConsumedMonday,
    int? plantsConsumedTuesday,
    int? plantsConsumedWednesday,
    int? plantsConsumedThursday,
    int? plantsConsumedFriday,
    int? plantsConsumedSaturday,
    int? plantsConsumedSunday,
    int? plantsperdayCounter,
    int? dayOfWeek,
    double? totalPortionsMonday,
    double? totalPortionsTuesday,
    double? totalPortionsWednesday,
    double? totalPortionsThursday,
    double? totalPortionsFriday,
    double? totalPortionsSaturday,
    double? totalPortionsSunday,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _totalDistinctPlantsSelected = totalDistinctPlantsSelected,
        _totalDistinctPlantsConsumed = totalDistinctPlantsConsumed,
        _totalPlantsSelectedRedConsumed = totalPlantsSelectedRedConsumed,
        _totalPlantsSelectedOrangeConsumed = totalPlantsSelectedOrangeConsumed,
        _totalPlantsSelectedYellowConsumed = totalPlantsSelectedYellowConsumed,
        _totalPlantsSelectedGreenConsumed = totalPlantsSelectedGreenConsumed,
        _totalPlantsSelectedPurpleConsumed = totalPlantsSelectedPurpleConsumed,
        _totalPlantsSelectedBrownConsumed = totalPlantsSelectedBrownConsumed,
        _totalPlantsSelectedWhiteConsumed = totalPlantsSelectedWhiteConsumed,
        _colorsConsumed = colorsConsumed,
        _plantsConsumedMonday = plantsConsumedMonday,
        _plantsConsumedTuesday = plantsConsumedTuesday,
        _plantsConsumedWednesday = plantsConsumedWednesday,
        _plantsConsumedThursday = plantsConsumedThursday,
        _plantsConsumedFriday = plantsConsumedFriday,
        _plantsConsumedSaturday = plantsConsumedSaturday,
        _plantsConsumedSunday = plantsConsumedSunday,
        _plantsperdayCounter = plantsperdayCounter,
        _dayOfWeek = dayOfWeek,
        _totalPortionsMonday = totalPortionsMonday,
        _totalPortionsTuesday = totalPortionsTuesday,
        _totalPortionsWednesday = totalPortionsWednesday,
        _totalPortionsThursday = totalPortionsThursday,
        _totalPortionsFriday = totalPortionsFriday,
        _totalPortionsSaturday = totalPortionsSaturday,
        _totalPortionsSunday = totalPortionsSunday,
        super(firestoreUtilData);

  // "totalDistinctPlantsSelected" field.
  int? _totalDistinctPlantsSelected;
  int get totalDistinctPlantsSelected => _totalDistinctPlantsSelected ?? 0;
  set totalDistinctPlantsSelected(int? val) =>
      _totalDistinctPlantsSelected = val;

  void incrementTotalDistinctPlantsSelected(int amount) =>
      totalDistinctPlantsSelected = totalDistinctPlantsSelected + amount;

  bool hasTotalDistinctPlantsSelected() => _totalDistinctPlantsSelected != null;

  // "totalDistinctPlantsConsumed" field.
  int? _totalDistinctPlantsConsumed;
  int get totalDistinctPlantsConsumed => _totalDistinctPlantsConsumed ?? 0;
  set totalDistinctPlantsConsumed(int? val) =>
      _totalDistinctPlantsConsumed = val;

  void incrementTotalDistinctPlantsConsumed(int amount) =>
      totalDistinctPlantsConsumed = totalDistinctPlantsConsumed + amount;

  bool hasTotalDistinctPlantsConsumed() => _totalDistinctPlantsConsumed != null;

  // "totalPlantsSelectedRedConsumed" field.
  int? _totalPlantsSelectedRedConsumed;
  int get totalPlantsSelectedRedConsumed =>
      _totalPlantsSelectedRedConsumed ?? 0;
  set totalPlantsSelectedRedConsumed(int? val) =>
      _totalPlantsSelectedRedConsumed = val;

  void incrementTotalPlantsSelectedRedConsumed(int amount) =>
      totalPlantsSelectedRedConsumed = totalPlantsSelectedRedConsumed + amount;

  bool hasTotalPlantsSelectedRedConsumed() =>
      _totalPlantsSelectedRedConsumed != null;

  // "totalPlantsSelectedOrangeConsumed" field.
  int? _totalPlantsSelectedOrangeConsumed;
  int get totalPlantsSelectedOrangeConsumed =>
      _totalPlantsSelectedOrangeConsumed ?? 0;
  set totalPlantsSelectedOrangeConsumed(int? val) =>
      _totalPlantsSelectedOrangeConsumed = val;

  void incrementTotalPlantsSelectedOrangeConsumed(int amount) =>
      totalPlantsSelectedOrangeConsumed =
          totalPlantsSelectedOrangeConsumed + amount;

  bool hasTotalPlantsSelectedOrangeConsumed() =>
      _totalPlantsSelectedOrangeConsumed != null;

  // "totalPlantsSelectedYellowConsumed" field.
  int? _totalPlantsSelectedYellowConsumed;
  int get totalPlantsSelectedYellowConsumed =>
      _totalPlantsSelectedYellowConsumed ?? 0;
  set totalPlantsSelectedYellowConsumed(int? val) =>
      _totalPlantsSelectedYellowConsumed = val;

  void incrementTotalPlantsSelectedYellowConsumed(int amount) =>
      totalPlantsSelectedYellowConsumed =
          totalPlantsSelectedYellowConsumed + amount;

  bool hasTotalPlantsSelectedYellowConsumed() =>
      _totalPlantsSelectedYellowConsumed != null;

  // "totalPlantsSelectedGreenConsumed" field.
  int? _totalPlantsSelectedGreenConsumed;
  int get totalPlantsSelectedGreenConsumed =>
      _totalPlantsSelectedGreenConsumed ?? 0;
  set totalPlantsSelectedGreenConsumed(int? val) =>
      _totalPlantsSelectedGreenConsumed = val;

  void incrementTotalPlantsSelectedGreenConsumed(int amount) =>
      totalPlantsSelectedGreenConsumed =
          totalPlantsSelectedGreenConsumed + amount;

  bool hasTotalPlantsSelectedGreenConsumed() =>
      _totalPlantsSelectedGreenConsumed != null;

  // "totalPlantsSelectedPurpleConsumed" field.
  int? _totalPlantsSelectedPurpleConsumed;
  int get totalPlantsSelectedPurpleConsumed =>
      _totalPlantsSelectedPurpleConsumed ?? 0;
  set totalPlantsSelectedPurpleConsumed(int? val) =>
      _totalPlantsSelectedPurpleConsumed = val;

  void incrementTotalPlantsSelectedPurpleConsumed(int amount) =>
      totalPlantsSelectedPurpleConsumed =
          totalPlantsSelectedPurpleConsumed + amount;

  bool hasTotalPlantsSelectedPurpleConsumed() =>
      _totalPlantsSelectedPurpleConsumed != null;

  // "totalPlantsSelectedBrownConsumed" field.
  int? _totalPlantsSelectedBrownConsumed;
  int get totalPlantsSelectedBrownConsumed =>
      _totalPlantsSelectedBrownConsumed ?? 0;
  set totalPlantsSelectedBrownConsumed(int? val) =>
      _totalPlantsSelectedBrownConsumed = val;

  void incrementTotalPlantsSelectedBrownConsumed(int amount) =>
      totalPlantsSelectedBrownConsumed =
          totalPlantsSelectedBrownConsumed + amount;

  bool hasTotalPlantsSelectedBrownConsumed() =>
      _totalPlantsSelectedBrownConsumed != null;

  // "totalPlantsSelectedWhiteConsumed" field.
  int? _totalPlantsSelectedWhiteConsumed;
  int get totalPlantsSelectedWhiteConsumed =>
      _totalPlantsSelectedWhiteConsumed ?? 0;
  set totalPlantsSelectedWhiteConsumed(int? val) =>
      _totalPlantsSelectedWhiteConsumed = val;

  void incrementTotalPlantsSelectedWhiteConsumed(int amount) =>
      totalPlantsSelectedWhiteConsumed =
          totalPlantsSelectedWhiteConsumed + amount;

  bool hasTotalPlantsSelectedWhiteConsumed() =>
      _totalPlantsSelectedWhiteConsumed != null;

  // "colorsConsumed" field.
  int? _colorsConsumed;
  int get colorsConsumed => _colorsConsumed ?? 0;
  set colorsConsumed(int? val) => _colorsConsumed = val;

  void incrementColorsConsumed(int amount) =>
      colorsConsumed = colorsConsumed + amount;

  bool hasColorsConsumed() => _colorsConsumed != null;

  // "plantsConsumedMonday" field.
  int? _plantsConsumedMonday;
  int get plantsConsumedMonday => _plantsConsumedMonday ?? 0;
  set plantsConsumedMonday(int? val) => _plantsConsumedMonday = val;

  void incrementPlantsConsumedMonday(int amount) =>
      plantsConsumedMonday = plantsConsumedMonday + amount;

  bool hasPlantsConsumedMonday() => _plantsConsumedMonday != null;

  // "plantsConsumedTuesday" field.
  int? _plantsConsumedTuesday;
  int get plantsConsumedTuesday => _plantsConsumedTuesday ?? 0;
  set plantsConsumedTuesday(int? val) => _plantsConsumedTuesday = val;

  void incrementPlantsConsumedTuesday(int amount) =>
      plantsConsumedTuesday = plantsConsumedTuesday + amount;

  bool hasPlantsConsumedTuesday() => _plantsConsumedTuesday != null;

  // "plantsConsumedWednesday" field.
  int? _plantsConsumedWednesday;
  int get plantsConsumedWednesday => _plantsConsumedWednesday ?? 0;
  set plantsConsumedWednesday(int? val) => _plantsConsumedWednesday = val;

  void incrementPlantsConsumedWednesday(int amount) =>
      plantsConsumedWednesday = plantsConsumedWednesday + amount;

  bool hasPlantsConsumedWednesday() => _plantsConsumedWednesday != null;

  // "plantsConsumedThursday" field.
  int? _plantsConsumedThursday;
  int get plantsConsumedThursday => _plantsConsumedThursday ?? 0;
  set plantsConsumedThursday(int? val) => _plantsConsumedThursday = val;

  void incrementPlantsConsumedThursday(int amount) =>
      plantsConsumedThursday = plantsConsumedThursday + amount;

  bool hasPlantsConsumedThursday() => _plantsConsumedThursday != null;

  // "plantsConsumedFriday" field.
  int? _plantsConsumedFriday;
  int get plantsConsumedFriday => _plantsConsumedFriday ?? 0;
  set plantsConsumedFriday(int? val) => _plantsConsumedFriday = val;

  void incrementPlantsConsumedFriday(int amount) =>
      plantsConsumedFriday = plantsConsumedFriday + amount;

  bool hasPlantsConsumedFriday() => _plantsConsumedFriday != null;

  // "plantsConsumedSaturday" field.
  int? _plantsConsumedSaturday;
  int get plantsConsumedSaturday => _plantsConsumedSaturday ?? 0;
  set plantsConsumedSaturday(int? val) => _plantsConsumedSaturday = val;

  void incrementPlantsConsumedSaturday(int amount) =>
      plantsConsumedSaturday = plantsConsumedSaturday + amount;

  bool hasPlantsConsumedSaturday() => _plantsConsumedSaturday != null;

  // "plantsConsumedSunday" field.
  int? _plantsConsumedSunday;
  int get plantsConsumedSunday => _plantsConsumedSunday ?? 0;
  set plantsConsumedSunday(int? val) => _plantsConsumedSunday = val;

  void incrementPlantsConsumedSunday(int amount) =>
      plantsConsumedSunday = plantsConsumedSunday + amount;

  bool hasPlantsConsumedSunday() => _plantsConsumedSunday != null;

  // "plantsperdayCounter" field.
  int? _plantsperdayCounter;
  int get plantsperdayCounter => _plantsperdayCounter ?? 0;
  set plantsperdayCounter(int? val) => _plantsperdayCounter = val;

  void incrementPlantsperdayCounter(int amount) =>
      plantsperdayCounter = plantsperdayCounter + amount;

  bool hasPlantsperdayCounter() => _plantsperdayCounter != null;

  // "dayOfWeek" field.
  int? _dayOfWeek;
  int get dayOfWeek => _dayOfWeek ?? 0;
  set dayOfWeek(int? val) => _dayOfWeek = val;

  void incrementDayOfWeek(int amount) => dayOfWeek = dayOfWeek + amount;

  bool hasDayOfWeek() => _dayOfWeek != null;

  // "totalPortionsMonday" field.
  double? _totalPortionsMonday;
  double get totalPortionsMonday => _totalPortionsMonday ?? 0.0;
  set totalPortionsMonday(double? val) => _totalPortionsMonday = val;

  void incrementTotalPortionsMonday(double amount) =>
      totalPortionsMonday = totalPortionsMonday + amount;

  bool hasTotalPortionsMonday() => _totalPortionsMonday != null;

  // "totalPortionsTuesday" field.
  double? _totalPortionsTuesday;
  double get totalPortionsTuesday => _totalPortionsTuesday ?? 0.0;
  set totalPortionsTuesday(double? val) => _totalPortionsTuesday = val;

  void incrementTotalPortionsTuesday(double amount) =>
      totalPortionsTuesday = totalPortionsTuesday + amount;

  bool hasTotalPortionsTuesday() => _totalPortionsTuesday != null;

  // "totalPortionsWednesday" field.
  double? _totalPortionsWednesday;
  double get totalPortionsWednesday => _totalPortionsWednesday ?? 0.0;
  set totalPortionsWednesday(double? val) => _totalPortionsWednesday = val;

  void incrementTotalPortionsWednesday(double amount) =>
      totalPortionsWednesday = totalPortionsWednesday + amount;

  bool hasTotalPortionsWednesday() => _totalPortionsWednesday != null;

  // "totalPortionsThursday" field.
  double? _totalPortionsThursday;
  double get totalPortionsThursday => _totalPortionsThursday ?? 0.0;
  set totalPortionsThursday(double? val) => _totalPortionsThursday = val;

  void incrementTotalPortionsThursday(double amount) =>
      totalPortionsThursday = totalPortionsThursday + amount;

  bool hasTotalPortionsThursday() => _totalPortionsThursday != null;

  // "totalPortionsFriday" field.
  double? _totalPortionsFriday;
  double get totalPortionsFriday => _totalPortionsFriday ?? 0.0;
  set totalPortionsFriday(double? val) => _totalPortionsFriday = val;

  void incrementTotalPortionsFriday(double amount) =>
      totalPortionsFriday = totalPortionsFriday + amount;

  bool hasTotalPortionsFriday() => _totalPortionsFriday != null;

  // "totalPortionsSaturday" field.
  double? _totalPortionsSaturday;
  double get totalPortionsSaturday => _totalPortionsSaturday ?? 0.0;
  set totalPortionsSaturday(double? val) => _totalPortionsSaturday = val;

  void incrementTotalPortionsSaturday(double amount) =>
      totalPortionsSaturday = totalPortionsSaturday + amount;

  bool hasTotalPortionsSaturday() => _totalPortionsSaturday != null;

  // "totalPortionsSunday" field.
  double? _totalPortionsSunday;
  double get totalPortionsSunday => _totalPortionsSunday ?? 0.0;
  set totalPortionsSunday(double? val) => _totalPortionsSunday = val;

  void incrementTotalPortionsSunday(double amount) =>
      totalPortionsSunday = totalPortionsSunday + amount;

  bool hasTotalPortionsSunday() => _totalPortionsSunday != null;

  static PlantsSummarySchemaStruct fromMap(Map<String, dynamic> data) =>
      PlantsSummarySchemaStruct(
        totalDistinctPlantsSelected:
            castToType<int>(data['totalDistinctPlantsSelected']),
        totalDistinctPlantsConsumed:
            castToType<int>(data['totalDistinctPlantsConsumed']),
        totalPlantsSelectedRedConsumed:
            castToType<int>(data['totalPlantsSelectedRedConsumed']),
        totalPlantsSelectedOrangeConsumed:
            castToType<int>(data['totalPlantsSelectedOrangeConsumed']),
        totalPlantsSelectedYellowConsumed:
            castToType<int>(data['totalPlantsSelectedYellowConsumed']),
        totalPlantsSelectedGreenConsumed:
            castToType<int>(data['totalPlantsSelectedGreenConsumed']),
        totalPlantsSelectedPurpleConsumed:
            castToType<int>(data['totalPlantsSelectedPurpleConsumed']),
        totalPlantsSelectedBrownConsumed:
            castToType<int>(data['totalPlantsSelectedBrownConsumed']),
        totalPlantsSelectedWhiteConsumed:
            castToType<int>(data['totalPlantsSelectedWhiteConsumed']),
        colorsConsumed: castToType<int>(data['colorsConsumed']),
        plantsConsumedMonday: castToType<int>(data['plantsConsumedMonday']),
        plantsConsumedTuesday: castToType<int>(data['plantsConsumedTuesday']),
        plantsConsumedWednesday:
            castToType<int>(data['plantsConsumedWednesday']),
        plantsConsumedThursday: castToType<int>(data['plantsConsumedThursday']),
        plantsConsumedFriday: castToType<int>(data['plantsConsumedFriday']),
        plantsConsumedSaturday: castToType<int>(data['plantsConsumedSaturday']),
        plantsConsumedSunday: castToType<int>(data['plantsConsumedSunday']),
        plantsperdayCounter: castToType<int>(data['plantsperdayCounter']),
        dayOfWeek: castToType<int>(data['dayOfWeek']),
        totalPortionsMonday: castToType<double>(data['totalPortionsMonday']),
        totalPortionsTuesday: castToType<double>(data['totalPortionsTuesday']),
        totalPortionsWednesday:
            castToType<double>(data['totalPortionsWednesday']),
        totalPortionsThursday:
            castToType<double>(data['totalPortionsThursday']),
        totalPortionsFriday: castToType<double>(data['totalPortionsFriday']),
        totalPortionsSaturday:
            castToType<double>(data['totalPortionsSaturday']),
        totalPortionsSunday: castToType<double>(data['totalPortionsSunday']),
      );

  static PlantsSummarySchemaStruct? maybeFromMap(dynamic data) => data is Map
      ? PlantsSummarySchemaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalDistinctPlantsSelected': _totalDistinctPlantsSelected,
        'totalDistinctPlantsConsumed': _totalDistinctPlantsConsumed,
        'totalPlantsSelectedRedConsumed': _totalPlantsSelectedRedConsumed,
        'totalPlantsSelectedOrangeConsumed': _totalPlantsSelectedOrangeConsumed,
        'totalPlantsSelectedYellowConsumed': _totalPlantsSelectedYellowConsumed,
        'totalPlantsSelectedGreenConsumed': _totalPlantsSelectedGreenConsumed,
        'totalPlantsSelectedPurpleConsumed': _totalPlantsSelectedPurpleConsumed,
        'totalPlantsSelectedBrownConsumed': _totalPlantsSelectedBrownConsumed,
        'totalPlantsSelectedWhiteConsumed': _totalPlantsSelectedWhiteConsumed,
        'colorsConsumed': _colorsConsumed,
        'plantsConsumedMonday': _plantsConsumedMonday,
        'plantsConsumedTuesday': _plantsConsumedTuesday,
        'plantsConsumedWednesday': _plantsConsumedWednesday,
        'plantsConsumedThursday': _plantsConsumedThursday,
        'plantsConsumedFriday': _plantsConsumedFriday,
        'plantsConsumedSaturday': _plantsConsumedSaturday,
        'plantsConsumedSunday': _plantsConsumedSunday,
        'plantsperdayCounter': _plantsperdayCounter,
        'dayOfWeek': _dayOfWeek,
        'totalPortionsMonday': _totalPortionsMonday,
        'totalPortionsTuesday': _totalPortionsTuesday,
        'totalPortionsWednesday': _totalPortionsWednesday,
        'totalPortionsThursday': _totalPortionsThursday,
        'totalPortionsFriday': _totalPortionsFriday,
        'totalPortionsSaturday': _totalPortionsSaturday,
        'totalPortionsSunday': _totalPortionsSunday,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalDistinctPlantsSelected': serializeParam(
          _totalDistinctPlantsSelected,
          ParamType.int,
        ),
        'totalDistinctPlantsConsumed': serializeParam(
          _totalDistinctPlantsConsumed,
          ParamType.int,
        ),
        'totalPlantsSelectedRedConsumed': serializeParam(
          _totalPlantsSelectedRedConsumed,
          ParamType.int,
        ),
        'totalPlantsSelectedOrangeConsumed': serializeParam(
          _totalPlantsSelectedOrangeConsumed,
          ParamType.int,
        ),
        'totalPlantsSelectedYellowConsumed': serializeParam(
          _totalPlantsSelectedYellowConsumed,
          ParamType.int,
        ),
        'totalPlantsSelectedGreenConsumed': serializeParam(
          _totalPlantsSelectedGreenConsumed,
          ParamType.int,
        ),
        'totalPlantsSelectedPurpleConsumed': serializeParam(
          _totalPlantsSelectedPurpleConsumed,
          ParamType.int,
        ),
        'totalPlantsSelectedBrownConsumed': serializeParam(
          _totalPlantsSelectedBrownConsumed,
          ParamType.int,
        ),
        'totalPlantsSelectedWhiteConsumed': serializeParam(
          _totalPlantsSelectedWhiteConsumed,
          ParamType.int,
        ),
        'colorsConsumed': serializeParam(
          _colorsConsumed,
          ParamType.int,
        ),
        'plantsConsumedMonday': serializeParam(
          _plantsConsumedMonday,
          ParamType.int,
        ),
        'plantsConsumedTuesday': serializeParam(
          _plantsConsumedTuesday,
          ParamType.int,
        ),
        'plantsConsumedWednesday': serializeParam(
          _plantsConsumedWednesday,
          ParamType.int,
        ),
        'plantsConsumedThursday': serializeParam(
          _plantsConsumedThursday,
          ParamType.int,
        ),
        'plantsConsumedFriday': serializeParam(
          _plantsConsumedFriday,
          ParamType.int,
        ),
        'plantsConsumedSaturday': serializeParam(
          _plantsConsumedSaturday,
          ParamType.int,
        ),
        'plantsConsumedSunday': serializeParam(
          _plantsConsumedSunday,
          ParamType.int,
        ),
        'plantsperdayCounter': serializeParam(
          _plantsperdayCounter,
          ParamType.int,
        ),
        'dayOfWeek': serializeParam(
          _dayOfWeek,
          ParamType.int,
        ),
        'totalPortionsMonday': serializeParam(
          _totalPortionsMonday,
          ParamType.double,
        ),
        'totalPortionsTuesday': serializeParam(
          _totalPortionsTuesday,
          ParamType.double,
        ),
        'totalPortionsWednesday': serializeParam(
          _totalPortionsWednesday,
          ParamType.double,
        ),
        'totalPortionsThursday': serializeParam(
          _totalPortionsThursday,
          ParamType.double,
        ),
        'totalPortionsFriday': serializeParam(
          _totalPortionsFriday,
          ParamType.double,
        ),
        'totalPortionsSaturday': serializeParam(
          _totalPortionsSaturday,
          ParamType.double,
        ),
        'totalPortionsSunday': serializeParam(
          _totalPortionsSunday,
          ParamType.double,
        ),
      }.withoutNulls;

  static PlantsSummarySchemaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PlantsSummarySchemaStruct(
        totalDistinctPlantsSelected: deserializeParam(
          data['totalDistinctPlantsSelected'],
          ParamType.int,
          false,
        ),
        totalDistinctPlantsConsumed: deserializeParam(
          data['totalDistinctPlantsConsumed'],
          ParamType.int,
          false,
        ),
        totalPlantsSelectedRedConsumed: deserializeParam(
          data['totalPlantsSelectedRedConsumed'],
          ParamType.int,
          false,
        ),
        totalPlantsSelectedOrangeConsumed: deserializeParam(
          data['totalPlantsSelectedOrangeConsumed'],
          ParamType.int,
          false,
        ),
        totalPlantsSelectedYellowConsumed: deserializeParam(
          data['totalPlantsSelectedYellowConsumed'],
          ParamType.int,
          false,
        ),
        totalPlantsSelectedGreenConsumed: deserializeParam(
          data['totalPlantsSelectedGreenConsumed'],
          ParamType.int,
          false,
        ),
        totalPlantsSelectedPurpleConsumed: deserializeParam(
          data['totalPlantsSelectedPurpleConsumed'],
          ParamType.int,
          false,
        ),
        totalPlantsSelectedBrownConsumed: deserializeParam(
          data['totalPlantsSelectedBrownConsumed'],
          ParamType.int,
          false,
        ),
        totalPlantsSelectedWhiteConsumed: deserializeParam(
          data['totalPlantsSelectedWhiteConsumed'],
          ParamType.int,
          false,
        ),
        colorsConsumed: deserializeParam(
          data['colorsConsumed'],
          ParamType.int,
          false,
        ),
        plantsConsumedMonday: deserializeParam(
          data['plantsConsumedMonday'],
          ParamType.int,
          false,
        ),
        plantsConsumedTuesday: deserializeParam(
          data['plantsConsumedTuesday'],
          ParamType.int,
          false,
        ),
        plantsConsumedWednesday: deserializeParam(
          data['plantsConsumedWednesday'],
          ParamType.int,
          false,
        ),
        plantsConsumedThursday: deserializeParam(
          data['plantsConsumedThursday'],
          ParamType.int,
          false,
        ),
        plantsConsumedFriday: deserializeParam(
          data['plantsConsumedFriday'],
          ParamType.int,
          false,
        ),
        plantsConsumedSaturday: deserializeParam(
          data['plantsConsumedSaturday'],
          ParamType.int,
          false,
        ),
        plantsConsumedSunday: deserializeParam(
          data['plantsConsumedSunday'],
          ParamType.int,
          false,
        ),
        plantsperdayCounter: deserializeParam(
          data['plantsperdayCounter'],
          ParamType.int,
          false,
        ),
        dayOfWeek: deserializeParam(
          data['dayOfWeek'],
          ParamType.int,
          false,
        ),
        totalPortionsMonday: deserializeParam(
          data['totalPortionsMonday'],
          ParamType.double,
          false,
        ),
        totalPortionsTuesday: deserializeParam(
          data['totalPortionsTuesday'],
          ParamType.double,
          false,
        ),
        totalPortionsWednesday: deserializeParam(
          data['totalPortionsWednesday'],
          ParamType.double,
          false,
        ),
        totalPortionsThursday: deserializeParam(
          data['totalPortionsThursday'],
          ParamType.double,
          false,
        ),
        totalPortionsFriday: deserializeParam(
          data['totalPortionsFriday'],
          ParamType.double,
          false,
        ),
        totalPortionsSaturday: deserializeParam(
          data['totalPortionsSaturday'],
          ParamType.double,
          false,
        ),
        totalPortionsSunday: deserializeParam(
          data['totalPortionsSunday'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'PlantsSummarySchemaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PlantsSummarySchemaStruct &&
        totalDistinctPlantsSelected == other.totalDistinctPlantsSelected &&
        totalDistinctPlantsConsumed == other.totalDistinctPlantsConsumed &&
        totalPlantsSelectedRedConsumed ==
            other.totalPlantsSelectedRedConsumed &&
        totalPlantsSelectedOrangeConsumed ==
            other.totalPlantsSelectedOrangeConsumed &&
        totalPlantsSelectedYellowConsumed ==
            other.totalPlantsSelectedYellowConsumed &&
        totalPlantsSelectedGreenConsumed ==
            other.totalPlantsSelectedGreenConsumed &&
        totalPlantsSelectedPurpleConsumed ==
            other.totalPlantsSelectedPurpleConsumed &&
        totalPlantsSelectedBrownConsumed ==
            other.totalPlantsSelectedBrownConsumed &&
        totalPlantsSelectedWhiteConsumed ==
            other.totalPlantsSelectedWhiteConsumed &&
        colorsConsumed == other.colorsConsumed &&
        plantsConsumedMonday == other.plantsConsumedMonday &&
        plantsConsumedTuesday == other.plantsConsumedTuesday &&
        plantsConsumedWednesday == other.plantsConsumedWednesday &&
        plantsConsumedThursday == other.plantsConsumedThursday &&
        plantsConsumedFriday == other.plantsConsumedFriday &&
        plantsConsumedSaturday == other.plantsConsumedSaturday &&
        plantsConsumedSunday == other.plantsConsumedSunday &&
        plantsperdayCounter == other.plantsperdayCounter &&
        dayOfWeek == other.dayOfWeek &&
        totalPortionsMonday == other.totalPortionsMonday &&
        totalPortionsTuesday == other.totalPortionsTuesday &&
        totalPortionsWednesday == other.totalPortionsWednesday &&
        totalPortionsThursday == other.totalPortionsThursday &&
        totalPortionsFriday == other.totalPortionsFriday &&
        totalPortionsSaturday == other.totalPortionsSaturday &&
        totalPortionsSunday == other.totalPortionsSunday;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalDistinctPlantsSelected,
        totalDistinctPlantsConsumed,
        totalPlantsSelectedRedConsumed,
        totalPlantsSelectedOrangeConsumed,
        totalPlantsSelectedYellowConsumed,
        totalPlantsSelectedGreenConsumed,
        totalPlantsSelectedPurpleConsumed,
        totalPlantsSelectedBrownConsumed,
        totalPlantsSelectedWhiteConsumed,
        colorsConsumed,
        plantsConsumedMonday,
        plantsConsumedTuesday,
        plantsConsumedWednesday,
        plantsConsumedThursday,
        plantsConsumedFriday,
        plantsConsumedSaturday,
        plantsConsumedSunday,
        plantsperdayCounter,
        dayOfWeek,
        totalPortionsMonday,
        totalPortionsTuesday,
        totalPortionsWednesday,
        totalPortionsThursday,
        totalPortionsFriday,
        totalPortionsSaturday,
        totalPortionsSunday
      ]);
}

PlantsSummarySchemaStruct createPlantsSummarySchemaStruct({
  int? totalDistinctPlantsSelected,
  int? totalDistinctPlantsConsumed,
  int? totalPlantsSelectedRedConsumed,
  int? totalPlantsSelectedOrangeConsumed,
  int? totalPlantsSelectedYellowConsumed,
  int? totalPlantsSelectedGreenConsumed,
  int? totalPlantsSelectedPurpleConsumed,
  int? totalPlantsSelectedBrownConsumed,
  int? totalPlantsSelectedWhiteConsumed,
  int? colorsConsumed,
  int? plantsConsumedMonday,
  int? plantsConsumedTuesday,
  int? plantsConsumedWednesday,
  int? plantsConsumedThursday,
  int? plantsConsumedFriday,
  int? plantsConsumedSaturday,
  int? plantsConsumedSunday,
  int? plantsperdayCounter,
  int? dayOfWeek,
  double? totalPortionsMonday,
  double? totalPortionsTuesday,
  double? totalPortionsWednesday,
  double? totalPortionsThursday,
  double? totalPortionsFriday,
  double? totalPortionsSaturday,
  double? totalPortionsSunday,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PlantsSummarySchemaStruct(
      totalDistinctPlantsSelected: totalDistinctPlantsSelected,
      totalDistinctPlantsConsumed: totalDistinctPlantsConsumed,
      totalPlantsSelectedRedConsumed: totalPlantsSelectedRedConsumed,
      totalPlantsSelectedOrangeConsumed: totalPlantsSelectedOrangeConsumed,
      totalPlantsSelectedYellowConsumed: totalPlantsSelectedYellowConsumed,
      totalPlantsSelectedGreenConsumed: totalPlantsSelectedGreenConsumed,
      totalPlantsSelectedPurpleConsumed: totalPlantsSelectedPurpleConsumed,
      totalPlantsSelectedBrownConsumed: totalPlantsSelectedBrownConsumed,
      totalPlantsSelectedWhiteConsumed: totalPlantsSelectedWhiteConsumed,
      colorsConsumed: colorsConsumed,
      plantsConsumedMonday: plantsConsumedMonday,
      plantsConsumedTuesday: plantsConsumedTuesday,
      plantsConsumedWednesday: plantsConsumedWednesday,
      plantsConsumedThursday: plantsConsumedThursday,
      plantsConsumedFriday: plantsConsumedFriday,
      plantsConsumedSaturday: plantsConsumedSaturday,
      plantsConsumedSunday: plantsConsumedSunday,
      plantsperdayCounter: plantsperdayCounter,
      dayOfWeek: dayOfWeek,
      totalPortionsMonday: totalPortionsMonday,
      totalPortionsTuesday: totalPortionsTuesday,
      totalPortionsWednesday: totalPortionsWednesday,
      totalPortionsThursday: totalPortionsThursday,
      totalPortionsFriday: totalPortionsFriday,
      totalPortionsSaturday: totalPortionsSaturday,
      totalPortionsSunday: totalPortionsSunday,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PlantsSummarySchemaStruct? updatePlantsSummarySchemaStruct(
  PlantsSummarySchemaStruct? plantsSummarySchema, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    plantsSummarySchema
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPlantsSummarySchemaStructData(
  Map<String, dynamic> firestoreData,
  PlantsSummarySchemaStruct? plantsSummarySchema,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (plantsSummarySchema == null) {
    return;
  }
  if (plantsSummarySchema.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && plantsSummarySchema.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final plantsSummarySchemaData =
      getPlantsSummarySchemaFirestoreData(plantsSummarySchema, forFieldValue);
  final nestedData =
      plantsSummarySchemaData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      plantsSummarySchema.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPlantsSummarySchemaFirestoreData(
  PlantsSummarySchemaStruct? plantsSummarySchema, [
  bool forFieldValue = false,
]) {
  if (plantsSummarySchema == null) {
    return {};
  }
  final firestoreData = mapToFirestore(plantsSummarySchema.toMap());

  // Add any Firestore field values
  plantsSummarySchema.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPlantsSummarySchemaListFirestoreData(
  List<PlantsSummarySchemaStruct>? plantsSummarySchemas,
) =>
    plantsSummarySchemas
        ?.map((e) => getPlantsSummarySchemaFirestoreData(e, true))
        .toList() ??
    [];
