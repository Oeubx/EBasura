import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'c_badges_creation_widget.dart' show CBadgesCreationWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CBadgesCreationModel extends FlutterFlowModel<CBadgesCreationWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField_name widget.
  FocusNode? textFieldNameFocusNode;
  TextEditingController? textFieldNameTextController;
  String? Function(BuildContext, String?)? textFieldNameTextControllerValidator;
  // State field(s) for TextField_desc widget.
  FocusNode? textFieldDescFocusNode;
  TextEditingController? textFieldDescTextController;
  String? Function(BuildContext, String?)? textFieldDescTextControllerValidator;
  // State field(s) for TextField_min widget.
  FocusNode? textFieldMinFocusNode;
  TextEditingController? textFieldMinTextController;
  String? Function(BuildContext, String?)? textFieldMinTextControllerValidator;
  // State field(s) for TextField_max widget.
  FocusNode? textFieldMaxFocusNode;
  TextEditingController? textFieldMaxTextController;
  String? Function(BuildContext, String?)? textFieldMaxTextControllerValidator;
  // State field(s) for CountController widget.
  int? countControllerValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldNameFocusNode?.dispose();
    textFieldNameTextController?.dispose();

    textFieldDescFocusNode?.dispose();
    textFieldDescTextController?.dispose();

    textFieldMinFocusNode?.dispose();
    textFieldMinTextController?.dispose();

    textFieldMaxFocusNode?.dispose();
    textFieldMaxTextController?.dispose();
  }
}
