import '../database.dart';

class UsercontractsTable extends SupabaseTable<UsercontractsRow> {
  @override
  String get tableName => 'usercontracts';

  @override
  UsercontractsRow createRow(Map<String, dynamic> data) =>
      UsercontractsRow(data);
}

class UsercontractsRow extends SupabaseDataRow {
  UsercontractsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsercontractsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  int? get idDatacontract => getField<int>('id_datacontract');
  set idDatacontract(int? value) => setField<int>('id_datacontract', value);

  bool? get currentConsent => getField<bool>('current_consent');
  set currentConsent(bool? value) => setField<bool>('current_consent', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get withdrawalEffectiveDate =>
      getField<DateTime>('withdrawal_effective_date');
  set withdrawalEffectiveDate(DateTime? value) =>
      setField<DateTime>('withdrawal_effective_date', value);
}
