import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'p_report_system_widget.dart' show PReportSystemWidget;

class PReportSystemModel extends FlutterFlowModel<PReportSystemWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  // Search and filter fields
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  String searchQuery = '';
  String selectedStreetFilter = 'All';
  String selectedTimeFilter = 'All Time';
  String sortBy = 'Alphabetical';

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
    searchController ??= TextEditingController();
    searchFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    cBottomBarModel.dispose();
    searchController?.dispose();
    searchFocusNode?.dispose();
  }
}
