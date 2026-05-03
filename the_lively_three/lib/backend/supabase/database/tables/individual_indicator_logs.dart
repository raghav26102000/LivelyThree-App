import '../database.dart';

class IndividualIndicatorLogsTable
    extends SupabaseTable<IndividualIndicatorLogsRow> {
  @override
  String get tableName => 'individual_indicator_logs';

  @override
  IndividualIndicatorLogsRow createRow(Map<String, dynamic> data) =>
      IndividualIndicatorLogsRow(data);
}

class IndividualIndicatorLogsRow extends SupabaseDataRow {
  IndividualIndicatorLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => IndividualIndicatorLogsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get logMessage => getField<String>('log_message')!;
  set logMessage(String value) => setField<String>('log_message', value);

  DateTime? get logTimestamp => getField<DateTime>('log_timestamp');
  set logTimestamp(DateTime? value) =>
      setField<DateTime>('log_timestamp', value);
}
