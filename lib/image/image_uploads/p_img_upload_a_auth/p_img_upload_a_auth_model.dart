import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/image/c_image_informational_dialog/c_image_informational_dialog_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'p_img_upload_a_auth_widget.dart' show PImgUploadAAuthWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PImgUploadAAuthModel extends FlutterFlowModel<PImgUploadAAuthWidget> {
  ///  Local state fields for this page.

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

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadedImgAdet = false;
  FFUploadedFile uploadedLocalFile_uploadedImgAdet =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_uploadImgToDbAdetNoAI = false;
  FFUploadedFile uploadedLocalFile_uploadImgToDbAdetNoAI =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadImgToDbAdetNoAI = '';

  // Stores action output result for [Custom Action - userRateLimiter] action in Button_scan widget.
  bool? userRateLimiterValue;
  // Stores action output result for [Custom Action - imageConversionToBase64String] action in Button_scan widget.
  String? uploadedImgAdetConverted;
  // Stores action output result for [Backend Call - API (authScan)] action in Button_scan widget.
  ApiCallResponse? successApi;
  // State field(s) for Checkbox_validity widget.
  bool? checkboxValidityValue;
  // State field(s) for Checkbox_recyclable widget.
  bool? checkboxRecyclableValue;
  // State field(s) for Checkbox_segregated widget.
  bool? checkboxSegregatedValue;
  // State field(s) for Checkbox_biodegradable widget.
  bool? checkboxBiodegradableValue;
  // State field(s) for Checkbox_nonbiode widget.
  bool? checkboxNonbiodeValue;
  bool isDataUploading_uploadImgToDbAdetHasAI = false;
  FFUploadedFile uploadedLocalFile_uploadImgToDbAdetHasAI =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadImgToDbAdetHasAI = '';

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
