import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'p_report_view_one_widget.dart' show PReportViewOneWidget;
import 'package:flutter/material.dart';

class PReportViewOneModel extends FlutterFlowModel<PReportViewOneWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for forEdit_Desc widget.
  FocusNode? forEditDescFocusNode;
  TextEditingController? forEditDescTextController;
  String? Function(BuildContext, String?)? forEditDescTextControllerValidator;

  // State field(s) for Street_DropDown widget.
  String? streetDropDownValue;
  FormFieldController<String>? streetDropDownValueController;

  // State field(s) for forEdit_Remarks widget.
  FocusNode? forEditRemarksFocusNode;
  TextEditingController? forEditRemarksTextController;
  String? Function(BuildContext, String?)?
      forEditRemarksTextControllerValidator;

  DateTime? datePicked;

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    forEditDescFocusNode?.dispose();
    forEditDescTextController?.dispose();

    forEditRemarksFocusNode?.dispose();
    forEditRemarksTextController?.dispose();

    cBottomBarModel.dispose();
  }
}
