import 'package:flutter/material.dart';

class LoaderUtils {
  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static Future<T> runWithLoader<T>(
    BuildContext context,
    Future<T> Function() asyncFunction,
  ) async {
    showLoader(context);
    try {
      final result = await asyncFunction();
      hideLoader(context);
      return result;
    } catch (e) {
      hideLoader(context);
      rethrow;
    }
  }
}
