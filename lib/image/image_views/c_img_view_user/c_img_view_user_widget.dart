import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_img_view_user_model.dart';
export 'c_img_view_user_model.dart';

class CImgViewUserWidget extends StatefulWidget {
  const CImgViewUserWidget({
    super.key,
    required this.imageIDref,
  });

  final ImageRow? imageIDref;

  @override
  State<CImgViewUserWidget> createState() => _CImgViewUserWidgetState();
}

class _CImgViewUserWidgetState extends State<CImgViewUserWidget> {
  late CImgViewUserModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CImgViewUserModel());

    _model.expandableExpandableController =
        ExpandableController(initialExpanded: false)
          ..addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: StreamBuilder<List<ImageRow>>(
        stream: _model.containerSupabaseStream ??= SupaFlow.client
            .from("Image")
            .stream(primaryKey: ['image_id'])
            .eqOrNull(
              'image_id',
              widget!.imageIDref?.imageId,
            )
            .map((list) => list.map((item) => ImageRow(item)).toList()),
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
          List<ImageRow> containerImageRowList = snapshot.data!;

          final containerImageRow = containerImageRowList.isNotEmpty
              ? containerImageRowList.first
              : null;

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: 500.0,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFE8EDF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        if ((containerImageRow?.allowFlagging == true) &&
                            (containerImageRow?.status != 'Flagged'))
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.black,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('Informational Dialog'),
                                      content: Text(
                                          'Press the Red Flag Icon if the image verification seems wrong.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            icon: Icon(
                              Icons.close_outlined,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: AlignmentDirectional(1.0, 1.0),
                      children: [
                        Stack(
                          alignment: AlignmentDirectional(0.0, 1.0),
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                containerImageRow!.imgReferenceLink,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Container(
                                width: double.infinity,
                                height: 85.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF6984A9),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
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
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FutureBuilder<List<UserRow>>(
                                    future: UserTable().querySingleRow(
                                      queryFn: (q) => q.eqOrNull(
                                        'user_id',
                                        containerImageRow?.imgUploader,
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

                                      final rowUserRow =
                                          rowUserRowList.isNotEmpty
                                              ? rowUserRowList.first
                                              : null;

                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 25.0,
                                          ),
                                          Text(
                                            valueOrDefault<String>(
                                              rowUserRow?.userName,
                                              '>user_name',
                                            ),
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
                                                  color: Colors.white,
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
                                        ].divide(SizedBox(width: 5.0)),
                                      );
                                    },
                                  ),
                                  if ((containerImageRow?.allowFlagging ==
                                          true) &&
                                      (containerImageRow?.status != 'Flagged'))
                                    Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: FlutterFlowIconButton(
                                        borderRadius: 8.0,
                                        buttonSize: 40.0,
                                        icon: Icon(
                                          Icons.flag_circle,
                                          color: Color(0xFFFF000E),
                                          size: 25.0,
                                        ),
                                        onPressed: () async {
                                          await ImageTable().update(
                                            data: {
                                              'status': 'Flagged',
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'image_id',
                                              containerImageRow?.imageId,
                                            ),
                                          );
                                          safeSetState(() {});
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.clock,
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      Text(
                                        dateTimeFormat(
                                            "Md", containerImageRow!.createdAt),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 5.0)),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (containerImageRow?.status ==
                                          'Uncategorized')
                                        Icon(
                                          Icons.question_mark_rounded,
                                          color: Color(0xFFFF0000),
                                          size: 20.0,
                                        ),
                                      if (containerImageRow?.status ==
                                          'Categorized by Ai')
                                        Icon(
                                          Icons.android,
                                          color: Color(0xFFC44545),
                                          size: 20.0,
                                        ),
                                      if (containerImageRow?.status ==
                                          'Unsegregated')
                                        Icon(
                                          Icons.delete_forever,
                                          color: Color(0xFFFF0000),
                                          size: 20.0,
                                        ),
                                      if (containerImageRow?.status ==
                                          'Segregated')
                                        Icon(
                                          Icons.check_circle_outline_sharp,
                                          color: Color(0xFF468432),
                                          size: 20.0,
                                        ),
                                      if (containerImageRow?.status ==
                                          'Flagged')
                                        Icon(
                                          Icons.flag_outlined,
                                          color: Color(0xFFFF0000),
                                          size: 20.0,
                                        ),
                                      if (containerImageRow?.status ==
                                          'Verified')
                                        FaIcon(
                                          FontAwesomeIcons.checkDouble,
                                          color: Color(0xFF468432),
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
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Color(0x00000000),
                        child: ExpandableNotifier(
                          controller: _model.expandableExpandableController,
                          child: ExpandablePanel(
                            header: Text(
                              'Image Description',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    color: Colors.black,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            ),
                            collapsed: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'View Image details by expanding this window',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: Color(0x8A000000),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            expanded: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<List<UserRow>>(
                                  future: UserTable().querySingleRow(
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.verified_outlined,
                                              color: Colors.black,
                                              size: 25.0,
                                            ),
                                            Text(
                                              containerImageRow?.updatedBy !=
                                                          null &&
                                                      containerImageRow
                                                              ?.updatedBy !=
                                                          ''
                                                  ? valueOrDefault<String>(
                                                      rowUserRow?.userName,
                                                      'user_name',
                                                    )
                                                  : 'Not yet Verified',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleLarge
                                                  .override(
                                                    font:
                                                        GoogleFonts.interTight(
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
                                                    color: Colors.black,
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
                                          ].divide(SizedBox(width: 5.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.clock,
                                              color: Colors.black,
                                              size: 15.0,
                                            ),
                                            Text(
                                              dateTimeFormat(
                                                  "Md",
                                                  containerImageRow!
                                                      .updatedAt!),
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
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
                                            ),
                                          ].divide(SizedBox(width: 5.0)),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      containerImageRow?.remark != null &&
                                              containerImageRow?.remark != ''
                                          ? containerImageRow?.remark
                                          : 'No remarks',
                                      'No remarks',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .labelLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2.0,
                                  color: Colors.black,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Theme(
                                          data: ThemeData(
                                            checkboxTheme: CheckboxThemeData(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            unselectedWidgetColor: Colors.black,
                                          ),
                                          child: Checkbox(
                                            value: _model
                                                    .checkboxRecyclingValue1 ??=
                                                containerImageRow!
                                                    .isSegregated!,
                                            onChanged: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : (newValue) async {
                                                    safeSetState(() => _model
                                                            .checkboxRecyclingValue1 =
                                                        newValue!);
                                                  },
                                            side: (Colors.black != null)
                                                ? BorderSide(
                                                    width: 2,
                                                    color: Colors.black!,
                                                  )
                                                : null,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            checkColor: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : FlutterFlowTheme.of(context)
                                                    .info,
                                          ),
                                        ),
                                        Text(
                                          'Segregated',
                                          style: FlutterFlowTheme.of(context)
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
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
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
                                            checkboxTheme: CheckboxThemeData(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            unselectedWidgetColor: Colors.black,
                                          ),
                                          child: Checkbox(
                                            value: _model
                                                    .checkboxRecyclingValue2 ??=
                                                containerImageRow!
                                                    .categoryRecycling!,
                                            onChanged: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : (newValue) async {
                                                    safeSetState(() => _model
                                                            .checkboxRecyclingValue2 =
                                                        newValue!);
                                                  },
                                            side: (Colors.black != null)
                                                ? BorderSide(
                                                    width: 2,
                                                    color: Colors.black!,
                                                  )
                                                : null,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            checkColor: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : FlutterFlowTheme.of(context)
                                                    .info,
                                          ),
                                        ),
                                        Text(
                                          'Recyclable',
                                          style: FlutterFlowTheme.of(context)
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
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
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
                                            checkboxTheme: CheckboxThemeData(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            unselectedWidgetColor: Colors.black,
                                          ),
                                          child: Checkbox(
                                            value: _model.checkboxBiodeValue ??=
                                                containerImageRow!
                                                    .categoryBiode!,
                                            onChanged: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : (newValue) async {
                                                    safeSetState(() => _model
                                                            .checkboxBiodeValue =
                                                        newValue!);
                                                  },
                                            side: (Colors.black != null)
                                                ? BorderSide(
                                                    width: 2,
                                                    color: Colors.black!,
                                                  )
                                                : null,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            checkColor: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : FlutterFlowTheme.of(context)
                                                    .info,
                                          ),
                                        ),
                                        Text(
                                          'Biodegradable',
                                          style: FlutterFlowTheme.of(context)
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
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
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
                                            checkboxTheme: CheckboxThemeData(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                            ),
                                            unselectedWidgetColor: Colors.black,
                                          ),
                                          child: Checkbox(
                                            value:
                                                _model.checkboxNonbiodeValue ??=
                                                    containerImageRow!
                                                        .categoryNonbiode!,
                                            onChanged: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : (newValue) async {
                                                    safeSetState(() => _model
                                                            .checkboxNonbiodeValue =
                                                        newValue!);
                                                  },
                                            side: (Colors.black != null)
                                                ? BorderSide(
                                                    width: 2,
                                                    color: Colors.black!,
                                                  )
                                                : null,
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            checkColor: (containerImageRow
                                                        ?.imgUploader ==
                                                    currentUserUid)
                                                ? null
                                                : FlutterFlowTheme.of(context)
                                                    .info,
                                          ),
                                        ),
                                        Text(
                                          'Non-Biodegradable',
                                          style: FlutterFlowTheme.of(context)
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
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ].divide(SizedBox(height: 5.0)),
                                ),
                              ].divide(SizedBox(height: 5.0)),
                            ),
                            theme: ExpandableThemeData(
                              tapHeaderToExpand: true,
                              tapBodyToExpand: false,
                              tapBodyToCollapse: false,
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              hasIcon: true,
                              expandIcon: FontAwesomeIcons.expandAlt,
                              collapseIcon: Icons.close_fullscreen,
                              iconColor: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ].divide(SizedBox(height: 15.0)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
