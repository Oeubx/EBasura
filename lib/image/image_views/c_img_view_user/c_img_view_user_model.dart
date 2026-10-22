import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'c_img_view_user_widget.dart' show CImgViewUserWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CImgViewUserModel extends FlutterFlowModel<CImgViewUserWidget> {
  ///  State fields for stateful widgets in this component.
  Stream<List<ImageRow>>? containerSupabaseStream;

  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // State field(s) for Checkbox_recycling widget.
  bool? checkboxRecyclingValue1;
  bool? checkboxRecyclingValue2;
  bool? checkboxBiodeValue;
  bool? checkboxNonbiodeValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    expandableExpandableController.dispose();
  }
}
