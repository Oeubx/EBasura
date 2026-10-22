import '/flutter_flow/flutter_flow_model.dart';
import 'c_badges_creation_widget.dart' show CBadgesCreationWidget;
import 'package:flutter/material.dart';

class CBadgesCreationModel extends FlutterFlowModel<CBadgesCreationWidget> {
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
