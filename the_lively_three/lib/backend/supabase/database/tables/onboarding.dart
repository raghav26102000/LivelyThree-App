import '../database.dart';

class OnboardingTable extends SupabaseTable<OnboardingRow> {
  @override
  String get tableName => 'onboarding';

  @override
  OnboardingRow createRow(Map<String, dynamic> data) => OnboardingRow(data);
}

class OnboardingRow extends SupabaseDataRow {
  OnboardingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OnboardingTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  bool? get qHealthyeating => getField<bool>('q_healthyeating');
  set qHealthyeating(bool? value) => setField<bool>('q_healthyeating', value);

  bool? get qNewfoods => getField<bool>('q_newfoods');
  set qNewfoods(bool? value) => setField<bool>('q_newfoods', value);

  bool? get qDifferentplants => getField<bool>('q_differentplants');
  set qDifferentplants(bool? value) =>
      setField<bool>('q_differentplants', value);

  String? get qActivitylevel => getField<String>('q_activitylevel');
  set qActivitylevel(String? value) =>
      setField<String>('q_activitylevel', value);

  bool? get qChangewillingness => getField<bool>('q_changewillingness');
  set qChangewillingness(bool? value) =>
      setField<bool>('q_changewillingness', value);

  String? get qChangeto => getField<String>('q_changeto');
  set qChangeto(String? value) => setField<String>('q_changeto', value);

  String? get qGoalOne => getField<String>('q_goal_one');
  set qGoalOne(String? value) => setField<String>('q_goal_one', value);

  String? get qGoalTwo => getField<String>('q_goal_two');
  set qGoalTwo(String? value) => setField<String>('q_goal_two', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get plantpreset => getField<String>('plantpreset');
  set plantpreset(String? value) => setField<String>('plantpreset', value);
}
