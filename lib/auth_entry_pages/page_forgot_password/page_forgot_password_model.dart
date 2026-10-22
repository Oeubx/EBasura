import '/flutter_flow/flutter_flow_util.dart';
import 'page_forgot_password_widget.dart' show PageForgotPasswordWidget;
import 'package:flutter/material.dart';

class PageForgotPasswordModel
    extends FlutterFlowModel<PageForgotPasswordWidget> {
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

  @override
  void initState(BuildContext context) {
    textFieldEmailTextControllerValidator =
        _textFieldEmailTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();
  }
}
