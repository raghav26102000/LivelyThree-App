import '../database.dart';

class UserindicatorsTable extends SupabaseTable<UserindicatorsRow> {
  @override
  String get tableName => 'userindicators';

  @override
  UserindicatorsRow createRow(Map<String, dynamic> data) =>
      UserindicatorsRow(data);
}

class UserindicatorsRow extends SupabaseDataRow {
  UserindicatorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserindicatorsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get frequency => getField<String>('frequency');
  set frequency(String? value) => setField<String>('frequency', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  bool? get subscriptionRequired => getField<bool>('subscription_required');
  set subscriptionRequired(bool? value) =>
      setField<bool>('subscription_required', value);

  bool? get isCommunity => getField<bool>('is_community');
  set isCommunity(bool? value) => setField<bool>('is_community', value);

  String? get displayname => getField<String>('displayname');
  set displayname(String? value) => setField<String>('displayname', value);

  String? get dataelementType => getField<String>('dataelement_type');
  set dataelementType(String? value) =>
      setField<String>('dataelement_type', value);

  bool? get hasComplexValues => getField<bool>('has_complex_values');
  set hasComplexValues(bool? value) =>
      setField<bool>('has_complex_values', value);
}
