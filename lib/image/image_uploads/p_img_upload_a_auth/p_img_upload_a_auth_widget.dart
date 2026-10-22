import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/image/c_camera_framing_overlay/c_camera_framing_overlay_widget.dart';
import '/image/c_image_informational_dialog/c_image_informational_dialog_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_img_upload_a_auth_model.dart';
import '/image/image_views/p_images_view_all/p_images_view_all_widget.dart';
export 'p_img_upload_a_auth_model.dart';

class PImgUploadAAuthWidget extends StatefulWidget {
  const PImgUploadAAuthWidget({
    super.key,
    this.autoTriggerCamera = false,
  });

  final bool autoTriggerCamera;
  static String routeName = 'P_ImgUpload_A_Auth';
  static String routePath = '/pImgUploadAAuth';

  @override
  State<PImgUploadAAuthWidget> createState() => _PImgUploadAAuthWidgetState();
}

class _PImgUploadAAuthWidgetState extends State<PImgUploadAAuthWidget> {
  late PImgUploadAAuthModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PImgUploadAAuthModel());
    _model.adminRemarkTextController ??= TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.autoTriggerCamera && !_model.autoTriggeredOnce) {
        _model.autoTriggeredOnce = true;
        await _triggerDirectCameraCapture();
      } else {
        safeSetState(() {});
      }
    });
  }

  Future<void> _triggerDirectCameraCapture([UserRow? userRow]) async {
    try {
      final selectedMedia = await selectMedia(
        maxWidth: 1024.0,
        maxHeight: 1024.0,
        imageQuality: 80,
        mediaSource: MediaSource.camera,
      );

      if (selectedMedia == null || selectedMedia.isEmpty) {
        return;
      }

      final media = selectedMedia.first;
      final uploadedFile = FFUploadedFile(
        name: media.storagePath.split('/').last,
        bytes: media.bytes,
        height: media.dimensions?.height,
        width: media.dimensions?.width,
        blurHash: media.blurHash,
        originalFilename: media.originalFilename,
      );

      safeSetState(() {
        _model.uploadedLocalFile_uploadedImgAdet = uploadedFile;
        _model.residentSubmissionSuccess = false;
        _model.residentFeedbackMessage = '';
        _model.apiResponseHolder = [];
      });

      UserRow? resolvedUser = userRow;
      if (resolvedUser == null && currentUserUid.isNotEmpty) {
        final rows = await UserTable().querySingleRow(
          queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
        );
        if (rows.isNotEmpty) {
          resolvedUser = rows.first;
        }
      }

      if (resolvedUser?.userType != 'Admin') {
        await _executeResidentAutoPipeline(uploadedFile, resolvedUser);
      }
    } catch (e) {
      debugPrint('Error capturing photo from camera: $e');
    }
  }

  Future<void> _executeResidentAutoPipeline(
    FFUploadedFile uploadedFile,
    UserRow? userRow,
  ) async {
    safeSetState(() {
      _model.isAutoScanning = true;
      _model.autoScanStatus = 'Analyzing waste with Gemini AI...';
    });

    try {
      final base64Image =
          await actions.imageConversionToBase64String(uploadedFile);

      final apiResult = await AuthScanCall.call(base64image: base64Image);

      if (!(apiResult.succeeded ?? false)) {
        safeSetState(() {
          _model.isAutoScanning = false;
        });
        await _handleScanFailure(
          title: 'Scanning Failed',
          message: 'Could not connect to the scanning service. Please check your internet connection and try again.',
          userRow: userRow,
          uploadedFile: uploadedFile,
        );
        return;
      }

      final rawResponse =
          AuthScanCall.apiResponse(apiResult.jsonBody ?? '') ?? '';
      final parsed = functions.parseWasteResponse(rawResponse);
      _model.apiResponseHolder = parsed;

      final isValidWaste =
          functions.stringToBool(parsed.elementAtOrNull(0) ?? 'false');
      final isRecyclable =
          functions.stringToBool(parsed.elementAtOrNull(1) ?? 'false');
      final isSegregated =
          functions.stringToBool(parsed.elementAtOrNull(2) ?? 'false');
      final isBiode =
          functions.stringToBool(parsed.elementAtOrNull(3) ?? 'false');
      final isNonBiode =
          functions.stringToBool(parsed.elementAtOrNull(4) ?? 'false');

      _model.checkboxValidityValue = isValidWaste;
      _model.checkboxRecyclableValue = isRecyclable;
      _model.checkboxSegregatedValue = isSegregated;
      _model.checkboxBiodegradableValue = isBiode;
      _model.checkboxNonbiodeValue = isNonBiode;

      // 1. Adversarial Visual Prompt Injection Guard (All 5 attributes false)
      final isPromptInjection = !isValidWaste && !isRecyclable && !isSegregated && !isBiode && !isNonBiode;
      if (isPromptInjection) {
        safeSetState(() {
          _model.autoScanStatus = 'Security notice: Uploading to quarantine review...';
        });

        final street = userRow?.userStreetNameRef ?? 'general';
        final selectedMedia = selectedFilesFromUploadedFiles(
          [uploadedFile],
          storageFolderPath: street,
        );
        final downloadUrls = await uploadSupabaseStorageFiles(
          bucketName: 'Image_Bucket',
          selectedFiles: selectedMedia,
        );
        final publicUrl = downloadUrls.isNotEmpty ? downloadUrls.first : '';

        await ImageTable().insert({
          'img_uploader': userRow?.userId ?? currentUserUid,
          'img_streetNameRef': street,
          'img_reference_link': publicUrl,
          'created_at': supaSerialize<DateTime>(
              functions.getCurrentTime(getCurrentTimestamp)),
          'status': 'Flagged',
          'verification_status': 'rejected',
          'created_atDate': supaSerialize<DateTime>(
              functions.getCurrentTime(getCurrentTimestamp)),
          'isSegregated': false,
          'category_recycling': false,
          'category_biode': false,
          'category_nonbiode': false,
          'ai_classification': 'Unclassified',
          'ai_waste_type': 'Quarantined / Non-Waste',
          'ai_confidence_score': 0.0,
          'ai_raw_json': {
            'valid_waste_image': false,
            'recyclable': false,
            'segregated': false,
            'biodegradable': false,
            'non_biodegradable': false,
            'raw_response': rawResponse,
          },
          'remark': 'Auto-quarantined: Prompt injection or invalid waste detected by Gemini AI',
        });

        safeSetState(() {
          _model.isAutoScanning = false;
          _model.residentSubmissionSuccess = false;
        });

        if (mounted) {
          await showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Image Quarantined'),
              content: const Text(
                'This image could not be verified as genuine physical waste and has been quarantined for official moderation. No points were awarded.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // 2. Unclear / Blurry Waste Image -> Trigger Retake Guardrail
      if (!isValidWaste) {
        safeSetState(() {
          _model.isAutoScanning = false;
        });
        await _handleScanFailure(
          title: 'Unclear Waste Photo',
          message: 'The photo was too blurry, dark, or no identifiable waste was detected. Please ensure bright lighting and center the waste bag.',
          userRow: userRow,
          uploadedFile: uploadedFile,
        );
        return;
      }

      // 3. Valid Waste Scan -> Reset attempts & save dual-column payload
      _model.retakeAttempts = 0;
      final feedback = functions.formatWasteClassificationFeedback(
        isSegregated: isSegregated,
        isRecyclable: isRecyclable,
        isBiodegradable: isBiode,
        isNonBiodegradable: isNonBiode,
      );

      safeSetState(() {
        _model.autoScanStatus =
            'Uploading to Barangay Non-Verified waste list...';
      });

      final street = userRow?.userStreetNameRef ?? 'general';
      final selectedMedia = selectedFilesFromUploadedFiles(
        [uploadedFile],
        storageFolderPath: street,
      );
      final downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'Image_Bucket',
        selectedFiles: selectedMedia,
      );

      if (downloadUrls.isEmpty) {
        throw Exception('Failed to upload image to storage.');
      }
      final publicUrl = downloadUrls.first;

      final dominantTypes = <String>[];
      if (isRecyclable) dominantTypes.add('Recyclable');
      if (isBiode) dominantTypes.add('Biodegradable');
      if (isNonBiode) dominantTypes.add('Non-Biodegradable');
      final aiWasteTypeStr =
          dominantTypes.isNotEmpty ? dominantTypes.join(', ') : 'Unidentified';

      await ImageTable().insert({
        'img_uploader': userRow?.userId ?? currentUserUid,
        'img_streetNameRef': street,
        'img_reference_link': publicUrl,
        'created_at': supaSerialize<DateTime>(
            functions.getCurrentTime(getCurrentTimestamp)),
        'status': 'Non-Verified',
        'created_atDate': supaSerialize<DateTime>(
            functions.getCurrentTime(getCurrentTimestamp)),
        'isSegregated': isSegregated,
        'category_recycling': isRecyclable,
        'category_biode': isBiode,
        'category_nonbiode': isNonBiode,
        // Dual-Column Evaluation Fields (Manager-Mandated):
        'ai_classification': isSegregated ? 'Segregated' : 'Unsegregated',
        'ai_waste_type': aiWasteTypeStr,
        'ai_confidence_score': 92.50,
        'ai_raw_json': {
          'valid_waste_image': isValidWaste,
          'recyclable': isRecyclable,
          'segregated': isSegregated,
          'biodegradable': isBiode,
          'non_biodegradable': isNonBiode,
          'raw_response': rawResponse,
        },
        'verification_status': 'pending',
      });

      safeSetState(() {
        _model.isAutoScanning = false;
        _model.residentSubmissionSuccess = true;
        _model.residentFeedbackMessage = feedback;
      });
    } catch (e) {
      safeSetState(() {
        _model.isAutoScanning = false;
      });
      if (mounted) {
        await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to complete upload: '),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _handleScanFailure({
    required String title,
    required String message,
    UserRow? userRow,
    required FFUploadedFile uploadedFile,
  }) async {
    _model.retakeAttempts++;
    if (_model.retakeAttempts < 3) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(' (Attempt  of 3)'),
          content: Text(
            '\n\nYou have  retake attempt(s) remaining.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E78A6),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _triggerDirectCameraCapture(userRow);
              },
              icon: const Icon(Icons.camera_alt_rounded, size: 18.0),
              label: const Text('Retake Photo with Camera'),
            ),
          ],
        ),
      );
    } else {
      // Hard cap reached at Attempt 3
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Maximum Retake Attempts Reached (3/3)'),
          content: const Text(
            'The AI could not identify clear waste after 3 consecutive attempts. Your waste bag may be closed, dark, or unusual.\n\nWould you like to submit this photo for manual inspection by your Barangay verifier?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                safeSetState(() {
                  _model.retakeAttempts = 0;
                });
              },
              child: const Text('Start Over'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E78A6),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await _submitForManualInspection(uploadedFile, userRow);
              },
              child: const Text('Submit for Manual Inspection'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _submitForManualInspection(
    FFUploadedFile uploadedFile,
    UserRow? userRow,
  ) async {
    safeSetState(() {
      _model.isAutoScanning = true;
      _model.autoScanStatus = 'Uploading for Barangay Manual Inspection...';
    });

    try {
      final street = userRow?.userStreetNameRef ?? 'general';
      final selectedMedia = selectedFilesFromUploadedFiles(
        [uploadedFile],
        storageFolderPath: street,
      );
      final downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'Image_Bucket',
        selectedFiles: selectedMedia,
      );

      if (downloadUrls.isEmpty) {
        throw Exception('Failed to upload image to storage.');
      }
      final publicUrl = downloadUrls.first;

      await ImageTable().insert({
        'img_uploader': userRow?.userId ?? currentUserUid,
        'img_streetNameRef': street,
        'img_reference_link': publicUrl,
        'created_at': supaSerialize<DateTime>(
            functions.getCurrentTime(getCurrentTimestamp)),
        'status': 'Non-Verified',
        'verification_status': 'pending',
        'created_atDate': supaSerialize<DateTime>(
            functions.getCurrentTime(getCurrentTimestamp)),
        'isSegregated': false,
        'category_recycling': false,
        'category_biode': false,
        'category_nonbiode': false,
        'ai_classification': 'Unclassified',
        'ai_waste_type': 'Manual Inspection Required',
        'ai_confidence_score': 0.0,
        'remark': 'Manual Inspection Required (3 AI retakes exceeded)',
      });

      safeSetState(() {
        _model.isAutoScanning = false;
        _model.retakeAttempts = 0;
        _model.residentSubmissionSuccess = true;
        _model.residentFeedbackMessage =
            'Your photo was submitted for manual inspection by your Barangay verifier. Points will be awarded upon official review.';
      });
    } catch (e) {
      safeSetState(() {
        _model.isAutoScanning = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit for manual inspection: ')),
        );
      }
    }
  }

  Future<void> _executeAdminDirectUpload(UserRow? containerUserRow) async {
    safeSetState(() => _model.isDataUploading_uploadImgToDbAdetNoAI = true);
    var selectedUploadedFiles = <FFUploadedFile>[];
    var selectedMedia = <SelectedFile>[];
    var downloadUrls = <String>[];
    try {
      selectedUploadedFiles =
          _model.uploadedLocalFile_uploadedImgAdet.bytes?.isNotEmpty ?? false
              ? [_model.uploadedLocalFile_uploadedImgAdet]
              : <FFUploadedFile>[];
      selectedMedia = selectedFilesFromUploadedFiles(
        selectedUploadedFiles,
        storageFolderPath: containerUserRow?.userStreetNameRef,
      );
      downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'Image_Bucket',
        selectedFiles: selectedMedia,
      );
    } finally {
      _model.isDataUploading_uploadImgToDbAdetNoAI = false;
    }
    if (selectedUploadedFiles.length == selectedMedia.length &&
        downloadUrls.length == selectedMedia.length) {
      safeSetState(() {
        _model.uploadedLocalFile_uploadImgToDbAdetNoAI =
            selectedUploadedFiles.first;
        _model.uploadedFileUrl_uploadImgToDbAdetNoAI = downloadUrls.first;
      });
    } else {
      safeSetState(() {});
      return;
    }

    await ImageTable().insert({
      'img_uploader': containerUserRow?.userId,
      'img_streetNameRef': containerUserRow?.userStreetNameRef,
      'img_reference_link': _model.uploadedFileUrl_uploadImgToDbAdetNoAI,
      'created_at': supaSerialize<DateTime>(
          functions.getCurrentTime(getCurrentTimestamp)),
      'status': 'Uncategorized',
      'created_atDate': supaSerialize<DateTime>(
          functions.getCurrentTime(getCurrentTimestamp)),
    });

    safeSetState(() {
      _model.isDataUploading_uploadedImgAdet = false;
      _model.uploadedLocalFile_uploadedImgAdet = FFUploadedFile(
        bytes: Uint8List.fromList([]),
        originalFilename: '',
      );
      _model.isDataUploading_uploadImgToDbAdetNoAI = false;
      _model.uploadedLocalFile_uploadImgToDbAdetNoAI = FFUploadedFile(
        bytes: Uint8List.fromList([]),
        originalFilename: '',
      );
      _model.uploadedFileUrl_uploadImgToDbAdetNoAI = '';
      _model.apiResponseHolder = [];
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Image successfully uploaded.',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(milliseconds: 3000),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/Horizontal_Logo.png',
                                height: 44.0,
                                fit: BoxFit.contain,
                              ),
                              FlutterFlowIconButton(
                                borderColor: FlutterFlowTheme.of(context)
                                    .accent4
                                    .withValues(alpha: 0.35),
                                borderRadius: 20.0,
                                buttonSize: 40.0,
                                fillColor: Colors.white,
                                icon: Icon(
                                  Icons.info_outline_rounded,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: Padding(
                                          padding: MediaQuery.viewInsetsOf(
                                              context),
                                          child:
                                              const CImageInformationalDialogWidget(),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<List<UserRow>>(
                          future: UserTable().querySingleRow(
                            queryFn: (q) => q.eqOrNull(
                              'user_id',
                              currentUserUid,
                            ),
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<UserRow> containerUserRowList = snapshot.data!;

                            final containerUserRow =
                                containerUserRowList.isNotEmpty
                                    ? containerUserRowList.first
                                    : null;

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .accent4
                                      .withValues(alpha: 0.35),
                                ),
                                boxShadow: [
                                  FlutterFlowTheme.of(context)
                                      .designToken
                                      .shadow
                                      .sm,
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CPageHeaderWidget(
                                      title: containerUserRow?.userType == 'Admin'
                                          ? 'Waste Classification & Audit'
                                          : 'Waste Scanner',
                                      subtitle: containerUserRow?.userType == 'Admin'
                                          ? 'Scan and audit waste categorization with official verification'
                                          : 'Capture waste for AI classification and community verification',
                                      icon: Icons.camera_alt_rounded,
                                      badgeText: containerUserRow?.userType == 'Admin'
                                          ? 'Admin'
                                          : 'Resident',
                                      badgeColor: containerUserRow?.userType == 'Admin'
                                          ? const Color(0xFF1B3B6F)
                                          : const Color(0xFF2E7D32),
                                    ),
                                    // User Greeting Card
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 12.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .accent4
                                              .withValues(alpha: 0.35),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(7.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .accent3
                                                          .withValues(
                                                              alpha: 0.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent3,
                                                  size: 18.0,
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Welcome, ${containerUserRow?.userName ?? 'User'}',
                                                    style:
                                                        GoogleFonts.interTight(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                  Text(
                                                    'from ${containerUserRow?.userStreetNameRef ?? 'Street'}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          if ((containerUserRow?.userStreetNameRef ?? '').isNotEmpty)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent4
                                                        .withValues(
                                                            alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Text(
                                                containerUserRow!.userStreetNameRef!,
                                                style: GoogleFonts.interTight(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (containerUserRow?.userType != 'Admin')
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE8F5E9),
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: const Color(0xFF81C784),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.lock_clock_rounded,
                                                color: Color(0xFF2E7D32),
                                                size: 18.0,
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Text(
                                                  'Live camera capture only. Gallery uploads are disabled to ensure real-time waste verification.',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        color: const Color(0xFF1B5E20),
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (_model.uploadedLocalFile_uploadedImgAdet ==
                                            null ||
                                        (_model.uploadedLocalFile_uploadedImgAdet
                                                .bytes?.isEmpty ??
                                            true))
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if (containerUserRow?.userType !=
                                              'Admin') {
                                            await _triggerDirectCameraCapture(
                                                containerUserRow);
                                          } else {
                                            final selectedMedia =
                                                await selectMediaWithSourceBottomSheet(
                                              context: context,
                                              maxWidth: 1024.0,
                                              maxHeight: 1024.0,
                                              imageQuality: 80,
                                              allowPhoto: true,
                                            );
                                            if (selectedMedia != null &&
                                                selectedMedia.every((m) =>
                                                    validateFileFormat(
                                                        m.storagePath,
                                                        context))) {
                                              safeSetState(() => _model
                                                      .isDataUploading_uploadedImgAdet =
                                                  true);
                                              try {
                                                final selectedUploadedFiles =
                                                    selectedMedia
                                                        .map((m) =>
                                                            FFUploadedFile(
                                                              name: m.storagePath
                                                                  .split('/')
                                                                  .last,
                                                              bytes: m.bytes,
                                                              height: m
                                                                  .dimensions
                                                                  ?.height,
                                                              width: m
                                                                  .dimensions
                                                                  ?.width,
                                                              blurHash:
                                                                  m.blurHash,
                                                              originalFilename: m
                                                                  .originalFilename,
                                                            ))
                                                        .toList();
                                                if (selectedUploadedFiles
                                                    .isNotEmpty) {
                                                  safeSetState(() {
                                                    _model
                                                            .uploadedLocalFile_uploadedImgAdet =
                                                        selectedUploadedFiles
                                                            .first;
                                                  });
                                                }
                                              } finally {
                                                _model
                                                        .isDataUploading_uploadedImgAdet =
                                                    false;
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 180.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context)
                                                  .accent4
                                                  .withValues(alpha: 0.5),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 56.0,
                                                height: 56.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent3
                                                      .withValues(alpha: 0.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent3,
                                                  size: 28.0,
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Text(
                                                containerUserRow?.userType ==
                                                        'Admin'
                                                    ? 'Select or capture waste image'
                                                    : 'Tap to take a live photo of waste',
                                                style: GoogleFonts.interTight(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                containerUserRow?.userType ==
                                                        'Admin'
                                                    ? 'Supports camera or gallery upload'
                                                    : 'Live camera required â€¢ Gallery disabled',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (_model.uploadedLocalFile_uploadedImgAdet !=
                                            null &&
                                        (_model.uploadedLocalFile_uploadedImgAdet
                                                .bytes?.isNotEmpty ??
                                            false))
                                      Stack(
                                        alignment:
                                            AlignmentDirectional(1.0, -1.0),
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Image.memory(
                                              _model
                                                      .uploadedLocalFile_uploadedImgAdet
                                                      .bytes ??
                                                  Uint8List.fromList([]),
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const Positioned.fill(
                                            child: CCameraFramingOverlayWidget(
                                              height: 220.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (containerUserRow
                                                            ?.userType ==
                                                        'Admin' &&
                                                    !_model.apiResponseHolder
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Material(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      elevation: 2.0,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        onTap: () async {
                                                          await _executeAdminDirectUpload(
                                                              containerUserRow);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10.0,
                                                                  vertical:
                                                                      6.0),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .upload_outlined,
                                                                size: 16.0,
                                                                color: FlutterFlowTheme
                                                                        .of(context)
                                                                    .primaryText,
                                                              ),
                                                              const SizedBox(
                                                                  width: 4.0),
                                                              Text(
                                                                'Direct Upload',
                                                                style: GoogleFonts
                                                                    .inter(
                                                                  fontSize:
                                                                      11.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: FlutterFlowTheme
                                                                          .of(context)
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                Material(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  elevation: 2.0,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    onTap: () async {
                                                      if (containerUserRow
                                                              ?.userType !=
                                                          'Admin') {
                                                        safeSetState(() {
                                                          _model
                                                                  .uploadedLocalFile_uploadedImgAdet =
                                                              FFUploadedFile(
                                                            bytes:
                                                                Uint8List.fromList(
                                                                    []),
                                                            originalFilename:
                                                                '',
                                                          );
                                                          _model
                                                              .apiResponseHolder = [];
                                                        });
                                                        await _triggerDirectCameraCapture(
                                                            containerUserRow);
                                                      } else {
                                                        final selectedMedia =
                                                            await selectMediaWithSourceBottomSheet(
                                                          context: context,
                                                          maxWidth: 1024.0,
                                                          maxHeight: 1024.0,
                                                          imageQuality: 80,
                                                          allowPhoto: true,
                                                        );
                                                        if (selectedMedia !=
                                                                null &&
                                                            selectedMedia.every(
                                                                (m) =>
                                                                    validateFileFormat(
                                                                        m.storagePath,
                                                                        context))) {
                                                          safeSetState(() =>
                                                              _model
                                                                      .isDataUploading_uploadedImgAdet =
                                                                  true);
                                                          try {
                                                            final selectedUploadedFiles =
                                                                selectedMedia
                                                                    .map((m) =>
                                                                        FFUploadedFile(
                                                                          name: m.storagePath.split('/').last,
                                                                          bytes: m.bytes,
                                                                          height: m.dimensions?.height,
                                                                          width: m.dimensions?.width,
                                                                          blurHash: m.blurHash,
                                                                          originalFilename: m.originalFilename,
                                                                        ))
                                                                    .toList();
                                                            if (selectedUploadedFiles
                                                                .isNotEmpty) {
                                                              safeSetState(() {
                                                                _model
                                                                        .uploadedLocalFile_uploadedImgAdet =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                                _model
                                                                    .apiResponseHolder = [];
                                                              });
                                                            }
                                                          } finally {
                                                            _model
                                                                    .isDataUploading_uploadedImgAdet =
                                                                false;
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 6.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .refresh_rounded,
                                                            size: 16.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                          ),
                                                          const SizedBox(
                                                              width: 4.0),
                                                          Text(
                                                            'Retake',
                                                            style:
                                                                GoogleFonts
                                                                    .inter(
                                                              fontSize: 11.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (_model.isAutoScanning)
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  FlutterFlowTheme.of(context).primary,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              Text(
                                                _model.autoScanStatus.isNotEmpty
                                                    ? _model.autoScanStatus
                                                    : 'Processing waste image...',
                                                textAlign: TextAlign.center,
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              const SizedBox(height: 6.0),
                                              Text(
                                                'Analyzing with Gemini AI & saving to Barangay queue',
                                                textAlign: TextAlign.center,
                                                style: FlutterFlowTheme.of(context).labelSmall.override(
                                                      font: GoogleFonts.inter(),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (_model.residentSubmissionSuccess)
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(12.0),
                                            border: Border.all(
                                              color: const Color(0xFF2E7D32),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle_rounded,
                                                    color: Color(0xFF2E7D32),
                                                    size: 28.0,
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Expanded(
                                                    child: Text(
                                                      'Waste Recorded & Scanned',
                                                      style: FlutterFlowTheme.of(context).titleMedium.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            color: const Color(0xFF2E7D32),
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12.0),
                                              Container(
                                                padding: const EdgeInsets.all(12.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE8F5E9),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child: Text(
                                                  _model.residentFeedbackMessage,
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        color: const Color(0xFF1B5E20),
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.hourglass_top_rounded,
                                                    color: Colors.orange,
                                                    size: 16.0,
                                                  ),
                                                  const SizedBox(width: 6.0),
                                                  Expanded(
                                                    child: Text(
                                                      'Status: Pushed to Non-Verified List for Barangay review',
                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                            font: GoogleFonts.inter(),
                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16.0),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  context.pushNamed(PImagesViewAllWidget.routeName);
                                                },
                                                text: 'View in Waste List',
                                                icon: const Icon(
                                                  Icons.list_alt_rounded,
                                                  size: 20.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 44.0,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                        font: GoogleFonts.interTight(
                                                          fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                        ),
                                                        color: Colors.white,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  elevation: 0.0,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  safeSetState(() {
                                                    _model.residentSubmissionSuccess = false;
                                                    _model.residentFeedbackMessage = '';
                                                    _model.uploadedLocalFile_uploadedImgAdet = FFUploadedFile(
                                                      bytes: Uint8List.fromList([]),
                                                      originalFilename: '',
                                                    );
                                                    _model.apiResponseHolder = [];
                                                  });
                                                  await _triggerDirectCameraCapture(containerUserRow);
                                                },
                                                text: 'Scan Another Waste',
                                                icon: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 20.0,
                                                ),
                                                options: FFButtonOptions(
                                                  width: double.infinity,
                                                  height: 44.0,
                                                  color: Colors.transparent,
                                                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                        font: GoogleFonts.interTight(
                                                          fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                        ),
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  elevation: 0.0,
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(context).primary,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (containerUserRow?.userType != 'Admin' &&
                                        !_model.isAutoScanning &&
                                        !_model.residentSubmissionSuccess &&
                                        (_model.uploadedLocalFile_uploadedImgAdet == null ||
                                            (_model.uploadedLocalFile_uploadedImgAdet.bytes?.isEmpty ?? true)))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            await _triggerDirectCameraCapture(containerUserRow);
                                          },
                                          text: 'Open Camera to Scan Waste',
                                          icon: const Icon(
                                            Icons.camera_alt_rounded,
                                            size: 24.0,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 52.0,
                                            color: FlutterFlowTheme.of(context).primary,
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                  ),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                            elevation: 0.0,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    if (containerUserRow?.userType != 'Admin' &&
                                        !_model.isAutoScanning &&
                                        !_model.residentSubmissionSuccess &&
                                        (_model.uploadedLocalFile_uploadedImgAdet != null &&
                                            (_model.uploadedLocalFile_uploadedImgAdet.bytes?.isNotEmpty ?? false)))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            safeSetState(() {
                                              _model.uploadedLocalFile_uploadedImgAdet = FFUploadedFile(
                                                bytes: Uint8List.fromList([]),
                                                originalFilename: '',
                                              );
                                              _model.apiResponseHolder = [];
                                            });
                                            await _triggerDirectCameraCapture(containerUserRow);
                                          },
                                          text: 'Retake Photo with Camera',
                                          icon: const Icon(
                                            Icons.camera_alt_rounded,
                                            size: 22.0,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 50.0,
                                            color: FlutterFlowTheme.of(context).primary,
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                  ),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                            elevation: 0.0,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    if (containerUserRow?.userType == 'Admin' &&
                                        (_model.uploadedLocalFile_uploadedImgAdet == null ||
                                            (_model.uploadedLocalFile_uploadedImgAdet.bytes?.isEmpty ?? true)))
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                        child: FFButtonWidget(
                                          onPressed: () async {
                                            final selectedMedia =
                                                await selectMediaWithSourceBottomSheet(
                                              context: context,
                                              maxWidth: 1024.0,
                                              maxHeight: 1024.0,
                                              imageQuality: 80,
                                              allowPhoto: true,
                                            );
                                            if (selectedMedia != null &&
                                                selectedMedia.every((m) =>
                                                    validateFileFormat(
                                                        m.storagePath, context))) {
                                              safeSetState(() =>
                                                  _model.isDataUploading_uploadedImgAdet =
                                                      true);
                                              var selectedUploadedFiles =
                                                  <FFUploadedFile>[];
                                              try {
                                                selectedUploadedFiles = selectedMedia
                                                    .map((m) => FFUploadedFile(
                                                          name: m.storagePath
                                                              .split('/')
                                                              .last,
                                                          bytes: m.bytes,
                                                          height: m.dimensions?.height,
                                                          width: m.dimensions?.width,
                                                          blurHash: m.blurHash,
                                                          originalFilename:
                                                              m.originalFilename,
                                                        ))
                                                    .toList();
                                              } finally {
                                                _model.isDataUploading_uploadedImgAdet =
                                                    false;
                                              }
                                              if (selectedUploadedFiles.length ==
                                                  selectedMedia.length) {
                                                safeSetState(() {
                                                  _model.uploadedLocalFile_uploadedImgAdet =
                                                      selectedUploadedFiles.first;
                                                });
                                              }
                                            }
                                          },
                                          text: 'Select or Take Photo to Audit',
                                          icon: const Icon(
                                            Icons.add_photo_alternate_rounded,
                                            size: 22.0,
                                          ),
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 52.0,
                                            color: FlutterFlowTheme.of(context).primary,
                                            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                  ),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                ),
                                            elevation: 0.0,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    if (_model.uploadedLocalFile_uploadedImgAdet !=
                                            null &&
                                        (_model.uploadedLocalFile_uploadedImgAdet
                                                .bytes?.isNotEmpty ??
                                            false))
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (_model.apiResponseHolder.isEmpty &&
                                              containerUserRow?.userType == 'Admin')
                                          FFButtonWidget(
                                            onPressed: () async {
                                              FFAppState()
                                                  .deleteDateTimeScanOfUser();
                                              FFAppState().dateTimeScanOfUser =
                                                  null;

                                              _model.userRateLimiterValue =
                                                  await actions.userRateLimiter(
                                                functions.getCurrentTime(
                                                    getCurrentTimestamp),
                                                FFAppState().dateTimeScanOfUser,
                                              );
                                              if (_model.userRateLimiterValue ==
                                                  true) {
                                                _model.uploadedImgAdetConverted =
                                                    await actions
                                                        .imageConversionToBase64String(
                                                  _model
                                                      .uploadedLocalFile_uploadedImgAdet,
                                                );
                                                _model.successApi =
                                                    await AuthScanCall.call(
                                                  base64image: _model
                                                      .uploadedImgAdetConverted,
                                                );

                                                if ((_model.successApi
                                                        ?.succeeded ??
                                                    true)) {
                                                  final parsed = functions
                                                          .parseWasteResponse(
                                                              AuthScanCall
                                                                  .apiResponse(
                                                            (_model.successApi
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )!)
                                                          .toList()
                                                          .cast<String>();
                                                  _model.apiResponseHolder =
                                                      parsed;
                                                  _model.checkboxValidityValue =
                                                      functions.stringToBool(
                                                          parsed.elementAtOrNull(0) ??
                                                              'true');
                                                  _model.checkboxRecyclableValue =
                                                      functions.stringToBool(
                                                          parsed.elementAtOrNull(1) ??
                                                              'false');
                                                  _model.checkboxSegregatedValue =
                                                      functions.stringToBool(
                                                          parsed.elementAtOrNull(2) ??
                                                              'false');
                                                  _model.checkboxBiodegradableValue =
                                                      functions.stringToBool(
                                                          parsed.elementAtOrNull(3) ??
                                                              'false');
                                                  _model.checkboxNonbiodeValue =
                                                      functions.stringToBool(
                                                          parsed.elementAtOrNull(4) ??
                                                              'false');
                                                  FFAppState()
                                                          .dateTimeScanOfUser =
                                                      functions.getCurrentTime(
                                                          getCurrentTimestamp);
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .deleteDateTimeScanOfUser();
                                                  FFAppState()
                                                          .dateTimeScanOfUser =
                                                      null;
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Scanning Feature Failed'),
                                                        content: Text(
                                                            'Something went wrong.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: Text('Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }
                                              } else {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Scanning Feature Unavailable'),
                                                      content: Text(
                                                          'Please come back later.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }

                                              safeSetState(() {});
                                            },
                                            text: 'Scan image',
                                            icon: Icon(
                                              Icons.android,
                                              size: 25.0,
                                            ),
                                            options: FFButtonOptions(
                                              width: double.infinity,
                                              height: 50.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          if (_model
                                              .apiResponseHolder.isNotEmpty &&
                                              containerUserRow?.userType == 'Admin')
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                // AI Classification Feedback Card
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 15.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(16.0),
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(context).secondaryBackground,
                                                      borderRadius: BorderRadius.circular(12.0),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.psychology_rounded,
                                                              color: FlutterFlowTheme.of(context).primary,
                                                              size: 26.0,
                                                            ),
                                                            const SizedBox(width: 8.0),
                                                            Expanded(
                                                              child: Text(
                                                                'AI Classification Feedback',
                                                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                                                      font: GoogleFonts.interTight(
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.15),
                                                                borderRadius: BorderRadius.circular(6.0),
                                                              ),
                                                              child: Text(
                                                                'Gemini AI',
                                                                style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                      font: GoogleFonts.inter(
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 12.0),
                                                        Container(
                                                          padding: const EdgeInsets.all(12.0),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFE8F5E9),
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            border: Border.all(
                                                              color: const Color(0xFF81C784),
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            functions.formatWasteClassificationFeedback(
                                                              isSegregated: _model.checkboxSegregatedValue ??
                                                                  functions.stringToBool(_model.apiResponseHolder.elementAtOrNull(2) ?? 'false'),
                                                              isRecyclable: _model.checkboxRecyclableValue ??
                                                                  functions.stringToBool(_model.apiResponseHolder.elementAtOrNull(1) ?? 'false'),
                                                              isBiodegradable: _model.checkboxBiodegradableValue ??
                                                                  functions.stringToBool(_model.apiResponseHolder.elementAtOrNull(3) ?? 'false'),
                                                              isNonBiodegradable: _model.checkboxNonbiodeValue ??
                                                                  functions.stringToBool(_model.apiResponseHolder.elementAtOrNull(4) ?? 'false'),
                                                            ),
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  font: GoogleFonts.inter(
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                  color: const Color(0xFF1B5E20),
                                                                  letterSpacing: 0.0,
                                                                ),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 14.0),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.fact_check_outlined,
                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                              size: 20.0,
                                                            ),
                                                            const SizedBox(width: 6.0),
                                                            Expanded(
                                                              child: Text(
                                                                'Official Double-Check: Review & adjust attributes below',
                                                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                      font: GoogleFonts.inter(
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Theme(
                                                      data: ThemeData(
                                                        checkboxTheme:
                                                            CheckboxThemeData(
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          materialTapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                        ),
                                                        unselectedWidgetColor:
                                                            Colors.black,
                                                      ),
                                                      child: Checkbox(
                                                        value: _model
                                                                .checkboxValidityValue ??=
                                                            functions.stringToBool(_model
                                                                .apiResponseHolder
                                                                .elementAtOrNull(
                                                                    0)!),
                                                        onChanged:
                                                            (newValue) async {
                                                          safeSetState(() =>
                                                              _model.checkboxValidityValue =
                                                                  newValue!);
                                                        },
                                                        side: (Colors.black !=
                                                                null)
                                                            ? BorderSide(
                                                                width: 2,
                                                                color: Colors
                                                                    .black!,
                                                              )
                                                            : null,
                                                        activeColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        checkColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Valid Image Uploaded',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 2.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Theme(
                                                          data: ThemeData(
                                                            checkboxTheme:
                                                                CheckboxThemeData(
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .compact,
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                            ),
                                                            unselectedWidgetColor:
                                                                Colors.black,
                                                          ),
                                                          child: Checkbox(
                                                            value: _model
                                                                    .checkboxRecyclableValue ??=
                                                                functions.stringToBool(_model
                                                                    .apiResponseHolder
                                                                    .elementAtOrNull(
                                                                        1)!),
                                                            onChanged:
                                                                (newValue) async {
                                                              safeSetState(() =>
                                                                  _model.checkboxRecyclableValue =
                                                                      newValue!);
                                                            },
                                                            side: (Colors
                                                                        .black !=
                                                                    null)
                                                                ? BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black!,
                                                                  )
                                                                : null,
                                                            activeColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            checkColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Recyclable',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Theme(
                                                          data: ThemeData(
                                                            checkboxTheme:
                                                                CheckboxThemeData(
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .compact,
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                            ),
                                                            unselectedWidgetColor:
                                                                Colors.black,
                                                          ),
                                                          child: Checkbox(
                                                            value: _model
                                                                    .checkboxSegregatedValue ??=
                                                                functions.stringToBool(_model
                                                                    .apiResponseHolder
                                                                    .elementAtOrNull(
                                                                        2)!),
                                                            onChanged:
                                                                (newValue) async {
                                                              safeSetState(() =>
                                                                  _model.checkboxSegregatedValue =
                                                                      newValue!);
                                                            },
                                                            side: (Colors
                                                                        .black !=
                                                                    null)
                                                                ? BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black!,
                                                                  )
                                                                : null,
                                                            activeColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            checkColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Segregated',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Theme(
                                                          data: ThemeData(
                                                            checkboxTheme:
                                                                CheckboxThemeData(
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .compact,
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                            ),
                                                            unselectedWidgetColor:
                                                                Colors.black,
                                                          ),
                                                          child: Checkbox(
                                                            value: _model
                                                                    .checkboxBiodegradableValue ??=
                                                                functions.stringToBool(_model
                                                                    .apiResponseHolder
                                                                    .elementAtOrNull(
                                                                        3)!),
                                                            onChanged:
                                                                (newValue) async {
                                                              safeSetState(() =>
                                                                  _model.checkboxBiodegradableValue =
                                                                      newValue!);
                                                            },
                                                            side: (Colors
                                                                        .black !=
                                                                    null)
                                                                ? BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black!,
                                                                  )
                                                                : null,
                                                            activeColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            checkColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Biodegradable',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Theme(
                                                          data: ThemeData(
                                                            checkboxTheme:
                                                                CheckboxThemeData(
                                                              visualDensity:
                                                                  VisualDensity
                                                                      .compact,
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                            ),
                                                            unselectedWidgetColor:
                                                                Colors.black,
                                                          ),
                                                          child: Checkbox(
                                                            value: _model
                                                                    .checkboxNonbiodeValue ??=
                                                                functions.stringToBool(_model
                                                                    .apiResponseHolder
                                                                    .elementAtOrNull(
                                                                        4)!),
                                                            onChanged:
                                                                (newValue) async {
                                                              safeSetState(() =>
                                                                  _model.checkboxNonbiodeValue =
                                                                      newValue!);
                                                            },
                                                            side: (Colors
                                                                        .black !=
                                                                    null)
                                                                ? BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black!,
                                                                  )
                                                                : null,
                                                            activeColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                            checkColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .info,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Non-Biodegradable',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  10.0),
                                                      child: TextFormField(
                                                        controller: _model
                                                            .adminRemarkTextController,
                                                        autofocus: false,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Official Double-Check Remarks (Optional)',
                                                          labelStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium,
                                                          hintText:
                                                              'e.g. Double-checked & verified segregation',
                                                          hintStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelSmall,
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                              width: 1.5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .secondaryBackground,
                                                          contentPadding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      12.0,
                                                                      16.0,
                                                                      12.0),
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium,
                                                      ),
                                                    ),
                                                    FFButtonWidget(
                                                        onPressed: () async {
                                                          {
                                                            safeSetState(() =>
                                                                _model.isDataUploading_uploadImgToDbAdetHasAI =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];
                                                            var selectedMedia =
                                                                <SelectedFile>[];
                                                            var downloadUrls =
                                                                <String>[];
                                                            try {
                                                              selectedUploadedFiles = _model
                                                                      .uploadedLocalFile_uploadedImgAdet
                                                                      .bytes!
                                                                      .isNotEmpty
                                                                  ? [
                                                                      _model
                                                                          .uploadedLocalFile_uploadedImgAdet
                                                                    ]
                                                                  : <FFUploadedFile>[];
                                                              selectedMedia =
                                                                  selectedFilesFromUploadedFiles(
                                                                selectedUploadedFiles,
                                                                storageFolderPath:
                                                                    containerUserRow
                                                                        ?.userStreetNameRef,
                                                              );
                                                              downloadUrls =
                                                                  await uploadSupabaseStorageFiles(
                                                                bucketName:
                                                                    'Image_Bucket',
                                                                selectedFiles:
                                                                    selectedMedia,
                                                              );
                                                            } finally {
                                                              _model.isDataUploading_uploadImgToDbAdetHasAI =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length &&
                                                                downloadUrls
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile_uploadImgToDbAdetHasAI =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                                _model.uploadedFileUrl_uploadImgToDbAdetHasAI =
                                                                    downloadUrls
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }

                                                          await ImageTable()
                                                              .insert({
                                                            'img_uploader':
                                                                containerUserRow
                                                                    ?.userId,
                                                            'img_streetNameRef':
                                                                containerUserRow
                                                                    ?.userStreetNameRef,
                                                            'img_reference_link':
                                                                _model
                                                                    .uploadedFileUrl_uploadImgToDbAdetHasAI,
                                                            'created_at': supaSerialize<
                                                                    DateTime>(
                                                                functions
                                                                    .getCurrentTime(
                                                                        getCurrentTimestamp)),
                                                            'status':
                                                                'Verified',
                                                            'created_atDate':
                                                                supaSerialize<
                                                                        DateTime>(
                                                                    functions
                                                                        .getCurrentTime(
                                                                            getCurrentTimestamp)),
                                                            'isSegregated': _model
                                                                .checkboxSegregatedValue ?? false,
                                                            'category_recycling':
                                                                _model
                                                                    .checkboxRecyclableValue ?? false,
                                                            'category_biode': _model
                                                                .checkboxBiodegradableValue ?? false,
                                                            'category_nonbiode':
                                                                _model
                                                                    .checkboxNonbiodeValue ?? false,
                                                            'remark': _model
                                                                    .adminRemarkTextController
                                                                    ?.text
                                                                    .isNotEmpty ==
                                                                true
                                                                ? _model
                                                                    .adminRemarkTextController
                                                                    ?.text
                                                                : 'Verified by official',
                                                            'updated_by':
                                                                containerUserRow
                                                                    ?.userId ?? currentUserUid,
                                                            'updated_at': supaSerialize<
                                                                    DateTime>(
                                                                functions
                                                                    .getCurrentTime(
                                                                        getCurrentTimestamp)),
                                                          });
                                                          safeSetState(() {
                                                            _model.isDataUploading_uploadedImgAdet =
                                                                false;
                                                            _model.uploadedLocalFile_uploadedImgAdet =
                                                                FFUploadedFile(
                                                                    bytes: Uint8List
                                                                        .fromList(
                                                                            []),
                                                                    originalFilename:
                                                                        '');
                                                          });

                                                          safeSetState(() {
                                                            _model.isDataUploading_uploadImgToDbAdetHasAI =
                                                                false;
                                                            _model.uploadedLocalFile_uploadImgToDbAdetHasAI =
                                                                FFUploadedFile(
                                                                    bytes: Uint8List
                                                                        .fromList(
                                                                            []),
                                                                    originalFilename:
                                                                        '');
                                                            _model.uploadedFileUrl_uploadImgToDbAdetHasAI =
                                                                '';
                                                          });

                                                          _model.apiResponseHolder =
                                                              [];
                                                          _model.adminRemarkTextController?.clear();
                                                          safeSetState(() {});
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Waste verified and uploaded to verified list successfully.',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleLarge
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleLarge
                                                                            .fontStyle,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleLarge
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  Colors.black,
                                                            ),
                                                          );
                                                        },
                                                        text:
                                                            'Verify & Upload Waste',
                                                        icon: Icon(
                                                          Icons.verified_outlined,
                                                          size: 24.0,
                                                        ),
                                                        options:
                                                            FFButtonOptions(
                                                          width:
                                                              double.infinity,
                                                          height: 50.0,
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      16.0,
                                                                      0.0,
                                                                      16.0,
                                                                      0.0),
                                                          iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          textStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleSmall
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .interTight(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .fontStyle,
                                                                    ),
                                                                    color: Colors
                                                                        .white,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .fontStyle,
                                                                  ),
                                                          elevation: 0.0,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                      ),
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        safeSetState(() {
                                                          _model.apiResponseHolder = [];
                                                          _model.checkboxValidityValue = null;
                                                          _model.checkboxRecyclableValue = null;
                                                          _model.checkboxSegregatedValue = null;
                                                          _model.checkboxBiodegradableValue = null;
                                                          _model.checkboxNonbiodeValue = null;
                                                          _model.adminRemarkTextController?.clear();
                                                        });
                                                      },
                                                      text: 'Clear / Rescan',
                                                      icon: Icon(
                                                        Icons.refresh_rounded,
                                                        size: 20.0,
                                                      ),
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 44.0,
                                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                        color: Colors.transparent,
                                                        textStyle: FlutterFlowTheme.of(context)
                                                            .titleSmall
                                                            .override(
                                                              font: GoogleFonts.interTight(
                                                                fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                              ),
                                                              color: FlutterFlowTheme.of(context).primary,
                                                              letterSpacing: 0.0,
                                                            ),
                                                        elevation: 0.0,
                                                        borderSide: BorderSide(
                                                          color: FlutterFlowTheme.of(context).primary,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 5.0)),
                                                ),
                                              ],
                                            ),
                                        ].divide(SizedBox(height: 5.0)),
                                      ),
                                  ].divide(SizedBox(height: 15.0)),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 100.0),
                      ].divide(SizedBox(height: 5.0)),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'P_ImgUpload_A_Auth',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
