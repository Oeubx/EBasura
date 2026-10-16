import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'page_user_management_widget.dart' show PageUserManagementWidget;
import 'package:flutter/material.dart';

class PageUserManagementModel
    extends FlutterFlowModel<PageUserManagementWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<UserRow>>? listViewSupabaseStream;
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
