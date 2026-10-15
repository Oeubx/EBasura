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

  // Pagination / Infinite scroll state
  int pageSize = 20;
  bool isLoadingMore = false;
  bool hasMoreItems = true;

  void resetStream() {
    staggeredViewSupabaseStream = null;
    pageSize = 20;
    hasMoreItems = true;
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
    pageSize = 20;
    hasMoreItems = true;
    resetStream();
  }

  void loadMoreItems(int currentItemCount) {
    if (isLoadingMore || !hasMoreItems) return;
    if (currentItemCount < pageSize) {
      // If we currently have fewer items returned than the requested pageSize, there are no more items
      hasMoreItems = false;
      return;
    }
    isLoadingMore = true;
    pageSize += 20;
    resetStream();
    isLoadingMore = false;
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
