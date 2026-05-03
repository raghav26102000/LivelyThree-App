import 'package:flutter/services.dart';
import 'package:the_lively_three/components/consumption_card/consumption_card_widget.dart';
import 'package:the_lively_three/components/plant_selection_filter/plant_selection_filter_widget.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_icon_button.dart';

import '../../custom_code/widgets/weekly_item_card.dart' show WeeklyItemCard;
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'plantselection_model.dart';
export 'plantselection_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:intl/intl.dart';
import '/l10n/app_localizations.dart';
import '/providers/locale_provider.dart' as locale_provider;

// DATA MODELS

class WeeklyPlantMetrics {
  final int id;
  final int week;
  final int idLoc;
  final String plantname;
  final String? color;
  final double portionsize;
  final double portionsum;
  final double average4w;
  final double? fiber;
  final double? protein;
  final int localizedPlantId;
  final double weeklyTotal;
  final int blueprintId;
  final double timesConsumed;
  final int category;
  final double? selectedNutrientValue;
  final bool? inthirdrule; // ADD THIS LINE
  final double? lastPortionSize; // 🆕 NEW FIELD

  WeeklyPlantMetrics({
    required this.id,
    required this.week,
    required this.idLoc,
    required this.plantname,
    required this.color,
    required this.portionsize,
    required this.portionsum,
    required this.average4w,
    required this.fiber,
    required this.protein,
    required this.localizedPlantId,
    required this.weeklyTotal,
    required this.blueprintId,
    required this.timesConsumed,
    required this.category,
    this.selectedNutrientValue,
    this.inthirdrule, // ADD THIS LINE
    this.lastPortionSize, // 🆕 NEW PARAMETER
  });

  factory WeeklyPlantMetrics.fromMap(Map<String, dynamic> m) {
    double _d(Object? v, [double fallback = 0.0]) {
      if (v == null) return fallback;
      if (v is num) return v.toDouble();
      final s = v.toString().trim();
      if (s.isEmpty) return fallback;
      return double.tryParse(s) ?? fallback;
    }

    double? _dn(Object? v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      return double.tryParse(s);
    }

    int _i(Object? v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? fallback;
    }

    // ADD THIS HELPER FUNCTION
    bool _b(Object? v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final str = v.toString().toLowerCase();
      return str == 'true' || str == '1' || str == 't' || str == 'yes';
    }

    if (m.isEmpty) {
      throw ArgumentError('Map cannot be empty');
    }

    return WeeklyPlantMetrics(
      id: _i(m['id']),
      week: _i(m['week']),
      idLoc: _i(m['id_loc']),
      blueprintId: _i(m['id_blueprint']),
      plantname: (m['plantname'] ?? 'Unknown') as String,
      color: m['color'] as String?,
      portionsize: _d(m['portionsize']),
      weeklyTotal: _d(m['weekly_total'] ?? 0.0),
      average4w: _d(m['avg_consumption_4weeks'] ?? 0.0),
      timesConsumed: _d(m['times_consumed'] ?? 0.0),
      fiber: _dn(m['fiber_value'] ?? m['fiber']),
      protein: _dn(m['protein_value'] ?? m['protein']),
      localizedPlantId: _i(m['original_localized_id'] ?? m['original_id']),
      portionsum: _d(m['portion_consumed'] ?? 0.0),
      category: _i(m['category_code'] ?? 0),
      selectedNutrientValue: _dn(m['selected_nutrient_value']),
      inthirdrule: m.containsKey('inthirdrule')
          ? _b(m['inthirdrule'])
          : null, // ADD THIS LINE
      lastPortionSize: _dn(m['last_portion_size']), // 🆕 NEW FIELD PARSING
    );
  }
}

// ALSO UPDATE THE ConsumptionChipItems CLASS

class ConsumptionChipItems {
  final String plantname;
  final String? color;
  final double portionPlant;
  final String uom;
  final int dietary_source;
  final int? dayNumber;
  final bool? inthirdrule; // ADD THIS LINE

  ConsumptionChipItems({
    required this.plantname,
    required this.color,
    required this.portionPlant,
    required this.uom,
    required this.dietary_source,
    required this.dayNumber,
    this.inthirdrule, // ADD THIS LINE
  });

  static int _asInt(dynamic v) =>
      v == null ? 0 : (v is num ? v.toInt() : int.tryParse(v.toString()) ?? 0);

  // ADD THIS HELPER
  static bool _asBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final str = v.toString().toLowerCase();
    return str == 'true' || str == '1' || str == 't' || str == 'yes';
  }

  factory ConsumptionChipItems.fromMap(Map<String, dynamic> m) {
    final anyPortion = m['portionsum'] ?? m['portionPlant'] ?? m['portionSum'];
    final portion =
        anyPortion is num ? anyPortion : num.tryParse('$anyPortion') ?? 0;
    return ConsumptionChipItems(
      plantname: (m['plantname'] ?? '').toString(),
      color: m['color']?.toString(),
      portionPlant: portion.toDouble(),
      uom: (m['uom'] ?? '').toString(),
      dietary_source: _asInt(m['dietary_source']),
      dayNumber: m['daynumber'] != null ? _asInt(m['daynumber']) : null,
      inthirdrule: m.containsKey('inthirdrule')
          ? _asBool(m['inthirdrule'])
          : null, // ADD THIS LINE
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'plantname': plantname,
      'color': color,
      'portionSum': portionPlant,
      'uom': uom,
      'dietary_source': dietary_source,
    };

    if (inthirdrule != null) {
      json['inthirdrule'] = inthirdrule;
    }

    return json;
  }

  @override
  String toString() => jsonEncode(toJson());
}

enum _SortMode {
  popular,
  alphabetic,
  fiber,
  protein,
  portionsum,
  micronutrients
}

class PlantselectionWidget extends StatefulWidget {
  final int dietarySource;
  const PlantselectionWidget({
    super.key,
    required this.dietarySource,
  });

  static String routeName = 'Plantselection';
  static String routePath = '/plantselection';

  @override
  State<PlantselectionWidget> createState() => _PlantselectionWidgetState();
}

class _ChipItem {
  final String plantname;
  final String colorTag;
  final double portionPlant;
  const _ChipItem(this.plantname, this.colorTag, this.portionPlant);
  _ChipItem copyWith(
          {String? plantname, String? colorTag, double? portionPlant}) =>
      _ChipItem(plantname ?? this.plantname, colorTag ?? this.colorTag,
          portionPlant ?? this.portionPlant);
}

class CategoryLookupService {
  static Map<int, Map<String, String?>> _categoryCache = {};
  static bool _cacheLoaded = false;

  static Future<void> _loadCategoryLookup() async {
    if (_cacheLoaded) return;

    try {
      final client = Supabase.instance.client;
      final result = await client
          .from('codelkup')
          .select('keycode, key1, key2')
          .eq('lkcode', 'food_item_category')
          .eq('status', 1);

      _categoryCache.clear();

      for (final row in result) {
        final keycode = row['keycode'] as int?;
        final key1 = row['key1']?.toString();
        final key2 = row['key2']?.toString();

        if (keycode != null) {
          _categoryCache[keycode] = {
            'name': key1,
            'icon': key2?.isNotEmpty == true ? key2 : null,
          };
        }
      }

      _cacheLoaded = true;
    } catch (e) {
      print('Error loading category lookup: $e');
    }
  }

  static Future<Map<String, String?>?> getCategoryData(
      int? categoryCode) async {
    if (categoryCode == null) return null;
    await _loadCategoryLookup();
    return _categoryCache[categoryCode];
  }

  static Future<String?> getCategoryName(int? categoryCode) async {
    final data = await getCategoryData(categoryCode);
    return data?['name'];
  }

  static Future<String?> getCategoryIcon(int? categoryCode) async {
    final data = await getCategoryData(categoryCode);
    return data?['icon'];
  }
}

class _PlantselectionWidgetState extends State<PlantselectionWidget> {
  late PlantselectionModel _model;
  late DateTime _selectedDate;
  Locale? currentLocale;
  int _refreshCounter = 0;
  double extraSpace = 0;
  Set<String> selectedColors = {};
  bool allSelected = true;
  _SortMode _sortMode = _SortMode.portionsum;

  List<WeeklyPlantMetrics> _all = [];
  List<WeeklyPlantMetrics> _filtered = [];
  bool _loadingList = true;
  String? _loadListError;
  List<ConsumptionChipItems> _weekRows = [];
  bool _loading = false;
  String? _error;
  late List<ConsumptionChipItems> consumptionTodaySorted = [];

  // List<_ChipItem> _chipsForSelectedDay = [];
  bool _loadingHeader = false;
  Map<int, String?> _categoryIcons = {};
  Map<String, dynamic>? selectedVitamin;
  bool isFilteringByVitamin = false;
  Set<int> selectedCategories = {};
  bool allCategoriesSelected = true;
  List<Map<String, dynamic>> availableCategories = [];

  // 🔥 NEW: Track if initial data load has completed
  bool _hasInitiallyLoaded = false;
  bool _loadingCategories = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> colors = [
    {"name": "Red", "short": "R", "color": Colors.red},
    {"name": "Orange", "short": "O", "color": Colors.orange},
    {"name": "Yellow", "short": "Y", "color": Colors.yellow.shade700},
    {"name": "Green", "short": "G", "color": Colors.green},
    {"name": "Purple", "short": "P", "color": Colors.purple},
    {"name": "Brown", "short": "B", "color": Colors.brown},
    {"name": "White", "short": "W", "color": Colors.grey},
  ];

  bool _isWeekChanged = false;

  DateTime _dateOnlyLocal(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _todayLocal() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

// Add a new state variable to track if filters should be hidden
  bool _hideFilters = false;

// Modified _loadAvailableCategories method
  Future<void> _loadAvailableCategories() async {
    if (widget.dietarySource == 1) return; // Skip for plants

    setState(() => _loadingCategories = true);

    try {
      final client = Supabase.instance.client;

      // First, fetch distinct category codes from blueprintplant for this dietary source
      final distinctCategories = await client
          .from('blueprintfooditem')
          .select('category_code')
          .eq('dietary_source', widget.dietarySource);

      final categoryCodes = (distinctCategories as List)
          .map((row) => row['category_code'] as int?)
          .where((code) => code != null) // Filter nulls here
          .cast<int>() // Cast to non-nullable int
          .toSet()
          .toList();

      // Check if -1 is in the list
      if (categoryCodes.contains(-1)) {
        if (mounted) {
          setState(() {
            _hideFilters = true;
            availableCategories = [];
            _loadingCategories = false;
          });
        }
        return;
      }

      // If no -1, fetch category details from codelkup
      if (categoryCodes.isEmpty) {
        if (mounted) {
          setState(() {
            _hideFilters = false;
            availableCategories = [];
            _loadingCategories = false;
          });
        }
        return;
      }

      final result = await client
          .from('codelkup')
          .select('keycode, key1, key2')
          .eq('lkcode', 'food_item_category')
          .eq('status', 1)
          .inFilter('keycode', categoryCodes)
          .order('key3', ascending: true);

      final categories = (result as List)
          .map((row) => {
                'code': row['keycode'] as int,
                'name': row['key1'] as String? ?? 'Unknown',
                'icon': row['key2'] as String?,
              })
          .toList();

      if (mounted) {
        setState(() {
          _hideFilters = false;
          availableCategories = categories;
          _loadingCategories = false;
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      if (mounted) {
        setState(() {
          _hideFilters = false;
          _loadingCategories = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlantselectionModel());

    _selectedDate = _todayLocal();
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController(text: '1');
    _model.textFieldFocusNode2 ??= FocusNode();

    CategoryLookupService._loadCategoryLookup();
    _loadAvailableCategories();

    _selectedDate = _seedDateFromAppState();
    // 🔥 REMOVED: _fetchWeeklyConsumption() will be called from didChangeDependencies via _reloadHeaderAndListForSelectedDate

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _fetchWeeklyConsumption() async {
    try {
      if (!mounted) return;
      final client = Supabase.instance.client;

      final int calendarWeek = FFAppState().calendarWeek;
      final int calendarYear = FFAppState().calendarYear;
      final int dietarySource = widget.dietarySource;

      final result = await client
          .from('vw_daily_plant_summary')
          .select('*')
          .eq('calendaryear', calendarYear)
          .eq('week', calendarWeek)
          .eq('user_id', currentUserUid)
          .eq('dietary_source', dietarySource);

      final rows = result.map((e) => ConsumptionChipItems.fromMap(e)).toList();

      final consumptionToday = rows
          .where((e) =>
              (e.dayNumber) == FFAppState().currentDayNumber &&
              e.dietary_source == dietarySource)
          .toList();
      const order = [
        'Red',
        'Orange',
        'Yellow',
        'Green',
        'Purple',
        'Brown',
        'White'
      ];
      final colorOrdered = order
          .expand((c) => consumptionToday.where((e) => (e.color ?? '') == c))
          .toList();
      if (!mounted) return;
      setState(() {
        _weekRows = rows;
        consumptionTodaySorted =
            (dietarySource == 1) ? colorOrdered : consumptionToday;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
      print('fetch error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  double calculateTotalPortions(
    List<ConsumptionChipItems> data, {
    int? dietarySource,
  }) {
    double total = 0.0;
    for (final row in data) {
      if (row.dietary_source == dietarySource) {
        total += (row.portionPlant ?? 0.0);
      }
    }
    return total;
  }

  double calculateThirdRulePortions(
    List<ConsumptionChipItems> data, {
    int? dietarySource,
  }) {
    double total = 0.0;
    for (final row in data) {
      if (row.dietary_source == dietarySource && row.inthirdrule == true) {
        total += (row.portionPlant ?? 0.0);
      }
    }
    return total;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocale = Provider.of<locale_provider.FFAppState>(context).locale;

    // 🔥 FIX: Only load data on first call, not on every rebuild
    if (!_hasInitiallyLoaded) {
      _hasInitiallyLoaded = true;
      _reloadHeaderAndListForSelectedDate(initial: true);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // NEW: Helper method to get configuration based on dietary source
  Map<String, dynamic> _getDietarySourceConfig() {
    switch (widget.dietarySource) {
      case 1: // Plants
        return {
          'title': AppLocalizations.of(context)?.consumptions ?? '',
          'addText': AppLocalizations.of(context)?.addPlant,
          'unit': 'g',
          'dailyTarget': 500,
          'showColorFilter': true,
          'showNutrientSort': true,
          'showAlphabeticSort': true,
          'showMicroNutrientSort': true,
          'showSearch': true,
          'defaultMessage': AppLocalizations.of(context)?.plantmsg,
        };
      case 2: // Animal Products
        return {
          'title': AppLocalizations.of(context)?.animalProductsTitle,
          'addText': AppLocalizations.of(context)?.addAnimalProducts,
          'unit': 'g',
          'dailyTarget': 200,
          'showColorFilter': false,
          'showCategoryFilter': true,
          'showNutrientSort': true,
          'showAlphabeticSort': true,
          'showMicroNutrientSort': true,
          'showSearch': true,
          'defaultMessage': AppLocalizations.of(context)?.productmsg,
        };
      case 3: // UPF
        return {
          'title': AppLocalizations.of(context)?.upfTitle,
          'addText': AppLocalizations.of(context)?.addUpf,
          'unit': 'g',
          'dailyTarget': 100,
          'showColorFilter': false,
          'showNutrientSort': false,
          'showCategoryFilter': true,
          'showAlphabeticSort': true,
          'showMicroNutrientSort': true,
          'showSearch': true,
          'defaultMessage': AppLocalizations.of(context)?.productmsg,
        };
      case 4: // Water
        return {
          'title': AppLocalizations.of(context)?.water,
          'addText': AppLocalizations.of(context)?.addWater,
          'unit': 'ml',
          'dailyTarget': 2000,
          'showColorFilter': false,
          'showNutrientSort': false,
          'showCategoryFilter': false,
          'showAlphabeticSort': false,
          'showMicroNutrientSort': false,
          'showSearch': false,
          'defaultMessage': AppLocalizations.of(context)?.defaultMsg,
        };
      default:
        return {
          'title': AppLocalizations.of(context)?.consumptions ?? '',
          'addText': AppLocalizations.of(context)?.addText,
          'unit': 'g',
          'dailyTarget': 500,
          'showColorFilter': false,
          'showNutrientSort': false,
          'defaultMessage': AppLocalizations.of(context)?.productmsg,
        };
    }
  }

  DateTime _seedDateFromAppState() {
    try {
      return DateTime.now();
    } catch (_) {
      return DateTime.now();
    }
  }

  (int week, int year) get _selectedIsoWeekYear {
    final d = _selectedDate;
    final thursday = d.add(Duration(days: 3 - ((d.weekday + 6) % 7)));
    final isoYear = thursday.year;
    final firstThursday = DateTime(isoYear, 1, 4);
    final firstWeekStart =
        firstThursday.subtract(Duration(days: (firstThursday.weekday + 6) % 7));
    final week = 1 + ((thursday.difference(firstWeekStart).inDays) ~/ 7);
    return (week, isoYear);
  }

  String get _selectedWeekdayName {
    return dateTimeFormat('EEEE', _selectedDate);
  }

  Future<void> _reloadHeaderAndListForSelectedDate(
      {bool initial = false}) async {
    FFAppState().currentDay = _selectedWeekdayName;

    final (w, y) = _selectedIsoWeekYear;
    final prevW = FFAppState().calendarWeek;
    final prevY = FFAppState().calendarYear;
    _isWeekChanged = (w != prevW) || (y != prevY);
    if (_isWeekChanged || initial) {
      FFAppState().calendarWeek = w;
      FFAppState().calendarYear = y;

      // 🔥 FIX: Load consumption data first, then plant metrics
      await _fetchWeeklyConsumption();
      await _fetchWeeklyPlantMetrics(
          currentUserUid, w, y, null, currentLocale.toString());
    }
  }

  Future<void> _fetchWeeklyPlantMetrics(
    String userId,
    int week,
    int year,
    String? color,
    String currentLocale, {
    int? nutrientId,
  }) async {
    if (!mounted) return;
    setState(() {
      _loadingList = true;
      _loadListError = null;
      _all = [];
      _filtered = [];
    });

    final int dietarySource = widget.dietarySource;

    String rpcFunction;
    Map<String, dynamic> params;

    if (nutrientId != null && isFilteringByVitamin) {
      rpcFunction = 'get_localized_plants_by_nutrient';
      params = {
        'p_user_id': userId,
        'p_week': week,
        'p_year': year,
        'p_locale': currentLocale,
        'p_nutrient_id': nutrientId,
        'p_color': color,
        'p_dietary_source': dietarySource,
      };
    } else {
      rpcFunction = 'get_localized_plants_with_consumption';
      params = {
        'p_user_id': userId,
        'p_week': week,
        'p_year': year,
        'p_color': color,
        'p_locale': currentLocale,
        'p_dietary_source': dietarySource,
      };
    }

    print('RPC function: $rpcFunction');
    print('RPC parameters: $params');

    try {
      final data =
          await Supabase.instance.client.rpc(rpcFunction, params: params);
      final rows = (data as List).cast<Map<String, dynamic>>();
      final plants = rows.map((m) => WeeklyPlantMetrics.fromMap(m)).toList();

      if (!mounted) return;
      setState(() {
        _all = plants;
        _loadingList = false;
      });
      _applyFilter();
    } catch (e, st) {
      debugPrint('RPC error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _loadingList = false;
        _loadListError = e.toString();
      });
    }
  }

  void _openMicronutrientFilter() async {
    try {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => PlantSelectionFilterWidget(),
      );

      if (result != null) {
        if (result.containsKey('selectedVitamin')) {
          final vitamin = result['selectedVitamin'] as Map<String, dynamic>?;

          if (vitamin != null) {
            if (mounted) {
              setState(() {
                selectedVitamin = vitamin;
                isFilteringByVitamin = true;
                _sortMode = _SortMode.micronutrients;
              });
            }

            final (isoWeek, isoYear) = _selectedIsoWeekYear;
            await _fetchWeeklyPlantMetrics(
              currentUserUid,
              isoWeek,
              isoYear,
              null,
              currentLocale.toString(),
              nutrientId: vitamin['id'] as int,
            );
          } else {
            print('DEBUG: Vitamin is null');
          }
        } else {
          print(
              'DEBUG: Result does not contain selectedVitamin key. Keys: ${result.keys}');
        }
      } else {
        print('DEBUG: Result is null - user probably cancelled');
      }
    } catch (e, stackTrace) {
      print('DEBUG: Error in _openMicronutrientFilter: $e, $stackTrace');
    }
  }

  void _clearVitaminFilter() async {
    if (!mounted) return;
    setState(() {
      selectedVitamin = null;
      isFilteringByVitamin = false;
      if (_sortMode == _SortMode.micronutrients) {
        _sortMode = _SortMode.portionsum;
      }
    });

    final (isoWeek, isoYear) = _selectedIsoWeekYear;
    await _fetchWeeklyPlantMetrics(
      currentUserUid,
      isoWeek,
      isoYear,
      null,
      currentLocale.toString(),
    );
  }

  void _applyFilter() {
    if (!mounted) return;
    final q = (_model.textController1?.text ?? '').trim().toLowerCase();
    var list = List<WeeklyPlantMetrics>.from(_all);

    if (widget.dietarySource == 1 &&
        !allSelected &&
        selectedColors.isNotEmpty) {
      list = list.where((r) => selectedColors.contains(r.color ?? '')).toList();
    }

    // Category filter (for dietary source 2)
    if (widget.dietarySource != 1 &&
        !allCategoriesSelected &&
        selectedCategories.isNotEmpty) {
      list =
          list.where((r) => selectedCategories.contains(r.category)).toList();
    }

    // text search
    if (q.isNotEmpty) {
      list = list.where((r) => r.plantname.toLowerCase().contains(q)).toList();
    }

    list.sort((a, b) {
      switch (_sortMode) {
        case _SortMode.portionsum:
          final lhs = b.portionsum.compareTo(a.portionsum);
          if (lhs != 0) return lhs;
          return a.plantname.toLowerCase().compareTo(b.plantname.toLowerCase());
        case _SortMode.popular:
          final lhs = b.average4w.compareTo(a.average4w);
          if (lhs != 0) return lhs;
          return a.plantname.toLowerCase().compareTo(b.plantname.toLowerCase());
        case _SortMode.alphabetic:
          return a.plantname.toLowerCase().compareTo(b.plantname.toLowerCase());
        case _SortMode.fiber:
          final af = a.fiber ?? -1;
          final bf = b.fiber ?? -1;
          final cmp = bf.compareTo(af);
          if (cmp != 0) return cmp;
          return a.plantname.toLowerCase().compareTo(b.plantname.toLowerCase());
        case _SortMode.protein:
          final ap = a.protein ?? -1;
          final bp = b.protein ?? -1;
          final cmp = bp.compareTo(ap);
          if (cmp != 0) return cmp;
          return a.plantname.toLowerCase().compareTo(b.plantname.toLowerCase());
        case _SortMode.micronutrients:
          final aNutrient = a.selectedNutrientValue ?? -1;
          final bNutrient = b.selectedNutrientValue ?? -1;
          final cmp = bNutrient.compareTo(aNutrient);
          if (cmp != 0) return cmp;
          return a.plantname.toLowerCase().compareTo(b.plantname.toLowerCase());
      }
    });
    if (!mounted) return;
    setState(() => _filtered = list);
    _loadCategoryIcons();
  }

  Future<void> _loadCategoryIcons() async {
    Set<int> categoryCodes = _filtered
        .where((plant) =>
            plant != null && plant.category != null && plant.category != 0)
        .map((plant) => plant.category!)
        .toSet();

    for (int categoryCode in categoryCodes) {
      try {
        final icon = await CategoryLookupService.getCategoryIcon(categoryCode);
        _categoryIcons[categoryCode] = icon;
      } catch (e) {
        print('Error loading category icon for code $categoryCode: $e');
        _categoryIcons[categoryCode] = null;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _reloadConsumptionForSelectedWeek(int week, int year) async {
    if (!mounted) return;
    setState(() => _loadingHeader = true);
    try {
      await actions.getConsumptionDetailUpdate(
        week,
        currentUserUid,
        year,
      );
    } catch (e, st) {
      debugPrint('getConsumptionDetailUpdate error: $e\n$st');
    } finally {
      if (!mounted) return;
      setState(() => _loadingHeader = false);
    }
  }

  void _onDateChanged() async {
    FFAppState().currentDay = DateFormat('EEEE').format(_selectedDate);
    FFAppState().currentDayNumber = _selectedDate.weekday;
    await _reloadHeaderAndListForSelectedDate(initial: false);
    await _fetchWeeklyConsumption();

    setState(() {});
  }

  void _goToPrevDay() {
    final prev =
        _dateOnlyLocal(_selectedDate).subtract(const Duration(days: 1));

    final (currWeek, currYear) = _selectedIsoWeekYear;

    final d = prev;
    final thursday = d.add(Duration(days: 3 - ((d.weekday + 6) % 7)));
    final isoYear = thursday.year;
    final firstThursday = DateTime(isoYear, 1, 4);
    final firstWeekStart =
        firstThursday.subtract(Duration(days: (firstThursday.weekday + 6) % 7));
    final week = 1 + ((thursday.difference(firstWeekStart).inDays) ~/ 7);
    final newWeek = (week, isoYear);

    if (newWeek != (currWeek, currYear)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please subscribe to check historic data.'),
        ),
      );
      return;
    }
    if (!mounted) return;
    setState(() => _selectedDate = prev);
    _onDateChanged();
  }

  void _goToNextDay() {
    final candidate =
        _dateOnlyLocal(_selectedDate).add(const Duration(days: 1));
    final today = _todayLocal();

    if (candidate.isAfter(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.cannotSelectFutureDate)),
      );
      return;
    }
    if (!mounted) return;
    setState(() => _selectedDate = candidate);
    _onDateChanged();
  }

  Color _colorFor(String? name) {
    switch ((name ?? '').toLowerCase()) {
      case 'red':
        return Colors.red.shade700;
      case 'orange':
        return Colors.orange.shade700;
      case 'yellow':
        return Colors.yellow.shade700;
      case 'green':
        return Colors.green.shade700;
      case 'purple':
        return Colors.purple.shade700;
      case 'brown':
        return Colors.brown.shade700;
      case 'white':
        return Colors.grey.shade700;
      default:
        return FlutterFlowTheme.of(context).primary;
    }
  }

  Color _chipColorFromTag(String? tag) {
    switch ((tag ?? '').toLowerCase()) {
      case 'red':
        return const Color(0xFFE53935);
      case 'orange':
        return const Color(0xFFF57C00);
      case 'yellow':
        return const Color(0xFFFBC02D);
      case 'green':
        return const Color(0xFF43A047);
      case 'purple':
        return const Color(0xFF8E24AA);
      case 'brown':
        return const Color(0xFF795548);
      case 'white':
        return const Color(0xFFBDBDBD);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Widget _sortChip(
      {required String label,
      required bool selected,
      required VoidCallback onTap,
      List<Color>? gradientColors,
      Widget icon = const SizedBox(width: 0, height: 0),
      String iconPosition = 'left'}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).alternate,
          border: selected
              ? Border.all(
                  color: FlutterFlowTheme.of(context).primary, width: 1)
              : Border.all(
                  color: FlutterFlowTheme.of(context).alternate, width: 1),
          borderRadius: BorderRadius.circular(16),
          gradient: (gradientColors != null)
              ? LinearGradient(
                  colors: gradientColors!,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (iconPosition == 'left') icon,
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                  color: FlutterFlowTheme.of(context).textGrey,
                  height: 1.65,
                ),
          ),
          if (iconPosition == 'right') icon,
        ]),
      ),
    );
  }

  void _onPortionAdded(String plantname, String colorTag, double delta) async {
    if (!mounted) return;

    // Find the plant in _all list to get its inthirdrule value
    bool? inthirdrule;
    for (var plant in _all) {
      if (plant.plantname.toLowerCase() == plantname.toLowerCase()) {
        inthirdrule = plant.inthirdrule;
        break;
      }
    }

    // 🔥 FIX: Combine both updates into single setState to avoid intermediate rebuilds
    setState(() {
      // Update consumption chips
      final existingIndex = consumptionTodaySorted.indexWhere(
          (item) => item.plantname.toLowerCase() == plantname.toLowerCase());

      if (existingIndex != -1) {
        final existingItem = consumptionTodaySorted[existingIndex];
        final updatedItem = ConsumptionChipItems(
          plantname: existingItem.plantname,
          color: existingItem.color,
          portionPlant: existingItem.portionPlant + delta,
          uom: existingItem.uom,
          dietary_source: existingItem.dietary_source,
          dayNumber: existingItem.dayNumber,
          inthirdrule: inthirdrule ?? existingItem.inthirdrule,
        );
        consumptionTodaySorted[existingIndex] = updatedItem;
      } else {
        final newItem = ConsumptionChipItems(
          plantname: plantname,
          color: colorTag,
          portionPlant: delta,
          uom: 'g',
          dietary_source: widget.dietarySource,
          dayNumber: FFAppState().currentDayNumber,
          inthirdrule: inthirdrule,
        );
        consumptionTodaySorted.add(newItem);
        _sortConsumptionByColorOrder();
      }

      // Update plant list
      for (int i = 0; i < _all.length; i++) {
        if (_all[i].plantname.toLowerCase() == plantname.toLowerCase()) {
          _all[i] = WeeklyPlantMetrics(
            id: _all[i].id,
            week: _all[i].week,
            idLoc: _all[i].idLoc,
            plantname: _all[i].plantname,
            color: _all[i].color,
            category: _all[i].category,
            portionsize: _all[i].portionsize,
            portionsum: _all[i].portionsum + delta,
            average4w: _all[i].average4w,
            fiber: _all[i].fiber,
            protein: _all[i].protein,
            localizedPlantId: _all[i].localizedPlantId,
            weeklyTotal: _all[i].weeklyTotal + delta,
            blueprintId: _all[i].blueprintId,
            timesConsumed: _all[i].timesConsumed + 1,
            selectedNutrientValue: _all[i].selectedNutrientValue,
            inthirdrule: _all[i].inthirdrule,
            lastPortionSize: delta,
          );
          break;
        }
      }

      // 🔥 ADD: Increment refresh counter
      _refreshCounter++;

      _applyFilter();
    });
  }

  Future<void> _fetchConsumptionToday(
      String userId, DateTime selectedDate, int dietarySource) async {
    print('🟡 [_fetchConsumptionToday] Starting fetch...');

    try {
      if (!mounted) return;

      final client = Supabase.instance.client;
      final (isoWeek, isoYear) = _selectedIsoWeekYear;
      final currentDayNumber = selectedDate.weekday;

      print(
          '🟡 [_fetchConsumptionToday] Fetching for week=$isoWeek, year=$isoYear, day=$currentDayNumber');

      final result = await client
          .from('vw_daily_plant_summary')
          .select('*')
          .eq('calendaryear', isoYear)
          .eq('week', isoWeek)
          .eq('user_id', userId)
          .eq('dietary_source', dietarySource)
          .eq('daynumber', currentDayNumber);

      print('🟡 [_fetchConsumptionToday] Got ${result.length} records');

      if (!mounted) return;

      final rows = result.map((e) => ConsumptionChipItems.fromMap(e)).toList();

      // Sort by color order for dietary source 1 (plants)
      if (dietarySource == 1) {
        const order = [
          'Red',
          'Orange',
          'Yellow',
          'Green',
          'Purple',
          'Brown',
          'White'
        ];
        final colorOrdered = order
            .expand((c) => rows.where((e) => (e.color ?? '') == c))
            .toList();

        if (mounted) {
          setState(() {
            consumptionTodaySorted = colorOrdered;
          });
          print(
              '🟢 [_fetchConsumptionToday] Updated consumptionTodaySorted with ${colorOrdered.length} items');
        }
      } else {
        if (mounted) {
          setState(() {
            consumptionTodaySorted = rows;
          });
          print(
              '🟢 [_fetchConsumptionToday] Updated consumptionTodaySorted with ${rows.length} items');
        }
      }
    } catch (e) {
      print('🔴 [_fetchConsumptionToday] Error: $e');
    }
  }

  Future<void> _refreshPlantData() async {
    print('🔵 [PlantSelection] _refreshPlantData called');

    if (!mounted) {
      print('🔴 [PlantSelection] Widget not mounted, skipping refresh');
      return;
    }

    try {
      final (isoWeek, isoYear) = _selectedIsoWeekYear;

      print('🟡 [PlantSelection] Fetching plant metrics...');
      await _fetchWeeklyPlantMetrics(
        currentUserUid,
        isoWeek,
        isoYear,
        null,
        currentLocale.toString(),
      );

      print('🟡 [PlantSelection] Fetching today\'s consumption...');
      await _fetchConsumptionToday(
        currentUserUid,
        _selectedDate,
        widget.dietarySource,
      );

      print('🟢 [PlantSelection] Data refresh completed');

      // 🔥 FIX: Increment counter to force rebuild
      if (mounted) {
        setState(() {
          _refreshCounter++;
        });
        print(
            '🟢 [PlantSelection] setState called, refresh counter: $_refreshCounter');
      }
    } catch (e) {
      print('🔴 [PlantSelection] Error refreshing data: $e');
    }
  }

  void _updatePlantListAfterConsumption(String plantname, double delta) {
    setState(() {
      for (int i = 0; i < _all.length; i++) {
        if (_all[i].plantname.toLowerCase() == plantname.toLowerCase()) {
          _all[i] = WeeklyPlantMetrics(
            id: _all[i].id,
            week: _all[i].week,
            idLoc: _all[i].idLoc,
            plantname: _all[i].plantname,
            color: _all[i].color,
            category: _all[i].category,
            portionsize: _all[i].portionsize, // Keep original portion size
            portionsum: _all[i].portionsum + delta,
            average4w: _all[i].average4w,
            fiber: _all[i].fiber,
            protein: _all[i].protein,
            localizedPlantId: _all[i].localizedPlantId,
            weeklyTotal: _all[i].weeklyTotal + delta,
            blueprintId: _all[i].blueprintId,
            timesConsumed: _all[i].timesConsumed + 1,
            selectedNutrientValue: _all[i].selectedNutrientValue,
            inthirdrule: _all[i].inthirdrule,
            lastPortionSize: delta, // 🔥 NEW: Set to the portion just added
          );
          break;
        }
      }

      _applyFilter();
    });
  }

  void _addOptimisticConsumptionChip(String plantname, String colorTag,
      double portionAdded, bool? inthirdrule) {
    if (!mounted) return;
    setState(() {
      final existingIndex = consumptionTodaySorted.indexWhere(
          (item) => item.plantname.toLowerCase() == plantname.toLowerCase());

      if (existingIndex != -1) {
        final existingItem = consumptionTodaySorted[existingIndex];
        final updatedItem = ConsumptionChipItems(
          plantname: existingItem.plantname,
          color: existingItem.color,
          portionPlant: existingItem.portionPlant + portionAdded,
          uom: existingItem.uom,
          dietary_source: existingItem.dietary_source,
          dayNumber: existingItem.dayNumber,
          inthirdrule:
              inthirdrule ?? existingItem.inthirdrule, // PRESERVE OR UPDATE
        );
        consumptionTodaySorted[existingIndex] = updatedItem;
      } else {
        final newItem = ConsumptionChipItems(
          plantname: plantname,
          color: colorTag,
          portionPlant: portionAdded,
          uom: 'g',
          dietary_source: widget.dietarySource,
          dayNumber: FFAppState().currentDayNumber,
          inthirdrule: inthirdrule, // ADD THIS
        );

        consumptionTodaySorted.add(newItem);
        _sortConsumptionByColorOrder();
      }
    });
  }

  void _sortConsumptionByColorOrder() {
    const colorOrder = [
      'Red',
      'Orange',
      'Yellow',
      'Green',
      'Purple',
      'Brown',
      'White'
    ];

    consumptionTodaySorted.sort((a, b) {
      final aIndex = colorOrder.indexOf(a.color ?? '');
      final bIndex = colorOrder.indexOf(b.color ?? '');

      if (aIndex != -1 && bIndex != -1) {
        return aIndex.compareTo(bIndex);
      }

      if (aIndex != -1) return -1;
      if (bIndex != -1) return 1;

      return (a.color ?? '').compareTo(b.color ?? '');
    });
  }

  void _switchToNonMicronutrientSort(_SortMode newSortMode) async {
    if (isFilteringByVitamin || selectedVitamin != null) {
      setState(() {
        selectedVitamin = null;
        isFilteringByVitamin = false;
        _sortMode = newSortMode;
      });

      final (isoWeek, isoYear) = _selectedIsoWeekYear;
      await _fetchWeeklyPlantMetrics(
        currentUserUid,
        isoWeek,
        isoYear,
        null,
        currentLocale.toString(),
      );
    } else {
      setState(() => _sortMode = newSortMode);
      _applyFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: FlutterFlowTheme.of(context)
          .primaryBackground, // Set this to your app's background color
      statusBarIconBrightness: Brightness.dark, // For light icons in status bar
    ));
    final locale = AppLocalizations.of(context)!;
    context.watch<FFAppState>();
    final (isoWeek, isoYear) = _selectedIsoWeekYear;
    final config = _getDietarySourceConfig();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        resizeToAvoidBottomInset: true,
        extendBody: false,
        body: SafeArea(
          top: true,
          bottom: true, // ✅ ADDED THIS
          child: Container(
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  0, 16, 0, 0), // ✅ CHANGED: Removed bottom padding
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Top Row (Close)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(9, 0, 9, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            context.pushNamed(
                              HomepageWidget.routeName,
                              extra: <String, dynamic>{
                                kTransitionInfoKey: const TransitionInfo(
                                  hasTransition: true,
                                  transitionType:
                                      PageTransitionType.bottomToTop,
                                ),
                              },
                            );
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24,
                          ),
                        ),
                        Text(
                          config['title'],
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 16),
                              ),
                        ),
                        const SizedBox(width: 24),
                      ].divide(const SizedBox(width: 8)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(9, 0, 9, 0),
                    child: ConsumptionCard(
                      dateText: dateTimeFormat('dd MMM yyyy', _selectedDate),
                      totalPortion: widget.dietarySource == 1
                          ? '${calculateThirdRulePortions(consumptionTodaySorted, dietarySource: widget.dietarySource).toStringAsFixed(0)} ${config['unit']} / ${config['dailyTarget']}${config['unit']}'
                          : '${calculateTotalPortions(consumptionTodaySorted, dietarySource: widget.dietarySource).toStringAsFixed(0)} ${config['unit']}',
                      onPrev: _goToPrevDay,
                      onNext: _goToNextDay,
                      showDateChangeIcon: true,
                      children: consumptionTodaySorted.isEmpty
                          ? (_todayLocal() == _selectedDate
                              ? [
                                  const SizedBox(
                                      height: 60,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Add Today's consumption.")
                                          ]))
                                ]
                              : [
                                  SizedBox(
                                      height: 60,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "No consumption for ${dateTimeFormat('dd MMM yyyy', _selectedDate)}")
                                          ]))
                                ])
                          : [
                              ...consumptionTodaySorted
                                  .map((r) => buildConsumptionTextChip(
                                        r.plantname,
                                        (r.portionPlant as num).toInt(),
                                        config['unit'],
                                        _chipColorFromTag(r.color),
                                      ))
                                  .toList(),
                            ],
                    ),
                  ),

                  // Week number row
                  Padding(
                    padding: EdgeInsets.only(
                        top: 12.0,
                        bottom: !config['showColorFilter'] &&
                                !config['showCategoryFilter'] &&
                                !config['showSearch']
                            ? 8
                            : 16,
                        left: 21,
                        right: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${config['addText']} ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                  font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500),
                                  color: FlutterFlowTheme.of(context).textGrey,
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 16),
                                  lineHeight: 1),
                        ),
                        Text(
                          '${locale.week} $isoWeek',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                  font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500),
                                  color: FlutterFlowTheme.of(context).textGrey,
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 10),
                                  lineHeight: 0),
                        ),
                      ],
                    ),
                  ),

                  // Color filter - Only show for plants
                  if (config['showColorFilter'] && !_hideFilters)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(9, 0, 9, 0),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.sizeOf(context).width - 32,
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    spacing: 3,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            allSelected = true;
                                            selectedColors.clear();
                                          });
                                          _applyFilter();
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          width: allSelected ? 61 : 44,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            gradient:
                                                const LinearGradient(colors: [
                                              Colors.red,
                                              Colors.orange,
                                              Colors.yellow,
                                              Colors.green,
                                              Colors.blue,
                                              Colors.purple
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(99),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            allSelected ? locale.all : 'A',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...List.generate(colors.length, (index) {
                                        final cName =
                                            colors[index]["name"] as String;
                                        final bool isSelected = !allSelected &&
                                            selectedColors.contains(cName);
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                selectedColors.remove(cName);
                                              } else {
                                                selectedColors.add(cName);
                                              }
                                              allSelected =
                                                  selectedColors.isEmpty;
                                            });
                                            _applyFilter();
                                          },
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                            width: isSelected ? 61 : 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: colors[index]["color"]
                                                  as Color,
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                            ),
                                            alignment: Alignment.center,
                                            margin:
                                                const EdgeInsets.only(left: 2),
                                            child: Text(
                                              isSelected
                                                  ? (colors[index]["name"]
                                                      as String)
                                                  : (colors[index]["short"]
                                                      as String),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: isSelected
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                fontSize: isSelected
                                                    ? FlutterFlowTheme
                                                        .adjustScale(size: 12)
                                                    : FlutterFlowTheme
                                                        .adjustScale(size: 16),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ]),
                              ))),
                    ),

                  // Category filter - Only show for Animal Products (dietary source 2)
                  if ((config['showCategoryFilter'] ?? false) && !_hideFilters)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(9, 0, 9, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.sizeOf(context).width - 32,
                            ),
                            child: _loadingCategories
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 8,
                                    children: [
                                      // 'All' chip
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            allCategoriesSelected = true;
                                            selectedCategories.clear();
                                          });
                                          _applyFilter();
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          width:
                                              allCategoriesSelected ? 61 : 44,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            gradient:
                                                const LinearGradient(colors: [
                                              Colors.red,
                                              Colors.orange,
                                              Colors.yellow,
                                              Colors.green,
                                              Colors.blue,
                                              Colors.purple
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(99),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            allCategoriesSelected
                                                ? locale.all
                                                : 'A',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  FlutterFlowTheme.adjustScale(
                                                      size: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Category chips with images
                                      ...availableCategories.map((category) {
                                        final categoryCode =
                                            category['code'] as int;
                                        final categoryName =
                                            category['name'] as String;
                                        final imageName =
                                            category['icon'] as String?;
                                        final isSelected =
                                            !allCategoriesSelected &&
                                                selectedCategories
                                                    .contains(categoryCode);

                                        return Tooltip(
                                          message: categoryName,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedCategories
                                                      .remove(categoryCode);
                                                } else {
                                                  selectedCategories
                                                      .add(categoryCode);
                                                }
                                                allCategoriesSelected =
                                                    selectedCategories.isEmpty;
                                              });
                                              _applyFilter();
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              height: 36,
                                              constraints: BoxConstraints(
                                                minWidth: 36,
                                                maxWidth: isSelected ? 200 : 36,
                                              ),
                                              padding: isSelected
                                                  ? const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8)
                                                  : const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primary
                                                        .withOpacity(0.1)
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                      : Colors.grey.shade300,
                                                  width: isSelected ? 2 : 1,
                                                ),
                                              ),
                                              child: isSelected
                                                  ? Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (imageName != null &&
                                                            imageName
                                                                .isNotEmpty)
                                                          SizedBox(
                                                            width: 12,
                                                            height: 12,
                                                            child: Image.asset(
                                                              'assets/images/$imageName',
                                                              fit: BoxFit
                                                                  .contain,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Text(
                                                                  categoryName
                                                                      .substring(
                                                                          0, 1)
                                                                      .toUpperCase(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: FlutterFlowTheme
                                                                        .adjustScale(
                                                                            size:
                                                                                12),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                        else
                                                          Text(
                                                            categoryName
                                                                .substring(0, 1)
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  FlutterFlowTheme
                                                                      .adjustScale(
                                                                          size:
                                                                              12),
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Flexible(
                                                          child: Text(
                                                            categoryName,
                                                            style: TextStyle(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  FlutterFlowTheme
                                                                      .adjustScale(
                                                                          size:
                                                                              13),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Center(
                                                      child: imageName !=
                                                                  null &&
                                                              imageName
                                                                  .isNotEmpty
                                                          ? Image.asset(
                                                              'assets/images/$imageName',
                                                              width: 20,
                                                              height: 20,
                                                              fit: BoxFit
                                                                  .contain,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Text(
                                                                  categoryName
                                                                      .substring(
                                                                          0, 1)
                                                                      .toUpperCase(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .textGrey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: FlutterFlowTheme
                                                                        .adjustScale(
                                                                            size:
                                                                                16),
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : Text(
                                                              categoryName
                                                                  .substring(
                                                                      0, 1)
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .textGrey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: FlutterFlowTheme
                                                                    .adjustScale(
                                                                        size:
                                                                            16),
                                                              ),
                                                            ),
                                                    ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),

                  if (config['showSearch'])
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(9, 0, 9, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.sizeOf(context).width - 32),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () async {
                                  _model.isShowingSearchBar = true;
                                  safeSetState(() {});
                                },
                                child: Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderRadius: BorderRadius.circular(16)),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.search_sharp,
                                      color:
                                          FlutterFlowTheme.of(context).textGrey,
                                      size: 24),
                                ),
                              ),
                              if (config['showMicroNutrientSort']) ...[
                                _sortChip(
                                    label: selectedVitamin != null
                                        ? selectedVitamin!['display_name'] ??
                                            'Micronutrients'
                                        : locale.micronutrients,
                                    selected:
                                        _sortMode == _SortMode.micronutrients ||
                                            isFilteringByVitamin,
                                    onTap: () {
                                      if (selectedVitamin != null) {
                                        _clearVitaminFilter();
                                      } else {
                                        print(
                                            'DEBUG: Micronutrients chip tapped');
                                        setState(() => _sortMode =
                                            _SortMode.micronutrients);
                                        _openMicronutrientFilter();
                                      }
                                    },
                                    icon: selectedVitamin != null
                                        ? const Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: Icon(Icons.close, size: 16),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(right: 4),
                                            child: Icon(Icons.sort, size: 16),
                                          ),
                                    iconPosition: selectedVitamin != null
                                        ? 'right'
                                        : 'left',
                                    gradientColors: const [
                                      Color(0xffffffff),
                                      Color(0xffe0e0e0)
                                    ]),
                              ],
                              if (config['showAlphabeticSort']) ...[
                                const SizedBox(width: 12),
                                _sortChip(
                                  label: locale.popular,
                                  selected: _sortMode == _SortMode.popular,
                                  onTap: () => _switchToNonMicronutrientSort(
                                      _SortMode.popular),
                                ),
                                const SizedBox(width: 12),
                                _sortChip(
                                  label: locale.alphabetic,
                                  selected: _sortMode == _SortMode.alphabetic,
                                  onTap: () => _switchToNonMicronutrientSort(
                                      _SortMode.alphabetic),
                                ),
                              ],
                              if (config['showNutrientSort']) ...[
                                const SizedBox(width: 12),
                                _sortChip(
                                  label: locale.highFiber,
                                  selected: _sortMode == _SortMode.fiber,
                                  onTap: () => _switchToNonMicronutrientSort(
                                      _SortMode.fiber),
                                ),
                                const SizedBox(width: 12),
                                _sortChip(
                                  label: locale.highProtein,
                                  selected: _sortMode == _SortMode.protein,
                                  onTap: () => _switchToNonMicronutrientSort(
                                      _SortMode.protein),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                  if (_model.isShowingSearchBar)
                    Container(
                      width: double.infinity,
                      height: 40,
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F1F1)),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(9, 4, 9, 4),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 2, 8, 2),
                              child: Icon(Icons.search_sharp,
                                  color: FlutterFlowTheme.of(context).textGrey,
                                  size: 18),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _model.textController1,
                                focusNode: _model.textFieldFocusNode1,
                                textInputAction: TextInputAction.search,
                                onFieldSubmitted: (_) => _applyFilter(),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: locale.search,
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .copyWith(
                                        color: FlutterFlowTheme.of(context)
                                            .textGrey,
                                        fontSize: FlutterFlowTheme.adjustScale(
                                            size: 12),
                                      ),
                                  border: InputBorder.none,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .copyWith(
                                      color:
                                          FlutterFlowTheme.of(context).textGrey,
                                      fontSize: FlutterFlowTheme.adjustScale(
                                          size: 12),
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 2, 8, 2),
                              child: InkWell(
                                onTap: () {
                                  _model.textController1?.clear();
                                  _model.isShowingSearchBar = false;
                                  _applyFilter();
                                },
                                child: const Icon(Icons.cancel_sharp,
                                    color: Color(0xFFACACAC), size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ✅ FIXED LIST SECTION - USE EXPANDED INSTEAD OF FIXED HEIGHT
                  Expanded(
                    // ✅ CHANGED FROM CONTAINER WITH HEIGHT TO EXPANDED
                    child: Container(
                      margin: EdgeInsets.only(
                        top: !config['showColorFilter'] &&
                                !config['showCategoryFilter'] &&
                                !config['showSearch']
                            ? 0
                            : 16,
                      ),
                      child: _loadingList
                          ? const Center(child: CircularProgressIndicator())
                          : (_loadListError != null)
                              ? Center(
                                  child:
                                      Text('${locale.error}: $_loadListError'))
                              : (_filtered.isEmpty)
                                  ? Center(
                                      child: Text(config['defaultMessage']))
                                  : Builder(
                                      builder: (context) {
                                        try {
                                          return RefreshIndicator(
                                            onRefresh: () async {
                                              await _fetchWeeklyPlantMetrics(
                                                  currentUserUid,
                                                  isoWeek,
                                                  isoYear,
                                                  null,
                                                  currentLocale.toString());
                                              await _loadCategoryIcons();
                                            },
                                            child: ListView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              padding: const EdgeInsets.only(
                                                  bottom:
                                                      16), // ✅ ADDED PADDING
                                              itemCount: _filtered.length,
                                              itemBuilder: (context, index) {
                                                if (index >= _filtered.length) {
                                                  return const SizedBox
                                                      .shrink();
                                                }

                                                final r = _filtered[index];
                                                if (r == null) {
                                                  return const SizedBox
                                                      .shrink();
                                                }

                                                String categoryIcon =
                                                    _categoryIcons[
                                                            r.category] ??
                                                        '';

                                                final plantName = r.plantname ??
                                                    'Unknown Plant';
                                                final colorTag = r.color ?? '';
                                                final localizedPlantId =
                                                    r.localizedPlantId ?? 0;
                                                final blueprintId =
                                                    r.blueprintId ?? 0;
                                                final portionSize =
                                                    r.portionsize ?? 0.0;
                                                final weeklyTotal =
                                                    r.weeklyTotal ?? 0.0;
                                                // 🆕 Calculate portion size for widget: use lastPortionSize if available
                                                final portionSizeForWidget =
                                                    r.lastPortionSize != null
                                                        ? (r.lastPortionSize!)
                                                            .toInt()
                                                        : (portionSize * 100)
                                                            .toInt();
                                                final isConsumedToday =
                                                    consumptionTodaySorted.any(
                                                        (item) =>
                                                            item.plantname
                                                                .toLowerCase() ==
                                                            plantName
                                                                .toLowerCase());
                                                return Column(
                                                  key: ValueKey(
                                                      'row_${localizedPlantId}_${r.portionsum}_${_sortMode.index}_$_refreshCounter'),
                                                  children: [
                                                    WeeklyItemCard(
                                                      key: ValueKey(
                                                          'card_${localizedPlantId}_${r.portionsum}_${_sortMode.index}_${isConsumedToday}_$_refreshCounter'),
                                                      primaryColor:
                                                          _colorFor(colorTag),
                                                      colorTag: colorTag,
                                                      onPortionAdded:
                                                          (plantname, colorTag,
                                                              delta) {
                                                        _onPortionAdded(
                                                            plantname,
                                                            colorTag,
                                                            delta);
                                                      },
                                                      onNeedBottomSpace:
                                                          (space) {
                                                        setState(() =>
                                                            extraSpace = space);
                                                      },
                                                      onConsumptionModified:
                                                          _refreshPlantData,
                                                      title: plantName,
                                                      weeklyTotal:
                                                          weeklyTotal.round(),
                                                      portionSize:
                                                          portionSizeForWidget,
                                                      uom: config['unit'],
                                                      plantId: localizedPlantId,
                                                      userId: currentUserUid,
                                                      weekdayNumber:
                                                          _selectedDate.weekday,
                                                      week: isoWeek,
                                                      year: isoYear,
                                                      blueprintId: blueprintId,
                                                      dietarySource:
                                                          widget.dietarySource,
                                                      canModify: true,
                                                      categoryIcon:
                                                          categoryIcon ?? '',
                                                      isConsumedToday:
                                                          isConsumedToday,
                                                    ),
                                                    const Divider(
                                                        height: 2,
                                                        color:
                                                            Color(0xffd8d8d8)),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        } catch (e) {
                                          print('Error building ListView: $e');
                                          return Center(
                                              child: Text(
                                                  'Error loading plants: $e'));
                                        }
                                      },
                                    ),
                    ),
                  ),
                  // SizedBox(
                  //   height: extraSpace + 16,
                  //   child: Text('$extraSpace'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildConsumptionTextChip(
      String name, int value, String? unit, Color dotColor) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 3, // Add spacing between items
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        // Remove Flexible wrapper - just use Text directly
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          "$value${unit ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
