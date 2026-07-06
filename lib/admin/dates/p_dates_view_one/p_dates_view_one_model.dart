import '/admin/dates/c_dates_deletion/c_dates_deletion_widget.dart';
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
import '/index.dart';
import 'p_dates_view_one_widget.dart' show PDatesViewOneWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
