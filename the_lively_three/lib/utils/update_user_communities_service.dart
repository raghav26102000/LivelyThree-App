import 'package:supabase_flutter/supabase_flutter.dart';

/// Syncs user with correct communities based on age, gender, ethnicity, and location.
class CommunitySyncService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Updates user’s community memberships based on given demographic attributes.
  Future<Map<String, dynamic>> updateUserCommunities({
    required int age,
    required int gender,
    required int ethnicity,
    required int location,
    required String reason,
  }) async {
    try {
      // Step 1️⃣: Get current authenticated user
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user found.');
      final userId = user.id;

      // Step 2️⃣: Find associated party record
      final partyResponse = await supabase
          .from('party')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (partyResponse == null) throw Exception('No party found for user.');
      final partyId = partyResponse['id'] as String;

      // Step 3️⃣: Fetch all current memberships with linked community attributes
      final currentMemberships = await supabase
          .from('community_membership')
          .select('community_id, community!inner (gender, age, location, ethnicity)')
          .eq('party_id', partyId);

      // Step 4️⃣: Fetch all active communities
      final communities = await supabase
          .from('community')
          .select('id, gender, age, location, ethnicity')
          .eq('status', 1);

      final Set<String> eligibleCommunityIds = {};
      final List<String> removedCommunities = []; // order-preserving
      final List<String> addedCommunities = []; // order-preserving

      // Step 5️⃣: Determine all communities the user *should belong* to
      for (final c in communities) {
        final cGender = c['gender'];
        final cAge = c['age'];
        final cLocation = c['location'];
        final cEthnicity = c['ethnicity'];

         // ✅ Explicit check: if all filters are -1, it's a global community
        final isGlobalCommunity = (cGender == -1 &&
            cAge == -1 &&
            cLocation == -1 &&
            cEthnicity == -1);

        if (isGlobalCommunity) {
          // All users must be added to this community
          eligibleCommunityIds.add(c['id'] as String);
        }

        // A user is eligible if the community field is -1 (wildcard) OR matches user’s value
        final matches = (cGender == -1 || cGender == gender) &&
            (cAge == -1 || cAge == age) &&
            (cLocation == -1 || cLocation == location) &&
            (cEthnicity == -1 || cEthnicity == ethnicity);

        if (matches) eligibleCommunityIds.add(c['id'] as String);
      }

      // Step 6️⃣: Determine current memberships before sync
      final currentIds =
          currentMemberships.map((e) => e['community_id'] as String).toSet();

      // Step 7️⃣: Identify which to remove and which to add
      final toRemove = currentIds.difference(eligibleCommunityIds);
      final toAdd = eligibleCommunityIds.difference(currentIds);

      // Step 8️⃣: Remove user from communities they no longer qualify for
      // Keep ordering by iterating toRemove (which is a set) converted to list.
      final List<String> toRemoveList = toRemove.toList();
      for (final id in toRemoveList) {
        await supabase
            .from('community_membership')
            .delete()
            .eq('party_id', partyId)
            .eq('community_id', id);

        removedCommunities.add(id);
      }

      // Step 9️⃣: Add user to all newly qualified communities
      final List<String> toAddList = toAdd.toList();
      for (final id in toAddList) {
        await supabase.from('community_membership').insert({
          'community_id': id,
          'party_id': partyId,
        });

        addedCommunities.add(id);
      }

      // Step 🔟: Log changes — pair removed + added where possible, then leftover rows
      final int pairs = removedCommunities.length < addedCommunities.length
          ? removedCommunities.length
          : addedCommunities.length;

      // Pair up first `pairs` items
      for (int i = 0; i < pairs; i++) {
        final oldId = removedCommunities[i];
        final newId = addedCommunities[i];

        await supabase.from('community_change_log').insert({
          'party_id': partyId,
          'old_community_id': oldId,
          'new_community_id': newId,
          'reason': reason,
        });
      }

      // If there are leftover removed communities (more removals than additions),
      // log them as old-only rows.
      if (removedCommunities.length > pairs) {
        for (int i = pairs; i < removedCommunities.length; i++) {
          final oldId = removedCommunities[i];
          await supabase.from('community_change_log').insert({
            'party_id': partyId,
            'old_community_id': oldId,
            'reason': reason,
          });
        }
      }

      // If there are leftover added communities (more additions than removals),
      // log them as new-only rows.
      if (addedCommunities.length > pairs) {
        for (int i = pairs; i < addedCommunities.length; i++) {
          final newId = addedCommunities[i];
          await supabase.from('community_change_log').insert({
            'party_id': partyId,
            'new_community_id': newId,
            'reason': reason,
          });
        }
      }

      // Step 11️⃣: Return summary
      return {
        'status': 'success',
        'removed': removedCommunities,
        'added': addedCommunities,
        'eligible': eligibleCommunityIds.toList(),
      };
    } catch (e) {
      print('❌ Error syncing communities: $e');
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
}
