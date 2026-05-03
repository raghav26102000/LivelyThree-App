import 'dart:convert';

/// A data model representing plant consumption information for a user.
/// This class is used across multiple widgets to display and manage
/// consumption data from the vw_daily_plant_summary view.
class PlantConsumptionRow {
  final int week;
  final int calendarYear;
  final String plantname;
  final String? color;
  final int? dayNumber;
  final double portionPlant;
  final int dateDay;
  final int dateMonth;
  final String uom;
  final int portionstaken;
  final int dietary_source;
  final bool inthirdrule;

  PlantConsumptionRow({
    required this.week,
    required this.calendarYear,
    required this.plantname,
    required this.color,
    required this.dayNumber,
    required this.portionPlant,
    required this.dateDay,
    required this.dateMonth,
    required this.uom,
    required this.dietary_source,
    required this.portionstaken,
    required this.inthirdrule,
  });

  /// Convert an integer value from dynamic input
  static int _asInt(dynamic v) =>
      v == null ? 0 : (v is num ? v.toInt() : int.tryParse(v.toString()) ?? 0);

  /// Convert a boolean value from dynamic input
  static bool _asBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    final str = v.toString().toLowerCase();
    return str == 'true' || str == '1' || str == 't' || str == 'yes';
  }

  /// Convert a date value from dynamic input
  static DateTime? _asDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return DateTime(v.year, v.month, v.day);
    try {
      final d = DateTime.parse(v.toString());
      return DateTime(d.year, d.month, d.day);
    } catch (_) {
      return null;
    }
  }

  /// Create a PlantConsumptionRow from a Map (typically from Supabase query result)
  factory PlantConsumptionRow.fromMap(Map<String, dynamic> m) {
    final anyPortion = m['portionsum'] ?? m['portionPlant'] ?? m['portionSum'];
    final portion =
        anyPortion is num ? anyPortion : num.tryParse('$anyPortion') ?? 0;
    return PlantConsumptionRow(
      week: _asInt(m['week']),
      calendarYear: _asInt(m['calendarYear'] ?? m['calendaryear']),
      plantname: (m['plantname'] ?? '').toString(),
      color: m['color']?.toString(),
      dayNumber: m['daynumber'] != null ? _asInt(m['daynumber']) : null,
      portionPlant: portion.toDouble(),
      dateDay: _asInt(m['dateDay'] ?? m['dateday']),
      dateMonth: _asInt(m['dateMonth'] ?? m['datemonth']),
      uom: (m['uom'] ?? '').toString(),
      dietary_source: _asInt(m['dietary_source']),
      portionstaken: _asInt(m['portionstaken']),
      inthirdrule: _asBool(m['inthirdrule']),
    );
  }

  /// Convert PlantConsumptionRow to a JSON Map
  Map<String, dynamic> toJson() => {
        'week': week,
        'calendarYear': calendarYear,
        'plantname': plantname,
        'color': color,
        'dayNumber': dayNumber,
        'portionSum': portionPlant,
        'dateDay': dateDay,
        'dateMonth': dateMonth,
        'uom': uom,
        'dietary_source': dietary_source,
        'portionstaken': portionstaken,
        'inthirdrule': inthirdrule,
      };

  @override
  String toString() => jsonEncode(toJson());

  /// Create a copy of this PlantConsumptionRow with updated values
  PlantConsumptionRow copyWith({
    int? week,
    int? calendarYear,
    String? plantname,
    String? color,
    int? dayNumber,
    double? portionPlant,
    int? dateDay,
    int? dateMonth,
    String? uom,
    int? dietary_source,
    int? portionstaken,
    bool? inthirdrule,
  }) {
    return PlantConsumptionRow(
      week: week ?? this.week,
      calendarYear: calendarYear ?? this.calendarYear,
      plantname: plantname ?? this.plantname,
      color: color ?? this.color,
      dayNumber: dayNumber ?? this.dayNumber,
      portionPlant: portionPlant ?? this.portionPlant,
      dateDay: dateDay ?? this.dateDay,
      dateMonth: dateMonth ?? this.dateMonth,
      uom: uom ?? this.uom,
      dietary_source: dietary_source ?? this.dietary_source,
      portionstaken: portionstaken ?? this.portionstaken,
      inthirdrule: inthirdrule ?? this.inthirdrule,
    );
  }

  /// Helper method to aggregate multiple PlantConsumptionRow objects by plant name
  /// Used for weekly summary views where you want to combine portions
  static List<PlantConsumptionRow> aggregateByPlantName(
      List<PlantConsumptionRow> rows) {
    final Map<String, PlantConsumptionRow> aggregated = {};

    for (final row in rows) {
      final key = row.plantname;
      if (aggregated.containsKey(key)) {
        final existing = aggregated[key]!;
        aggregated[key] = existing.copyWith(
          portionPlant: existing.portionPlant + row.portionPlant,
          portionstaken: existing.portionstaken + row.portionstaken,
        );
      } else {
        aggregated[key] = row;
      }
    }

    return aggregated.values.toList();
  }

  /// Calculate total portions for a list of rows, optionally filtered by dietary source
  static double calculateTotalPortions(
    List<PlantConsumptionRow> data, {
    int? dietarySource,
  }) {
    double total = 0.0;
    for (final row in data) {
      if (dietarySource == null || row.dietary_source == dietarySource) {
        total += row.portionPlant;
      }
    }
    return total;
  }

  /// Calculate total quantity for a list of rows, optionally filtered by dietary source
  static int calculateTotalQuantity(
    List<PlantConsumptionRow> data, {
    int? dietarySource,
  }) {
    int totalQuantity = 0;
    for (final row in data) {
      if (dietarySource == null || row.dietary_source == dietarySource) {
        totalQuantity += row.portionstaken;
      }
    }
    return totalQuantity;
  }
}