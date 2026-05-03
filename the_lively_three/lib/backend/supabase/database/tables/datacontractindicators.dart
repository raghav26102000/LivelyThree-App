import '../database.dart';

class DatacontractindicatorsTable
    extends SupabaseTable<DatacontractindicatorsRow> {
  @override
  String get tableName => 'datacontractindicators';

  @override
  DatacontractindicatorsRow createRow(Map<String, dynamic> data) =>
      DatacontractindicatorsRow(data);
}

class DatacontractindicatorsRow extends SupabaseDataRow {
  DatacontractindicatorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DatacontractindicatorsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get idDatacontract => getField<int>('id_datacontract');
  set idDatacontract(int? value) => setField<int>('id_datacontract', value);

  int? get idIndicator => getField<int>('id_indicator');
  set idIndicator(int? value) => setField<int>('id_indicator', value);

  String? get sharedReceived => getField<String>('shared_received');
  set sharedReceived(String? value) =>
      setField<String>('shared_received', value);
}
