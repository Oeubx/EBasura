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

class ResidentLeaderboardEntry {
  final int rank;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int points;
  final String streetRef;
  final bool isCurrentUser;

  const ResidentLeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.points,
    required this.streetRef,
    required this.isCurrentUser,
  });

  factory ResidentLeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return ResidentLeaderboardEntry(
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      userId: map['user_id']?.toString() ?? '',
      displayName: map['display_name']?.toString() ?? 'Eco Resident',
      avatarUrl: map['avatar_url']?.toString(),
      points: (map['points'] as num?)?.toInt() ?? 0,
      streetRef: map['street_ref']?.toString() ?? 'Batasan Hills',
      isCurrentUser: map['is_current_user'] as bool? ?? false,
    );
  }
}

class StreetLeaderboardEntry {
  final int rank;
  final String streetRef;
  final int totalPoints;
  final int activeResidents;
  final double pointsPerResident;

  const StreetLeaderboardEntry({
    required this.rank,
    required this.streetRef,
    required this.totalPoints,
    required this.activeResidents,
    required this.pointsPerResident,
  });

  factory StreetLeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return StreetLeaderboardEntry(
      rank: (map['rank'] as num?)?.toInt() ?? 0,
      streetRef: map['street_ref']?.toString() ?? 'Batasan Hills Street',
      totalPoints: (map['total_points'] as num?)?.toInt() ?? 0,
      activeResidents: (map['active_residents'] as num?)?.toInt() ?? 0,
      pointsPerResident: (map['points_per_resident'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class UserRankSummary {
  final int rank;
  final int points;
  final int pointsToNext;

  const UserRankSummary({
    required this.rank,
    required this.points,
    required this.pointsToNext,
  });

  factory UserRankSummary.fromMap(Map<String, dynamic> map) {
    return UserRankSummary(
      rank: (map['my_rank'] as num?)?.toInt() ?? 0,
      points: (map['my_points'] as num?)?.toInt() ?? 0,
      pointsToNext: (map['points_to_next'] as num?)?.toInt() ?? 0,
    );
  }
}

class LeaderboardV2Bundle {
  final List<ResidentLeaderboardEntry> residentEntries;
  final List<StreetLeaderboardEntry> streetEntries;
  final UserRankSummary? userRank;

  const LeaderboardV2Bundle({
    required this.residentEntries,
    required this.streetEntries,
    this.userRank,
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
  late Future<LeaderboardV2Bundle> _leaderboardFuture;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedPeriod = 'this_week'; // 'this_week', 'this_month', 'all_time'
  String _selectedBoard = 'residents'; // 'residents', 'streets'

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

  Future<LeaderboardV2Bundle> _loadLeaderboardData() async {
    List<ResidentLeaderboardEntry> residentEntries = [];
    List<StreetLeaderboardEntry> streetEntries = [];
    UserRankSummary? userRank;

    if (_selectedBoard == 'residents') {
      try {
        final res = await SupaFlow.client.rpc(
          'get_leaderboard',
          params: {
            'p_period': _selectedPeriod,
            'p_limit': 50,
          },
        );
        if (res is List) {
          residentEntries = res
              .map((e) => ResidentLeaderboardEntry.fromMap(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList();
        }
      } catch (e) {
        debugPrint('Error fetching get_leaderboard: $e');
      }

      if (currentUserUid.isNotEmpty) {
        try {
          final rankRes = await SupaFlow.client.rpc(
            'get_my_rank',
            params: {'p_period': _selectedPeriod},
          );
          if (rankRes is List && rankRes.isNotEmpty) {
            userRank = UserRankSummary.fromMap(
              Map<String, dynamic>.from(rankRes.first as Map),
            );
          }
        } catch (e) {
          debugPrint('Error fetching get_my_rank: $e');
        }
      }
    } else {
      try {
        final res = await SupaFlow.client.rpc(
          'get_street_leaderboard',
          params: {'p_period': _selectedPeriod},
        );
        if (res is List) {
          streetEntries = res
              .map((e) => StreetLeaderboardEntry.fromMap(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList();
        }
      } catch (e) {
        debugPrint('Error fetching get_street_leaderboard: $e');
      }
    }

    return LeaderboardV2Bundle(
      residentEntries: residentEntries,
      streetEntries: streetEntries,
      userRank: userRank,
    );
  }

  Future<void> _navigateToStreet(String streetName) async {
    try {
      final rows = await StreetTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('street_name', streetName),
      );
      if (rows.isNotEmpty && mounted) {
        context.pushNamed(
          PStreetViewOneWidget.routeName,
          queryParameters: {
            'streetsRef': serializeParam(
              rows.first,
              ParamType.SupabaseRow,
            ),
          }.withoutNulls,
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Street details for "$streetName" not found in directory.',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF2E78A6),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error navigating to street: $e');
    }
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
                            'Top eco-citizens and streets ranked by verified segregation',
                        icon: Icons.leaderboard_rounded,
                      ),

                      if (isGuest) ...[
                        const SizedBox(height: 12.0),
                        _buildGuestBanner(context, theme),
                      ],

                      const SizedBox(height: 14.0),

                      // Segmented Controls: Board Selector & Period Selector
                      _buildBoardSelector(),
                      const SizedBox(height: 10.0),
                      _buildPeriodSelector(),
                      const SizedBox(height: 14.0),

                      FutureBuilder<LeaderboardV2Bundle>(
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
                          final residents = bundle?.residentEntries ?? [];
                          final streets = bundle?.streetEntries ?? [];
                          final userRank = bundle?.userRank;

                          if (_selectedBoard == 'residents') {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isGuest && userRank != null) ...[
                                  _buildUserStandingCard(context, userRank),
                                  const SizedBox(height: 16.0),
                                ],

                                if (residents.isEmpty)
                                  _buildEmptyState(
                                    context,
                                    title: 'No Resident Points Recorded',
                                    description:
                                        'Be the first eco-citizen in Barangay Batasan Hills to scan, segregate, and earn verified points for $_periodDisplayName!',
                                  )
                                else ...[
                                  if (residents.length >= 3) ...[
                                    _buildTop3Podium(
                                      context,
                                      residents.take(3).toList(),
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        residents.length >= 3
                                            ? 'Rankings 4+'
                                            : 'Rankings',
                                        style: GoogleFonts.comfortaa(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF013448),
                                        ),
                                      ),
                                      Text(
                                        '${residents.length} residents active',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.0,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),

                                  ..._buildResidentListItems(
                                    context,
                                    residents.length >= 3
                                        ? residents.skip(3).toList()
                                        : residents,
                                  ),
                                ],
                              ],
                            );
                          } else {
                            // Streets Board
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildStreetHeaderCard(),
                                const SizedBox(height: 14.0),

                                if (streets.isEmpty)
                                  _buildEmptyState(
                                    context,
                                    title: 'No Street Activity Yet',
                                    description:
                                        'No verified segregation points have been logged for streets in $_periodDisplayName. Scan your waste and set the bar for your neighborhood!',
                                  )
                                else ...[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Street Rankings',
                                        style: GoogleFonts.comfortaa(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF013448),
                                        ),
                                      ),
                                      Text(
                                        '${streets.length} participating streets',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.0,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  ..._buildStreetListItems(context, streets),
                                ],
                              ],
                            );
                          }
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

  String get _periodDisplayName {
    switch (_selectedPeriod) {
      case 'this_week':
        return 'This Week';
      case 'this_month':
        return 'This Month';
      default:
        return 'All-Time';
    }
  }

  Widget _buildBoardSelector() {
    final boards = [
      {'key': 'residents', 'label': 'Residents', 'icon': Icons.person_rounded},
      {'key': 'streets', 'label': 'Streets', 'icon': Icons.location_city_rounded},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: Row(
        children: boards.map((b) {
          final isSelected = _selectedBoard == b['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (_selectedBoard != b['key']) {
                  setState(() {
                    _selectedBoard = b['key'] as String;
                    _leaderboardFuture = _loadLeaderboardData();
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF31A11F) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18.0),
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: Color(0x2031A11F),
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      b['icon'] as IconData,
                      size: 16.0,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      b['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = [
      {'key': 'this_week', 'label': 'This Week'},
      {'key': 'this_month', 'label': 'This Month'},
      {'key': 'all_time', 'label': 'All-Time'},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          width: 1.0,
        ),
      ),
      child: Row(
        children: periods.map((p) {
          final isSelected = _selectedPeriod == p['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (_selectedPeriod != p['key']) {
                  setState(() {
                    _selectedPeriod = p['key'] as String;
                    _leaderboardFuture = _loadLeaderboardData();
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E78A6) : Colors.transparent,
                  borderRadius: BorderRadius.circular(13.0),
                ),
                child: Center(
                  child: Text(
                    p['label'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStreetHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD5F2E2),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFF70BF5A).withValues(alpha: 0.5),
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
              Icons.balance_rounded,
              color: Color(0xFF31A11F),
              size: 22.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points Per Active Resident',
                  style: GoogleFonts.comfortaa(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF013448),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'Streets are scored by total points divided by active participants so all street sizes compete fairly.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF334155),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestBanner(BuildContext context, FlutterFlowTheme theme) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: () => context.pushNamed(LandingPageWidget.routeName),
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
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
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: Color(0xFF2E78A6),
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                      'Tap here to sign in & climb the community board.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF2E78A6),
                size: 14.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserStandingCard(
    BuildContext context,
    UserRankSummary userRank,
  ) {
    final rankText = userRank.rank > 0 ? '#${userRank.rank}' : 'Unranked';

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
                  userRank.rank > 1 && userRank.pointsToNext > 0
                      ? '${userRank.pointsToNext} pts needed to pass rank #${userRank.rank - 1}!'
                      : (userRank.rank == 1
                          ? '🌟 You are leading the community in $_periodDisplayName!'
                          : 'Scan and segregate verified waste to earn your official rank.'),
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.90),
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
                '${userRank.points}',
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
    List<ResidentLeaderboardEntry> top3,
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
    required ResidentLeaderboardEntry entry,
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

  List<Widget> _buildResidentListItems(
    BuildContext context,
    List<ResidentLeaderboardEntry> items,
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
                    entry.streetRef,
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

  List<Widget> _buildStreetListItems(
    BuildContext context,
    List<StreetLeaderboardEntry> streets,
  ) {
    return streets.map((street) {
      final isTop3 = street.rank <= 3;
      final badgeColor = street.rank == 1
          ? const Color(0xFFF59E0B)
          : (street.rank == 2
              ? const Color(0xFF94A3B8)
              : (street.rank == 3
                  ? const Color(0xFFD97706)
                  : const Color(0xFF2E78A6)));

      return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          child: InkWell(
            onTap: () => _navigateToStreet(street.streetRef),
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: isTop3
                      ? badgeColor.withValues(alpha: 0.45)
                      : const Color(0xFFE2E8F0),
                  width: isTop3 ? 1.5 : 1.0,
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
                  Container(
                    width: 34.0,
                    height: 34.0,
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#${street.rank}',
                        style: GoogleFonts.comfortaa(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          street.streetRef,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.comfortaa(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF013448),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          '${street.totalPoints} total pts • ${street.activeResidents} active resident${street.activeResidents == 1 ? '' : 's'}',
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 3.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD5F2E2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          '${street.pointsPerResident.toStringAsFixed(1)} pts/res',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF31A11F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6.0),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF94A3B8),
                    size: 13.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required String title,
    required String description,
  }) {
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
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.comfortaa(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF013448),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            description,
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
