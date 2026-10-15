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
  return math.max(0, initialValue - amountOfPoints);
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

String formatWasteClassificationFeedback({
  required bool isSegregated,
  required bool isRecyclable,
  required bool isBiodegradable,
  required bool isNonBiodegradable,
}) {
  final segregationText = isSegregated ? "segregated" : "not segregated";

  final categories = <String>[];
  if (isRecyclable) categories.add("recyclable");
  if (isBiodegradable) categories.add("biodegradable");
  if (isNonBiodegradable) categories.add("non-biodegradable");

  String combinationText;
  if (categories.isEmpty) {
    combinationText = "unidentified waste";
  } else if (categories.length == 1) {
    combinationText = categories.first;
  } else if (categories.length == 2) {
    combinationText = "${categories[0]} and ${categories[1]}";
  } else {
    combinationText = "${categories[0]}, ${categories[1]}, and ${categories[2]}";
  }

  return "The waste seems $segregationText with combination of $combinationText.";
}

String formatWasteClassificationFromList(List<String>? responseList) {
  if (responseList == null || responseList.length < 5) {
    return "The waste could not be classified accurately.";
  }
  // 5 attributes in order:
  // 0: valid_waste_image
  // 1: recyclable
  // 2: segregated
  // 3: biodegradable
  // 4: non_biodegradable
  final isValidWaste = stringToBool(responseList[0]);
  if (!isValidWaste) {
    return "The uploaded image does not appear to contain valid identifiable waste.";
  }

  final isRecyclable = stringToBool(responseList[1]);
  final isSegregated = stringToBool(responseList[2]);
  final isBiodegradable = stringToBool(responseList[3]);
  final isNonBiodegradable = stringToBool(responseList[4]);

  return formatWasteClassificationFeedback(
    isSegregated: isSegregated,
    isRecyclable: isRecyclable,
    isBiodegradable: isBiodegradable,
    isNonBiodegradable: isNonBiodegradable,
  );
}

