import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_notification/c_notification_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_profile_model.dart';
export 'page_profile_model.dart';

class _ProfileBundle {
  const _ProfileBundle({
    required this.user,
    required this.subtable,
    required this.badge,
  });

  final UserRow? user;
  final UserSubtableRow? subtable;
  final BadgeRow? badge;
}

class PageProfileWidget extends StatefulWidget {
  const PageProfileWidget({super.key});

  static String routeName = 'Page_Profile';
  static String routePath = '/pageProfile';

  @override
  State<PageProfileWidget> createState() => _PageProfileWidgetState();
}

class _PageProfileWidgetState extends State<PageProfileWidget> {
  late PageProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<_ProfileBundle>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageProfileModel());
    _profileFuture = _loadProfileData();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<_ProfileBundle> _loadProfileData() async {
    final userRes = await UserTable().querySingleRow(
      queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
    );
    final user = userRes.firstOrNull;

    final subtableRes = await UserSubtableTable().querySingleRow(
      queryFn: (q) => q.eqOrNull('user_idRef', currentUserUid),
    );
    final subtable = subtableRes.firstOrNull;

    BadgeRow? badge;
    if (subtable?.userPoints != null) {
      final badgeRes = await BadgeTable().queryRows(
        queryFn: (q) => q
            .lteOrNull('badge_minPts', subtable!.userPoints)
            .gteOrNull('badge_maxPts', subtable.userPoints),
      );
      badge = badgeRes.firstOrNull;
    }

    return _ProfileBundle(user: user, subtable: subtable, badge: badge);
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
                color: theme.accent3,
                onRefresh: () async {
                  setState(() {
                    _profileFuture = _loadProfileData();
                  });
                  await _profileFuture;
                },
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Image.asset(
                          'assets/images/Horizontal_Logo.png',
                          height: 38.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const CPageHeaderWidget(
                        title: 'My Profile',
                        subtitle:
                            'Account details, gamification points & unlocked badges',
                        icon: Icons.person_rounded,
                      ),
                      FutureBuilder<_ProfileBundle>(
                        future: _profileFuture,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.accent3,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          final data = snapshot.data!;
                          final user = data.user;
                          final subtable = data.subtable;
                          final badge = data.badge;

                          final rawName = user?.userName;
                          final displayName = (rawName == null ||
                                  rawName.trim().isEmpty ||
                                  rawName == 'EBasura User')
                              ? (user?.userEmail ?? 'EBasura Resident')
                              : rawName;
                          final streetName = user?.userStreetNameRef ??
                              'No Street Registered';
                          final email = user?.userEmail ?? currentUserEmail;
                          final points = subtable?.userPoints ?? 0;
                          final badgeText = badge != null
                              ? 'Level ${badge.badgeLevel}'
                              : 'Starter';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildUserIdentityCard(
                                theme: theme,
                                displayName: displayName,
                                streetName: streetName,
                                email: email,
                              ),
                              if (subtable?.notification == true) ...[
                                const SizedBox(height: 12.0),
                                _buildNotificationAlert(context, theme),
                              ],
                              const SizedBox(height: 12.0),
                              _buildGamificationCard(
                                context: context,
                                theme: theme,
                                points: points,
                                badgeText: badgeText,
                              ),
                              const SizedBox(height: 20.0),
                              _buildActionButtons(context, theme),
                              const SizedBox(height: 14.0),
                              _buildSignOutButton(context, theme),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_Profile',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserIdentityCard({
    required FlutterFlowTheme theme,
    required String displayName,
    required String streetName,
    required String email,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56.0,
            height: 56.0,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1F8),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                size: 32.0,
                color: Color(0xFF2E78A6),
              ),
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.comfortaa(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14.0,
                      color: Color(0xFF2E78A6),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        streetName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E78A6),
                        ),
                      ),
                    ),
                  ],
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationAlert(
      BuildContext context, FlutterFlowTheme theme) {
    return InkWell(
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
                child: const CNotificationWidget(authIdRef: ''),
              ),
            );
          },
        );
        safeSetState(() {});
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: const Color(0xFFFCA5A5),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFDC2626),
              size: 22.0,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Segregation Reminder',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  Text(
                    'Please review proper waste segregation. Tap to view alert.',
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: const Color(0xFF991B1B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFDC2626),
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamificationCard({
    required BuildContext context,
    required FlutterFlowTheme theme,
    required int points,
    required String badgeText,
  }) {
    return Container(
      width: double.infinity,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gamification Stats',
                style: GoogleFonts.comfortaa(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                ),
              ),
              InkWell(
                onTap: () => context.pushNamed(PageLeaderboardWidget.routeName),
                child: Row(
                  children: [
                    Text(
                      'Leaderboard',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E78A6),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16.0,
                      color: Color(0xFF2E78A6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5F2E2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF31A11F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatNumber(points, formatType: FormatType.compact),
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF013448),
                              ),
                            ),
                            Text(
                              'Earned Points',
                              style: GoogleFonts.inter(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF013448),
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1F8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E78A6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.military_tech_rounded,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badgeText,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2E78A6),
                              ),
                            ),
                            Text(
                              'Current Badge',
                              style: GoogleFonts.inter(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2E78A6),
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
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, FlutterFlowTheme theme) {
    return Row(
      children: [
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              context.pushNamed(PImagesViewAllUserWidget.routeName);
            },
            text: 'My Uploads',
            icon: const Icon(
              Icons.photo_library_rounded,
              size: 16.0,
            ),
            options: FFButtonOptions(
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: const Color(0xFF2E78A6),
              textStyle: GoogleFonts.inter(
                fontSize: 13.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: FFButtonWidget(
            onPressed: () async {
              context.pushNamed(PageProfileSettingsWidget.routeName);
            },
            text: 'Settings',
            icon: const Icon(
              Icons.settings_rounded,
              size: 16.0,
              color: Color(0xFF2E78A6),
            ),
            options: FFButtonOptions(
              height: 48.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.white,
              textStyle: GoogleFonts.inter(
                fontSize: 13.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E78A6),
              ),
              borderSide: const BorderSide(
                color: Color(0xFF2E78A6),
                width: 1.2,
              ),
              elevation: 0.0,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton(
      BuildContext context, FlutterFlowTheme theme) {
    return FFButtonWidget(
      onPressed: () async {
        final router = GoRouter.of(context);
        router.prepareAuthEvent();
        await authManager.signOut();
        router.clearRedirectLocation();

        if (context.mounted) {
          context.goNamedAuth(
            LandingPageWidget.routeName,
            context.mounted,
          );
        }
      },
      text: 'Sign Out',
      icon: const Icon(
        Icons.logout_rounded,
        size: 18.0,
        color: Color(0xFFDC2626),
      ),
      options: FFButtonOptions(
        width: double.infinity,
        height: 48.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: const Color(0xFFFEE2E2),
        textStyle: GoogleFonts.inter(
          fontSize: 13.0,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFDC2626),
        ),
        elevation: 0.0,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
