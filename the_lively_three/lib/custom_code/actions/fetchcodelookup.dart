// // Automatic FlutterFlow imports
// import '/backend/backend.dart';
// import '/backend/schema/structs/index.dart';
// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import 'index.dart'; // Imports other custom actions
// import 'package:flutter/material.dart';
// // Add this:
// import 'package:supabase_flutter/supabase_flutter.dart';


// // Begin custom action code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!


// class CodeLkupRow {
//   final int id;
//   final String lkcode;
//   final int keycode;
//   final String? description;
//   final String? key1, key2, key3, key4, key5;
//   final int status;
//   final Map<String, dynamic> key6;

//   CodeLkupRow({
//     required this.id,
//     required this.lkcode,
//     required this.keycode,
//     this.description,
//     this.key1, this.key2, this.key3, this.key4, this.key5,
//     required this.status,
//     required this.key6,
//   });

//   factory CodeLkupRow.fromMap(Map<String, dynamic> m) => CodeLkupRow(
//     id: m['id'] as int,
//     lkcode: m['lkcode'] as String,
//     keycode: m['keycode'] as int,
//     description: m['description'] as String?,
//     key1: m['key1'] as String?,
//     key2: m['key2'] as String?,
//     key3: m['key3'] as String?,
//     key4: m['key4'] as String?,
//     key5: m['key5'] as String?,
//     status: m['status'] as int,
//     key6: Map<String, dynamic>.from(m['key6'] ?? const {}),
//   );
// }


// /// Fetch rows from public.codelkup
// /// - Pass one of [lkcode] (text) or [keycode] (int)
// /// - Optional [status] filter (e.g., 1 for active)
// /// - Optional [limit] and [orderBy] (defaults to id ASC)
// // Future<List<CodeLkupRow>> fetchCodelkup({
//   String? lkcode,   // e.g. 'rainbow_colors'
//   int?    keycode,  // alternative filter
//   int?    status,   // optional
//   int?    limit,
//   String  orderBy   = 'id',
//   bool    ascending = true,
// }) async {
//   final supa = Supabase.instance.client;

//   // Build a single filter map so we can use .match(...) in one chain
//   final filters = <String, dynamic>{};
//   if (lkcode != null && lkcode.isNotEmpty) {
//     filters['lkcode'] = lkcode;
//   } else if (keycode != null) {
//     filters['keycode'] = keycode;
//   } else {
//     // nothing to filter by – return empty explicitly
//     return <CodeLkupRow>[];
//   }
//   if (status != null) filters['status'] = status;

//   // Build final transform builder (keep a single type)
//   var builder = supa
//       .from('codelkup')
//       .select('*')
//       .match(filters)                    // -> FilterBuilder (returned), but we keep chaining
//       .order(orderBy, ascending: ascending); // -> back to TransformBuilder

//   if (limit != null) {
//     builder = builder.limit(limit);     // still a TransformBuilder
//   }

//   // Execute
//   final List<dynamic> rows = await builder;

//   // Cast each row to Map<String,dynamic> then to your model
//   return rows
//       .map((e) => CodeLkupRow.fromMap(Map<String, dynamic>.from(e as Map)))
//       .toList();
// }