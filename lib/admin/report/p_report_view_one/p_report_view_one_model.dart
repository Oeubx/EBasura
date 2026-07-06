import '/admin/report/c_report_deletion/c_report_deletion_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'p_report_view_one_widget.dart' show PReportViewOneWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
