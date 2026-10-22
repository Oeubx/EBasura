import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'c_dates_creation_widget.dart' show CDatesCreationWidget;
import 'package:flutter/material.dart';

class CDatesCreationModel extends FlutterFlowModel<CDatesCreationWidget> {
  ///  State fields for stateful widgets in this component.

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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
  }
}
