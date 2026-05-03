import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateCommunityService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// 🔹 After creating a new community, populate it with all matching users
  Future<void> updateUserCommunitiesForCommunity(String communityId) async {
    try {
      // 1️⃣ Fetch community details
      final community = await supabase
          .from('community')
          .select('id, name, age, gender, location, ethnicity')
          .eq('id', communityId)
          .maybeSingle();

      if (community == null) {
        print('❌ Community not found with id: $communityId');
        return;
      }

      final int ageCode = community['age'] ?? -1;
      final int genderCode = community['gender'] ?? -1;
      final int location = community['location'] ?? -1;
      final int ethnicity = community['ethnicity'] ?? -1;
      final String communityName = community['name'];

      print('🔍 Processing community "$communityName" '
          '(ageCode=$ageCode, genderCode=$genderCode, location=$location, ethnicity=$ethnicity)');

      String? genderValue;
      String? ageKey1;
      int? lowerAge;
      int? upperAge;

      // 2️⃣ Fetch Gender from codelkup (if not -1)
      if (genderCode != -1) {
        final genderLookup = await supabase
            .from('codelkup')
            .select('key1')
            .eq('lkcode', 'Gender')
            .eq('keycode', genderCode)
            .maybeSingle();

        if (genderLookup != null && genderLookup['key1'] != null) {
          genderValue = genderLookup['key1'] as String;
          print('👥 Gender code $genderCode → "$genderValue"');
        } else {
          print('⚠️ No Gender found for keycode $genderCode, ignoring gender filter.');
        }
      }

      // 3️⃣ Fetch Age Group from codelkup (if not -1)
      if (ageCode != -1) {
        final ageLookup = await supabase
            .from('codelkup')
            .select('key1')
            .eq('lkcode', 'age_group')
            .eq('keycode', ageCode)
            .maybeSingle();

        if (ageLookup != null && ageLookup['key1'] != null) {
          ageKey1 = ageLookup['key1'] as String;
          print('🎂 Age group code $ageCode → "$ageKey1"');

          // Parse "25-35", "25+", or "25"
          final rangeMatch = RegExp(r'^(\d+)\s*-\s*(\d+)$').firstMatch(ageKey1);
          if (rangeMatch != null) {
            lowerAge = int.parse(rangeMatch.group(1)!);
            upperAge = int.parse(rangeMatch.group(2)!);
            print('📏 Age range detected: $lowerAge - $upperAge');
          } else {
            final directMatch = RegExp(r'^(\d+)\+?$').firstMatch(ageKey1);
            if (directMatch != null) {
              lowerAge = int.parse(directMatch.group(1)!);
              upperAge = null; // any age >= lowerAge
              print('📏 Age threshold detected: $lowerAge+');
            }
          }
        } else {
          print('⚠️ No Age Group found for keycode $ageCode, ignoring age filter.');
        }
      }

      // 4️⃣ Build dynamic query
      var query = supabase.from('users').select('id, age, gender, country, ethnicity');

      if (genderValue != null && genderCode != -1) {
        query = query.eq('gender', genderValue);
      }
      if (location != -1) {
        query = query.eq('country', location);
      }
      if (ethnicity != -1) {
        query = query.eq('ethnicity', ethnicity);
      }

      // Age filter (applied only when valid)
      if (ageCode != -1 && lowerAge != null) {
        if (upperAge != null) {
          query = query.gte('age', lowerAge).lte('age', upperAge);
        } else {
          query = query.gte('age', lowerAge);
        }
      }

      // 5️⃣ Execute query
      final List<dynamic> users = await query;

      if (users.isEmpty) {
        print('⚠️ No users found matching this community’s criteria.');
        return;
      }

      print('👥 Found ${users.length} matching users for community "$communityName".');

      // 6️⃣ Loop through each user and ensure membership
      for (final user in users) {
        final String userId = user['id'];

        final existingParty = await supabase
            .from('party')
            .select('id')
            .eq('user_id', userId)
            .maybeSingle();

        if (existingParty == null) {
          print('⚠️ No party found for user $userId, skipping.');
          continue;
        }

        final String partyId = existingParty['id'];

        final existingMembership = await supabase
            .from('community_membership')
            .select('id')
            .eq('community_id', communityId)
            .eq('party_id', partyId)
            .maybeSingle();

        if (existingMembership != null) {
          print('ℹ️ User $userId already in community "$communityName".');
          continue;
        }

        await supabase.from('community_membership').insert({
          'community_id': communityId,
          'party_id': partyId,
          'joined_at': DateTime.now().toUtc().toIso8601String(),
        });

        print('✅ Added user $userId to community "$communityName".');
      }

      print('🎉 Finished populating community "$communityName".');
    } catch (e) {
      print('❌ Error updating users for community: $e');
    }
  }
}
