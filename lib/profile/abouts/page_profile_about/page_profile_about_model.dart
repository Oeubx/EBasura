import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '/index.dart';
import 'page_profile_about_widget.dart' show PageProfileAboutWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PageProfileAboutModel extends FlutterFlowModel<PageProfileAboutWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField_feedback widget.
  FocusNode? textFieldFeedbackFocusNode;
  TextEditingController? textFieldFeedbackTextController;
  String? Function(BuildContext, String?)?
      textFieldFeedbackTextControllerValidator;
  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    textFieldFeedbackFocusNode?.dispose();
    textFieldFeedbackTextController?.dispose();

    cBottomBarModel.dispose();
  }
}
