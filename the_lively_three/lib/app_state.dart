import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }


   bool _navFloatingButtonVisibility = false;
  bool get navFloatingButtonVisibility => _navFloatingButtonVisibility;
  set navFloatingButtonVisibility(bool value) {
    _navFloatingButtonVisibility = value;
  }

  String? selectedLanguage = 'en';

  void updateSelectedLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _dayList = prefs
              .getStringList('ff_dayList')
              ?.map((x) {
                try {
                  return DayDataTypeStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _dayList;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _isVisible1 = false;
  bool get isVisible1 => _isVisible1;
  set isVisible1(bool value) {
    _isVisible1 = value;
  }

  bool _isVisible2 = false;
  bool get isVisible2 => _isVisible2;
  set isVisible2(bool value) {
    _isVisible2 = value;
  }

  bool _isVisible3 = false;
  bool get isVisible3 => _isVisible3;
  set isVisible3(bool value) {
    _isVisible3 = value;
  }

  bool _dummy = false;
  bool get dummy => _dummy;
  set dummy(bool value) {
    _dummy = value;
  }

  int _totalWeeklySelectedPlants = 0;
  int get totalWeeklySelectedPlants => _totalWeeklySelectedPlants;
  set totalWeeklySelectedPlants(int value) {
    _totalWeeklySelectedPlants = value;
  }

  int _redWeeklySelectedPlants = 0;
  int get redWeeklySelectedPlants => _redWeeklySelectedPlants;
  set redWeeklySelectedPlants(int value) {
    _redWeeklySelectedPlants = value;
  }

  int _orangeWeeklySelectedPlants = 0;
  int get orangeWeeklySelectedPlants => _orangeWeeklySelectedPlants;
  set orangeWeeklySelectedPlants(int value) {
    _orangeWeeklySelectedPlants = value;
  }

  int _yellowWeeklySelectedPlants = 0;
  int get yellowWeeklySelectedPlants => _yellowWeeklySelectedPlants;
  set yellowWeeklySelectedPlants(int value) {
    _yellowWeeklySelectedPlants = value;
  }

  int _greenWeeklySelectedPlants = 0;
  int get greenWeeklySelectedPlants => _greenWeeklySelectedPlants;
  set greenWeeklySelectedPlants(int value) {
    _greenWeeklySelectedPlants = value;
  }

  int _purpleWeeklySelectedPlants = 0;
  int get purpleWeeklySelectedPlants => _purpleWeeklySelectedPlants;
  set purpleWeeklySelectedPlants(int value) {
    _purpleWeeklySelectedPlants = value;
  }

  int _brownWeeklySelectedPlants = 0;
  int get brownWeeklySelectedPlants => _brownWeeklySelectedPlants;
  set brownWeeklySelectedPlants(int value) {
    _brownWeeklySelectedPlants = value;
  }

  int _whiteWeeklySelectedPlants = 0;
  int get whiteWeeklySelectedPlants => _whiteWeeklySelectedPlants;
  set whiteWeeklySelectedPlants(int value) {
    _whiteWeeklySelectedPlants = value;
  }

  List<ChoiceChipsDataTypeStruct> _choiceChipsSelectedList = [];
  List<ChoiceChipsDataTypeStruct> get choiceChipsSelectedList =>
      _choiceChipsSelectedList;
  set choiceChipsSelectedList(List<ChoiceChipsDataTypeStruct> value) {
    _choiceChipsSelectedList = value;
  }

  void addToChoiceChipsSelectedList(ChoiceChipsDataTypeStruct value) {
    choiceChipsSelectedList.add(value);
  }

  void removeFromChoiceChipsSelectedList(ChoiceChipsDataTypeStruct value) {
    choiceChipsSelectedList.remove(value);
  }

  void removeAtIndexFromChoiceChipsSelectedList(int index) {
    choiceChipsSelectedList.removeAt(index);
  }

  void updateChoiceChipsSelectedListAtIndex(
    int index,
    ChoiceChipsDataTypeStruct Function(ChoiceChipsDataTypeStruct) updateFn,
  ) {
    choiceChipsSelectedList[index] = updateFn(_choiceChipsSelectedList[index]);
  }

  void insertAtIndexInChoiceChipsSelectedList(
      int index, ChoiceChipsDataTypeStruct value) {
    choiceChipsSelectedList.insert(index, value);
  }

  List<ChoiceChipsDataTypeStruct> _locPlantList = [];
  List<ChoiceChipsDataTypeStruct> get locPlantList => _locPlantList;
  set locPlantList(List<ChoiceChipsDataTypeStruct> value) {
    _locPlantList = value;
  }

  void addToLocPlantList(ChoiceChipsDataTypeStruct value) {
    locPlantList.add(value);
  }

  void removeFromLocPlantList(ChoiceChipsDataTypeStruct value) {
    locPlantList.remove(value);
  }

  void removeAtIndexFromLocPlantList(int index) {
    locPlantList.removeAt(index);
  }

  void updateLocPlantListAtIndex(
    int index,
    ChoiceChipsDataTypeStruct Function(ChoiceChipsDataTypeStruct) updateFn,
  ) {
    locPlantList[index] = updateFn(_locPlantList[index]);
  }

  void insertAtIndexInLocPlantList(int index, ChoiceChipsDataTypeStruct value) {
    locPlantList.insert(index, value);
  }

  List<NutrientDataTypeStruct> _nutrientAppStateList = [];
  List<NutrientDataTypeStruct> get nutrientAppStateList =>
      _nutrientAppStateList;
  set nutrientAppStateList(List<NutrientDataTypeStruct> value) {
    _nutrientAppStateList = value;
  }

  void addToNutrientAppStateList(NutrientDataTypeStruct value) {
    nutrientAppStateList.add(value);
  }

  void removeFromNutrientAppStateList(NutrientDataTypeStruct value) {
    nutrientAppStateList.remove(value);
  }

  void removeAtIndexFromNutrientAppStateList(int index) {
    nutrientAppStateList.removeAt(index);
  }

  void updateNutrientAppStateListAtIndex(
    int index,
    NutrientDataTypeStruct Function(NutrientDataTypeStruct) updateFn,
  ) {
    nutrientAppStateList[index] = updateFn(_nutrientAppStateList[index]);
  }

  void insertAtIndexInNutrientAppStateList(
      int index, NutrientDataTypeStruct value) {
    nutrientAppStateList.insert(index, value);
  }

  List<CountryListDataTypeStruct> _countryList = [];
  List<CountryListDataTypeStruct> get countryList => _countryList;
  set countryList(List<CountryListDataTypeStruct> value) {
    _countryList = value;
  }

  void addToCountryList(CountryListDataTypeStruct value) {
    countryList.add(value);
  }

  void removeFromCountryList(CountryListDataTypeStruct value) {
    countryList.remove(value);
  }

  void removeAtIndexFromCountryList(int index) {
    countryList.removeAt(index);
  }

  void updateCountryListAtIndex(
    int index,
    CountryListDataTypeStruct Function(CountryListDataTypeStruct) updateFn,
  ) {
    countryList[index] = updateFn(_countryList[index]);
  }

  void insertAtIndexInCountryList(int index, CountryListDataTypeStruct value) {
    countryList.insert(index, value);
  }

  String _countrySelected = '';
  String get countrySelected => _countrySelected;
  set countrySelected(String value) {
    _countrySelected = value;
  }

  int _idx = 0;
  int get idx => _idx;
  set idx(int value) {
    _idx = value;
  }

  int _countmax = 0;
  int get countmax => _countmax;
  set countmax(int value) {
    _countmax = value;
  }

  String _currentDay = '';
  String get currentDay => _currentDay;
  set currentDay(String value) {
    _currentDay = value;
  }
String _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
String get currentDate => _currentDate;
set currentDate(String value) {
  _currentDate = value;
}


  int _currentDayNumber = 0;
  int get currentDayNumber => _currentDayNumber;
  set currentDayNumber(int value) {
    _currentDayNumber = value;
  }

  int _calendarWeek = 0;
  int get calendarWeek => _calendarWeek;
  set calendarWeek(int value) {
    _calendarWeek = value;
  }

  int _calendarYear = 0;
  int get calendarYear => _calendarYear;
  set calendarYear(int value) {
    _calendarYear = value;
  }

  PlantsSummarySchemaStruct _plantSummary = PlantsSummarySchemaStruct();
  PlantsSummarySchemaStruct get plantSummary => _plantSummary;
  set plantSummary(PlantsSummarySchemaStruct value) {
    _plantSummary = value;
  }

  void updatePlantSummaryStruct(Function(PlantsSummarySchemaStruct) updateFn) {
    updateFn(_plantSummary);
  }

  List<DayDataTypeStruct> _dayList = [];
  List<DayDataTypeStruct> get dayList => _dayList;
  set dayList(List<DayDataTypeStruct> value) {
    _dayList = value;
    prefs.setStringList('ff_dayList', value.map((x) => x.serialize()).toList());
  }

  void addToDayList(DayDataTypeStruct value) {
    dayList.add(value);
    prefs.setStringList(
        'ff_dayList', _dayList.map((x) => x.serialize()).toList());
  }

  void removeFromDayList(DayDataTypeStruct value) {
    dayList.remove(value);
    prefs.setStringList(
        'ff_dayList', _dayList.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromDayList(int index) {
    dayList.removeAt(index);
    prefs.setStringList(
        'ff_dayList', _dayList.map((x) => x.serialize()).toList());
  }

  void updateDayListAtIndex(
    int index,
    DayDataTypeStruct Function(DayDataTypeStruct) updateFn,
  ) {
    dayList[index] = updateFn(_dayList[index]);
    prefs.setStringList(
        'ff_dayList', _dayList.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInDayList(int index, DayDataTypeStruct value) {
    dayList.insert(index, value);
    prefs.setStringList(
        'ff_dayList', _dayList.map((x) => x.serialize()).toList());
  }

  List<WeeklyConsumptionDetailsSchemaStruct> _weeklyConsumptionList = [];
  List<WeeklyConsumptionDetailsSchemaStruct> get weeklyConsumptionList =>
      _weeklyConsumptionList;
  set weeklyConsumptionList(List<WeeklyConsumptionDetailsSchemaStruct> value) {
    _weeklyConsumptionList = value;
  }

  void addToWeeklyConsumptionList(WeeklyConsumptionDetailsSchemaStruct value) {
    weeklyConsumptionList.add(value);
  }

  void removeFromWeeklyConsumptionList(
      WeeklyConsumptionDetailsSchemaStruct value) {
    weeklyConsumptionList.remove(value);
  }

  void removeAtIndexFromWeeklyConsumptionList(int index) {
    weeklyConsumptionList.removeAt(index);
  }

  void updateWeeklyConsumptionListAtIndex(
    int index,
    WeeklyConsumptionDetailsSchemaStruct Function(
            WeeklyConsumptionDetailsSchemaStruct)
        updateFn,
  ) {
    weeklyConsumptionList[index] = updateFn(_weeklyConsumptionList[index]);
  }

  void insertAtIndexInWeeklyConsumptionList(
      int index, WeeklyConsumptionDetailsSchemaStruct value) {
    weeklyConsumptionList.insert(index, value);
  }

  String _screenCategory = '';
  String get screenCategory => _screenCategory;
  set screenCategory(String value) {
    _screenCategory = value;
  }

  bool _genOptIn = false;
  bool get genOptIn => _genOptIn;
  set genOptIn(bool value) {
    _genOptIn = value;
  }

  PanelCoordinatesDataTypeStruct _moodCoordinates =
      PanelCoordinatesDataTypeStruct();
  PanelCoordinatesDataTypeStruct get moodCoordinates => _moodCoordinates;
  set moodCoordinates(PanelCoordinatesDataTypeStruct value) {
    _moodCoordinates = value;
  }

  void updateMoodCoordinatesStruct(
      Function(PanelCoordinatesDataTypeStruct) updateFn) {
    updateFn(_moodCoordinates);
  }

  PanelCoordinatesDataTypeStruct _bodyCoordinates =
      PanelCoordinatesDataTypeStruct();
  PanelCoordinatesDataTypeStruct get bodyCoordinates => _bodyCoordinates;
  set bodyCoordinates(PanelCoordinatesDataTypeStruct value) {
    _bodyCoordinates = value;
  }

  void updateBodyCoordinatesStruct(
      Function(PanelCoordinatesDataTypeStruct) updateFn) {
    updateFn(_bodyCoordinates);
  }

  bool _hasSubscription = false;
  bool get hasSubscription => _hasSubscription;
  set hasSubscription(bool value) {
    _hasSubscription = value;
  }

  NutrientBoundDataTypeStruct _nutrientBounds = NutrientBoundDataTypeStruct();
  NutrientBoundDataTypeStruct get nutrientBounds => _nutrientBounds;
  set nutrientBounds(NutrientBoundDataTypeStruct value) {
    _nutrientBounds = value;
  }

  void updateNutrientBoundsStruct(
      Function(NutrientBoundDataTypeStruct) updateFn) {
    updateFn(_nutrientBounds);
  }

  String _signupVerificationStatus = 'unverified';
  String get signupVerificationStatus => _signupVerificationStatus;
  set signupVerificationStatus(String value) {
    _signupVerificationStatus = value;
  }

  String _onboardPreset = '';
  String get onboardPreset => _onboardPreset;
  set onboardPreset(String value) {
    _onboardPreset = value;
  }

  DateTime? _birthday;
  DateTime? get birthday => _birthday;
  set birthday(DateTime? value) {
    _birthday = value;
  }

  List<LocPlantSelectionListSchemaStruct> _locplantselectionlist = [];
  List<LocPlantSelectionListSchemaStruct> get locplantselectionlist =>
      _locplantselectionlist;
  set locplantselectionlist(List<LocPlantSelectionListSchemaStruct> value) {
    _locplantselectionlist = value;
  }

  void addToLocplantselectionlist(LocPlantSelectionListSchemaStruct value) {
    locplantselectionlist.add(value);
  }

  void removeFromLocplantselectionlist(
      LocPlantSelectionListSchemaStruct value) {
    locplantselectionlist.remove(value);
  }

  void removeAtIndexFromLocplantselectionlist(int index) {
    locplantselectionlist.removeAt(index);
  }

  void updateLocplantselectionlistAtIndex(
    int index,
    LocPlantSelectionListSchemaStruct Function(
            LocPlantSelectionListSchemaStruct)
        updateFn,
  ) {
    locplantselectionlist[index] = updateFn(_locplantselectionlist[index]);
  }

  void insertAtIndexInLocplantselectionlist(
      int index, LocPlantSelectionListSchemaStruct value) {
    locplantselectionlist.insert(index, value);
  }

  double _userProteinValue = 0.0;
  double get userProteinValue => _userProteinValue;
  set userProteinValue(double value) {
    _userProteinValue = value;
  }

  double _userFiberValue = 0.0;
  double get userFiberValue => _userFiberValue;
  set userFiberValue(double value) {
    _userFiberValue = value;
  }

  String _nextUpdateJob = '';
  String get nextUpdateJob => _nextUpdateJob;
  set nextUpdateJob(String value) {
    _nextUpdateJob = value;
  }

  WeeklyIndicatorsDataTypeStruct _individualIndicators =
      WeeklyIndicatorsDataTypeStruct();
  WeeklyIndicatorsDataTypeStruct get individualIndicators =>
      _individualIndicators;
  set individualIndicators(WeeklyIndicatorsDataTypeStruct value) {
    _individualIndicators = value;
  }

  void updateIndividualIndicatorsStruct(
      Function(WeeklyIndicatorsDataTypeStruct) updateFn) {
    updateFn(_individualIndicators);
  }

  DashboardComIndBundleDataTypeStruct _communityIndicators =
      DashboardComIndBundleDataTypeStruct();
  DashboardComIndBundleDataTypeStruct get communityIndicators =>
      _communityIndicators;
  set communityIndicators(DashboardComIndBundleDataTypeStruct value) {
    _communityIndicators = value;
  }

  void updateCommunityIndicatorsStruct(
      Function(DashboardComIndBundleDataTypeStruct) updateFn) {
    updateFn(_communityIndicators);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
