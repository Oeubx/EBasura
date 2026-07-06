import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

int incrementationFunction(int initialValue) {
  return initialValue + 1;
}

int plusPoints(
  int initialValue,
  int amountOfPoints,
) {
  return initialValue + amountOfPoints;
}

int minusPoints(
  int initialValue,
  int amountOfPoints,
) {
  return initialValue + amountOfPoints;
}

int decrementationFunction(int initialValue) {
  return initialValue - 1;
}

DateTime getCurrentTime(DateTime currentTimeValue) {
  return currentTimeValue.subtract(const Duration(hours: 8));
}

List<String> parseWasteResponse(String apiResponseText) {
// 1. Safety check: if the input text is null or empty, return an empty list
  if (apiResponseText.isEmpty) {
    return [];
  }

  // 2. Since it's already a single string, split it directly by the newline character
  return apiResponseText
      .split('\n')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

bool stringToBool(String textValue) {
// Returns true if the string is exactly 'true', otherwise returns false
  return textValue.trim().toLowerCase() == 'true';
}
