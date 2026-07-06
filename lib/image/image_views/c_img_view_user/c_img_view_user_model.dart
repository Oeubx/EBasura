import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'c_img_view_user_widget.dart' show CImgViewUserWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CImgViewUserModel extends FlutterFlowModel<CImgViewUserWidget> {
  ///  State fields for stateful widgets in this component.

  Stream<List<ImageRow>>? containerSupabaseStream;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // State field(s) for Checkbox_recycling widget.
  bool? checkboxRecyclingValue1;
  // State field(s) for Checkbox_recycling widget.
  bool? checkboxRecyclingValue2;
  // State field(s) for Checkbox_biode widget.
  bool? checkboxBiodeValue;
  // State field(s) for Checkbox_nonbiode widget.
  bool? checkboxNonbiodeValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    expandableExpandableController.dispose();
  }
}
