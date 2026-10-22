import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'page_profile_about_widget.dart' show PageProfileAboutWidget;
import 'package:flutter/material.dart';

class PageProfileAboutModel extends FlutterFlowModel<PageProfileAboutWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField_feedback widget.
  FocusNode? textFieldFeedbackFocusNode;
  TextEditingController? textFieldFeedbackTextController;
  String? Function(BuildContext, String?)?
      textFieldFeedbackTextControllerValidator;
  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    textFieldFeedbackFocusNode?.dispose();
    textFieldFeedbackTextController?.dispose();

    cBottomBarModel.dispose();
  }
}
