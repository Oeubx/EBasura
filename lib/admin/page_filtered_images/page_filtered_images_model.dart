import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'page_filtered_images_widget.dart' show PageFilteredImagesWidget;
import 'package:flutter/material.dart';

class PageFilteredImagesModel
    extends FlutterFlowModel<PageFilteredImagesWidget> {
  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    cBottomBarModel.dispose();
  }
}
