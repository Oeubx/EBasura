// Automatic FlutterFlow imports
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

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/auth/supabase_auth/auth_util.dart';

bool? guestRateLimiter(
  DateTime currentTime,
  DateTime? prevUsedTime,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // If user has never used the feature before → allow
  if (prevUsedTime == null) {
    return true;
  }

  // Compute time difference
  final difference = currentTime.difference(prevUsedTime);

  // Check if 24 hours have passed
  if (difference.inHours >= 24) {
    return true; // ALLOW
  }

  return false; // BLOCK
  /// MODIFY CODE ONLY ABOVE THIS LINE
}
