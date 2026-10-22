import '/flutter_flow/flutter_flow_util.dart';
import 'page_sign_up_widget.dart' show PageSignUpWidget;
import 'package:flutter/material.dart';

class PageSignUpModel extends FlutterFlowModel<PageSignUpWidget> {
  final formKey = GlobalKey<FormState>();

  // State field(s) for TextField_email widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;

  String? _textFieldEmailTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val.trim())) {
      return 'Enter a valid email address';
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
      return 'Confirm password is required';
    }
    if (val != textFieldPasswordTextController?.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // Stores action output result for custom action validation
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
    checkboxValue = false;
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
