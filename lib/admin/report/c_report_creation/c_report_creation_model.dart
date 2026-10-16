import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'c_report_creation_widget.dart' show CReportCreationWidget;
import 'package:flutter/material.dart';

class CReportCreationModel extends FlutterFlowModel<CReportCreationWidget> {
  /// State fields for stateful widgets in this component.

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;

  // State field(s) for Remarks widget.
  FocusNode? remarksFocusNode;
  TextEditingController? remarksTextController;
  String? Function(BuildContext, String?)? remarksTextControllerValidator;

  // State field(s) for Street_DropDown widget.
  String? streetDropDownValue;
  FormFieldController<String>? streetDropDownValueController;
  DateTime? datePicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();

    remarksFocusNode?.dispose();
    remarksTextController?.dispose();
  }
}
