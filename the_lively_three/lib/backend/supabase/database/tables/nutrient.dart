import '../database.dart';

class NutrientTable extends SupabaseTable<NutrientRow> {
  @override
  String get tableName => 'nutrient';

  @override
  NutrientRow createRow(Map<String, dynamic> data) => NutrientRow(data);
}

class NutrientRow extends SupabaseDataRow {
  NutrientRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NutrientTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
