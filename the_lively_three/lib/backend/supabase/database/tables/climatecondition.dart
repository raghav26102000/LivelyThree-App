import '../database.dart';

class ClimateconditionTable extends SupabaseTable<ClimateconditionRow> {
  @override
  String get tableName => 'climatecondition';

  @override
  ClimateconditionRow createRow(Map<String, dynamic> data) =>
      ClimateconditionRow(data);
}

class ClimateconditionRow extends SupabaseDataRow {
  ClimateconditionRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClimateconditionTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get regions => getField<String>('regions');
  set regions(String? value) => setField<String>('regions', value);
}
