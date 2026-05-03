import '../database.dart';

class CommunityIndicatorLogsTable
    extends SupabaseTable<CommunityIndicatorLogsRow> {
  @override
  String get tableName => 'community_indicator_logs';

  @override
  CommunityIndicatorLogsRow createRow(Map<String, dynamic> data) =>
      CommunityIndicatorLogsRow(data);
}

class CommunityIndicatorLogsRow extends SupabaseDataRow {
  CommunityIndicatorLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityIndicatorLogsTable();

  int get logId => getField<int>('log_id')!;
  set logId(int value) => setField<int>('log_id', value);

  String get logMessage => getField<String>('log_message')!;
  set logMessage(String value) => setField<String>('log_message', value);

  DateTime get logTimestamp => getField<DateTime>('log_timestamp')!;
  set logTimestamp(DateTime value) =>
      setField<DateTime>('log_timestamp', value);
}
