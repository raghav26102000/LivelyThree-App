// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic?> insertUpdateMoodPanelCoordinatesAndColors(
  int xCoordinate,
  int yCoordinate,
  String userid,
) async {
  // Input validation
  if (xCoordinate < -100 ||
      xCoordinate > 100 ||
      yCoordinate < -100 ||
      yCoordinate > 100) {
    throw ArgumentError(
        "Coordinates must be in the range (-100:100) for both x and y.");
  }

  // Define colors for blending
  const Color centerColor = Color(0xFFE0E3E7); // Light Grey

  const Color topLeftColor = Color(0xFFFF0000); // Red
  // const Color topLeftColor = Color(0xFF9e0202); // Red

  const Color topRightColor = Color(0xFF37FF01); // Green
  // const Color topRightColor = Color(0xFF209600); // Green

  const Color bottomLeftColor = Color(0xFF00E4FF); // Blue
  // const Color bottomLeftColor = Color(0xFF0090a1); // Blue

  const Color bottomRightColor = Color(0xFFFFF801); // Yellow
  //  const Color bottomRightColor = Color(0xFF969202); // Yellow

  // Calculate the maximum distance from (0,0) to (100,100)
  const double maxDistance = 141.4213562373095; // sqrt(100^2 + 100^2)

  // Calculate the distance and blend ratio
  final double distance = math
      .sqrt((xCoordinate.toDouble() * xCoordinate.toDouble()) +
          (yCoordinate.toDouble() * yCoordinate.toDouble()))
      .clamp(0.0, maxDistance);
  final double blendRatio = (distance / maxDistance).clamp(0.0, 1.0);

  // Determine the quadrant colors
  Color primaryColor;
  if (xCoordinate < 0 && yCoordinate > 0) {
    // Top-left (Red)
    primaryColor = topLeftColor;
  } else if (xCoordinate >= 0 && yCoordinate > 0) {
    // Top-right (Green)
    primaryColor = topRightColor;
  } else if (xCoordinate < 0 && yCoordinate <= 0) {
    // Bottom-left (Blue)
    primaryColor = bottomLeftColor;
  } else {
    // Bottom-right (Yellow)
    primaryColor = bottomRightColor;
  }

  // Blend color linearly from the center tone
  final Color blendedColor = Color.lerp(centerColor, primaryColor, blendRatio)!;

  // Convert the final color to HEX format
  String hexColor =
      "#${blendedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}";

  //print("Coordinates: ($xCoordinate, $yCoordinate)");
  //print("Distance: $distance, Blend Ratio: $blendRatio");
  //print("Assigned Primary Color: ${primaryColor.toString()}");
  //print("Final Hex Color: $hexColor");

  // Get time-based information
  final DateTime now = DateTime.now();
  final int calendarWeek =
      ((int.parse(DateFormat("D").format(now)) - now.weekday + 10) / 7).floor();
  final int weekday = now.weekday;
  final int period = ((now.hour / 2).floor() + 1).clamp(1, 12);

  // Supabase client
  final supabaseClient = Supabase.instance.client;

  try {
    // Call the Supabase RPC function
    final data = await supabaseClient.rpc(
      'update_moodpanel',
      params: {
        'calendarweek': calendarWeek,
        'calendaryear': now.year,
        'weekday': weekday,
        'user_id': userid,
        'period': period,
        'x_coordinate': xCoordinate,
        'y_coordinate': yCoordinate,
        'hex_color': hexColor,
      },
    );

    print(period);

    if (data == null) {
      throw Exception('No data returned from the Supabase RPC function.');
    }

    // Prepare the JSON structure for the return
    final result = <String, dynamic>{
      'weekday': data['weekday'],
      'calendarweek': data['calendarweek'],
      'calendaryear': data['calendaryear'],
    };

    for (int i = 1; i <= 12; i++) {
      final periodKey = 'period_$i';
      final periodData = data[periodKey];
      result[periodKey] = periodData; // Assign as-is, already a string
    }

    return result; // Return the prepared JSON
  } catch (e) {
    print('Error in insertUpdateMoodPanelCoordinatesAndColors: $e');

    // Prepare a fallback JSON structure
    final fallbackResult = <String, dynamic>{
      'weekday': weekday,
      'calendarweek': calendarWeek,
      'calendaryear': now.year,
    };

    for (int i = 1; i <= 12; i++) {
      fallbackResult['period_$i'] = null;
    }

    return fallbackResult;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
