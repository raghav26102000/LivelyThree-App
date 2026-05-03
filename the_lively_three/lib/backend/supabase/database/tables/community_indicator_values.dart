import '../database.dart';

class CommunityIndicatorValuesTable
    extends SupabaseTable<CommunityIndicatorValuesRow> {
  @override
  String get tableName => 'community_indicator_values';

  @override
  CommunityIndicatorValuesRow createRow(Map<String, dynamic> data) =>
      CommunityIndicatorValuesRow(data);
}

class CommunityIndicatorValuesRow extends SupabaseDataRow {
  CommunityIndicatorValuesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityIndicatorValuesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  int? get idIndicator => getField<int>('id_indicator');
  set idIndicator(int? value) => setField<int>('id_indicator', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get participantCount => getField<int>('participant_count');
  set participantCount(int? value) => setField<int>('participant_count', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);

  dynamic get value => getField<dynamic>('value');
  set value(dynamic val) => setField<dynamic>('value', val);
}
