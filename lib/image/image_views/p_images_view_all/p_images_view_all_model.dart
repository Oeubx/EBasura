import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'p_images_view_all_widget.dart' show PImagesViewAllWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PImagesViewAllModel extends FlutterFlowModel<PImagesViewAllWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown_status widget.
  String? dropDownStatusValue;
  FormFieldController<String>? dropDownStatusValueController;
  Stream<List<ImageRow>>? staggeredViewSupabaseStream;
  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  // Multi-attribute dynamic filter state
  String activeQuickFilter = 'All';
  String selectedStreet = 'All';
  bool filterRecyclable = false;
  bool filterBiodegradable = false;
  bool filterSegregated = false;

  bool get hasActiveAdvancedFilters =>
      selectedStreet != 'All' ||
      filterRecyclable ||
      filterBiodegradable ||
      filterSegregated;

  int get activeFilterCount {
    int count = 0;
    if (selectedStreet != 'All') count++;
    if (filterRecyclable) count++;
    if (filterBiodegradable) count++;
    if (filterSegregated) count++;
    return count;
  }

  void resetStream() {
    staggeredViewSupabaseStream = null;
  }

  void resetAllFilters() {
    activeQuickFilter = 'All';
    selectedStreet = 'All';
    filterRecyclable = false;
    filterBiodegradable = false;
    filterSegregated = false;
    dropDownStatusValue = 'All';
    dropDownStatusValueController?.value = 'All';
    searchController?.clear();
    searchQuery = '';
    sortNewestFirst = true;
    resetStream();
  }

  // Search & Sorting state
  TextEditingController? searchController;
  FocusNode? searchFocusNode;
  String searchQuery = '';
  bool sortNewestFirst = true;

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
