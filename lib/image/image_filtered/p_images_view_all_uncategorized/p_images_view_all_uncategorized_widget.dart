import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'p_images_view_all_uncategorized_model.dart';
export 'p_images_view_all_uncategorized_model.dart';

class PImagesViewAllUncategorizedWidget extends StatefulWidget {
  const PImagesViewAllUncategorizedWidget({super.key});

  static String routeName = 'P_Images_ViewAll_Uncategorized';
  static String routePath = '/pImagesViewAllUncategorized';

  @override
  State<PImagesViewAllUncategorizedWidget> createState() =>
      _PImagesViewAllUncategorizedWidgetState();
}

class _PImagesViewAllUncategorizedWidgetState
    extends State<PImagesViewAllUncategorizedWidget> {
  late PImagesViewAllUncategorizedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PImagesViewAllUncategorizedModel());

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
                  color: Color(0xFFE8EDF2),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
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
                      Container(
                        width: double.infinity,
                        height: 525.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFDFF1F1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: SingleChildScrollView(
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<UserRow> rowUserRowList =
                                        snapshot.data!;

                                    final rowUserRow = rowUserRowList.isNotEmpty
                                        ? rowUserRowList.first
                                        : null;

                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 25.0,
                                        ),
                                        RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Welcome user, ',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.black,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              TextSpan(
                                                text: rowUserRow!.userName!,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 5.0)),
                                    );
                                  },
                                ),
                                Text(
                                  'Click on the image to view their description.',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                                Divider(
                                  thickness: 2.0,
                                  color: Colors.black,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 425.0,
                                  decoration: BoxDecoration(),
                                  child: StreamBuilder<List<ImageRow>>(
                                    stream: _model
                                            .staggeredViewSupabaseStream ??=
                                        SupaFlow.client
                                            .from("Image")
                                            .stream(primaryKey: ['image_id'])
                                            .eqOrNull(
                                              'status',
                                              'Uncategorized',
                                            )
                                            .order('created_at')
                                            .limit(10)
                                            .map((list) => list
                                                .map((item) => ImageRow(item))
                                                .toList()),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      List<ImageRow> staggeredViewImageRowList =
                                          snapshot.data!;

                                      return MasonryGridView.builder(
                                        gridDelegate:
                                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        itemCount:
                                            staggeredViewImageRowList.length,
                                        itemBuilder:
                                            (context, staggeredViewIndex) {
                                          final staggeredViewImageRow =
                                              staggeredViewImageRowList[
                                                  staggeredViewIndex];
                                          return Stack(
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            children: [
                                              Stack(
                                                alignment: AlignmentDirectional(
                                                    0.0, 1.0),
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      context.pushNamed(
                                                        PImgViewVerifierWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'imageIDref':
                                                              serializeParam(
                                                            staggeredViewImageRow,
                                                            ParamType
                                                                .SupabaseRow,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        staggeredViewImageRow
                                                            .imgReferenceLink,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Opacity(
                                                    opacity: 0.5,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 35.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF263B6A),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
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
                                                              staggeredViewImageRow
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
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Uncategorized')
                                                          Icon(
                                                            Icons
                                                                .question_mark_rounded,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Categorized by Ai')
                                                          Icon(
                                                            Icons.android,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Unsegregated')
                                                          Icon(
                                                            Icons
                                                                .delete_forever,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Segregated')
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline_sharp,
                                                            color: Color(
                                                                0xFF468432),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Flagged')
                                                          Icon(
                                                            Icons.flag_outlined,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
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
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ].divide(SizedBox(height: 5.0)),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 5.0)),
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
