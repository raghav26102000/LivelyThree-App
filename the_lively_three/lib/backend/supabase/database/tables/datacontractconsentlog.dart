import '../database.dart';

class DatacontractconsentlogTable
    extends SupabaseTable<DatacontractconsentlogRow> {
  @override
  String get tableName => 'datacontractconsentlog';

  @override
  DatacontractconsentlogRow createRow(Map<String, dynamic> data) =>
      DatacontractconsentlogRow(data);
}

class DatacontractconsentlogRow extends SupabaseDataRow {
  DatacontractconsentlogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DatacontractconsentlogTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get idDatacontract => getField<int>('id_datacontract');
  set idDatacontract(int? value) => setField<int>('id_datacontract', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  bool? get changeConsent => getField<bool>('change_consent');
  set changeConsent(bool? value) => setField<bool>('change_consent', value);

  DateTime? get changeTime => getField<DateTime>('change_time');
  set changeTime(DateTime? value) => setField<DateTime>('change_time', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);
}
