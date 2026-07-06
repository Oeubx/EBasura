import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'c_report_creation_widget.dart' show CReportCreationWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CReportCreationModel extends FlutterFlowModel<CReportCreationWidget> {
  ///  State fields for stateful widgets in this component.

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
