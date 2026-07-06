import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/image/c_image_deletion/c_image_deletion_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'p_img_view_verifier_widget.dart' show PImgViewVerifierWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PImgViewVerifierModel extends FlutterFlowModel<PImgViewVerifierWidget> {
  ///  Local state fields for this page.

  int categoryCount = 0;

  List<String> apiResponseHolder = [];
  void addToApiResponseHolder(String item) => apiResponseHolder.add(item);
  void removeFromApiResponseHolder(String item) =>
      apiResponseHolder.remove(item);
  void removeAtIndexFromApiResponseHolder(int index) =>
      apiResponseHolder.removeAt(index);
  void insertAtIndexInApiResponseHolder(int index, String item) =>
      apiResponseHolder.insert(index, item);
  void updateApiResponseHolderAtIndex(int index, Function(String) updateFn) =>
      apiResponseHolder[index] = updateFn(apiResponseHolder[index]);

  bool? reverified = false;

  ///  State fields for stateful widgets in this page.

  Stream<List<ImageRow>>? containerSupabaseStream;
  // State field(s) for Switch_isSegregated widget.
  bool? switchIsSegregatedValue;
  // State field(s) for Checkbox_recycling widget.
  bool? checkboxRecyclingValue;
  // State field(s) for Checkbox_biode widget.
  bool? checkboxBiodeValue;
  // State field(s) for Checkbox_nonbiode widget.
  bool? checkboxNonbiodeValue1;
  // State field(s) for Checkbox_validity widget.
  bool? checkboxValidityValue;
  // State field(s) for Checkbox_segregated widget.
  bool? checkboxSegregatedValue;
  // State field(s) for Checkbox_recyclable widget.
  bool? checkboxRecyclableValue;
  // State field(s) for Checkbox_biodegradable widget.
  bool? checkboxBiodegradableValue;
  // State field(s) for Checkbox_nonbiode widget.
  bool? checkboxNonbiodeValue2;
  // State field(s) for TextField_remarks widget.
  FocusNode? textFieldRemarksFocusNode;
  TextEditingController? textFieldRemarksTextController;
  String? Function(BuildContext, String?)?
      textFieldRemarksTextControllerValidator;
  // Stores action output result for [Custom Action - imageConversionToBase64StringRevalidation] action in Button_ai_verify widget.
  String? uploadedImgFromDBConverted;
  // Stores action output result for [Backend Call - API (revalidationScan)] action in Button_ai_verify widget.
  ApiCallResponse? revalidationSuccess;
  // Model for C_BottomBar component.
  late CBottomBarModel cBottomBarModel;

  @override
  void initState(BuildContext context) {
    cBottomBarModel = createModel(context, () => CBottomBarModel());
  }

  @override
  void dispose() {
    textFieldRemarksFocusNode?.dispose();
    textFieldRemarksTextController?.dispose();

    cBottomBarModel.dispose();
  }
}
