import '/auth/supabase_auth/auth_util.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'page_change_password_widget.dart' show PageChangePasswordWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PageChangePasswordModel
    extends FlutterFlowModel<PageChangePasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
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
      return 'Confirm Password is required';
    }

    if (val.length < 8) {
      return 'Password must have a minimum of 8 characters';
    }

    return null;
  }

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    textFieldPasswordVisibility = false;
    textFieldPasswordTextControllerValidator =
        _textFieldPasswordTextControllerValidator;
    textfieldCpasswordVisibility = false;
    textfieldCpasswordTextControllerValidator =
        _textfieldCpasswordTextControllerValidator;
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    textFieldPasswordFocusNode?.dispose();
    textFieldPasswordTextController?.dispose();

    textfieldCpasswordFocusNode?.dispose();
    textfieldCpasswordTextController?.dispose();

    cBottomBarModel.dispose();
  }
}
