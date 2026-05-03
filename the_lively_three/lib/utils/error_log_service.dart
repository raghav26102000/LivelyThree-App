import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorLogService {
  /// Logs error into error_log table (auto detects class & function)
  static Future<void> logError(dynamic error, [StackTrace? stackTrace]) async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) {
        debugPrint('[error_log] No logged-in user → skipping log');
        return;
      }

      // 🔍 Extract class & function names from StackTrace
      final trace = (stackTrace ?? StackTrace.current).toString().split('\n');
      String? caller;
      if (trace.isNotEmpty) {
        final frame = trace.firstWhere(
          (line) => line.contains('package:'),
          orElse: () => trace.first,
        );
        final match = RegExp(r'#\d+\s+(\S+)').firstMatch(frame);
        caller = match?.group(1); // Example: MyClass.myFunction
      }

      String? className;
      String? functionName;

      if (caller != null && caller.contains('.')) {
        final parts = caller.split('.');
        className = parts.first;
        functionName = parts.last;
      } else {
        className = 'unknown';
        functionName = caller ?? 'unknown';
      }

      await client.from('error_log').insert({
        'class_name': className,
        'function_name': functionName,
        'error': error.toString(),
        'user_id': user.id,
        'created_by': user.id,
        'status': 1,
      });

      debugPrint('✅ Error logged: $className → $functionName');
    } catch (e) {
      debugPrint('❌ Failed to log error: $e');
    }
  }
}
