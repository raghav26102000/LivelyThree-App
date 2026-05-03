import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);

  int? get height => getField<int>('height');
  set height(int? value) => setField<int>('height', value);

  String? get region => getField<String>('region');
  set region(String? value) => setField<String>('region', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get firstname => getField<String>('firstname');
  set firstname(String? value) => setField<String>('firstname', value);

  String? get lastname => getField<String>('lastname');
  set lastname(String? value) => setField<String>('lastname', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get displayname => getField<String>('displayname');
  set displayname(String? value) => setField<String>('displayname', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);

  int? get consecutiveZeroCount => getField<int>('consecutive_zero_count');
  set consecutiveZeroCount(int? value) =>
      setField<int>('consecutive_zero_count', value);

  bool? get hasSubscription => getField<bool>('has_subscription');
  set hasSubscription(bool? value) => setField<bool>('has_subscription', value);

  bool? get emailVerified => getField<bool>('email_verified');
  set emailVerified(bool? value) => setField<bool>('email_verified', value);

  DateTime? get birthdate => getField<DateTime>('birthdate');
  set birthdate(DateTime? value) => setField<DateTime>('birthdate', value);

  double? get currentProteinValue => getField<double>('current_protein_value');
  set currentProteinValue(double? value) =>
      setField<double>('current_protein_value', value);

  double? get currentFiberValue => getField<double>('current_fiber_value');
  set currentFiberValue(double? value) =>
      setField<double>('current_fiber_value', value);

  bool? get isOnboarded => getField<bool>('is_onboarded');
  set isOnboarded(bool? value) => setField<bool>('is_onboarded', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  DateTime get onboardedAt => getField<DateTime>('onboarded_at')!;
  set onboardedAt(DateTime value) => setField<DateTime>('onboarded_at', value);

  String get userName => getField<String>('user_name')!;
  set userName(String value) => setField<String>('user_name', value);

  String get timezone => getField<String>('timezone')!;
  set timezone(String value) => setField<String>('timezone', value);
}
