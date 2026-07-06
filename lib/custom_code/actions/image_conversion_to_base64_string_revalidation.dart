// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> imageConversionToBase64StringRevalidation(
    String? imageUrl) async {
  if (imageUrl == null || imageUrl.isEmpty) {
    throw Exception('No image URL provided.');
  }

  try {
    // Download the image data from the web link
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Convert the downloaded binary body bytes into a Base64 string
      return base64Encode(response.bodyBytes);
    } else {
      throw Exception(
          'Failed to download image. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error converting remote image to Base64: $e');
  }
}
