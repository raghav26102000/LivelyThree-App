import 'package:supabase_flutter/supabase_flutter.dart';
import '/utils/update_user_communities_service.dart';

class CommunityJoinService {
  final SupabaseClient supabase = Supabase.instance.client;
  final updateUserCommunity = CommunitySyncService();

  /// 🔹 Fetch user data and pass to ensurePartyAndJoinCommunity
  Future<void> addUsersToCommunities(
      String userId, String partyId, String existingReason) async {
    try {
      // Fetch user data from 'users' table
      final userData = await supabase
          .from('users')
          .select('gender, country, ethnicity, age')
          .eq('id', userId)
          .maybeSingle();

      print('Data fetched of id: $userId');
      if (userData == null) {
        print('❌ No user found with id: $userId');
        return;
      }

      final String gender = userData['gender'] ?? '';
      final String location = userData['country'];
      final int ethnicity = userData['ethnicity'];
      final int age = userData['age'] ?? 0;

      print(
          '👤 User data fetched for $userId → gender=$gender, location=$location, ethnicity=$ethnicity, age=$age');

      final newReason =
          "Updated → Age Group: ($age), Gender: ${gender ?? 'N/A'} , Ethnicity:  ($ethnicity), Location: ${location ?? 'N/A'}";

      final reason = "$existingReason\n$newReason";

      final genderLookup = await supabase
          .from('codelkup')
          .select('keycode')
          .eq('lkcode', 'Gender')
          .eq('key1', gender)
          .maybeSingle();

      if (genderLookup == null) {
        print('⚠️ Gender "$gender" not found in codelkup.');
        return;
      }

      final int genderCode = genderLookup['keycode'];
      print('👥 Gender "$gender" matched to keycode: $genderCode');

      // 3️⃣ Handle ethnicity (default -1)
      int ethnicityCode = ethnicity;

      // 4️⃣ Determine the age group keycode
      int? ageGroupCode;
      final List<dynamic> ageGroups = await supabase
          .from('codelkup')
          .select('keycode, key1')
          .eq('lkcode', 'age_group');

      for (final group in ageGroups) {
        final key1 = group['key1'] as String?;
        if (key1 == null) continue;

        if (key1.toLowerCase() == 'all') {
          ageGroupCode ??= group['keycode'];
          continue;
        }

        final match = RegExp(r'^(\d+)\s*-\s*(\d+)$').firstMatch(key1);
        if (match != null) {
          final int lower = int.parse(match.group(1)!);
          final int upper = int.parse(match.group(2)!);
          if (age >= lower && age <= upper) {
            ageGroupCode = group['keycode'];
            print('🎂 Age $age matched range $key1 → keycode $ageGroupCode');
            break;
          }
        }
      }

      if (ageGroupCode == null) {
        print('⚠️ No specific age group matched; using default "All".');
        final fallback = ageGroups.firstWhere(
          (g) => (g['key1'] as String?)?.toLowerCase() == 'all',
          orElse: () => null,
        );
        if (fallback != null) {
          ageGroupCode = fallback['keycode'];
        }
      }

      // 5️⃣ Convert location to integer
      int? locationCode;
      if (location != null && location.isNotEmpty) {
        try {
          locationCode = int.tryParse(location);
          print('📍 Converted location "$location" to code $locationCode');
        } catch (_) {
          print('⚠️ Invalid location format "$location", ignoring.');
        }
      }

      if (
          // genderCode != null &&
          locationCode != null &&
              //   ethnicityCode != null &&
              ageGroupCode != null
          // reason != null
          ) {
        print("🔄 Syncing communities due to user changes...");
        final result = await updateUserCommunity.updateUserCommunities(
          age: ageGroupCode, // <-- use group keycode instead of raw age
          gender: genderCode,
          ethnicity: ethnicityCode,
          location: locationCode,
          reason: reason,
        );
        print("🏡 Community Sync Result: $result");

        // 6️⃣ Find matching community
        // var query = supabase.from('community').select('id, name');
        // query = query
        //     .eq('gender', genderCode)
        //     .eq('ethnicity', ethnicityCode)
        //     .eq('age', ageGroupCode ?? 0);

        // if (locationCode != null) {
        //   query = query.eq('location', locationCode);
        // }

        // final community = await query.maybeSingle();

        // if (community == null) {
        //   print(
        //       '⚠️ No community found for gender=$genderCode, ethnicity=$ethnicityCode, ageGroup=$ageGroupCode, location=$locationCode');
        //   return;
        // }

        // final communityId = community['id'];
        // final communityName = community['name'];
        // print('✅ Found community: $communityName ($communityId)');

        // // 7️⃣ Check or create membership
        // final existingMembership = await supabase
        //     .from('community_membership')
        //     .select('id')
        //     .eq('community_id', communityId)
        //     .eq('party_id', partyId)
        //     .maybeSingle();

        // if (existingMembership != null) {
        //   print('ℹ️ Already member of "$communityName".');
        // } else {
        //   await supabase.from('community_membership').insert({
        //     'community_id': communityId,
        //     'party_id': partyId,
        //     'joined_at': DateTime.now().toUtc().toIso8601String(),
        //   });
        //   print('✅ Joined "$communityName" successfully.');
      }
    } catch (e) {
      print('❌ Error while adding user $userId to community: $e');
    }
  }

  /// 🔹 Ensures a 'party' record exists and joins correct community based on user attributes
  Future<void> ensurePartyAndJoinCommunity(String reason) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('❌ User not logged in.');
      return;
    }

    final userId = user.id;

    try {
      // 1️⃣ Ensure the user has a party record
      final existingParty = await supabase
          .from('party')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      String partyId;

      if (existingParty != null) {
        partyId = existingParty['id'];
        print('✅ Found existing party: $partyId');
      } else {
        print('👤 Creating new party record for user $userId');
        final insertedParty = await supabase
            .from('party')
            .insert({
              'type': 1,
              'user_id': userId,
              'created_at': DateTime.now().toUtc().toIso8601String(),
            })
            .select('id')
            .single();

        partyId = insertedParty['id'];
        print('✅ Created new party: $partyId');
        await addUsersToCommunities(userId, partyId, reason);
      }
    } catch (e) {
      print('❌ Error during party or community join: $e');
    }
  }
}
