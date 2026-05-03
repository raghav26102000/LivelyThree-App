import '../database.dart';

class CommunityMembershipTable extends SupabaseTable<CommunityMembershipRow> {
  @override
  String get tableName => 'community_membership';

  @override
  CommunityMembershipRow createRow(Map<String, dynamic> data) =>
      CommunityMembershipRow(data);
}

class CommunityMembershipRow extends SupabaseDataRow {
  CommunityMembershipRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunityMembershipTable();

  /// Primary key
  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  /// Foreign key to community.id
  String get communityId => getField<String>('community_id')!;
  set communityId(String value) => setField<String>('community_id', value);

  /// Foreign key to party.id
  String get partyId => getField<String>('party_id')!;
  set partyId(String value) => setField<String>('party_id', value);

  /// Timestamp when the user joined
  DateTime get joinedAt => getField<DateTime>('joined_at')!;
  set joinedAt(DateTime value) => setField<DateTime>('joined_at', value);
}
