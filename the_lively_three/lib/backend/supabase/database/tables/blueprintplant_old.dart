import '../database.dart';

class BlueprintplantOldTable extends SupabaseTable<BlueprintplantOldRow> {
  @override
  String get tableName => 'blueprintplant_old';

  @override
  BlueprintplantOldRow createRow(Map<String, dynamic> data) =>
      BlueprintplantOldRow(data);
}

class BlueprintplantOldRow extends SupabaseDataRow {
  BlueprintplantOldRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BlueprintplantOldTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get genus => getField<String>('genus');
  set genus(String? value) => setField<String>('genus', value);

  String? get origin => getField<String>('origin');
  set origin(String? value) => setField<String>('origin', value);

  String? get color => getField<String>('color');
  set color(String? value) => setField<String>('color', value);

  String? get hex => getField<String>('hex');
  set hex(String? value) => setField<String>('hex', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get species => getField<String>('species');
  set species(String? value) => setField<String>('species', value);
}
