import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'p_street_compliance_desk_widget.dart' show PStreetComplianceDeskWidget;
import 'package:flutter/material.dart';

class PStreetComplianceDeskModel
    extends FlutterFlowModel<PStreetComplianceDeskWidget> {
  /// State fields for stateful widgets in this page.
  late CBottomBarModel cBottomBarModel;

  // Search filter
  FocusNode? searchFocusNode;
  TextEditingController? searchTextController;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    cBottomBarModel.dispose();
    searchFocusNode?.dispose();
    searchTextController?.dispose();
  }
}
