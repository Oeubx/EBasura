import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'p_images_view_all_widget.dart' show PImagesViewAllWidget;

class PImagesViewAllModel extends FlutterFlowModel<PImagesViewAllWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown_status widget.
  String? dropDownStatusValue;
  FormFieldController<String>? dropDownStatusValueController;
  Stream<List<ImageRow>>? staggeredViewSupabaseStream;

  // Selected tab for dual-feed separation (0: Non-Verified, 1: Verified)
  int selectedTabIndex = 0;

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    cBottomBarModel.dispose();
  }
}
