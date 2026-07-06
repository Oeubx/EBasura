import '/backend/api_requests/api_calls.dart';
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
import 'p_img_upload_a_guest_widget.dart' show PImgUploadAGuestWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PImgUploadAGuestModel extends FlutterFlowModel<PImgUploadAGuestWidget> {
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

  bool isDataUploading_imgUploadAGuest = false;
  FFUploadedFile uploadedLocalFile_imgUploadAGuest =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - guestRateLimiter] action in Button_scan widget.
  bool? guestRateLimiterValue;
  // Stores action output result for [Custom Action - imageConversionToBase64String] action in Button_scan widget.
  String? uploadedImgAdetConvertedGuest;
  // Stores action output result for [Backend Call - API (guestScan)] action in Button_scan widget.
  ApiCallResponse? successApiGuest;
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
