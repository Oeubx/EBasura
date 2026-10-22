import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_model.dart';
import 'p_badge_view_all_widget.dart' show PBadgeViewAllWidget;
import 'package:flutter/material.dart';

class PBadgeViewAllModel extends FlutterFlowModel<PBadgeViewAllWidget> {
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
