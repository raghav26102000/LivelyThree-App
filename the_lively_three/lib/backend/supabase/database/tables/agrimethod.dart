import '../database.dart';

class AgrimethodTable extends SupabaseTable<AgrimethodRow> {
  @override
  String get tableName => 'agrimethod';

  @override
  AgrimethodRow createRow(Map<String, dynamic> data) => AgrimethodRow(data);
}

class AgrimethodRow extends SupabaseDataRow {
  AgrimethodRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AgrimethodTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);
}
