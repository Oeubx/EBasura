import '/admin/report/c_report_creation/c_report_creation_widget.dart';
import '/admin/report/c_report_view_images/c_report_view_images_widget.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_report_view_all_model.dart';
export 'p_report_view_all_model.dart';

class PReportViewAllWidget extends StatefulWidget {
  const PReportViewAllWidget({super.key});

  static String routeName = 'P_Report_ViewAll';
  static String routePath = '/pReportViewAll';

  @override
  State<PReportViewAllWidget> createState() => _PReportViewAllWidgetState();
}

class _PReportViewAllWidgetState extends State<PReportViewAllWidget> {
  late PReportViewAllModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PReportViewAllModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required Future<List<ImageRow>> future,
  }) {
    return FutureBuilder<List<ImageRow>>(
      future: future,
      builder: (context, snapshot) {
        final count = snapshot.hasData ? snapshot.data!.length : 0;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 15.0),
            const SizedBox(width: 3.0),
            Text(
              '$count',
              style: GoogleFonts.interTight(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 2.0),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              RefreshIndicator(
                color: theme.primary,
                onRefresh: () async {
                  safeSetState(() {});
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 120.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with EBasura Brand Identity & Hub Back Button
                      CPageHeaderWidget(
                        title: 'Collection Reports',
                        subtitle:
                            'Historical waste collection audits & field logs',
                        icon: Icons.summarize_rounded,
                        trailing: InkWell(
                          onTap: () async {
                            if (Navigator.of(context).canPop()) {
                              context.safePop();
                            } else {
                              context.goNamed(PReportSystemWidget.routeName);
                            }
                          },
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: theme.accent4.withValues(alpha: 0.6),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 16.0,
                                  color: theme.primaryText,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Hub',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),

                      // FutureBuilder fetching Collection Reports
                      FutureBuilder<List<ReportRow>>(
                        future: ReportTable().queryRows(
                          queryFn: (q) =>
                              q.order('created_at', ascending: false),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final reportList = snapshot.data ?? [];
                          if (reportList.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.folder_open_rounded,
                                      size: 48.0,
                                      color: theme.secondaryText,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Text(
                                      'No collection reports yet',
                                      style: theme.titleMedium,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Tap the + button to create a report.',
                                      style: theme.labelMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reportList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12.0),
                            itemBuilder: (context, index) {
                              final listViewReportRow = reportList[index];
                              return EBasuraCard(
                                padding: const EdgeInsets.all(16.0),
                                margin: EdgeInsets.zero,
                                onTap: () async {
                                  context.pushNamed(
                                    PReportViewOneWidget.routeName,
                                    queryParameters: {
                                      'reportRef': serializeParam(
                                        listViewReportRow,
                                        ParamType.SupabaseRow,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header: Street Name & Photos Button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 32.0,
                                                height: 32.0,
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme.secondaryBackground,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.location_on_rounded,
                                                  color: theme.accent3,
                                                  size: 18.0,
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      valueOrDefault<String>(
                                                        listViewReportRow
                                                            .reportStreetNameRef,
                                                        'Unassigned Street',
                                                      ),
                                                      style:
                                                          GoogleFonts.interTight(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            theme.primaryText,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'Conducted: ${dateTimeFormat("yMd", listViewReportRow.reportConductedDate)}',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            theme.secondaryText,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        // View Images Thumbnail Button
                                        InkWell(
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child:
                                                        CReportViewImagesWidget(
                                                      reportIDref:
                                                          listViewReportRow,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                              vertical: 6.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme.secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                color: theme.accent4
                                                    .withValues(alpha: 0.7),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.photo_library_rounded,
                                                  color: theme.accent3,
                                                  size: 16.0,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  'Photos',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.accent3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12.0),

                                    // Metrics Row: Total, Uncategorized, Unsegregated, Segregated
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: theme.accent4
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Total Images
                                          _buildMetricItem(
                                            context: context,
                                            icon: Icons.photo_rounded,
                                            color: theme.accent3,
                                            label: 'Total',
                                            future: ImageTable().queryRows(
                                              queryFn: (q) => q
                                                  .eqOrNull(
                                                      'img_streetNameRef',
                                                      listViewReportRow
                                                          .reportStreetNameRef)
                                                  .eqOrNull(
                                                      'created_atDate',
                                                      supaSerialize<DateTime>(
                                                          listViewReportRow
                                                              .reportConductedDate)),
                                            ),
                                          ),
                                          // Uncategorized
                                          _buildMetricItem(
                                            context: context,
                                            icon: Icons.help_outline_rounded,
                                            color: const Color(0xFFC44545),
                                            label: 'Uncat.',
                                            future: ImageTable().queryRows(
                                              queryFn: (q) => q
                                                  .eqOrNull(
                                                      'img_streetNameRef',
                                                      listViewReportRow
                                                          .reportStreetNameRef)
                                                  .eqOrNull(
                                                      'status', 'Uncategorized')
                                                  .eqOrNull(
                                                      'created_atDate',
                                                      supaSerialize<DateTime>(
                                                          listViewReportRow
                                                              .reportConductedDate)),
                                            ),
                                          ),
                                          // Unsegregated
                                          _buildMetricItem(
                                            context: context,
                                            icon: Icons.delete_outline_rounded,
                                            color: const Color(0xFFC44545),
                                            label: 'Unseg.',
                                            future: ImageTable().queryRows(
                                              queryFn: (q) => q
                                                  .eqOrNull(
                                                      'img_streetNameRef',
                                                      listViewReportRow
                                                          .reportStreetNameRef)
                                                  .eqOrNull(
                                                      'status', 'Unsegregated')
                                                  .eqOrNull(
                                                      'created_atDate',
                                                      supaSerialize<DateTime>(
                                                          listViewReportRow
                                                              .reportConductedDate)),
                                            ),
                                          ),
                                          // Segregated
                                          _buildMetricItem(
                                            context: context,
                                            icon: Icons
                                                .check_circle_outline_rounded,
                                            color: theme.ecoPrimary,
                                            label: 'Segregated',
                                            future: ImageTable().queryRows(
                                              queryFn: (q) => q
                                                  .eqOrNull(
                                                      'img_streetNameRef',
                                                      listViewReportRow
                                                          .reportStreetNameRef)
                                                  .eqOrNull(
                                                      'status', 'Segregated')
                                                  .eqOrNull(
                                                      'created_atDate',
                                                      supaSerialize<DateTime>(
                                                          listViewReportRow
                                                              .reportConductedDate)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),

                                    // Description & Remarks
                                    Text(
                                      valueOrDefault<String>(
                                        listViewReportRow.reportDescription,
                                        'No report description provided.',
                                      ),
                                      style: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500,
                                        color: theme.primaryText,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (listViewReportRow.reportRemarks !=
                                            null &&
                                        listViewReportRow.reportRemarks!
                                            .trim()
                                            .isNotEmpty) ...[
                                      const SizedBox(height: 4.0),
                                      Text(
                                        'Remarks: ${listViewReportRow.reportRemarks}',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.0,
                                          fontStyle: FontStyle.italic,
                                          color: theme.secondaryText,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Floating Action Button to Create Report
              Align(
                alignment: const AlignmentDirectional(1.0, 1.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 0.0, 20.0, 95.0),
                  child: FloatingActionButton(
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
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: const CReportCreationWidget(),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    backgroundColor: theme.accent3,
                    elevation: 4.0,
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.post_add_rounded,
                      color: Colors.white,
                      size: 26.0,
                    ),
                  ),
                ),
              ),

              // Bottom Navigation Bar
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_AdminDashboard',
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
