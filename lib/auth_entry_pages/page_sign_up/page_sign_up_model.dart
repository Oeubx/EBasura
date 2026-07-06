import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'page_sign_up_widget.dart' show PageSignUpWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PageSignUpModel extends FlutterFlowModel<PageSignUpWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField_email widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;
  String? _textFieldEmailTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter Email is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for TextField_password widget.
  FocusNode? textFieldPasswordFocusNode;
  TextEditingController? textFieldPasswordTextController;
  late bool textFieldPasswordVisibility;
  String? Function(BuildContext, String?)?
      textFieldPasswordTextControllerValidator;
  String? _textFieldPasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required';
    }

    if (val.length < 8) {
      return 'Password must have a minimum of 8 characters';
    }

    if (!RegExp('').hasMatch(val)) {
      return 'Invalid text';
    }
    return null;
  }

  // State field(s) for Textfield_cpassword widget.
  FocusNode? textfieldCpasswordFocusNode;
  TextEditingController? textfieldCpasswordTextController;
  late bool textfieldCpasswordVisibility;
  String? Function(BuildContext, String?)?
      textfieldCpasswordTextControllerValidator;
  String? _textfieldCpasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirm Password is required';
    }

    if (val.length < 8) {
      return 'Password must have a minimum of 8 characters';
    }

    if (!RegExp('').hasMatch(val)) {
      return 'Invalid text';
    }
    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for [Custom Action - signUpValidation] action in Button_signUp widget.
  String? signUpError;

  @override
  void initState(BuildContext context) {
    textFieldEmailTextControllerValidator =
        _textFieldEmailTextControllerValidator;
    textFieldPasswordVisibility = false;
    textFieldPasswordTextControllerValidator =
        _textFieldPasswordTextControllerValidator;
    textfieldCpasswordVisibility = false;
    textfieldCpasswordTextControllerValidator =
        _textfieldCpasswordTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();

    textFieldPasswordFocusNode?.dispose();
    textFieldPasswordTextController?.dispose();

    textfieldCpasswordFocusNode?.dispose();
    textfieldCpasswordTextController?.dispose();
  }
}
