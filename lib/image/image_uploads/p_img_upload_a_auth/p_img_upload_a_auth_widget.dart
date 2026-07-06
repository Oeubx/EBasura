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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_img_upload_a_auth_model.dart';
export 'p_img_upload_a_auth_model.dart';

class PImgUploadAAuthWidget extends StatefulWidget {
  const PImgUploadAAuthWidget({super.key});

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

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
                  color: Color(0xFFE8EDF2),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/Horizontal_Logo.png',
                                width: double.infinity,
                                height: 150.0,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 15.0, 0.0, 0.0),
                                child: FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.black,
                                    size: 24.0,
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
                                                CImageInformationalDialogWidget(),
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                ),
                              ),
                            ),
                          ],
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
                                color: Color(0xFFBFC9D1),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional(1.0, 1.0),
                                      children: [
                                        if (_model.uploadedLocalFile_uploadedImgAdet !=
                                                null &&
                                            (_model.uploadedLocalFile_uploadedImgAdet
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
                                                  _model.uploadedLocalFile_uploadedImgAdet
                                                          .bytes ??
                                                      Uint8List.fromList([]),
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
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
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondary
                                                      ],
                                                      stops: [0.0, 1.0],
                                                      begin:
                                                          AlignmentDirectional(
                                                              0.0, -1.0),
                                                      end: AlignmentDirectional(
                                                          0, 1.0),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'Welcome, ',
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
                                                                    color: _model.uploadedLocalFile_uploadedImgAdet !=
                                                                                null &&
                                                                            (_model.uploadedLocalFile_uploadedImgAdet.bytes?.isNotEmpty ??
                                                                                false)
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
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
                                                            TextSpan(
                                                              text:
                                                                  valueOrDefault<
                                                                      String>(
                                                                containerUserRow
                                                                    ?.userName,
                                                                '>username',
                                                              ),
                                                              style: TextStyle(
                                                                color: _model.uploadedLocalFile_uploadedImgAdet !=
                                                                            null &&
                                                                        (_model.uploadedLocalFile_uploadedImgAdet.bytes?.isNotEmpty ??
                                                                            false)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            )
                                                          ],
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
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: 'from ',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    color: _model.uploadedLocalFile_uploadedImgAdet !=
                                                                                null &&
                                                                            (_model.uploadedLocalFile_uploadedImgAdet.bytes?.isNotEmpty ??
                                                                                false)
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelLarge
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  valueOrDefault<
                                                                      String>(
                                                                containerUserRow
                                                                    ?.userStreetNameRef,
                                                                '>streetname',
                                                              ),
                                                              style: TextStyle(
                                                                color: _model.uploadedLocalFile_uploadedImgAdet !=
                                                                            null &&
                                                                        (_model.uploadedLocalFile_uploadedImgAdet.bytes?.isNotEmpty ??
                                                                            false)
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            )
                                                          ],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelLarge
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLarge
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLarge
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ].divide(
                                                        SizedBox(height: 5.0)),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      if (_model.uploadedLocalFile_uploadedImgAdet ==
                                                              null ||
                                                          (_model
                                                                  .uploadedLocalFile_uploadedImgAdet
                                                                  .bytes
                                                                  ?.isEmpty ??
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
                                                            fillColor:
                                                                Colors.white,
                                                            icon: Icon(
                                                              Icons.camera,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              final selectedMedia =
                                                                  await selectMediaWithSourceBottomSheet(
                                                                context:
                                                                    context,
                                                                allowPhoto:
                                                                    true,
                                                              );
                                                              if (selectedMedia !=
                                                                      null &&
                                                                  selectedMedia.every((m) =>
                                                                      validateFileFormat(
                                                                          m.storagePath,
                                                                          context))) {
                                                                safeSetState(() =>
                                                                    _model.isDataUploading_uploadedImgAdet =
                                                                        true);
                                                                var selectedUploadedFiles =
                                                                    <FFUploadedFile>[];

                                                                try {
                                                                  selectedUploadedFiles =
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
                                                                } finally {
                                                                  _model.isDataUploading_uploadedImgAdet =
                                                                      false;
                                                                }
                                                                if (selectedUploadedFiles
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length) {
                                                                  safeSetState(
                                                                      () {
                                                                    _model.uploadedLocalFile_uploadedImgAdet =
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
                                                      if ((_model.uploadedLocalFile_uploadedImgAdet !=
                                                                  null &&
                                                              (_model
                                                                      .uploadedLocalFile_uploadedImgAdet
                                                                      .bytes
                                                                      ?.isNotEmpty ??
                                                                  false)) &&
                                                          !(_model
                                                              .apiResponseHolder
                                                              .isNotEmpty))
                                                        FlutterFlowIconButton(
                                                          borderColor:
                                                              Colors.black,
                                                          borderRadius: 8.0,
                                                          buttonSize: 40.0,
                                                          fillColor:
                                                              Colors.white,
                                                          icon: Icon(
                                                            Icons
                                                                .upload_outlined,
                                                            color: Colors.black,
                                                          ),
                                                          onPressed: () async {
                                                            {
                                                              safeSetState(() =>
                                                                  _model.isDataUploading_uploadImgToDbAdetNoAI =
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
                                                                _model.isDataUploading_uploadImgToDbAdetNoAI =
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
                                                                safeSetState(
                                                                    () {
                                                                  _model.uploadedLocalFile_uploadImgToDbAdetNoAI =
                                                                      selectedUploadedFiles
                                                                          .first;
                                                                  _model.uploadedFileUrl_uploadImgToDbAdetNoAI =
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
                                                                      .uploadedFileUrl_uploadImgToDbAdetNoAI,
                                                              'created_at': supaSerialize<
                                                                      DateTime>(
                                                                  functions
                                                                      .getCurrentTime(
                                                                          getCurrentTimestamp)),
                                                              'status':
                                                                  'Uncategorized',
                                                              'created_atDate':
                                                                  supaSerialize<
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
                                                              _model.isDataUploading_uploadImgToDbAdetNoAI =
                                                                  false;
                                                              _model.uploadedLocalFile_uploadImgToDbAdetNoAI =
                                                                  FFUploadedFile(
                                                                      bytes: Uint8List
                                                                          .fromList(
                                                                              []),
                                                                      originalFilename:
                                                                          '');
                                                              _model.uploadedFileUrl_uploadImgToDbAdetNoAI =
                                                                  '';
                                                            });

                                                            _model.apiResponseHolder =
                                                                [];
                                                            safeSetState(() {});
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Image is successfully uploaded.',
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
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleLarge
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleLarge
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        4000),
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            );
                                                          },
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
                                    if (_model.uploadedLocalFile_uploadedImgAdet !=
                                            null &&
                                        (_model.uploadedLocalFile_uploadedImgAdet
                                                .bytes?.isNotEmpty ??
                                            false))
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
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
                                                  _model.apiResponseHolder =
                                                      functions
                                                          .parseWasteResponse(
                                                              AuthScanCall
                                                                  .apiResponse(
                                                            (_model.successApi
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )!)
                                                          .toList()
                                                          .cast<String>();
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
                                              .apiResponseHolder.isNotEmpty)
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
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
                                                    Expanded(
                                                      child: FFButtonWidget(
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
                                                                'Categorized by Ai',
                                                            'created_atDate':
                                                                supaSerialize<
                                                                        DateTime>(
                                                                    functions
                                                                        .getCurrentTime(
                                                                            getCurrentTimestamp)),
                                                            'isSegregated': _model
                                                                .checkboxSegregatedValue,
                                                            'category_recycling':
                                                                _model
                                                                    .checkboxRecyclableValue,
                                                            'category_biode': _model
                                                                .checkboxBiodegradableValue,
                                                            'category_nonbiode':
                                                                _model
                                                                    .checkboxNonbiodeValue,
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
                                                          safeSetState(() {});
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Image is successfully uploaded.',
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
                                                            'Upload Scanned Image',
                                                        icon: Icon(
                                                          Icons.upload_outlined,
                                                          size: 25.0,
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
                        Container(
                          height: 500.0,
                          decoration: BoxDecoration(),
                        ),
                      ].divide(SizedBox(height: 5.0)),
                    ),
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.cBottomBarModel,
                updateCallback: () => safeSetState(() {}),
                child: CBottomBarWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
