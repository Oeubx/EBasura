import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_model.dart';
import 'p_badge_view_one_widget.dart' show PBadgeViewOneWidget;
import 'package:flutter/material.dart';

class PBadgeViewOneModel extends FlutterFlowModel<PBadgeViewOneWidget> {
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

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

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

    cBottomBarModel.dispose();
  }
}
