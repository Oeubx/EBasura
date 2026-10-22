import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'page_profile_about_a_d_e_t_widget.dart' show PageProfileAboutADETWidget;
import 'package:flutter/material.dart';

class PageProfileAboutADETModel
    extends FlutterFlowModel<PageProfileAboutADETWidget> {
  ///  State fields for stateful widgets in this page.

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
