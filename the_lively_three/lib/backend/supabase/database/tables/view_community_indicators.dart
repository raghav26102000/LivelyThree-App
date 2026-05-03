import '../database.dart';

class ViewCommunityIndicatorsTable
    extends SupabaseTable<ViewCommunityIndicatorsRow> {
  @override
  String get tableName => 'view_community_indicators';

  @override
  ViewCommunityIndicatorsRow createRow(Map<String, dynamic> data) =>
      ViewCommunityIndicatorsRow(data);
}

class ViewCommunityIndicatorsRow extends SupabaseDataRow {
  ViewCommunityIndicatorsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewCommunityIndicatorsTable();

  int? get idIndicator => getField<int>('id_indicator');
  set idIndicator(int? value) => setField<int>('id_indicator', value);

  String? get indicatorname => getField<String>('indicatorname');
  set indicatorname(String? value) => setField<String>('indicatorname', value);

  dynamic? get value => getField<dynamic>('value');
  set value(dynamic? value) => setField<dynamic>('value', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get participantCount => getField<int>('participant_count');
  set participantCount(int? value) => setField<int>('participant_count', value);

  int? get calendarweek => getField<int>('calendarweek');
  set calendarweek(int? value) => setField<int>('calendarweek', value);

  int? get calendaryear => getField<int>('calendaryear');
  set calendaryear(int? value) => setField<int>('calendaryear', value);

  String? get displayname => getField<String>('displayname');
  set displayname(String? value) => setField<String>('displayname', value);
}
