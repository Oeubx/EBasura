import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'p_dates_view_one_widget.dart' show PDatesViewOneWidget;
import 'package:flutter/material.dart';

class PDatesViewOneModel extends FlutterFlowModel<PDatesViewOneWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;

  // State field(s) for Street_DropDown widget.
  String? streetDropDownValue;
  FormFieldController<String>? streetDropDownValueController;

  // State field(s) for Day_DropDown widget.
  String? dayDropDownValue;
  FormFieldController<String>? dayDropDownValueController;

  DateTime? datePicked1;
  DateTime? datePicked2;

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
    cBottomBarModel.dispose();
  }
}
