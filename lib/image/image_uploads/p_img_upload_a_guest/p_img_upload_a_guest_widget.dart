import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/index.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/image/c_image_informational_dialog/c_image_informational_dialog_widget.dart';
import '/image/c_camera_framing_overlay/c_camera_framing_overlay_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_img_upload_a_guest_model.dart';
export 'p_img_upload_a_guest_model.dart';

class PImgUploadAGuestWidget extends StatefulWidget {
  const PImgUploadAGuestWidget({
    super.key,
    this.autoTriggerCamera = false,
  });

  final bool autoTriggerCamera;

  static String routeName = 'P_ImgUpload_A_Guest';
  static String routePath = '/pImgUploadAGuest';

  @override
  State<PImgUploadAGuestWidget> createState() => _PImgUploadAGuestWidgetState();
}

class _PImgUploadAGuestWidgetState extends State<PImgUploadAGuestWidget> {
  late PImgUploadAGuestModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PImgUploadAGuestModel());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.autoTriggerCamera && !_model.autoTriggeredOnce) {
        _model.autoTriggeredOnce = true;
        await _triggerDirectCameraCapture();
      } else {
        safeSetState(() {});
      }
    });
  }

  Future<void> _triggerDirectCameraCapture() async {
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
        _model.uploadedLocalFile_imgUploadAGuest = uploadedFile;
        _model.apiResponseHolder = [];
        _model.isUploadRecorded = false;
        _model.savedPublicUrl = null;
      });
    } catch (e) {
      debugPrint('Error triggering direct camera for guest: ');
    }
  }

  Future<void> _saveGuestScanToSupabase() async {
    if (_model.uploadedLocalFile_imgUploadAGuest.bytes == null ||
        _model.uploadedLocalFile_imgUploadAGuest.bytes!.isEmpty) {
      return;
    }
    safeSetState(() => _model.isSavingToDb = true);
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = (_model.uploadedLocalFile_imgUploadAGuest.originalFilename.isNotEmpty &&
              _model.uploadedLocalFile_imgUploadAGuest.originalFilename.contains('.'))
          ? _model.uploadedLocalFile_imgUploadAGuest.originalFilename.split('.').last
          : (_model.uploadedLocalFile_imgUploadAGuest.name != null &&
                  _model.uploadedLocalFile_imgUploadAGuest.name!.contains('.'))
              ? _model.uploadedLocalFile_imgUploadAGuest.name!.split('.').last
              : 'jpg';
      final filename = 'guest_$timestamp.$ext';
      final selectedFile = SelectedFile(
        storagePath: 'Guest/$filename',
        bytes: _model.uploadedLocalFile_imgUploadAGuest.bytes!,
        originalFilename:
            _model.uploadedLocalFile_imgUploadAGuest.originalFilename.isNotEmpty
                ? _model.uploadedLocalFile_imgUploadAGuest.originalFilename
                : filename,
      );
      final downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'Image_Bucket',
        selectedFiles: [selectedFile],
      );
      if (downloadUrls.isNotEmpty) {
        _model.savedPublicUrl = downloadUrls.first;
        final isValidWaste = functions.stringToBool(
            _model.apiResponseHolder.elementAtOrNull(0) ?? 'false');
        final isRecyclable = functions.stringToBool(
            _model.apiResponseHolder.elementAtOrNull(1) ?? 'false');
        final isSegregated = functions.stringToBool(
            _model.apiResponseHolder.elementAtOrNull(2) ?? 'false');
        final isBiode = functions.stringToBool(
            _model.apiResponseHolder.elementAtOrNull(3) ?? 'false');
        final isNonBiode = functions.stringToBool(
            _model.apiResponseHolder.elementAtOrNull(4) ?? 'false');

        final dominantTypes = <String>[];
        if (isRecyclable) dominantTypes.add('Recyclable');
        if (isBiode) dominantTypes.add('Biodegradable');
        if (isNonBiode) dominantTypes.add('Non-Biodegradable');
        final aiWasteTypeStr = dominantTypes.isNotEmpty
            ? dominantTypes.join(', ')
            : 'Unidentified';

        await ImageTable().insert({
          'img_uploader': null,
          'img_streetNameRef': 'Guest Upload',
          'img_reference_link': _model.savedPublicUrl,
          'created_at': supaSerialize<DateTime>(
              functions.getCurrentTime(getCurrentTimestamp)),
          'status': 'Non-Verified',
          'verification_status': 'pending',
          'created_atDate': supaSerialize<DateTime>(
              functions.getCurrentTime(getCurrentTimestamp)),
          'isSegregated': isSegregated,
          'category_recycling': isRecyclable,
          'category_biode': isBiode,
          'category_nonbiode': isNonBiode,
          'ai_classification': isSegregated ? 'Segregated' : 'Unsegregated',
          'ai_waste_type': aiWasteTypeStr,
          'ai_confidence_score': 90.00,
          'ai_raw_json': {
            'valid_waste_image': isValidWaste,
            'recyclable': isRecyclable,
            'segregated': isSegregated,
            'biodegradable': isBiode,
            'non_biodegradable': isNonBiode,
            'uploader_role': 'Guest',
          },
        });
        _model.isUploadRecorded = true;
      }
    } catch (e) {
      debugPrint('Guest scan save error: ');
    } finally {
      safeSetState(() => _model.isSavingToDb = false);
    }
  }

  Widget _buildGuestParticipationNotice(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD5F2E2),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFA3C9D9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: const BoxDecoration(
              color: Color(0xFF2E78A6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 18.0,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest Participation Recorded',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF013448),
                  ),
                ),
                const SizedBox(height: 4.0),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      color: const Color(0xFF1E293B),
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Your participation is recorded, but you will not receive points. Please ',
                      ),
                      TextSpan(
                        text: 'sign in',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E78A6),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed(PageSignInWidget.routeName);
                          },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'read rules',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E78A6),
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              enableDrag: true,
                              context: context,
                              builder: (context) => const Padding(
                                padding: EdgeInsets.zero,
                                child: CImageInformationalDialogWidget(),
                              ),
                            );
                          },
                      ),
                      const TextSpan(
                        text: ' to earn rewards on verified scans.',
                      ),
                    ],
                  ),
                ),
                if (_model.isSavingToDb) ...[
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const SizedBox(
                        width: 14.0,
                        height: 14.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF2E78A6)),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Recording participation...',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ] else if (_model.isUploadRecorded) ...[
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.cloud_done_rounded,
                        size: 14.0,
                        color: Color(0xFF31A11F),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Saved as Guest Upload (Pending Review)',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF31A11F),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
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
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 120.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Top Brand Bar with Back Button and Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () => context.safePop(),
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFD5F2E2),
                                    width: 1.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0D000000),
                                      blurRadius: 4.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Color(0xFF2E78A6),
                                  size: 20.0,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/Horizontal_Logo.png',
                              height: 42.0,
                              fit: BoxFit.contain,
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: true,
                                  context: context,
                                  builder: (context) => const Padding(
                                    padding: EdgeInsets.zero,
                                    child: CImageInformationalDialogWidget(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFD5F2E2),
                                    width: 1.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0D000000),
                                      blurRadius: 4.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF2E78A6),
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14.0),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: const Color(0xFFD5F2E2),
                              width: 1.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 10.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional(1.0, 1.0),
                                  children: [
                                    if (_model.uploadedLocalFile_imgUploadAGuest !=
                                            null &&
                                        (_model.uploadedLocalFile_imgUploadAGuest
                                                .bytes?.isNotEmpty ??
                                            false))
                                      Stack(
                                        alignment:
                                            AlignmentDirectional(0.0, 1.0),
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.memory(
                                              _model.uploadedLocalFile_imgUploadAGuest
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
                                          Opacity(
                                            opacity: 0.5,
                                            child: Container(
                                              width: double.infinity,
                                              height: 65.0,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                    FlutterFlowTheme.of(context)
                                                        .secondary
                                                  ],
                                                  stops: [0.0, 1.0],
                                                  begin: AlignmentDirectional(
                                                      0.0, -1.0),
                                                  end: AlignmentDirectional(
                                                      0, 1.0),
                                                ),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Welcome, ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontStyle,
                                                                ),
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
                                                        TextSpan(
                                                          text: 'Guest',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleLarge
                                                              .override(
                                                                font: GoogleFonts
                                                                    .interTight(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleLarge
                                                                      .fontStyle,
                                                                ),
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
                                                        )
                                                      ],
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
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ].divide(SizedBox(height: 5.0)),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  if (_model.uploadedLocalFile_imgUploadAGuest ==
                                                          null ||
                                                      (_model.uploadedLocalFile_imgUploadAGuest
                                                              .bytes?.isEmpty ??
                                                          true))
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  5.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowIconButton(
                                                        borderColor:
                                                            Colors.black,
                                                        borderRadius: 8.0,
                                                        buttonSize: 40.0,
                                                        fillColor: Colors.white,
                                                        icon: Icon(
                                                          Icons.camera,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () async {
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
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading_imgUploadAGuest =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                            originalFilename:
                                                                                m.originalFilename,
                                                                          ))
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading_imgUploadAGuest =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                    .length ==
                                                                selectedMedia
                                                                    .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile_imgUploadAGuest =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  if (_model.uploadedLocalFile_imgUploadAGuest !=
                                                          null &&
                                                      (_model
                                                              .uploadedLocalFile_imgUploadAGuest
                                                              .bytes
                                                              ?.isNotEmpty ??
                                                          false))
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  5.0,
                                                                  0.0),
                                                      child:
                                                          FlutterFlowIconButton(
                                                        borderColor:
                                                            Colors.black,
                                                        borderRadius: 8.0,
                                                        buttonSize: 40.0,
                                                        fillColor: Colors.white,
                                                        icon: Icon(
                                                          Icons.camera,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () async {
                                                          safeSetState(() {
                                                            _model.isDataUploading_imgUploadAGuest =
                                                                false;
                                                            _model.uploadedLocalFile_imgUploadAGuest =
                                                                FFUploadedFile(
                                                                    bytes: Uint8List
                                                                        .fromList(
                                                                            []),
                                                                    originalFilename:
                                                                        '');
                                                          });

                                                          safeSetState(() {});
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 10.0)),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_model.uploadedLocalFile_imgUploadAGuest !=
                                        null &&
                                    (_model.uploadedLocalFile_imgUploadAGuest
                                            .bytes?.isNotEmpty ??
                                        false))
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      if (_model.apiResponseHolder.isEmpty)
                                      FFButtonWidget(
                                        onPressed: () async {
                                          _model.guestRateLimiterValue =
                                              await actions.guestRateLimiter(
                                            functions.getCurrentTime(
                                                getCurrentTimestamp),
                                            FFAppState().dateTimeScanOfGuest,
                                          );
                                          if (_model.guestRateLimiterValue ==
                                              true) {
                                            _model.uploadedImgAdetConvertedGuest =
                                                await actions
                                                    .imageConversionToBase64String(
                                              _model
                                                  .uploadedLocalFile_imgUploadAGuest,
                                            );
                                            _model.successApiGuest =
                                                await GuestScanCall.call(
                                              base64image: _model
                                                  .uploadedImgAdetConvertedGuest,
                                            );

                                            if ((_model.successApiGuest
                                                    ?.succeeded ??
                                                true)) {
                                              _model.apiResponseHolder =
                                                  functions
                                                      .parseWasteResponse(
                                                          GuestScanCall
                                                              .apiResponse(
                                                        (_model.successApiGuest
                                                                ?.jsonBody ??
                                                            ''),
                                                      )!)
                                                      .toList()
                                                      .cast<String>();
                                              FFAppState().dateTimeScanOfGuest =
                                                  functions.getCurrentTime(
                                                      getCurrentTimestamp);
                                              safeSetState(() {});
                                              await _saveGuestScanToSupabase();
                                            } else {
                                              await showDialog(
                                                context: context,
                                                builder: (alertDialogContext) {
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
                                              builder: (alertDialogContext) {
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
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
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      if (_model.apiResponseHolder.isNotEmpty)
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Theme(
                                                  data: ThemeData(
                                                    checkboxTheme:
                                                        CheckboxThemeData(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                    ),
                                                    unselectedWidgetColor:
                                                        Colors.black,
                                                  ),
                                                  child: Checkbox(
                                                    value: _model
                                                            .checkboxValidityValue ??=
                                                        functions.stringToBool(
                                                            _model
                                                                .apiResponseHolder
                                                                .elementAtOrNull(
                                                                    0)!),
                                                    onChanged:
                                                        (newValue) async {
                                                      safeSetState(() => _model
                                                              .checkboxValidityValue =
                                                          newValue!);
                                                    },
                                                    side: (Colors.black != null)
                                                        ? BorderSide(
                                                            width: 2,
                                                            color:
                                                                Colors.black!,
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
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleSmall
                                                      .override(
                                                        font: GoogleFonts
                                                            .interTight(
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
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              thickness: 2.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                            if (_model.checkboxValidityValue ==
                                                false)
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
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
                                                        'Recyclable',
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
                                                        'Segregated',
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
                                                        'Biodegradable',
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
                                                        'Non-Biodegradable',
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
                                    FFButtonWidget(
                                      onPressed: () async {
                                        safeSetState(() {
                                          _model.apiResponseHolder = [];
                                          _model.checkboxValidityValue = null;
                                          _model.checkboxRecyclableValue = null;
                                          _model.checkboxSegregatedValue = null;
                                          _model.checkboxBiodegradableValue = null;
                                          _model.checkboxNonbiodeValue = null;
                                          _model.isUploadRecorded = false;
                                          _model.savedPublicUrl = null;
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
                                    _buildGuestParticipationNotice(context),
                                                ].divide(SizedBox(height: 5.0)),
                                              ),
                                          ],
                                        ),
                                    ].divide(SizedBox(height: 5.0)),
                                  ),
                              ].divide(SizedBox(height: 15.0)),
                            ),
                          ),
                        ),
                      ].divide(const SizedBox(height: 5.0)),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'P_ImgUpload_A_Guest',
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
