import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'p_street_view_all_widget.dart' show PStreetViewAllWidget;
import 'package:flutter/material.dart';

class PStreetViewAllModel extends FlutterFlowModel<PStreetViewAllWidget> {
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
