import '../database.dart';

class ViewIndividualIndicatorsValuesTable
    extends SupabaseTable<ViewIndividualIndicatorsValuesRow> {
  @override
  String get tableName => 'view_individual_indicators_values';

  @override
  ViewIndividualIndicatorsValuesRow createRow(Map<String, dynamic> data) =>
      ViewIndividualIndicatorsValuesRow(data);
}

class ViewIndividualIndicatorsValuesRow extends SupabaseDataRow {
  ViewIndividualIndicatorsValuesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewIndividualIndicatorsValuesTable();

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  int? get idIndicator => getField<int>('id_indicator');
  set idIndicator(int? value) => setField<int>('id_indicator', value);

  String? get indicatorname => getField<String>('indicatorname');
  set indicatorname(String? value) => setField<String>('indicatorname', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);

  double? get value => getField<double>('value');
  set value(double? value) => setField<double>('value', value);

  String? get displayname => getField<String>('displayname');
  set displayname(String? value) => setField<String>('displayname', value);

  dynamic? get jsonbValue => getField<dynamic>('jsonb_value');
  set jsonbValue(dynamic? value) => setField<dynamic>('jsonb_value', value);
}
