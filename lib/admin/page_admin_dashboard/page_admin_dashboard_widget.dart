import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_admin_dashboard_model.dart';
export 'page_admin_dashboard_model.dart';

class PageAdminDashboardWidget extends StatefulWidget {
  const PageAdminDashboardWidget({super.key});

  static String routeName = 'Page_AdminDashboard';
  static String routePath = '/pageAdminDashboard';

  @override
  State<PageAdminDashboardWidget> createState() =>
      _PageAdminDashboardWidgetState();
}

class _PageAdminDashboardWidgetState extends State<PageAdminDashboardWidget> {
  late PageAdminDashboardModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageAdminDashboardModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color badgeBg,
  }) {
    return Expanded(
      child: EBasuraCard(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34.0,
                  height: 34.0,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              value,
              style: GoogleFonts.interTight(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10.0,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiGrid(BuildContext context) {
    return FutureBuilder<List<ImageRow>>(
      future: ImageTable().queryRows(queryFn: (q) => q),
      builder: (context, imageSnap) {
        final allImages = imageSnap.data ?? [];
        final totalScans = allImages.length;
        final verifiedCount =
            allImages.where((i) => i.status == 'Verified').length;
        final pendingCount =
            allImages.where((i) => i.status != 'Verified').length;

        return Column(
          children: [
            Row(
              children: [
                _buildKpiCard(
                  context: context,
                  title: 'Total Scans',
                  value: '$totalScans',
                  subtitle: 'Citizen submissions',
                  icon: Icons.photo_library_rounded,
                  iconColor: FlutterFlowTheme.of(context).accent3,
                  badgeBg: FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.25),
                ),
                const SizedBox(width: 12.0),
                _buildKpiCard(
                  context: context,
                  title: 'Verified Recyclables',
                  value: '$verifiedCount',
                  subtitle: 'Confirmed classifications',
                  icon: Icons.check_circle_rounded,
                  iconColor: FlutterFlowTheme.of(context).ecoPrimary,
                  badgeBg: FlutterFlowTheme.of(context).mintTint,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                _buildKpiCard(
                  context: context,
                  title: 'Pending Moderation',
                  value: '$pendingCount',
                  subtitle: pendingCount > 0 ? 'Requires inspection' : 'Queue clear',
                  icon: Icons.pending_actions_rounded,
                  iconColor: pendingCount > 0
                      ? const Color(0xFFE65100)
                      : FlutterFlowTheme.of(context).ecoPrimary,
                  badgeBg: pendingCount > 0
                      ? const Color(0xFFFFE0B2)
                      : FlutterFlowTheme.of(context).mintTint,
                ),
                const SizedBox(width: 12.0),
                FutureBuilder<List<StreetRow>>(
                  future: StreetTable().queryRows(
                    queryFn: (q) => q.eqOrNull('has_storage', true),
                  ),
                  builder: (context, streetSnap) {
                    final streetCount = streetSnap.data?.length ?? 0;
                    return _buildKpiCard(
                      context: context,
                      title: 'Monitored Streets',
                      value: '$streetCount',
                      subtitle: 'Active waste zones',
                      icon: Icons.signpost_rounded,
                      iconColor: FlutterFlowTheme.of(context).ecoSecondary,
                      badgeBg: FlutterFlowTheme.of(context).mintTint,
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdminActionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    Widget? trailingBadge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: EBasuraCard(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22.0,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingBadge != null) ...[
              const SizedBox(width: 8.0),
              trailingBadge,
            ],
            const SizedBox(width: 6.0),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: FlutterFlowTheme.of(context).accent4,
              size: 14.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationsHub(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Management & Operations',
          style: GoogleFonts.interTight(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        const SizedBox(height: 10.0),
        // Moderation Queue
        FutureBuilder<List<ImageRow>>(
          future: ImageTable().queryRows(
            queryFn: (q) => q.neqOrNull('status', 'Verified'),
          ),
          builder: (context, snap) {
            final count = snap.data?.length ?? 0;
            return _buildAdminActionTile(
              context: context,
              title: 'Waste Verification Queue',
              subtitle: 'Review & verify community waste scan submissions',
              icon: Icons.fact_check_rounded,
              iconColor: FlutterFlowTheme.of(context).accent3,
              trailingBadge: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: count > 0
                      ? const Color(0xFFE65100)
                      : FlutterFlowTheme.of(context).ecoPrimary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  count > 0 ? '$count Pending' : 'Clear',
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () async {
                context.pushNamed(
                  PImagesViewAllWidget.routeName,
                  queryParameters: {
                    'initialTabIndex': serializeParam(0, ParamType.int),
                  }.withoutNulls,
                );
              },
            );
          },
        ),
        const SizedBox(height: 10.0),
        // Schedules Manager
        _buildAdminActionTile(
          context: context,
          title: 'Collection Schedules',
          subtitle: 'Manage pickup timing, routes, and assigned collectors',
          icon: Icons.calendar_month_rounded,
          iconColor: FlutterFlowTheme.of(context).ecoPrimary,
          onTap: () async {
            context.pushNamed(PDatesViewAllWidget.routeName);
          },
        ),
        const SizedBox(height: 10.0),
        // Incident Reports
        _buildAdminActionTile(
          context: context,
          title: 'Waste Incident Reports',
          subtitle: 'Citizen complaints, hazardous spills & overflow alerts',
          icon: Icons.report_problem_rounded,
          iconColor: const Color(0xFFE65100),
          onTap: () async {
            context.pushNamed(PReportViewAllWidget.routeName);
          },
        ),
        const SizedBox(height: 10.0),
        // User & Crew Directory
        _buildAdminActionTile(
          context: context,
          title: 'User & Crew Management',
          subtitle: 'Assign roles, inspect resident profiles & crew accounts',
          icon: Icons.groups_rounded,
          iconColor: FlutterFlowTheme.of(context).accent3,
          onTap: () async {
            context.pushNamed(PageUserManagementWidget.routeName);
          },
        ),
        const SizedBox(height: 10.0),
        // Street Directory
        _buildAdminActionTile(
          context: context,
          title: 'Street & Zone Directory',
          subtitle: 'Configure barangay street boundaries & storage bins',
          icon: Icons.signpost_rounded,
          iconColor: FlutterFlowTheme.of(context).ecoSecondary,
          onTap: () async {
            context.pushNamed(PStreetViewAllWidget.routeName);
          },
        ),
        const SizedBox(height: 10.0),
        // Gamification Badges
        _buildAdminActionTile(
          context: context,
          title: 'Badges & Achievement Rules',
          subtitle: 'Configure eco milestones, point rules & badge rewards',
          icon: Icons.military_tech_rounded,
          iconColor: const Color(0xFFD97706),
          onTap: () async {
            context.pushNamed(PBadgeViewAllWidget.routeName);
          },
        ),
        const SizedBox(height: 10.0),
        // Filtered Image Records
        _buildAdminActionTile(
          context: context,
          title: 'All Image Records Archive',
          subtitle: 'Filter historical waste submissions by category & AI flag',
          icon: Icons.image_search_rounded,
          iconColor: FlutterFlowTheme.of(context).accent4,
          onTap: () async {
            context.pushNamed(PageFilteredImagesWidget.routeName);
          },
        ),
      ],
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
                      title: 'Admin Command Center',
                      subtitle: 'Barangay waste management, moderation queue & field operations',
                      icon: Icons.admin_panel_settings_rounded,
                    ),
                    const SizedBox(height: 16.0),
                    _buildKpiGrid(context),
                    const SizedBox(height: 20.0),
                    _buildOperationsHub(context),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: CBottomBarWidget(activeRoute: 'Page_AdminDashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
