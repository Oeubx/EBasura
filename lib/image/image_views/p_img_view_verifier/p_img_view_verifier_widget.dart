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
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_img_view_verifier_model.dart';
export 'p_img_view_verifier_model.dart';

class PImgViewVerifierWidget extends StatefulWidget {
  const PImgViewVerifierWidget({
    super.key,
    required this.imageIDref,
  });

  final ImageRow? imageIDref;

  static String routeName = 'P_ImgView_Verifier';
  static String routePath = '/pImgViewVerifier';

  @override
  State<PImgViewVerifierWidget> createState() => _PImgViewVerifierWidgetState();
}

class _PImgViewVerifierWidgetState extends State<PImgViewVerifierWidget> {
  late PImgViewVerifierModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PImgViewVerifierModel());

    _model.textFieldRemarksFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: FlutterFlowTheme.of(context).tertiary,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
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
                        StreamBuilder<List<ImageRow>>(
                          stream: _model.containerSupabaseStream ??= SupaFlow
                              .client
                              .from("Image")
                              .stream(primaryKey: ['image_id'])
                              .eqOrNull(
                                'image_id',
                                widget!.imageIDref?.imageId,
                              )
                              .map((list) =>
                                  list.map((item) => ImageRow(item)).toList()),
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
                            List<ImageRow> containerImageRowList =
                                snapshot.data!;

                            final containerImageRow =
                                containerImageRowList.isNotEmpty
                                    ? containerImageRowList.first
                                    : null;

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFDFF1F1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Stack(
                                        alignment:
                                            AlignmentDirectional(1.0, 1.0),
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional(0.0, 1.0),
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  containerImageRow!
                                                      .imgReferenceLink,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Opacity(
                                                opacity: 0.5,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 75.0,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF2C3947),
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
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    FutureBuilder<
                                                        List<UserRow>>(
                                                      future: UserTable()
                                                          .querySingleRow(
                                                        queryFn: (q) =>
                                                            q.eqOrNull(
                                                          'user_id',
                                                          containerImageRow
                                                              ?.imgUploader,
                                                        ),
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
                                                        // Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        List<UserRow>
                                                            rowUserRowList =
                                                            snapshot.data!;

                                                        final rowUserRow =
                                                            rowUserRowList
                                                                    .isNotEmpty
                                                                ? rowUserRowList
                                                                    .first
                                                                : null;

                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              Icons.person,
                                                              color:
                                                                  Colors.white,
                                                              size: 25.0,
                                                            ),
                                                            Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                rowUserRow
                                                                    ?.userName,
                                                                '>user_name',
                                                              ),
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
                                                          ].divide(SizedBox(
                                                              width: 5.0)),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: Colors.white,
                                                          size: 20.0,
                                                        ),
                                                        Text(
                                                          dateTimeFormat(
                                                              "Md",
                                                              containerImageRow!
                                                                  .createdAt),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ].divide(
                                                          SizedBox(width: 5.0)),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (containerImageRow
                                                                ?.status ==
                                                            'Uncategorized')
                                                          Icon(
                                                            Icons
                                                                .question_mark_rounded,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (containerImageRow
                                                                ?.status ==
                                                            'Categorized by Ai')
                                                          Icon(
                                                            Icons.android,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (containerImageRow
                                                                ?.status ==
                                                            'Unsegregated')
                                                          Icon(
                                                            Icons
                                                                .delete_forever,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (containerImageRow
                                                                ?.status ==
                                                            'Segregated')
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline_sharp,
                                                            color: Color(
                                                                0xFF468432),
                                                            size: 20.0,
                                                          ),
                                                        if (containerImageRow
                                                                ?.status ==
                                                            'Flagged')
                                                          Icon(
                                                            Icons.flag_outlined,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (containerImageRow
                                                                ?.status ==
                                                            'Verified')
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .checkDouble,
                                                            color: Color(
                                                                0xFF468432),
                                                            size: 20.0,
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
                                      if (containerImageRow?.updatedBy !=
                                              null &&
                                          containerImageRow?.updatedBy != '')
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder<List<UserRow>>(
                                              future:
                                                  UserTable().querySingleRow(
                                                queryFn: (q) => q.eqOrNull(
                                                  'user_id',
                                                  containerImageRow?.updatedBy,
                                                ),
                                              ),
                                              builder: (context, snapshot) {
                                                // Customize what your widget looks like when it's loading.
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                    child: SizedBox(
                                                      width: 50.0,
                                                      height: 50.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                List<UserRow> rowUserRowList =
                                                    snapshot.data!;

                                                final rowUserRow =
                                                    rowUserRowList.isNotEmpty
                                                        ? rowUserRowList.first
                                                        : null;

                                                return Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .verified_outlined,
                                                          color: Colors.black,
                                                          size: 25.0,
                                                        ),
                                                        Text(
                                                          containerImageRow
                                                                          ?.updatedBy !=
                                                                      null &&
                                                                  containerImageRow
                                                                          ?.updatedBy !=
                                                                      ''
                                                              ? valueOrDefault<
                                                                  String>(
                                                                  rowUserRow
                                                                      ?.userName,
                                                                  'user_name',
                                                                )
                                                              : 'Not yet Verified',
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
                                                                color: Colors
                                                                    .black,
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
                                                      ].divide(
                                                          SizedBox(width: 5.0)),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: Colors.black,
                                                          size: 15.0,
                                                        ),
                                                        Text(
                                                          dateTimeFormat(
                                                              "Md",
                                                              containerImageRow!
                                                                  .updatedAt!),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ].divide(
                                                          SizedBox(width: 5.0)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Divider(
                                              thickness: 2.0,
                                              color: Colors.black,
                                            ),
                                          ].divide(SizedBox(height: 5.0)),
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 20.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Is the image\nSegregated?',
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
                                                    Switch.adaptive(
                                                      value: _model
                                                              .switchIsSegregatedValue ??=
                                                          (containerImageRow
                                                                      ?.isSegregated ==
                                                                  true) ||
                                                              (containerImageRow
                                                                      ?.isSegregated ==
                                                                  false),
                                                      onChanged:
                                                          (newValue) async {
                                                        safeSetState(() => _model
                                                                .switchIsSegregatedValue =
                                                            newValue!);
                                                      },
                                                      activeColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      activeTrackColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      inactiveTrackColor:
                                                          Colors.white,
                                                      inactiveThumbColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
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
                                                              .checkboxRecyclingValue ??=
                                                          (containerImageRow
                                                                      ?.categoryRecycling ==
                                                                  true) ||
                                                              (containerImageRow
                                                                      ?.categoryRecycling ==
                                                                  false),
                                                      onChanged:
                                                          (newValue) async {
                                                        safeSetState(() => _model
                                                                .checkboxRecyclingValue =
                                                            newValue!);
                                                      },
                                                      side: (Colors.black !=
                                                              null)
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
                                                    'Recyclable',
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
                                                          fontSize: 14.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
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
                                                              .checkboxBiodeValue ??=
                                                          (containerImageRow
                                                                      ?.categoryBiode ==
                                                                  true) ||
                                                              (containerImageRow
                                                                      ?.categoryBiode ==
                                                                  false),
                                                      onChanged:
                                                          (newValue) async {
                                                        safeSetState(() => _model
                                                                .checkboxBiodeValue =
                                                            newValue!);
                                                      },
                                                      side: (Colors.black !=
                                                              null)
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
                                                    'Biodegradable',
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
                                                          fontSize: 14.0,
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
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
                                                              .checkboxNonbiodeValue1 ??=
                                                          (containerImageRow
                                                                      ?.categoryNonbiode ==
                                                                  true) ||
                                                              (containerImageRow
                                                                      ?.categoryNonbiode ==
                                                                  false),
                                                      onChanged:
                                                          (newValue) async {
                                                        safeSetState(() => _model
                                                                .checkboxNonbiodeValue1 =
                                                            newValue!);
                                                      },
                                                      side: (Colors.black !=
                                                              null)
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
                                                    'Non-Biodegradable',
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
                                                          fontSize: 14.0,
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
                                            ],
                                          ),
                                          if (_model.reverified == true)
                                            SizedBox(
                                              height: 165.0,
                                              child: VerticalDivider(
                                                thickness: 2.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          if (_model.reverified == true)
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                if (_model.apiResponseHolder
                                                    .isNotEmpty)
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    3.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'Valid Image\nUploaded',
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
                                                                    fontSize:
                                                                        14.0,
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
                                                                        BorderRadius.circular(
                                                                            4.0),
                                                                  ),
                                                                ),
                                                                unselectedWidgetColor:
                                                                    Colors
                                                                        .black,
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
                                                                side: (Colors
                                                                            .black !=
                                                                        null)
                                                                    ? BorderSide(
                                                                        width:
                                                                            2,
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
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'Segregated',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
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
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .black,
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
                                                                          width:
                                                                              2,
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
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'Recyclable',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
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
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .black,
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
                                                                          width:
                                                                              2,
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
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'Biodegradable',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
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
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .black,
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
                                                                          width:
                                                                              2,
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
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'Non-Biodegradable',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
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
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                    ),
                                                                  ),
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                child: Checkbox(
                                                                  value: _model
                                                                          .checkboxNonbiodeValue2 ??=
                                                                      functions.stringToBool(_model
                                                                          .apiResponseHolder
                                                                          .elementAtOrNull(
                                                                              4)!),
                                                                  onChanged:
                                                                      (newValue) async {
                                                                    safeSetState(() =>
                                                                        _model.checkboxNonbiodeValue2 =
                                                                            newValue!);
                                                                  },
                                                                  side: (Colors
                                                                              .black !=
                                                                          null)
                                                                      ? BorderSide(
                                                                          width:
                                                                              2,
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
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 2.0,
                                        color: Colors.black,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            child: TextFormField(
                                              controller: _model
                                                      .textFieldRemarksTextController ??=
                                                  TextEditingController(
                                                text: containerImageRow?.remark,
                                              ),
                                              focusNode: _model
                                                  .textFieldRemarksFocusNode,
                                              autofocus: false,
                                              enabled: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                hintText: 'Leave a remark..',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMedium
                                                                  .fontStyle,
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                              cursorColor:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              enableInteractiveSelection: true,
                                              validator: _model
                                                  .textFieldRemarksTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (containerImageRow?.status !=
                                                  'Verified')
                                                FutureBuilder<
                                                    List<UserSubtableRow>>(
                                                  future: UserSubtableTable()
                                                      .querySingleRow(
                                                    queryFn: (q) => q.eqOrNull(
                                                      'user_idRef',
                                                      containerImageRow
                                                          ?.imgUploader,
                                                    ),
                                                  ),
                                                  builder: (context, snapshot) {
                                                    // Customize what your widget looks like when it's loading.
                                                    if (!snapshot.hasData) {
                                                      return Center(
                                                        child: SizedBox(
                                                          width: 50.0,
                                                          height: 50.0,
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .primary,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    List<UserSubtableRow>
                                                        rowUserSubtableRowList =
                                                        snapshot.data!;

                                                    final rowUserSubtableRow =
                                                        rowUserSubtableRowList
                                                                .isNotEmpty
                                                            ? rowUserSubtableRowList
                                                                .first
                                                            : null;

                                                    return Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      -1.0,
                                                                      0.0),
                                                              child:
                                                                  FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    enableDrag:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          FocusScope.of(context)
                                                                              .unfocus();
                                                                          FocusManager
                                                                              .instance
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              MediaQuery.viewInsetsOf(context),
                                                                          child:
                                                                              CImageDeletionWidget(
                                                                            imageRef:
                                                                                containerImageRow!,
                                                                            userSubtableRef:
                                                                                rowUserSubtableRow!,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).then((value) =>
                                                                      safeSetState(
                                                                          () {}));
                                                                },
                                                                text: 'Delete',
                                                                icon: Icon(
                                                                  Icons
                                                                      .edit_note,
                                                                  size: 25.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 50.0,
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Color(
                                                                      0xFFC44545),
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Color(
                                                                            0xFFFBF4F4),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      0.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                            ),
                                                            if (containerImageRow
                                                                    ?.status ==
                                                                'Flagged')
                                                              FFButtonWidget(
                                                                onPressed:
                                                                    () async {
                                                                  await ImageTable()
                                                                      .update(
                                                                    data: {
                                                                      'allowFlagging':
                                                                          false,
                                                                    },
                                                                    matchingRows:
                                                                        (rows) =>
                                                                            rows.eqOrNull(
                                                                      'image_id',
                                                                      containerImageRow
                                                                          ?.imageId,
                                                                    ),
                                                                  );
                                                                },
                                                                text: 'Disable',
                                                                icon: Icon(
                                                                  Icons
                                                                      .flag_outlined,
                                                                  size: 25.0,
                                                                ),
                                                                options:
                                                                    FFButtonOptions(
                                                                  height: 50.0,
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                  iconAlignment:
                                                                      IconAlignment
                                                                          .end,
                                                                  iconPadding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  color: Colors
                                                                      .white,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleSmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .interTight(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontStyle,
                                                                      ),
                                                                  elevation:
                                                                      0.0,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                              ),
                                                          ].divide(SizedBox(
                                                              height: 10.0)),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            FFButtonWidget(
                                                              onPressed:
                                                                  () async {
                                                                if (_model
                                                                        .checkboxRecyclingValue ==
                                                                    true) {
                                                                  _model.categoryCount =
                                                                      _model.categoryCount +
                                                                          1;
                                                                }
                                                                if (_model
                                                                        .checkboxBiodeValue ==
                                                                    true) {
                                                                  _model.categoryCount =
                                                                      _model.categoryCount +
                                                                          1;
                                                                }
                                                                if (_model
                                                                        .checkboxNonbiodeValue1 ==
                                                                    true) {
                                                                  _model.categoryCount =
                                                                      _model.categoryCount +
                                                                          1;
                                                                }
                                                                if (_model
                                                                        .switchIsSegregatedValue ==
                                                                    true) {
                                                                  if (containerImageRow
                                                                          ?.status !=
                                                                      'Flagged') {
                                                                    await ImageTable()
                                                                        .update(
                                                                      data: {
                                                                        'status':
                                                                            'Segregated',
                                                                        'remark': _model
                                                                            .textFieldRemarksTextController
                                                                            .text,
                                                                        'updated_by':
                                                                            currentUserUid,
                                                                        'allowFlagging':
                                                                            true,
                                                                        'isSegregated':
                                                                            _model.switchIsSegregatedValue,
                                                                        'category_recycling':
                                                                            _model.checkboxRecyclingValue,
                                                                        'category_biode':
                                                                            _model.checkboxBiodeValue,
                                                                        'category_nonbiode':
                                                                            _model.checkboxNonbiodeValue1,
                                                                      },
                                                                      matchingRows:
                                                                          (rows) =>
                                                                              rows.eqOrNull(
                                                                        'image_id',
                                                                        containerImageRow
                                                                            ?.imageId,
                                                                      ),
                                                                    );
                                                                    if (_model
                                                                            .categoryCount ==
                                                                        3) {
                                                                      await UserSubtableTable()
                                                                          .update(
                                                                        data: {
                                                                          'user_points': functions.plusPoints(
                                                                              rowUserSubtableRow!.userPoints!,
                                                                              100),
                                                                          'notification':
                                                                              false,
                                                                        },
                                                                        matchingRows:
                                                                            (rows) =>
                                                                                rows.eqOrNull(
                                                                          'user_idRef',
                                                                          containerImageRow
                                                                              ?.imgUploader,
                                                                        ),
                                                                      );
                                                                    } else if (_model
                                                                            .categoryCount ==
                                                                        2) {
                                                                      await UserSubtableTable()
                                                                          .update(
                                                                        data: {
                                                                          'user_points': functions.plusPoints(
                                                                              rowUserSubtableRow!.userPoints!,
                                                                              50),
                                                                          'notification':
                                                                              false,
                                                                        },
                                                                        matchingRows:
                                                                            (rows) =>
                                                                                rows.eqOrNull(
                                                                          'user_idRef',
                                                                          containerImageRow
                                                                              ?.imgUploader,
                                                                        ),
                                                                      );
                                                                    } else if (_model
                                                                            .categoryCount ==
                                                                        1) {
                                                                      await UserSubtableTable()
                                                                          .update(
                                                                        data: {
                                                                          'user_points': functions.plusPoints(
                                                                              rowUserSubtableRow!.userPoints!,
                                                                              25),
                                                                          'notification':
                                                                              false,
                                                                        },
                                                                        matchingRows:
                                                                            (rows) =>
                                                                                rows.eqOrNull(
                                                                          'user_idRef',
                                                                          containerImageRow
                                                                              ?.imgUploader,
                                                                        ),
                                                                      );
                                                                    }
                                                                  } else {
                                                                    await ImageTable()
                                                                        .update(
                                                                      data: {
                                                                        'status':
                                                                            'Verified',
                                                                        'remark': _model
                                                                            .textFieldRemarksTextController
                                                                            .text,
                                                                        'updated_by':
                                                                            currentUserUid,
                                                                        'allowFlagging':
                                                                            false,
                                                                        'isSegregated':
                                                                            _model.switchIsSegregatedValue,
                                                                        'category_recycling':
                                                                            _model.checkboxRecyclingValue,
                                                                        'category_biode':
                                                                            _model.checkboxBiodeValue,
                                                                        'category_nonbiode':
                                                                            _model.checkboxNonbiodeValue1,
                                                                      },
                                                                      matchingRows:
                                                                          (rows) =>
                                                                              rows.eqOrNull(
                                                                        'image_id',
                                                                        containerImageRow
                                                                            ?.imageId,
                                                                      ),
                                                                    );
                                                                    await UserSubtableTable()
                                                                        .update(
                                                                      data: {
                                                                        'user_points': functions.plusPoints(
                                                                            rowUserSubtableRow!.userPoints!,
                                                                            100),
                                                                        'notification':
                                                                            false,
                                                                      },
                                                                      matchingRows:
                                                                          (rows) =>
                                                                              rows.eqOrNull(
                                                                        'user_idRef',
                                                                        containerImageRow
                                                                            ?.imgUploader,
                                                                      ),
                                                                    );
                                                                  }
                                                                } else {
                                                                  await ImageTable()
                                                                      .update(
                                                                    data: {
                                                                      'status':
                                                                          'Unsegregated',
                                                                      'remark': _model
                                                                          .textFieldRemarksTextController
                                                                          .text,
                                                                      'updated_by':
                                                                          currentUserUid,
                                                                      'allowFlagging':
                                                                          true,
                                                                      'isSegregated':
                                                                          _model
                                                                              .switchIsSegregatedValue,
                                                                      'category_recycling':
                                                                          _model
                                                                              .checkboxRecyclingValue,
                                                                      'category_biode':
                                                                          _model
                                                                              .checkboxBiodeValue,
                                                                      'category_nonbiode':
                                                                          _model
                                                                              .checkboxNonbiodeValue1,
                                                                    },
                                                                    matchingRows:
                                                                        (rows) =>
                                                                            rows.eqOrNull(
                                                                      'image_id',
                                                                      containerImageRow
                                                                          ?.imageId,
                                                                    ),
                                                                  );
                                                                  await UserSubtableTable()
                                                                      .update(
                                                                    data: {
                                                                      'notification':
                                                                          true,
                                                                    },
                                                                    matchingRows:
                                                                        (rows) =>
                                                                            rows.eqOrNull(
                                                                      'user_idRef',
                                                                      containerImageRow
                                                                          ?.imgUploader,
                                                                    ),
                                                                  );
                                                                }

                                                                _model.categoryCount =
                                                                    0;
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              text: 'Save',
                                                              icon: Icon(
                                                                Icons
                                                                    .verified_outlined,
                                                                size: 25.0,
                                                              ),
                                                              options:
                                                                  FFButtonOptions(
                                                                height: 50.0,
                                                                padding: EdgeInsetsDirectional
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
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
                                                              onPressed:
                                                                  () async {
                                                                _model.uploadedImgFromDBConverted =
                                                                    await actions
                                                                        .imageConversionToBase64StringRevalidation(
                                                                  containerImageRow
                                                                      ?.imgReferenceLink,
                                                                );
                                                                _model.revalidationSuccess =
                                                                    await RevalidationScanCall
                                                                        .call(
                                                                  base64image:
                                                                      _model
                                                                          .uploadedImgFromDBConverted,
                                                                );

                                                                if ((_model
                                                                        .revalidationSuccess
                                                                        ?.succeeded ??
                                                                    true)) {
                                                                  _model.apiResponseHolder =
                                                                      functions
                                                                          .parseWasteResponse(RevalidationScanCall
                                                                              .apiResponse(
                                                                            (_model.revalidationSuccess?.jsonBody ??
                                                                                ''),
                                                                          )!)
                                                                          .toList()
                                                                          .cast<
                                                                              String>();
                                                                  _model.reverified =
                                                                      true;
                                                                  safeSetState(
                                                                      () {});
                                                                } else {
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (alertDialogContext) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            'Scanning Feature Failed'),
                                                                        content:
                                                                            Text('Something went wrong.'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(alertDialogContext),
                                                                            child:
                                                                                Text('Ok'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                }

                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              text: 'Re-Verify',
                                                              icon: Icon(
                                                                Icons.android,
                                                                size: 25.0,
                                                              ),
                                                              options:
                                                                  FFButtonOptions(
                                                                height: 50.0,
                                                                padding: EdgeInsetsDirectional
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
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .success,
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleSmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
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
                                                          ].divide(SizedBox(
                                                              height: 10.0)),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                            ].divide(SizedBox(height: 10.0)),
                                          ),
                                        ].divide(SizedBox(height: 10.0)),
                                      ),
                                    ].divide(SizedBox(height: 10.0)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          width: 100.0,
                          height: 150.0,
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
