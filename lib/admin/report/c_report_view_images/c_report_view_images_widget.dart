import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_report_view_images_model.dart';
export 'c_report_view_images_model.dart';

class CReportViewImagesWidget extends StatefulWidget {
  const CReportViewImagesWidget({
    super.key,
    required this.reportIDref,
  });

  final ReportRow? reportIDref;

  @override
  State<CReportViewImagesWidget> createState() =>
      _CReportViewImagesWidgetState();
}

class _CReportViewImagesWidgetState extends State<CReportViewImagesWidget> {
  late CReportViewImagesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CReportViewImagesModel());

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
      child: Container(
        width: double.infinity,
        height: 450.0,
        constraints: BoxConstraints(
          minHeight: 225.0,
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
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Divider(
                  thickness: 2.0,
                  indent: 75.0,
                  endIndent: 75.0,
                  color: Colors.black,
                ),
              ),
              Container(
                width: double.infinity,
                height: 375.0,
                decoration: BoxDecoration(),
                child: FutureBuilder<List<ImageRow>>(
                  future: ImageTable().queryRows(
                    queryFn: (q) => q
                        .eqOrNull(
                          'img_streetNameRef',
                          widget!.reportIDref?.reportStreetNameRef,
                        )
                        .eqOrNull(
                          'created_atDate',
                          supaSerialize<DateTime>(
                              widget!.reportIDref?.reportConductedDate),
                        )
                        .order('created_at'),
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
                    List<ImageRow> staggeredViewImageRowList = snapshot.data!;

                    return MasonryGridView.builder(
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      itemCount: staggeredViewImageRowList.length,
                      itemBuilder: (context, staggeredViewIndex) {
                        final staggeredViewImageRow =
                            staggeredViewImageRowList[staggeredViewIndex];
                        return Stack(
                          alignment: AlignmentDirectional(1.0, 1.0),
                          children: [
                            Stack(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    staggeredViewImageRow.imgReferenceLink,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    width: double.infinity,
                                    height: 35.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF6984A9),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
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
                                        dateTimeFormat("Md",
                                            staggeredViewImageRow.createdAt),
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
                                      if (staggeredViewImageRow.status ==
                                          'Uncategorized')
                                        Icon(
                                          Icons.question_mark_rounded,
                                          color: Color(0xFFC44545),
                                          size: 20.0,
                                        ),
                                      if (staggeredViewImageRow.status ==
                                          'Unsegregated')
                                        Icon(
                                          Icons.delete_forever,
                                          color: Color(0xFFC44545),
                                          size: 20.0,
                                        ),
                                      if (staggeredViewImageRow.status ==
                                          'Segregated')
                                        Icon(
                                          Icons.check_circle_outline_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 20.0,
                                        ),
                                      if (staggeredViewImageRow.status ==
                                          'Flagged')
                                        Icon(
                                          Icons.flag_outlined,
                                          color: Color(0xFFFF0000),
                                          size: 20.0,
                                        ),
                                      if (staggeredViewImageRow.status ==
                                          'Verified')
                                        FaIcon(
                                          FontAwesomeIcons.checkDouble,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
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
            ].divide(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}
