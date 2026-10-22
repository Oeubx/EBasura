import '/admin/report/c_report_view_images/c_report_view_images_widget.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_view_sub_features_model.dart';
export 'page_view_sub_features_model.dart';

class PageViewSubFeaturesWidget extends StatefulWidget {
  const PageViewSubFeaturesWidget({super.key});

  static String routeName = 'Page_ViewSubFeatures';
  static String routePath = '/pageViewSubFeatures';

  @override
  State<PageViewSubFeaturesWidget> createState() =>
      _PageViewSubFeaturesWidgetState();
}

class _PageViewSubFeaturesWidgetState extends State<PageViewSubFeaturesWidget>
    with TickerProviderStateMixin {
  late PageViewSubFeaturesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<CollectionRow>>? _collectionsFuture;
  Future<List<ReportRow>>? _reportsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageViewSubFeaturesModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _collectionsFuture = CollectionTable().queryRows(
      queryFn: (q) => q,
    );
    _reportsFuture = ReportTable().queryRows(
      queryFn: (q) => q.order('created_at', ascending: false),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildCollectionsTab(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FutureBuilder<List<CollectionRow>>(
      future: _collectionsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.accent3),
                ),
              ),
            ),
          );
        }

        final collections = snapshot.data!;
        if (collections.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 48.0,
                    color: theme.accent4,
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'No Collections Scheduled',
                    style: GoogleFonts.comfortaa(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'There are currently no active collection schedules.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: theme.accent3,
          onRefresh: () async {
            setState(() {
              _collectionsFuture = CollectionTable().queryRows(
                queryFn: (q) => q,
              );
            });
            await _collectionsFuture;
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 120.0,
            ),
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final item = collections[index];
              return _buildCollectionCard(context, item);
            },
          ),
        );
      },
    );
  }

  Widget _buildCollectionCard(BuildContext context, CollectionRow item) {
    final theme = FlutterFlowTheme.of(context);
    final streetName = item.collectionStreetNameRef;
    final day = item.collectionDay;
    final description = item.collectionDescription;
    final startTime = item.collectionTimeDurationStart.time != null
        ? dateTimeFormat("jm", item.collectionTimeDurationStart.time)
        : '';
    final endTime = item.collectionTimeDurationEnd.time != null
        ? dateTimeFormat("jm", item.collectionTimeDurationEnd.time)
        : '';
    final timeRange = (startTime.isNotEmpty && endTime.isNotEmpty)
        ? '$startTime - $endTime'
        : (startTime.isNotEmpty ? startTime : 'All day');

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 20.0,
                  color: theme.accent3,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14.0,
                          color: Color(0xFF31A11F),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          timeRange,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF31A11F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  day,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF013448),
                  ),
                ),
              ),
            ],
          ),
          if (description != null && description.trim().isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: const Color(0xFF475569),
                height: 1.35,
              ),
            ),
          ],
          if (item.lastUpdatedTime != null) ...[
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  size: 13.0,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Updated ${dateTimeFormat("relative", item.lastUpdatedTime)}',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportsTab(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FutureBuilder<List<ReportRow>>(
      future: _reportsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.accent3),
                ),
              ),
            ),
          );
        }

        final reports = snapshot.data!;
        if (reports.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 48.0,
                    color: theme.accent4,
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'No Reports Filed',
                    style: GoogleFonts.comfortaa(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'No waste audit reports have been conducted yet.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: theme.accent3,
          onRefresh: () async {
            setState(() {
              _reportsFuture = ReportTable().queryRows(
                queryFn: (q) => q.order('created_at', ascending: false),
              );
            });
            await _reportsFuture;
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 120.0,
            ),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final item = reports[index];
              return _buildReportCard(context, item);
            },
          ),
        );
      },
    );
  }

  Widget _buildReportCard(BuildContext context, ReportRow item) {
    final theme = FlutterFlowTheme.of(context);
    final streetName = item.reportStreetNameRef;
    final conductedDate = dateTimeFormat("yMd", item.reportConductedDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1F8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(
                  Icons.assignment_rounded,
                  size: 20.0,
                  color: theme.accent3,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 13.0,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          conductedDate,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (modalContext) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(modalContext).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(modalContext),
                          child: CReportViewImagesWidget(
                            reportIDref: item,
                          ),
                        ),
                      );
                    },
                  );
                  safeSetState(() {});
                },
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: theme.accent3,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library_rounded,
                        size: 14.0,
                        color: theme.accent3,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Photos',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: theme.accent3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(
              height: 1.0,
              thickness: 1.0,
              color: Color(0xFFF1F5F9),
            ),
          ),
          _ReportImageSummaryWidget(
            streetName: item.reportStreetNameRef,
            conductedDate: item.reportConductedDate,
          ),
        ],
      ),
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/Horizontal_Logo.png',
                          height: 38.0,
                          fit: BoxFit.contain,
                        ),
                        if (Navigator.of(context).canPop())
                          FlutterFlowIconButton(
                            borderColor: theme.accent4.withValues(alpha: 0.35),
                            borderRadius: 20.0,
                            buttonSize: 38.0,
                            fillColor: Colors.white,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: theme.primaryText,
                              size: 20.0,
                            ),
                            onPressed: () async => context.safePop(),
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CPageHeaderWidget(
                      title: 'Community Hub',
                      subtitle:
                          'Explore collection schedules & street waste reports',
                      icon: Icons.explore_rounded,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: theme.accent4.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      child: TabBar(
                        controller: _model.tabBarController,
                        indicator: BoxDecoration(
                          color: theme.accent3,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        labelStyle: GoogleFonts.inter(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700,
                        ),
                        unselectedLabelColor: const Color(0xFF64748B),
                        unselectedLabelStyle: GoogleFonts.inter(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(
                            icon:
                                Icon(Icons.calendar_month_rounded, size: 18.0),
                            text: 'Collections',
                          ),
                          Tab(
                            icon: Icon(Icons.assignment_rounded, size: 18.0),
                            text: 'Reports',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _model.tabBarController,
                      children: [
                        _buildCollectionsTab(context),
                        _buildReportsTab(context),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_ViewSubFeatures',
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

class _ReportImageSummaryWidget extends StatelessWidget {
  const _ReportImageSummaryWidget({
    required this.streetName,
    required this.conductedDate,
  });

  final String? streetName;
  final DateTime? conductedDate;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return FutureBuilder<List<ImageRow>>(
      future: ImageTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('img_streetNameRef', streetName)
            .eqOrNull('created_atDate', supaSerialize<DateTime>(conductedDate)),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.accent3),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Loading image metrics...',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          );
        }

        final images = snapshot.data!;
        final totalCount = images.length;
        final uncategorizedCount =
            images.where((img) => img.status == 'Uncategorized').length;
        final unsegregatedCount =
            images.where((img) => img.status == 'Unsegregated').length;
        final segregatedCount =
            images.where((img) => img.status == 'Segregated').length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatChip(
              icon: Icons.photo_library_outlined,
              label: 'Total',
              count: totalCount,
              color: const Color(0xFF2E78A6),
              bgColor: const Color(0xFFE8F1F8),
            ),
            _buildStatChip(
              icon: Icons.help_outline_rounded,
              label: 'Pending',
              count: uncategorizedCount,
              color: const Color(0xFFD97706),
              bgColor: const Color(0xFFFEF3C7),
            ),
            _buildStatChip(
              icon: Icons.cancel_outlined,
              label: 'Unseg',
              count: unsegregatedCount,
              color: const Color(0xFFDC2626),
              bgColor: const Color(0xFFFEE2E2),
            ),
            _buildStatChip(
              icon: Icons.check_circle_outline_rounded,
              label: 'Seg',
              count: segregatedCount,
              color: const Color(0xFF31A11F),
              bgColor: const Color(0xFFD5F2E2),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.0, color: color),
          const SizedBox(width: 4.0),
          Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 2.0),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
