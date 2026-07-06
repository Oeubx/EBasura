import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/image/c_image_informational_dialog/c_image_informational_dialog_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'p_img_upload_research_widget.dart' show PImgUploadResearchWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PImgUploadResearchModel
    extends FlutterFlowModel<PImgUploadResearchWidget> {
  ///  Local state fields for this page.
  /// for auth user
  String? apiAuthResponse;

  /// for guest users
  String? apiGuestResponse;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadedImg = false;
  FFUploadedFile uploadedLocalFile_uploadedImg =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_uploadImgToDb = false;
  FFUploadedFile uploadedLocalFile_uploadImgToDb =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadImgToDb = '';

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
