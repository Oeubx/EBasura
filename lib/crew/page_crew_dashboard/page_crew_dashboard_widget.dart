import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_crew_dashboard_model.dart';
export 'page_crew_dashboard_model.dart';

class PageCrewDashboardWidget extends StatefulWidget {
  const PageCrewDashboardWidget({super.key});

  static String routeName = 'Page_CrewDashboard';
  static String routePath = '/pageCrewDashboard';

  @override
  State<PageCrewDashboardWidget> createState() =>
      _PageCrewDashboardWidgetState();
}

class _PageCrewDashboardWidgetState extends State<PageCrewDashboardWidget> {
  late PageCrewDashboardModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _shiftStatus = 'In Progress';
  final Set<String> _collectedStreetIds = {};

  final List<String> _statusOptions = [
    'Idle',
    'En Route',
    'In Progress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageCrewDashboardModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildShiftStatusBar(BuildContext context) {
    return EBasuraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).mintTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping_rounded,
                  color: FlutterFlowTheme.of(context).accent3,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Truck #04 • Field Crew Unit',
                      style: GoogleFonts.interTight(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                    Text(
                      'Barangay Central Collection Route',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).ecoPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  _shiftStatus,
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).ecoPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          Text(
            'Shift Status Selector:',
            style: GoogleFonts.inter(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            children: _statusOptions.map((status) {
              final isSelected = _shiftStatus == status;
              return InkWell(
                onTap: () {
                  safeSetState(() {
                    _shiftStatus = status;
                  });
                },
                borderRadius: BorderRadius.circular(20.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 7.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? FlutterFlowTheme.of(context).accent3
                        : FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: isSelected
                          ? FlutterFlowTheme.of(context).accent3
                          : FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.4),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistSection(BuildContext context) {
    return FutureBuilder<List<CollectionRow>>(
      future: CollectionTable().queryRows(queryFn: (q) => q),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final collections = snapshot.data!;
        final completedCount = _collectedStreetIds.length;
        final totalCount = collections.length;
        final progress = totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Street Collection Checklist',
                  style: GoogleFonts.interTight(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                Text(
                  '$completedCount of $totalCount Done',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).ecoPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).ecoPrimary,
                ),
                minHeight: 8.0,
              ),
            ),
            const SizedBox(height: 12.0),
            ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: collections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10.0),
              itemBuilder: (context, index) {
                final item = collections[index];
                final id = item.collectionId ?? '$index';
                final isCollected = _collectedStreetIds.contains(id);

                return EBasuraCard(
                  padding: const EdgeInsets.all(14.0),
                  backgroundColor: isCollected
                      ? FlutterFlowTheme.of(context).secondaryBackground
                      : Colors.white,
                  borderColor: isCollected
                      ? FlutterFlowTheme.of(context).ecoPrimary.withValues(alpha: 0.4)
                      : FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.collectionStreetNameRef,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  '${item.collectionDay} • ${item.collectionTimeDurationStart} - ${item.collectionTimeDurationEnd}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              safeSetState(() {
                                if (isCollected) {
                                  _collectedStreetIds.remove(id);
                                } else {
                                  _collectedStreetIds.add(id);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(20.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: isCollected
                                    ? FlutterFlowTheme.of(context).ecoPrimary
                                    : FlutterFlowTheme.of(context).mintTint,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isCollected
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: isCollected
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context).accent3,
                                    size: 16.0,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    isCollected ? 'Collected' : 'Mark Done',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold,
                                      color: isCollected
                                          ? Colors.white
                                          : FlutterFlowTheme.of(context).accent3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: EBasuraButton.button4(
                              text: 'Incident / Hazard',
                              icon: const Icon(
                                Icons.report_problem_rounded,
                                size: 16.0,
                              ),
                              height: 34.0,
                              onPressed: () async {
                                context.pushNamed(PReportViewAllWidget.routeName);
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: EBasuraButton.button3(
                              text: 'View Street',
                              icon: const Icon(
                                Icons.signpost_rounded,
                                size: 16.0,
                              ),
                              height: 34.0,
                              onPressed: () async {
                                context.pushNamed(PDatesViewAllWidget.routeName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
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
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CPageHeaderWidget(
                      title: 'Crew Operations',
                      subtitle: 'Field collection dispatch & live street checklist',
                      icon: Icons.local_shipping_rounded,
                    ),
                    const SizedBox(height: 16.0),
                    _buildShiftStatusBar(context),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: EBasuraButton.button2(
                        text: 'Log Verification Scan',
                        icon: const Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        onPressed: () async {
                          context.pushNamed(
                            PImgUploadAAuthWidget.routeName,
                            queryParameters: {
                              'autoTriggerCamera':
                                  serializeParam(true, ParamType.bool),
                            }.withoutNulls,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    _buildChecklistSection(context),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: CBottomBarWidget(activeRoute: 'Page_CrewDashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
