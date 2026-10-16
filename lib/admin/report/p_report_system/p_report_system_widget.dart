import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_report_system_model.dart';
export 'p_report_system_model.dart';

class _StreetReportSummary {
  final String streetName;
  final String? streetId;
  final int totalImages;
  final int nonVerifiedImages;
  final int verifiedImages;
  final int uploadsToday;
  final int uploadsLastHour;
  final String lastUpdatedBy;
  final DateTime? lastUpdatedTime;

  const _StreetReportSummary({
    required this.streetName,
    this.streetId,
    required this.totalImages,
    required this.nonVerifiedImages,
    required this.verifiedImages,
    required this.uploadsToday,
    required this.uploadsLastHour,
    required this.lastUpdatedBy,
    this.lastUpdatedTime,
  });
}

class PReportSystemWidget extends StatefulWidget {
  const PReportSystemWidget({super.key});

  static String routeName = 'P_Report_System';
  static String routePath = '/pReportSystem';

  @override
  State<PReportSystemWidget> createState() => _PReportSystemWidgetState();
}

class _PReportSystemWidgetState extends State<PReportSystemWidget> {
  late PReportSystemModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PReportSystemModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  List<_StreetReportSummary> _buildSummaries({
    required List<StreetRow> streets,
    required List<ImageRow> images,
  }) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    // Collect all unique street names from both StreetTable and ImageTable (case-insensitively)
    final Map<String, StreetRow?> streetMap = {};
    for (final s in streets) {
      final trimmed = s.streetName.trim();
      if (trimmed.isNotEmpty) {
        streetMap[trimmed] = s;
      }
    }
    for (final img in images) {
      final name = img.imgStreetNameRef.trim();
      if (name.isNotEmpty &&
          !streetMap.keys.any((k) => k.toLowerCase() == name.toLowerCase())) {
        streetMap[name] = null;
      }
    }

    final List<_StreetReportSummary> summaries = [];

    for (final entry in streetMap.entries) {
      final streetName = entry.key;
      final streetRow = entry.value;

      final streetImages = images
          .where((img) =>
              img.imgStreetNameRef.trim().toLowerCase() ==
              streetName.toLowerCase())
          .toList();

      final totalImages = streetImages.length;
      final verifiedImages =
          streetImages.where((img) => img.status == 'Verified').length;
      final nonVerifiedImages = totalImages - verifiedImages;

      final uploadsToday = streetImages
          .where((img) => img.createdAt.isAfter(startOfToday))
          .length;
      final uploadsLastHour = streetImages
          .where((img) => img.createdAt.isAfter(oneHourAgo))
          .length;

      // Determine latest updated by and timestamp
      streetImages.sort((a, b) {
        final dateA = a.updatedAt ?? a.createdAt;
        final dateB = b.updatedAt ?? b.createdAt;
        return dateB.compareTo(dateA);
      });

      String lastUpdatedBy = 'No updates yet';
      DateTime? lastUpdatedTime;

      if (streetImages.isNotEmpty) {
        final latestImg = streetImages.first;
        if (latestImg.updatedBy != null && latestImg.updatedBy!.isNotEmpty) {
          lastUpdatedBy = latestImg.updatedBy!;
        } else if (streetRow?.lastUpdatedBy != null &&
            streetRow!.lastUpdatedBy!.isNotEmpty) {
          lastUpdatedBy = streetRow.lastUpdatedBy!;
        } else if (latestImg.imgUploader.isNotEmpty) {
          lastUpdatedBy = latestImg.imgUploader;
        }
        lastUpdatedTime = latestImg.updatedAt ?? latestImg.createdAt;
      } else if (streetRow != null) {
        if (streetRow.lastUpdatedBy != null &&
            streetRow.lastUpdatedBy!.isNotEmpty) {
          lastUpdatedBy = streetRow.lastUpdatedBy!;
        }
        lastUpdatedTime = streetRow.lastUpdatedTime ?? streetRow.createdAt;
      }

      summaries.add(
        _StreetReportSummary(
          streetName: streetName,
          streetId: streetRow?.streetId,
          totalImages: totalImages,
          nonVerifiedImages: nonVerifiedImages,
          verifiedImages: verifiedImages,
          uploadsToday: uploadsToday,
          uploadsLastHour: uploadsLastHour,
          lastUpdatedBy: lastUpdatedBy,
          lastUpdatedTime: lastUpdatedTime,
        ),
      );
    }

    // Sort based on active sort mode
    if (_model.sortBy == 'Pending First') {
      summaries.sort(
          (a, b) => b.nonVerifiedImages.compareTo(a.nonVerifiedImages));
    } else if (_model.sortBy == 'Most Uploads') {
      summaries.sort((a, b) => b.totalImages.compareTo(a.totalImages));
    } else {
      summaries.sort((a, b) => a.streetName.compareTo(b.streetName));
    }
    return summaries;
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
                width: double.infinity,
                height: double.infinity,
                color: FlutterFlowTheme.of(context).primaryBackground,
                child: RefreshIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                  onRefresh: () async {
                    safeSetState(() {});
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 110.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with EBasura Brand Identity
                      const CPageHeaderWidget(
                        title: 'Reports Hub',
                        subtitle: 'Street waste health & collection monitoring',
                        icon: Icons.assessment_rounded,
                      ),
                      const SizedBox(height: 16.0),

                      // FutureBuilder fetching Reports, Streets, and Images
                      FutureBuilder<List<ReportRow>>(
                        future: ReportTable().queryRows(
                          queryFn: (q) => q.order('created_at', ascending: false),
                        ),
                        builder: (context, reportSnapshot) {
                          final totalCreatedReports =
                              reportSnapshot.data?.length ?? 0;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // DISPLAY ABOVE CONTAINER: Hero Banner
                              _buildTopHeroBanner(
                                context: context,
                                totalCreatedReports: totalCreatedReports,
                                isLoadingReports: !reportSnapshot.hasData,
                              ),
                              const SizedBox(height: 18.0),

                              // System Report Filtering by Street & Search Bar
                              _buildFilterBar(context),
                              const SizedBox(height: 16.0),

                              // MAIN CONTAINER: System Street Report Cards
                              FutureBuilder<List<StreetRow>>(
                                future: StreetTable().queryRows(
                                  queryFn: (q) => q.order('street_name'),
                                ),
                                builder: (context, streetSnapshot) {
                                  return FutureBuilder<List<ImageRow>>(
                                    future: ImageTable().queryRows(
                                      queryFn: (q) => q.order('created_at',
                                          ascending: false),
                                    ),
                                    builder: (context, imageSnapshot) {
                                      if (!streetSnapshot.hasData ||
                                          !imageSnapshot.hasData) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(40.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }

                                      final streets =
                                          streetSnapshot.data ?? [];
                                      final images = imageSnapshot.data ?? [];
                                      final summaries = _buildSummaries(
                                        streets: streets,
                                        images: images,
                                      );

                                      // Filter based on search query & dropdown
                                      final filteredSummaries =
                                          summaries.where((s) {
                                        if (_model.selectedStreetFilter !=
                                                'All' &&
                                            s.streetName.toLowerCase() !=
                                                _model.selectedStreetFilter
                                                    .toLowerCase()) {
                                          return false;
                                        }
                                        if (_model.searchQuery.isNotEmpty) {
                                          final q = _model.searchQuery
                                              .toLowerCase();
                                          if (!s.streetName
                                              .toLowerCase()
                                              .contains(q)) {
                                            return false;
                                          }
                                        }
                                        return true;
                                      }).toList();

                                      if (filteredSummaries.isEmpty) {
                                        return _buildEmptyState(context);
                                      }

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: filteredSummaries.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 14.0),
                                        itemBuilder: (context, index) {
                                          final item =
                                              filteredSummaries[index];
                                          return _buildStreetReportCard(
                                            context: context,
                                            summary: item,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
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

  /// Top display banner above container with Total Created Reports & VIEW REPORTS > button
  Widget _buildTopHeroBanner({
    required BuildContext context,
    required int totalCreatedReports,
    required bool isLoadingReports,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Count of Total Created Reports
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent3.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.folder_shared_rounded,
                        color: FlutterFlowTheme.of(context).accent3,
                        size: 16.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'TOTAL CREATED REPORTS',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                isLoadingReports
                    ? const SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$totalCreatedReports',
                            style: GoogleFonts.interTight(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            totalCreatedReports == 1 ? 'Report' : 'Reports',
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),

          // Right: VIEW REPORTS > Button (Button 2 Style: #2E78A6 solid with white text)
          EBasuraButton.button2(
            width: 155.0,
            height: 42.0,
            text: 'VIEW REPORTS >',
            onPressed: () async {
              context.pushNamed(PReportViewAllWidget.routeName);
            },
          ),
        ],
      ),
    );
  }

  /// Search and street filter controls
  Widget _buildFilterBar(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Search Input
            Expanded(
              child: Container(
                height: 44.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: theme.accent4.withValues(alpha: 0.5),
                    width: 1.0,
                  ),
                  boxShadow: [
                    theme.designToken.shadow.sm,
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: theme.secondaryText,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _model.searchController,
                        focusNode: _model.searchFocusNode,
                        onChanged: (val) {
                          safeSetState(() {
                            _model.searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Filter by street name...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.0,
                            color: theme.secondaryText,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    if (_model.searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          safeSetState(() {
                            _model.searchController?.clear();
                            _model.searchQuery = '';
                          });
                        },
                        child: Icon(
                          Icons.clear_rounded,
                          size: 18.0,
                          color: theme.secondaryText,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10.0),

            // Street Dropdown Filter
            FutureBuilder<List<StreetRow>>(
              future: StreetTable().queryRows(
                queryFn: (q) => q.order('street_name'),
              ),
              builder: (context, snapshot) {
                final streetNames = ['All'];
                if (snapshot.hasData && snapshot.data != null) {
                  streetNames.addAll(
                    snapshot.data!
                        .map((s) => s.streetName.trim())
                        .where((s) => s.isNotEmpty)
                        .toSet()
                        .toList(),
                  );
                }

                return Container(
                  height: 44.0,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: theme.accent4.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                    boxShadow: [
                      theme.designToken.shadow.sm,
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: streetNames.contains(_model.selectedStreetFilter)
                          ? _model.selectedStreetFilter
                          : 'All',
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: theme.secondaryText,
                        size: 20.0,
                      ),
                      items: streetNames.map((name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(
                            name == 'All' ? 'All Streets' : name,
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: theme.primaryText,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          safeSetState(() {
                            _model.selectedStreetFilter = val;
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSortChip(
                context: context,
                label: 'A-Z (Alphabetical)',
                sortKey: 'Alphabetical',
              ),
              const SizedBox(width: 8.0),
              _buildSortChip(
                context: context,
                label: 'Pending Moderation First',
                sortKey: 'Pending First',
              ),
              const SizedBox(width: 8.0),
              _buildSortChip(
                context: context,
                label: 'Most Uploads',
                sortKey: 'Most Uploads',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortChip({
    required BuildContext context,
    required String label,
    required String sortKey,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final isSelected = _model.sortBy == sortKey;
    return InkWell(
      onTap: () {
        safeSetState(() {
          _model.sortBy = sortKey;
        });
      },
      borderRadius: BorderRadius.circular(20.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: isSelected ? theme.accent3 : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected
                ? theme.accent3
                : theme.accent4.withValues(alpha: 0.5),
            width: 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.accent3.withValues(alpha: 0.25),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : theme.secondaryText,
          ),
        ),
      ),
    );
  }

  /// Main container single street system report card
  Widget _buildStreetReportCard({
    required BuildContext context,
    required _StreetReportSummary summary,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final formattedTime = summary.lastUpdatedTime != null
        ? dateTimeFormat('relative', summary.lastUpdatedTime)
        : 'Never';

    return EBasuraCard(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. STREET NAME (leftmost) & TOTAL COUNT OF IMG UPLOADED (rightmost)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.place_rounded,
                        color: theme.accent3,
                        size: 18.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        summary.streetName,
                        style: GoogleFonts.interTight(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.accent4.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: theme.accent4.withValues(alpha: 0.7),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo_library_rounded,
                      color: theme.accent3,
                      size: 14.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      '${summary.totalImages} Imgs',
                      style: GoogleFonts.interTight(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: theme.accent3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // 2. COUNT OF NON-VERIFIED IMG & COUNT OF VERIFIED IMG
          Row(
            children: [
              // Non-Verified Tally Container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: const Color(0xFFF8B4B4),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF05252).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.pending_actions_rounded,
                          color: Color(0xFFC44545),
                          size: 18.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${summary.nonVerifiedImages}',
                              style: GoogleFonts.interTight(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFC44545),
                              ),
                            ),
                            Text(
                              'Non-Verified',
                              style: GoogleFonts.inter(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8A2B2B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10.0),

              // Verified Tally Container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: theme.ecoPrimary.withValues(alpha: 0.4),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: theme.ecoPrimary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_rounded,
                          color: theme.ecoPrimary,
                          size: 18.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${summary.verifiedImages}',
                              style: GoogleFonts.interTight(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: theme.ecoPrimary,
                              ),
                            ),
                            Text(
                              'Verified',
                              style: GoogleFonts.inter(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B6A12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // 3. Upload Velocity (Per Day / Per Hour)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: theme.accent4.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: theme.accent3,
                  size: 16.0,
                ),
                const SizedBox(width: 6.0),
                Expanded(
                  child: Text(
                    'Uploads Today: ${summary.uploadsToday}  •  Past hour: ${summary.uploadsLastHour}',
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: theme.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),

          // 4. Last Updated By & Last Updated Time
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14.0,
                color: theme.secondaryText,
              ),
              const SizedBox(width: 5.0),
              Expanded(
                child: Text(
                  'Last updated by: ${summary.lastUpdatedBy}  ($formattedTime)',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: theme.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),

          // 5. VIEW ALL BUTTON: Deep link to PImagesViewAllWidget pre-filtered to street & Non-Verified
          EBasuraButton.button3(
            width: double.infinity,
            height: 40.0,
            text: 'VIEW ALL',
            iconData: Icons.open_in_new_rounded,
            onPressed: () async {
              context.pushNamed(
                PImagesViewAllWidget.routeName,
                queryParameters: {
                  'initialTabIndex': serializeParam(0, ParamType.int),
                  'initialStatus':
                      serializeParam('Non-Verified', ParamType.String),
                  'initialStreet':
                      serializeParam(summary.streetName, ParamType.String),
                }.withoutNulls,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Empty state when no street matches search filter
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 48.0,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'No streets found',
              style: FlutterFlowTheme.of(context).titleMedium,
            ),
            const SizedBox(height: 4.0),
            Text(
              'Try clearing your street search filter.',
              style: FlutterFlowTheme.of(context).labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
