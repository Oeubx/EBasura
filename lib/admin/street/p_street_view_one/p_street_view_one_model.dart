import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'p_street_view_one_widget.dart' show PStreetViewOneWidget;
import 'package:flutter/material.dart';

class PStreetViewOneModel extends FlutterFlowModel<PStreetViewOneWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
    cBottomBarModel.dispose();
  }
}
