import '../database.dart';

class IndividualIndicatorBatchLogsTable
    extends SupabaseTable<IndividualIndicatorBatchLogsRow> {
  @override
  String get tableName => 'individual_indicator_batch_logs';

  @override
  IndividualIndicatorBatchLogsRow createRow(Map<String, dynamic> data) =>
      IndividualIndicatorBatchLogsRow(data);
}

class IndividualIndicatorBatchLogsRow extends SupabaseDataRow {
  IndividualIndicatorBatchLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => IndividualIndicatorBatchLogsTable();

  int get logId => getField<int>('log_id')!;
  set logId(int value) => setField<int>('log_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get indicatorName => getField<String>('indicator_name');
  set indicatorName(String? value) => setField<String>('indicator_name', value);

  double? get value => getField<double>('value');
  set value(double? value) => setField<double>('value', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  DateTime? get timestamp => getField<DateTime>('timestamp');
  set timestamp(DateTime? value) => setField<DateTime>('timestamp', value);
}
