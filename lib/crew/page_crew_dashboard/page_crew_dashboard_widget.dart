import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
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
                      subtitle: 'Field collection dispatch & live route status',
                    ),
                    const SizedBox(height: 16.0),
                    EBasuraCard(
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
                                      'Shift Status: Active',
                                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts: true,
                                          ),
                                    ),
                                    Text(
                                      'Barangay Waste Collection Unit',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Inter',
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            useGoogleFonts: true,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Active route assigned. Tap Pickups in the bottom dock to inspect scheduled collection streets or log verification scans.',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  useGoogleFonts: true,
                                ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: EBasuraButton.button1(
                                  text: 'View Pickups',
                                  icon: const Icon(
                                    Icons.checklist_rounded,
                                    size: 18.0,
                                  ),
                                  onPressed: () async {
                                    context.pushNamed(PDatesViewAllWidget.routeName);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: EBasuraButton.button3(
                                  text: 'Incident Alerts',
                                  icon: const Icon(
                                    Icons.report_problem_rounded,
                                    size: 18.0,
                                  ),
                                  onPressed: () async {
                                    context.pushNamed(PReportViewAllWidget.routeName);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
