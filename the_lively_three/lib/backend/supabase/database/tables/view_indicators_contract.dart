import '../database.dart';

class ViewIndicatorsContractTable
    extends SupabaseTable<ViewIndicatorsContractRow> {
  @override
  String get tableName => 'view_indicators_contract';

  @override
  ViewIndicatorsContractRow createRow(Map<String, dynamic> data) =>
      ViewIndicatorsContractRow(data);
}

class ViewIndicatorsContractRow extends SupabaseDataRow {
  ViewIndicatorsContractRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewIndicatorsContractTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get contractname => getField<String>('contractname');
  set contractname(String? value) => setField<String>('contractname', value);

  String? get contractDescription => getField<String>('contract_description');
  set contractDescription(String? value) =>
      setField<String>('contract_description', value);

  String? get contractValidityType =>
      getField<String>('contract_validity_type');
  set contractValidityType(String? value) =>
      setField<String>('contract_validity_type', value);

  int? get contractValidityDuration =>
      getField<int>('contract_validity_duration');
  set contractValidityDuration(int? value) =>
      setField<int>('contract_validity_duration', value);

  String? get indicatorDisplayname => getField<String>('indicator_displayname');
  set indicatorDisplayname(String? value) =>
      setField<String>('indicator_displayname', value);

  String? get indicatorname => getField<String>('indicatorname');
  set indicatorname(String? value) => setField<String>('indicatorname', value);

  String? get frequency => getField<String>('frequency');
  set frequency(String? value) => setField<String>('frequency', value);

  String? get indicatorDescription => getField<String>('indicator_description');
  set indicatorDescription(String? value) =>
      setField<String>('indicator_description', value);

  bool? get isCommunity => getField<bool>('is_community');
  set isCommunity(bool? value) => setField<bool>('is_community', value);

  bool? get indicatorSubRequired => getField<bool>('indicator_sub_required');
  set indicatorSubRequired(bool? value) =>
      setField<bool>('indicator_sub_required', value);

  String? get sharedReceived => getField<String>('shared_received');
  set sharedReceived(String? value) =>
      setField<String>('shared_received', value);

  int? get idDatacontract => getField<int>('id_datacontract');
  set idDatacontract(int? value) => setField<int>('id_datacontract', value);

  int? get idIndicator => getField<int>('id_indicator');
  set idIndicator(int? value) => setField<int>('id_indicator', value);
}
