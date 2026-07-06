import '/admin/badges/c_badges_deletion/c_badges_deletion_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'p_badge_view_one_widget.dart' show PBadgeViewOneWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PBadgeViewOneModel extends FlutterFlowModel<PBadgeViewOneWidget> {
  ///  Local state fields for this page.

  bool isEditingBadge = false;

  ///  State fields for stateful widgets in this page.

  Stream<List<BadgeRow>>? containerSupabaseStream;
  // State field(s) for TextField_name widget.
  FocusNode? textFieldNameFocusNode;
  TextEditingController? textFieldNameTextController;
  String? Function(BuildContext, String?)? textFieldNameTextControllerValidator;
  // State field(s) for TextField_desc widget.
  FocusNode? textFieldDescFocusNode;
  TextEditingController? textFieldDescTextController;
  String? Function(BuildContext, String?)? textFieldDescTextControllerValidator;
  // State field(s) for TextField_min widget.
  FocusNode? textFieldMinFocusNode;
  TextEditingController? textFieldMinTextController;
  String? Function(BuildContext, String?)? textFieldMinTextControllerValidator;
  // State field(s) for TextField_max widget.
  FocusNode? textFieldMaxFocusNode;
  TextEditingController? textFieldMaxTextController;
  String? Function(BuildContext, String?)? textFieldMaxTextControllerValidator;
  // State field(s) for CountController widget.
  int? countControllerValue;
  Stream<List<UserRow>>? rowSupabaseStream;
  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    textFieldNameFocusNode?.dispose();
    textFieldNameTextController?.dispose();

    textFieldDescFocusNode?.dispose();
    textFieldDescTextController?.dispose();

    textFieldMinFocusNode?.dispose();
    textFieldMinTextController?.dispose();

    textFieldMaxFocusNode?.dispose();
    textFieldMaxTextController?.dispose();

    cBottomBarModel.dispose();
  }
}
