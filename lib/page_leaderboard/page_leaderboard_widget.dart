import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_leaderboard_model.dart';
export 'page_leaderboard_model.dart';

class LeaderboardEntry {
  final int rank;
  final UserSubtableRow subtable;
  final UserRow? user;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.subtable,
    this.user,
    required this.isCurrentUser,
  });

  String get displayName {
    final rawName = user?.userName;
    if (rawName == null || rawName.trim().isEmpty || rawName == 'EBasura User') {
      final email = user?.userEmail;
      if (email != null && email.isNotEmpty) {
        return email.split('@').first;
      }
      return 'Eco Resident #$rank';
    }
    return rawName;
  }

  String get streetName {
    final rawStreet = user?.userStreetNameRef;
    if (rawStreet == null || rawStreet.trim().isEmpty) {
      return 'Batasan Hills Resident';
    }
    return rawStreet;
  }

  int get points => subtable.userPoints ?? 0;
}

class LeaderboardBundle {
  final List<LeaderboardEntry> entries;
  final LeaderboardEntry? currentUserEntry;

  const LeaderboardBundle({
    required this.entries,
    this.currentUserEntry,
  });
}

class PageLeaderboardWidget extends StatefulWidget {
  const PageLeaderboardWidget({super.key});

  static String routeName = 'Page_Leaderboard';
  static String routePath = '/pageLeaderboard';

  @override
  State<PageLeaderboardWidget> createState() => _PageLeaderboardWidgetState();
}

class _PageLeaderboardWidgetState extends State<PageLeaderboardWidget> {
  late PageLeaderboardModel _model;
  late Future<LeaderboardBundle> _leaderboardFuture;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageLeaderboardModel());
    _leaderboardFuture = _loadLeaderboardData();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _leaderboardFuture = _loadLeaderboardData();
    });
    await _leaderboardFuture;
  }

  Future<LeaderboardBundle> _loadLeaderboardData() async {
    // 1. Fetch top subtables ordered by points descending
    final subtables = await UserSubtableTable().queryRows(
      queryFn: (q) => q
          .neqOrNull('user_points', 0)
          .order('user_points', ascending: false)
          .limit(50),
    );

    if (subtables.isEmpty) {
      LeaderboardEntry? currentEntry;
      if (currentUserUid.isNotEmpty) {
        final currentSub = await UserSubtableTable().querySingleRow(
          queryFn: (q) => q.eqOrNull('user_idRef', currentUserUid),
        );
        if (currentSub.isNotEmpty) {
          final currentUserRows = await UserTable().querySingleRow(
            queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
          );
          currentEntry = LeaderboardEntry(
            rank: 0,
            subtable: currentSub.first,
            user: currentUserRows.firstOrNull,
            isCurrentUser: true,
          );
        }
      }
      return LeaderboardBundle(entries: [], currentUserEntry: currentEntry);
    }

    // 2. Collect unique user_idRef values for batch fetching
    final userIds = subtables
        .map((s) => s.userIdRef)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    // 3. Batch fetch all users in a single query
    final Map<String, UserRow> userMap = {};
    if (userIds.isNotEmpty) {
      final users = await UserTable().queryRows(
        queryFn: (q) => q.inFilter('user_id', userIds),
      );
      for (final u in users) {
        if (u.userId != null) {
          userMap[u.userId!] = u;
        }
      }
    }

    // 4. Assemble entries
    LeaderboardEntry? currentEntry;
    final List<LeaderboardEntry> entries = [];
    for (int i = 0; i < subtables.length; i++) {
      final s = subtables[i];
      final u = userMap[s.userIdRef];
      final isCurrent =
          s.userIdRef == currentUserUid && currentUserUid.isNotEmpty;
      final entry = LeaderboardEntry(
        rank: i + 1,
        subtable: s,
        user: u,
        isCurrentUser: isCurrent,
      );
      entries.add(entry);
      if (isCurrent) {
        currentEntry = entry;
      }
    }

    // 5. If current user is logged in but not in top 50, fetch their individual score
    if (currentEntry == null && currentUserUid.isNotEmpty) {
      final currentSub = await UserSubtableTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('user_idRef', currentUserUid),
      );
      if (currentSub.isNotEmpty) {
        final currentUserRows = await UserTable().querySingleRow(
          queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
        );
        currentEntry = LeaderboardEntry(
          rank: 0,
          subtable: currentSub.first,
          user: currentUserRows.firstOrNull,
          isCurrentUser: true,
        );
      }
    }

    return LeaderboardBundle(
      entries: entries,
      currentUserEntry: currentEntry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isGuest = currentUserUid.isEmpty;

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
                onRefresh: _handleRefresh,
                color: const Color(0xFF2E78A6),
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                    bottom: 110.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top branding bar with refresh button
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
                                Icons.refresh_rounded,
                                color: theme.primaryText,
                                size: 20.0,
                              ),
                              onPressed: _handleRefresh,
                            ),
                          ],
                        ),
                      ),

                      const CPageHeaderWidget(
                        title: 'Community Leaderboard',
                        subtitle:
                            'Top eco-citizens ranking by verified waste segregation',
                        icon: Icons.leaderboard_rounded,
                      ),

                      if (isGuest) ...[
                        const SizedBox(height: 12.0),
                        _buildGuestBanner(context, theme),
                      ],

                      const SizedBox(height: 14.0),

                      FutureBuilder<LeaderboardBundle>(
                        future: _leaderboardFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(48.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2E78A6),
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return _buildErrorState(context, snapshot.error);
                          }

                          final bundle = snapshot.data;
                          final entries = bundle?.entries ?? [];
                          final currentEntry = bundle?.currentUserEntry;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Standing Summary (if authenticated)
                              if (!isGuest && currentEntry != null) ...[
                                _buildUserStandingCard(context, currentEntry),
                                const SizedBox(height: 16.0),
                              ],

                              if (entries.isEmpty)
                                _buildEmptyState(context)
                              else ...[
                                // Top 3 Podium (if at least 3 entries)
                                if (entries.length >= 3) ...[
                                  _buildTop3Podium(context, entries.take(3).toList()),
                                  const SizedBox(height: 20.0),
                                ],

                                // Section Heading for list
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entries.length >= 3
                                          ? 'Rankings 4+'
                                          : 'Rankings',
                                      style: GoogleFonts.comfortaa(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF013448),
                                      ),
                                    ),
                                    Text(
                                      '${entries.length} residents',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.0,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),

                                // List of entries (entries 4+ if podium shown, or all if <3)
                                ..._buildListItems(
                                  context,
                                  entries.length >= 3
                                      ? entries.skip(3).toList()
                                      : entries,
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Dock
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_Leaderboard',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestBanner(BuildContext context, FlutterFlowTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1F8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFA3C9D9),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.military_tech_rounded,
              color: Color(0xFF2E78A6),
              size: 24.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join the Rankings',
                  style: GoogleFonts.comfortaa(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF013448),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Sign in to earn points from verified waste scanning and climb the community board.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF475569),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          FFButtonWidget(
            onPressed: () async =>
                context.pushNamed(LandingPageWidget.routeName),
            text: 'Sign In',
            options: FFButtonOptions(
              height: 36.0,
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              color: const Color(0xFF2E78A6),
              textStyle: GoogleFonts.inter(
                fontSize: 12.0,
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

  Widget _buildUserStandingCard(
    BuildContext context,
    LeaderboardEntry entry,
  ) {
    final rankText = entry.rank > 0 ? '#${entry.rank}' : 'Unranked';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E78A6), Color(0xFF1B4D6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x252E78A6),
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Color(0xFFD5F2E2),
              size: 28.0,
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Your Standing',
                      style: GoogleFonts.comfortaa(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF31A11F),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        rankText,
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  entry.rank > 0
                      ? 'You are currently in the top rankings! Keep segregating.'
                      : 'Scan and segregate verified waste to earn your official rank.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.85),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.points}',
                style: GoogleFonts.inter(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFD5F2E2),
                ),
              ),
              Text(
                'pts',
                style: GoogleFonts.inter(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTop3Podium(
    BuildContext context,
    List<LeaderboardEntry> top3,
  ) {
    final first = top3[0];
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFFF59E0B),
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Top Eco Champions',
                style: GoogleFonts.comfortaa(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF013448),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 2nd Place (Left)
              if (second != null)
                Expanded(
                  child: _buildPodiumStep(
                    entry: second,
                    rank: 2,
                    badgeColor: const Color(0xFF94A3B8),
                    pedestalHeight: 80.0,
                    pedestalColor: const Color(0xFFF1F5F9),
                  ),
                )
              else
                const Expanded(child: SizedBox()),

              // 1st Place (Center - Elevated)
              Expanded(
                child: _buildPodiumStep(
                  entry: first,
                  rank: 1,
                  badgeColor: const Color(0xFFF59E0B),
                  pedestalHeight: 105.0,
                  pedestalColor: const Color(0xFFFEF3C7),
                ),
              ),

              // 3rd Place (Right)
              if (third != null)
                Expanded(
                  child: _buildPodiumStep(
                    entry: third,
                    rank: 3,
                    badgeColor: const Color(0xFFD97706),
                    pedestalHeight: 65.0,
                    pedestalColor: const Color(0xFFF1F5F9),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumStep({
    required LeaderboardEntry entry,
    required int rank,
    required Color badgeColor,
    required double pedestalHeight,
    required Color pedestalColor,
  }) {
    final initials = entry.displayName.isNotEmpty
        ? entry.displayName.substring(0, 1).toUpperCase()
        : 'E';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar with rank indicator
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: rank == 1 ? 28.0 : 22.0,
              backgroundColor: badgeColor.withValues(alpha: 0.18),
              child: Text(
                initials,
                style: GoogleFonts.comfortaa(
                  fontSize: rank == 1 ? 20.0 : 16.0,
                  fontWeight: FontWeight.w700,
                  color: badgeColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
              ),
              child: rank == 1
                  ? const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 11.0,
                    )
                  : Text(
                      '$rank',
                      style: GoogleFonts.inter(
                        fontSize: 9.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        Text(
          entry.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: rank == 1 ? 12.5 : 11.5,
            fontWeight: rank == 1 ? FontWeight.w700 : FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          '${entry.points} pts',
          style: GoogleFonts.inter(
            fontSize: 11.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF31A11F),
          ),
        ),
        const SizedBox(height: 8.0),
        // Pedestal base block
        Container(
          width: double.infinity,
          height: pedestalHeight,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: pedestalColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            border: Border.all(
              color: badgeColor.withValues(alpha: 0.25),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: GoogleFonts.comfortaa(
                fontSize: rank == 1 ? 22.0 : 18.0,
                fontWeight: FontWeight.w800,
                color: badgeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildListItems(
    BuildContext context,
    List<LeaderboardEntry> items,
  ) {
    if (items.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'No additional rankings to display.',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ];
    }

    return items.map((entry) {
      final isCurrent = entry.isCurrentUser;
      final initials = entry.displayName.isNotEmpty
          ? entry.displayName.substring(0, 1).toUpperCase()
          : 'E';

      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isCurrent ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isCurrent
                ? const Color(0xFF70BF5A)
                : const Color(0xFFE2E8F0),
            width: isCurrent ? 1.5 : 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Rank Number Badge
            Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: isCurrent
                    ? const Color(0xFFD5F2E2)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${entry.rank}',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: isCurrent
                        ? const Color(0xFF31A11F)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),

            // Avatar
            CircleAvatar(
              radius: 16.0,
              backgroundColor: const Color(0xFFE8F1F8),
              child: Text(
                initials,
                style: GoogleFonts.comfortaa(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E78A6),
                ),
              ),
            ),
            const SizedBox(width: 10.0),

            // Name & Street
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          entry.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight:
                                isCurrent ? FontWeight.w700 : FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 6.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF31A11F),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'YOU',
                            style: GoogleFonts.inter(
                              fontSize: 9.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    entry.streetName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),

            // Points
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry.points}',
                  style: GoogleFonts.inter(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF31A11F),
                  ),
                ),
                Text(
                  'pts',
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.0,
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
              Icons.emoji_events_outlined,
              color: Color(0xFF31A11F),
              size: 42.0,
            ),
          ),
          const SizedBox(height: 14.0),
          Text(
            'No Points Recorded Yet',
            style: GoogleFonts.comfortaa(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF013448),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Be the first eco-citizen in Barangay Batasan Hills to scan, segregate, and earn verified recycling points!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object? error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFFCA5A5),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFDC2626),
            size: 36.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Failed to load leaderboard',
            style: GoogleFonts.comfortaa(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF991B1B),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              color: const Color(0xFF7F1D1D),
            ),
          ),
          const SizedBox(height: 12.0),
          FFButtonWidget(
            onPressed: _handleRefresh,
            text: 'Retry',
            options: FFButtonOptions(
              height: 34.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xFFDC2626),
              textStyle: GoogleFonts.inter(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(17.0),
            ),
          ),
        ],
      ),
    );
  }
}
