import '/auth/supabase_auth/auth_util.dart';
import '/auth/role_util.dart';
import '/components/c_page_header/c_page_header_widget.dart';
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
    _model.auditOpenTimestamp = DateTime.now();

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
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Top Brand Header Bar with Back Button
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
                            const SizedBox(width: 40.0),
                          ],
                        ),
                        const SizedBox(height: 12.0),
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

                            if (containerImageRow == null) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Text('Waste record not found or has been deleted.'),
                                ),
                              );
                            }

                            return FutureBuilder<List<UserRow>>(
                              future: UserTable().querySingleRow(
                                queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
                              ),
                              builder: (context, userSnapshot) {
                                final currentUserRow = userSnapshot.data?.isNotEmpty == true
                                    ? userSnapshot.data!.first
                                    : null;
                                final isAdmin = RoleService.isAdmin(currentUserRow?.userType);

                                return Container(
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
                                    blurRadius: 8.0,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final cats = <String>[];
                                          if (containerImageRow.categoryRecycling == true) cats.add('Recyclable');
                                          if (containerImageRow.categoryBiode == true) cats.add('Biodegradable');
                                          if (containerImageRow.categoryNonbiode == true) cats.add('Non-Biodegradable');
                                          final catStr = cats.isEmpty
                                              ? 'Waste'
                                              : (cats.length == 1 ? '${cats.first} Waste' : '${cats.join(" & ")} Waste');
                                          final isVerified = containerImageRow.status == 'Verified';

                                          return CPageHeaderWidget(
                                            title: 'Verification of $catStr',
                                            subtitle: isAdmin
                                                ? 'Review AI scan findings, audit categorization, and award community points'
                                                : 'View waste classification results and verification status',
                                            icon: Icons.verified_user_rounded,
                                            badgeText: isVerified ? 'Verified' : 'Pending',
                                            badgeColor: isVerified ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                                          );
                                        },
                                      ),
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
                                                                (containerImageRow?.imgUploader == null ||
                                                                        containerImageRow?.imgUploader ==
                                                                            '00000000-0000-0000-0000-000000000000')
                                                                    ? 'Guest'
                                                                    : 'Unknown User',
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
                                      // AI Classification Feedback Card
                                      Builder(
                                        builder: (context) {
                                          final currentSegregated = _model.switchIsSegregatedValue ??
                                              containerImageRow.isSegregated ??
                                              false;
                                          final currentRecycling = _model.checkboxRecyclingValue ??
                                              containerImageRow.categoryRecycling ??
                                              false;
                                          final currentBiode = _model.checkboxBiodeValue ??
                                              containerImageRow.categoryBiode ??
                                              false;
                                          final currentNonBiode = _model.checkboxNonbiodeValue1 ??
                                              containerImageRow.categoryNonbiode ??
                                              false;

                                          final feedbackText = functions.formatWasteClassificationFeedback(
                                            isSegregated: currentSegregated,
                                            isRecyclable: currentRecycling,
                                            isBiodegradable: currentBiode,
                                            isNonBiodegradable: currentNonBiode,
                                          );

                                          return Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F8E9),
                                              borderRadius: BorderRadius.circular(10.0),
                                              border: Border.all(
                                                color: const Color(0xFF81C784),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.auto_awesome,
                                                          color: Color(0xFF2E7D32),
                                                          size: 20.0,
                                                        ),
                                                        const SizedBox(width: 8.0),
                                                        Text(
                                                          'AI Waste Classification',
                                                          style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14.0,
                                                            color: const Color(0xFF1B5E20),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 8.0, vertical: 3.0),
                                                      decoration: BoxDecoration(
                                                        color: containerImageRow.status == 'Verified'
                                                            ? const Color(0xFF2E7D32)
                                                            : const Color(0xFFE65100),
                                                        borderRadius: BorderRadius.circular(6.0),
                                                      ),
                                                      child: Text(
                                                        containerImageRow.status == 'Verified'
                                                            ? 'Verified'
                                                            : 'Non-Verified',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  feedbackText,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xFF2E7D32),
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
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
                                      if (!isAdmin)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context).alternate,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Classification Summary',
                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                      font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                                                      letterSpacing: 0.0,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                                    decoration: BoxDecoration(
                                                      color: containerImageRow.isSegregated == true
                                                          ? const Color(0xFF2E7D32)
                                                          : const Color(0xFFC62828),
                                                      borderRadius: BorderRadius.circular(6.0),
                                                    ),
                                                    child: Text(
                                                      containerImageRow.isSegregated == true ? 'Segregated' : 'Not Segregated',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),
                                              Wrap(
                                                spacing: 6.0,
                                                runSpacing: 4.0,
                                                children: [
                                                  if (containerImageRow.categoryRecycling == true)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFF1976D2),
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: const Text('Recyclable', style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w600)),
                                                    ),
                                                  if (containerImageRow.categoryBiode == true)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFF388E3C),
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: const Text('Biodegradable', style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w600)),
                                                    ),
                                                  if (containerImageRow.categoryNonbiode == true)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFE65100),
                                                        borderRadius: BorderRadius.circular(4.0),
                                                      ),
                                                      child: const Text('Non-Biodegradable', style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w600)),
                                                    ),
                                                ],
                                              ),
                                              if (containerImageRow.remark != null && containerImageRow.remark!.isNotEmpty) ...[
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  'Official Remarks:',
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                                const SizedBox(height: 3.0),
                                                Text(
                                                  containerImageRow.remark!,
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.inter(fontStyle: FontStyle.italic),
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      if (isAdmin)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Text(
                                            'Official Double-Check & Adjustments',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                      if (isAdmin)
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
                                                      value: _model.switchIsSegregatedValue ??= containerImageRow?.isSegregated ?? false,
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
                                                      value: _model.checkboxRecyclingValue ??= containerImageRow?.categoryRecycling ?? false,
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
                                                      value: _model.checkboxBiodeValue ??= containerImageRow?.categoryBiode ?? false,
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
                                                      value: _model.checkboxNonbiodeValue1 ??= containerImageRow?.categoryNonbiode ?? false,
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
                                              enabled: isAdmin &&
                                                  containerImageRow?.status !=
                                                      'Verified',
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
                                                hintText: containerImageRow?.status == 'Verified' ? 'Remarks locked (Record is Verified)' : 'Leave a remark..',
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
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
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
                                                fillColor: (isAdmin &&
                                                        containerImageRow
                                                                ?.status !=
                                                            'Verified')
                                                    ? Colors.white
                                                    : const Color(0xFFF1F4F8),
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
                                                            if (isAdmin || (containerImageRow.imgUploader == currentUserUid && containerImageRow.status != 'Verified'))
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
                                                                                rowUserSubtableRow,
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
                                                            if (isAdmin)
                                                                FFButtonWidget(
                                                                  onPressed: () async {
                                                                    final finalSegregated = _model.switchIsSegregatedValue ??
                                                                        containerImageRow.isSegregated ??
                                                                        false;
                                                                    final finalRecycling = _model.checkboxRecyclingValue ??
                                                                        containerImageRow.categoryRecycling ??
                                                                        false;
                                                                    final finalBiode = _model.checkboxBiodeValue ??
                                                                        containerImageRow.categoryBiode ??
                                                                        false;
                                                                    final finalNonBiode = _model.checkboxNonbiodeValue1 ??
                                                                        containerImageRow.categoryNonbiode ??
                                                                        false;
                                                                    final finalRemark = _model.textFieldRemarksTextController?.text.isNotEmpty == true
                                                                        ? _model.textFieldRemarksTextController!.text
                                                                        : 'Verified by official';

                                                                    // 1. Calculate Audit Latency & Agreement
                                                                    final elapsedSeconds = DateTime.now()
                                                                        .difference(_model.auditOpenTimestamp ?? DateTime.now())
                                                                        .inMilliseconds / 1000.0;

                                                                    final isAgreement = (finalSegregated == (containerImageRow.isSegregated ?? false)) &&
                                                                        (finalRecycling == (containerImageRow.categoryRecycling ?? false)) &&
                                                                        (finalBiode == (containerImageRow.categoryBiode ?? false)) &&
                                                                        (finalNonBiode == (containerImageRow.categoryNonbiode ?? false));
                                                                    final verStatus = isAgreement ? 'verified' : 'corrected';

                                                                    final adminTypes = <String>[];
                                                                    if (finalRecycling) adminTypes.add('Recyclable');
                                                                    if (finalBiode) adminTypes.add('Biodegradable');
                                                                    if (finalNonBiode) adminTypes.add('Non-Biodegradable');
                                                                    final adminWasteTypeStr = adminTypes.isNotEmpty ? adminTypes.join(', ') : 'Unidentified';

                                                                    // Update Image record to Verified
                                                                    await ImageTable().update(
                                                                      data: {
                                                                        'status': 'Verified',
                                                                        'verification_status': verStatus,
                                                                        'admin_id': currentUserUid,
                                                                        'admin_classification': finalSegregated ? 'Segregated' : 'Unsegregated',
                                                                        'admin_waste_type': adminWasteTypeStr,
                                                                        'verification_time_seconds': elapsedSeconds,
                                                                        'verified_at': DateTime.now().toUtc().toIso8601String(),
                                                                        'remark': finalRemark,
                                                                        'updated_by': currentUserUid,
                                                                        'updated_at': DateTime.now().toIso8601String(),
                                                                        'allowFlagging': false,
                                                                        'isSegregated': finalSegregated,
                                                                        'category_recycling': finalRecycling,
                                                                        'category_biode': finalBiode,
                                                                        'category_nonbiode': finalNonBiode,
                                                                      },
                                                                      matchingRows: (rows) => rows.eqOrNull(
                                                                        'image_id',
                                                                        containerImageRow.imageId,
                                                                      ),
                                                                    );

                                                                    // 2. Gamification points handling
                                                                    if (finalSegregated && rowUserSubtableRow != null) {
                                                                      int activeCount = 0;
                                                                      if (finalRecycling) activeCount++;
                                                                      if (finalBiode) activeCount++;
                                                                      if (finalNonBiode) activeCount++;

                                                                      int pts = 25;
                                                                      if (activeCount >= 3) {
                                                                        pts = 100;
                                                                      } else if (activeCount == 2) {
                                                                        pts = 50;
                                                                      }

                                                                      await UserSubtableTable().update(
                                                                        data: {
                                                                          'user_points': functions.plusPoints(
                                                                            rowUserSubtableRow.userPoints ?? 0,
                                                                            pts,
                                                                          ),
                                                                          'notification': false,
                                                                          'updated_at': DateTime.now().toIso8601String(),
                                                                        },
                                                                        matchingRows: (rows) => rows.eqOrNull(
                                                                          'user_idRef',
                                                                          containerImageRow.imgUploader,
                                                                        ),
                                                                      );
                                                                    } else if (!finalSegregated && rowUserSubtableRow != null) {
                                                                      await UserSubtableTable().update(
                                                                        data: {
                                                                          'notification': true,
                                                                          'updated_at': DateTime.now().toIso8601String(),
                                                                        },
                                                                        matchingRows: (rows) => rows.eqOrNull(
                                                                          'user_idRef',
                                                                          containerImageRow.imgUploader,
                                                                        ),
                                                                      );
                                                                    }

                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      const SnackBar(
                                                                        content: Text('Waste verified successfully! Moved to Verified list.'),
                                                                        backgroundColor: Color(0xFF2E7D32),
                                                                        duration: Duration(seconds: 2),
                                                                      ),
                                                                    );

                                                                    context.safePop();
                                                                  },
                                                                  text: containerImageRow.status == 'Verified' ? 'Update' : 'Verify',
                                                                  icon: Icon(
                                                                    containerImageRow.status == 'Verified'
                                                                        ? Icons.check_circle_outline
                                                                        : Icons.verified_rounded,
                                                                    size: 22.0,
                                                                  ),
                                                                  options: FFButtonOptions(
                                                                    height: 50.0,
                                                                    padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                                                                    color: const Color(0xFF2E7D32),
                                                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                      font: GoogleFonts.interTight(
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                      color: Colors.white,
                                                                      letterSpacing: 0.0,
                                                                    ),
                                                                    elevation: 2.0,
                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                  ),
                                                                )
,
                                                            if (isAdmin)
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
                                                              text: 'Re-scan',
                                                              icon: Icon(
                                                                Icons.document_scanner_outlined,
                                                                size: 22.0,
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
                                                            if (!isAdmin)
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                                                decoration: BoxDecoration(
                                                                  color: containerImageRow.status == 'Verified'
                                                                      ? const Color(0xFFE8F5E9)
                                                                      : const Color(0xFFFFF3E0),
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  border: Border.all(
                                                                    color: containerImageRow.status == 'Verified'
                                                                        ? const Color(0xFF81C784)
                                                                        : const Color(0xFFFFB74D),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Icon(
                                                                      containerImageRow.status == 'Verified'
                                                                          ? Icons.verified
                                                                          : Icons.hourglass_top,
                                                                      size: 16.0,
                                                                      color: containerImageRow.status == 'Verified'
                                                                          ? const Color(0xFF2E7D32)
                                                                          : const Color(0xFFE65100),
                                                                    ),
                                                                    const SizedBox(width: 4.0),
                                                                    Text(
                                                                      containerImageRow.status == 'Verified'
                                                                          ? 'Status: Verified'
                                                                          : 'Status: Pending Verification',
                                                                      style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: containerImageRow.status == 'Verified'
                                                                            ? const Color(0xFF2E7D32)
                                                                            : const Color(0xFFE65100),
                                                                      ),
                                                                    ),
                                                                  ],
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
              Align(
                alignment: Alignment.bottomCenter,
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'P_Images_ViewAll',
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
