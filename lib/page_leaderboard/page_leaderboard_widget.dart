import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_leaderboard_model.dart';
export 'page_leaderboard_model.dart';

class PageLeaderboardWidget extends StatefulWidget {
  const PageLeaderboardWidget({super.key});

  static String routeName = 'Page_Leaderboard';
  static String routePath = '/pageLeaderboard';

  @override
  State<PageLeaderboardWidget> createState() => _PageLeaderboardWidgetState();
}

class _PageLeaderboardWidgetState extends State<PageLeaderboardWidget> {
  late PageLeaderboardModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageLeaderboardModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF4F8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).accent4,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.leaderboard_rounded,
              color: FlutterFlowTheme.of(context).accent3,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest Mode Leaderboard',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                Text(
                  'Sign in or register to join rankings and earn rewards.',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          EBasuraButton.button3(
            text: 'Sign In',
            height: 34.0,
            onPressed: () async {
              context.pushNamed(LandingPageWidget.routeName);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color bgColor;
    Color textColor;
    IconData? medalIcon;

    if (rank == 1) {
      bgColor = const Color(0xFFFFD700);
      textColor = const Color(0xFF7A5C00);
      medalIcon = Icons.workspace_premium_rounded;
    } else if (rank == 2) {
      bgColor = const Color(0xFFC0C0C0);
      textColor = const Color(0xFF4A4A4A);
      medalIcon = Icons.military_tech_rounded;
    } else if (rank == 3) {
      bgColor = const Color(0xFFCD7F32);
      textColor = Colors.white;
      medalIcon = Icons.military_tech_rounded;
    } else {
      bgColor = const Color(0xFFE2E8F0);
      textColor = const Color(0xFF64748B);
      medalIcon = null;
    }

    return Container(
      width: 34.0,
      height: 34.0,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: medalIcon != null
            ? Icon(
                medalIcon,
                color: textColor,
                size: 20.0,
              )
            : Text(
                '$rank',
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = currentUserUid.isEmpty;

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
                      title: 'Community Leaderboard',
                      subtitle: 'Top eco-citizens ranking by verified waste recycling',
                      icon: Icons.leaderboard_rounded,
                    ),
                    if (isGuest) ...[
                      const SizedBox(height: 12.0),
                      _buildGuestBanner(context),
                    ],
                    const SizedBox(height: 16.0),
                    FutureBuilder<List<UserSubtableRow>>(
                      future: UserSubtableTable().queryRows(
                        queryFn: (q) => q
                            .neqOrNull('user_points', 0)
                            .order('user_points', ascending: false),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final leaderboard = snapshot.data!;

                        if (leaderboard.isEmpty) {
                          return EBasuraCard(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      color: FlutterFlowTheme.of(context).accent4,
                                      size: 48.0,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Text(
                                      'No points recorded yet',
                                      style: GoogleFonts.interTight(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      'Be the first resident to scan recyclables and claim #1 rank!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.0,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: leaderboard.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                          itemBuilder: (context, index) {
                            final row = leaderboard[index];
                            final rank = index + 1;
                            final isCurrentUser = row.userIdRef == currentUserUid;

                            return EBasuraCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 12.0,
                              ),
                              child: Row(
                                children: [
                                  _buildRankBadge(rank),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: FutureBuilder<List<UserRow>>(
                                      future: UserTable().querySingleRow(
                                        queryFn: (q) => q.eqOrNull(
                                          'user_id',
                                          row.userIdRef,
                                        ),
                                      ),
                                      builder: (context, userSnap) {
                                        final user = userSnap.hasData &&
                                                userSnap.data!.isNotEmpty
                                            ? userSnap.data!.first
                                            : null;
                                        final name = user?.userName == 'EBasura User' ||
                                                user?.userName == null
                                            ? (user?.userEmail?.split('@').first ??
                                                'Resident #$rank')
                                            : user!.userName!;
                                        final street = user?.userStreetNameRef ??
                                            'Barangay Resident';

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14.0,
                                                      fontWeight: isCurrentUser
                                                          ? FontWeight.bold
                                                          : FontWeight.w600,
                                                      color: isCurrentUser
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .accent3
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                    ),
                                                  ),
                                                ),
                                                if (isCurrentUser) ...[
                                                  const SizedBox(width: 6.0),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 2.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .mintTint,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Text(
                                                      'You',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: FlutterFlowTheme.of(
                                                                context)
                                                            .accent3,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            Text(
                                              street,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 11.0,
                                                color: FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${row.userPoints ?? 0}',
                                        style: GoogleFonts.interTight(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: FlutterFlowTheme.of(context)
                                              .ecoPrimary,
                                        ),
                                      ),
                                      Text(
                                        'pts',
                                        style: GoogleFonts.inter(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w500,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
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
              const Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: CBottomBarWidget(activeRoute: 'Page_Leaderboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
