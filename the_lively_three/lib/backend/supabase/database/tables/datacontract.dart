import '../database.dart';

class DatacontractTable extends SupabaseTable<DatacontractRow> {
  @override
  String get tableName => 'datacontract';

  @override
  DatacontractRow createRow(Map<String, dynamic> data) => DatacontractRow(data);
}

class DatacontractRow extends SupabaseDataRow {
  DatacontractRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DatacontractTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get contractName => getField<String>('contract_name');
  set contractName(String? value) => setField<String>('contract_name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get validityType => getField<String>('validity_type');
  set validityType(String? value) => setField<String>('validity_type', value);

  int? get validityDuration => getField<int>('validity_duration');
  set validityDuration(int? value) => setField<int>('validity_duration', value);

  DateTime? get startDate => getField<DateTime>('start_date');
  set startDate(DateTime? value) => setField<DateTime>('start_date', value);

  DateTime? get endDate => getField<DateTime>('end_date');
  set endDate(DateTime? value) => setField<DateTime>('end_date', value);

  String? get contractType => getField<String>('contract_type');
  set contractType(String? value) => setField<String>('contract_type', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get parentContractId => getField<int>('parent_contract_id');
  set parentContractId(int? value) =>
      setField<int>('parent_contract_id', value);
}
