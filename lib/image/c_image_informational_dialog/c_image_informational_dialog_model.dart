import '/flutter_flow/flutter_flow_util.dart';
import 'c_image_informational_dialog_widget.dart'
    show CImageInformationalDialogWidget;
import 'package:flutter/material.dart';

class CImageInformationalDialogModel
    extends FlutterFlowModel<CImageInformationalDialogWidget> {
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
