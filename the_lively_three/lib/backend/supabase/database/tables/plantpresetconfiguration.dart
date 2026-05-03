import '../database.dart';

class PlantpresetconfigurationTable
    extends SupabaseTable<PlantpresetconfigurationRow> {
  @override
  String get tableName => 'plantpresetconfiguration';

  @override
  PlantpresetconfigurationRow createRow(Map<String, dynamic> data) =>
      PlantpresetconfigurationRow(data);
}

class PlantpresetconfigurationRow extends SupabaseDataRow {
  PlantpresetconfigurationRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PlantpresetconfigurationTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  bool? get exploratory => getField<bool>('exploratory');
  set exploratory(bool? value) => setField<bool>('exploratory', value);

  String? get primaryGoal => getField<String>('primary_goal');
  set primaryGoal(String? value) => setField<String>('primary_goal', value);

  String? get secondaryGoal => getField<String>('secondary_goal');
  set secondaryGoal(String? value) => setField<String>('secondary_goal', value);

  String? get presetLabel => getField<String>('preset_label');
  set presetLabel(String? value) => setField<String>('preset_label', value);

  double? get proteinValue => getField<double>('protein_value');
  set proteinValue(double? value) => setField<double>('protein_value', value);

  double? get fiberValue => getField<double>('fiber_value');
  set fiberValue(double? value) => setField<double>('fiber_value', value);

  bool? get isBelowSixtyfive => getField<bool>('is_below_sixtyfive');
  set isBelowSixtyfive(bool? value) =>
      setField<bool>('is_below_sixtyfive', value);
}
