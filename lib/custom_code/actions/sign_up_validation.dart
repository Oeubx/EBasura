// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<String?> signUpValidation(
  String email,
  String password,
  String confirmPassword,
) async {
  // Check if passwords match
  if (password != confirmPassword) {
    return "Passwords do not match.";
  }

  // Check if fields are empty
  if (email.trim().isEmpty || password.trim().isEmpty) {
    return "Email and password are required.";
  }

  // Basic password length check
  if (password.length < 6) {
    return "Password must be at least 6 characters.";
  }

  // Optional: basic email format validation
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(email)) {
    return "Invalid email format.";
  }

  // If all validations pass
  return null;
}
