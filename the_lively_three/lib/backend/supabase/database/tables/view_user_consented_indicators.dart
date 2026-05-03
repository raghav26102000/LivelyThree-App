import '../database.dart';

class ViewUserConsentedIndicatorsTable
    extends SupabaseTable<ViewUserConsentedIndicatorsRow> {
  @override
  String get tableName => 'view_user_consented_indicators';

  @override
  ViewUserConsentedIndicatorsRow createRow(Map<String, dynamic> data) =>
      ViewUserConsentedIndicatorsRow(data);
}

class ViewUserConsentedIndicatorsRow extends SupabaseDataRow {
  ViewUserConsentedIndicatorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewUserConsentedIndicatorsTable();

  String? get userid => getField<String>('userid');
  set userid(String? value) => setField<String>('userid', value);

  bool? get consent => getField<bool>('consent');
  set consent(bool? value) => setField<bool>('consent', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get datacontractName => getField<String>('datacontract_name');
  set datacontractName(String? value) =>
      setField<String>('datacontract_name', value);

  int? get datacontractId => getField<int>('datacontract_id');
  set datacontractId(int? value) => setField<int>('datacontract_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get sharedReceived => getField<String>('shared_received');
  set sharedReceived(String? value) =>
      setField<String>('shared_received', value);

  String? get indicatorName => getField<String>('indicator_name');
  set indicatorName(String? value) => setField<String>('indicator_name', value);
}
