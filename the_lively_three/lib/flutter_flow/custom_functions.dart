import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

int? totalSelectNumber(
  int? redSelect,
  int? orangeSelect,
  int? yellowSelect,
  int? greenSelect,
  int? purpleSelect,
  int? brownSelect,
  int? whiteSelect,
) {
  // Enter integer based arguments based on app state variables and return a sum total.
  return (redSelect ?? 0) +
      (orangeSelect ?? 0) +
      (yellowSelect ?? 0) +
      (brownSelect ?? 0) +
      (whiteSelect ?? 0) +
      (greenSelect ?? 0) +
      (purpleSelect ?? 0);
}

double? roundingNumber(double? weekyhealthscore) {
  // Take a double argument as input, divide it by 100 and and round it to 1 decimal number
  if (weekyhealthscore != null) {
    double dividedValue = weekyhealthscore / 100;
    double roundedValue = (dividedValue * 100).round() / 100;

    return roundedValue;
  }
  return null;
}

Color? progressBarColors(double weeklyhealthscore) {
  // Can you generate a custom function which receive an argument (double) and creates the following return value of type color: if argument <=24 then red, else if argument <= 49 then orange, if <=74 then yellow else green.
  if (weeklyhealthscore <= 24) {
    return Colors.red;
  } else if (weeklyhealthscore <= 49) {
    return Colors.orange;
  } else if (weeklyhealthscore <= 74) {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}

bool isToggleDisabled() {
  // Create a function which disables a toggle widget each Sunday 23:50 to Monday 0:30 and returns false if it is outside the period and true within that period.
  DateTime now = DateTime.now();
  if (now.weekday == DateTime.sunday && now.hour == 23 && now.minute >= 50) {
    return true;
  } else if (now.weekday == DateTime.monday &&
      now.hour == 0 &&
      now.minute <= 30) {
    return true;
  } else {
    return false;
  }
}

bool isCurrentPeriod(
  int startHour,
  int startMinute,
  int endHour,
  int endMinute,
) {
  // Validate inputs
  if (startHour < 0 || startHour > 23 || endHour < 0 || endHour > 23) {
    throw ArgumentError("Hours must be between 0 and 23.");
  }
  if (startMinute < 0 || startMinute > 59 || endMinute < 0 || endMinute > 59) {
    throw ArgumentError("Minutes must be between 0 and 59.");
  }

  DateTime now = DateTime.now();
  DateTime startTime =
      DateTime(now.year, now.month, now.day, startHour, startMinute);
  DateTime endTime = DateTime(now.year, now.month, now.day, endHour, endMinute);

  // Handle overnight periods
  if (endTime.isBefore(startTime)) {
    endTime = endTime.add(Duration(days: 1));
  }

  return now.isAfter(startTime) && now.isBefore(endTime);
}

Color? hexToColor(String? hexCode) {
  // Validate the hexCode format
  if (hexCode == null || !RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(hexCode)) {
    return null; // Return null for invalid hex codes
  }

  // Convert the hex code to a Color object
  return Color(int.parse(hexCode.substring(1), radix: 16) + 0xFF000000);
}

bool numberEvaluation(double missingColorNumber) {
  // take a parameter called "missingColorNumber" (integer) and look if the value is 0 or higher. If it is higher than return true, otherwise return false
  if (missingColorNumber > 0) {
    return true;
  } else {
    return false;
  }
}
