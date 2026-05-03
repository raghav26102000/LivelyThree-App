import '../database.dart';

class CommunityindicatorvaluesTable
    extends SupabaseTable<CommunityindicatorvaluesRow> {
  @override
  String get tableName => 'communityindicatorvalues';

  @override
  CommunityindicatorvaluesRow createRow(Map<String, dynamic> data) =>
      CommunityindicatorvaluesRow(data);
}

class CommunityindicatorvaluesRow extends SupabaseDataRow {
  CommunityindicatorvaluesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityindicatorvaluesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

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

  dynamic? get value => getField<dynamic>('value');
  set value(dynamic? value) => setField<dynamic>('value', value);
}
