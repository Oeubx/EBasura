import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'page_profile_widget.dart' show PageProfileWidget;

class PageProfileModel extends FlutterFlowModel<PageProfileWidget> {
  // State fields for Incident Reporting
  FocusNode? reportSubjectFocusNode;
  TextEditingController? reportSubjectTextController;
  String? Function(BuildContext, String?)? reportSubjectTextControllerValidator;

  FocusNode? reportDescFocusNode;
  TextEditingController? reportDescTextController;
  String? Function(BuildContext, String?)? reportDescTextControllerValidator;

  String? reportStreetValue;
  FFUploadedFile reportUploadedFile =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  bool isSubmittingReport = false;

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    reportSubjectFocusNode?.dispose();
    reportSubjectTextController?.dispose();
    reportDescFocusNode?.dispose();
    reportDescTextController?.dispose();
    cBottomBarModel.dispose();
  }
}
