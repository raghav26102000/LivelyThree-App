import '../database.dart';

class SubscriptionsTable extends SupabaseTable<SubscriptionsRow> {
  @override
  String get tableName => 'subscriptions';

  @override
  SubscriptionsRow createRow(Map<String, dynamic> data) =>
      SubscriptionsRow(data);
}

class SubscriptionsRow extends SupabaseDataRow {
  SubscriptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get idUser => getField<String>('id_user');
  set idUser(String? value) => setField<String>('id_user', value);

  String? get subscriptionType => getField<String>('subscription_type');
  set subscriptionType(String? value) =>
      setField<String>('subscription_type', value);

  DateTime? get startDate => getField<DateTime>('start_date');
  set startDate(DateTime? value) => setField<DateTime>('start_date', value);

  DateTime? get endDate => getField<DateTime>('end_date');
  set endDate(DateTime? value) => setField<DateTime>('end_date', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
