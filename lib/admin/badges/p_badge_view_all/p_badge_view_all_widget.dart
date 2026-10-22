import '/admin/badges/c_badges_creation/c_badges_creation_widget.dart';
import '/admin/badges/p_badge_view_one/p_badge_view_one_widget.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_badge_view_all_model.dart';
export 'p_badge_view_all_model.dart';

class PBadgeViewAllWidget extends StatefulWidget {
  const PBadgeViewAllWidget({super.key});

  static String routeName = 'P_Badge_ViewAll';
  static String routePath = '/pBadgeViewAll';

  @override
  State<PBadgeViewAllWidget> createState() => _PBadgeViewAllWidgetState();
}

class _PBadgeViewAllWidgetState extends State<PBadgeViewAllWidget> {
  late PBadgeViewAllModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<BadgeRow>>? _badgesFuture;
  final Map<String, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PBadgeViewAllModel());
    _badgesFuture = _loadBadges();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<List<BadgeRow>> _loadBadges() async {
    final badges = await BadgeTable().queryRows(
      queryFn: (q) => q
          .order('badge_level', ascending: true)
          .order('badge_minPts', ascending: true),
    );

    // Batch fetch user names for updated_by to eliminate N+1 query waterfall
    final userIds = badges
        .map((b) => b.updatedBy)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (userIds.isNotEmpty) {
      try {
        final users = await UserTable().queryRows(
          queryFn: (q) => q.inFilter('user_id', userIds),
        );
        for (final u in users) {
          if (u.userId != null && u.userName != null) {
            _userNames[u.userId!] = u.userName!;
          }
        }
      } catch (_) {
        // Fallback gracefully if user lookup fails
      }
    }

    return badges;
  }

  Future<void> _refresh() async {
    setState(() {
      _badgesFuture = _loadBadges();
    });
    await _badgesFuture;
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
                onRefresh: _refresh,
                color: const Color(0xFF2E78A6),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 120.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand topbar with back button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/Horizontal_Logo.png',
                              height: 38.0,
                              fit: BoxFit.contain,
                            ),
                            FlutterFlowIconButton(
                              borderColor:
                                  theme.accent4.withValues(alpha: 0.35),
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

                      const CPageHeaderWidget(
                        title: 'Badge Directory',
                        subtitle:
                            'Configure gamification rewards, milestone tiers, & point limits',
                        icon: Icons.military_tech_rounded,
                      ),

                      // Actions & Summary Row
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: FutureBuilder<List<BadgeRow>>(
                          future: _badgesFuture,
                          builder: (context, snapshot) {
                            final count = snapshot.data?.length ?? 0;
                            return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD5F2E2),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 15.0,
                                        color: Color(0xFF31A11F),
                                      ),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        '$count Badges Active',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF013448),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    final created =
                                        await showModalBottomSheet<bool>(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (bottomSheetContext) {
                                        return GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                bottomSheetContext),
                                            child:
                                                const CBadgesCreationWidget(),
                                          ),
                                        );
                                      },
                                    );
                                    if (created == true) {
                                      _refresh();
                                    }
                                  },
                                  text: 'New Badge',
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    size: 18.0,
                                    color: Colors.white,
                                  ),
                                  options: FFButtonOptions(
                                    height: 38.0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0,
                                    ),
                                    color: const Color(0xFF2E78A6),
                                    textStyle: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(19.0),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // Badges List FutureBuilder
                      FutureBuilder<List<BadgeRow>>(
                        future: _badgesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF2E78A6),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: const Color(0xFFFEE2E2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    size: 36.0,
                                    color: Color(0xFFDC2626),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Unable to load badges',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF013448),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  FFButtonWidget(
                                    onPressed: _refresh,
                                    text: 'Retry',
                                    options: FFButtonOptions(
                                      height: 36.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      color: const Color(0xFF2E78A6),
                                      textStyle: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final badges = snapshot.data ?? [];

                          if (badges.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(32.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: theme.accent4.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD5F2E2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.military_tech_rounded,
                                      size: 40.0,
                                      color: Color(0xFF31A11F),
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),
                                  Text(
                                    'No Badges Configured',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF013448),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    'Create milestone badges to incentivize resident recycling participation.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: badges.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12.0),
                            itemBuilder: (context, index) {
                              final badge = badges[index];
                              final level = badge.badgeLevel ?? 1;
                              final name = badge.badgeName ?? 'Unnamed Badge';
                              final desc = badge.badgeDescription ?? '';
                              final minPts = badge.badgeMinPts ?? 0;
                              final maxPts = badge.badgeMaxPts ?? 1000;
                              final updatedByName = badge.updatedBy != null
                                  ? (_userNames[badge.updatedBy!] ?? 'Admin')
                                  : 'Admin';
                              final updateDate = badge.updatedAt ??
                                  badge.createdAt ??
                                  DateTime.now();

                              return InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () async {
                                  await context.pushNamed(
                                    PBadgeViewOneWidget.routeName,
                                    queryParameters: {
                                      'badgeRef': serializeParam(
                                        badge,
                                        ParamType.SupabaseRow,
                                      ),
                                    }.withoutNulls,
                                  );
                                  _refresh();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color:
                                          theme.accent4.withValues(alpha: 0.3),
                                      width: 1.0,
                                    ),
                                    boxShadow: [
                                      theme.designToken.shadow.sm,
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Top Row: Level badge, title, points range, chevron
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Level circular chip
                                            Container(
                                              width: 44.0,
                                              height: 44.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD5F2E2),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.military_tech_rounded,
                                                    size: 18.0,
                                                    color: Color(0xFF31A11F),
                                                  ),
                                                  Text(
                                                    'Lvl $level',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xFF013448),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 12.0),

                                            // Name and points
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          name,
                                                          style: GoogleFonts
                                                              .comfortaa(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: const Color(
                                                                0xFF013448),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 3.0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                                  0xFFA3C9D9)
                                                              .withValues(
                                                                  alpha: 0.25),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .stars_rounded,
                                                              size: 14.0,
                                                              color: Color(
                                                                  0xFF2E78A6),
                                                            ),
                                                            const SizedBox(
                                                                width: 4.0),
                                                            Text(
                                                              '${formatNumber(minPts, formatType: FormatType.compact)} - ${formatNumber(maxPts, formatType: FormatType.compact)} pts',
                                                              style:
                                                                  GoogleFonts
                                                                      .inter(
                                                                fontSize: 11.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: const Color(
                                                                    0xFF2E78A6),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (desc.isNotEmpty) ...[
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      desc,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12.0,
                                                        color:
                                                            theme.secondaryText,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              size: 20.0,
                                              color: theme.secondaryText
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 12.0),
                                        Divider(
                                          height: 1.0,
                                          thickness: 1.0,
                                          color: theme.accent4
                                              .withValues(alpha: 0.25),
                                        ),
                                        const SizedBox(height: 10.0),

                                        // Footer metadata: Updated By & Updated At
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.account_circle_outlined,
                                                  size: 15.0,
                                                  color: theme.secondaryText,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  'Updated by $updatedByName',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11.0,
                                                    color: theme.secondaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.schedule_rounded,
                                                  size: 14.0,
                                                  color: theme.secondaryText,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  dateTimeFormat(
                                                      "Md", updateDate),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11.0,
                                                    color: theme.secondaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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

              // Bottom Navigation Bar
              Align(
                alignment: Alignment.bottomCenter,
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
