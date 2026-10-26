import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_notification/c_notification_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_profile_model.dart';
export 'page_profile_model.dart';

class _ProfileBundle {
  const _ProfileBundle({
    required this.user,
    required this.subtable,
    required this.badge,
    required this.streets,
  });

  final UserRow? user;
  final UserSubtableRow? subtable;
  final BadgeRow? badge;
  final List<StreetRow> streets;
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
    _model.reportSubjectTextController ??= TextEditingController();
    _model.reportSubjectFocusNode ??= FocusNode();
    _model.reportDescTextController ??= TextEditingController();
    _model.reportDescFocusNode ??= FocusNode();
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

    final streetsRes = await StreetTable().queryRows(
      queryFn: (q) => q.order('street_name', ascending: true),
    );

    return _ProfileBundle(
      user: user,
      subtable: subtable,
      badge: badge,
      streets: streetsRes,
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
                              const SizedBox(height: 16.0),
                              _buildIncidentReportingSection(
                                context: context,
                                theme: theme,
                                user: user,
                                streets: data.streets,
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

  Widget _buildIncidentReportingSection({
    required BuildContext context,
    required FlutterFlowTheme theme,
    required UserRow? user,
    required List<StreetRow> streets,
  }) {
    final streetOptions = streets.map((s) => s.streetName).toList();
    if (streetOptions.isEmpty && (user?.userStreetNameRef?.isNotEmpty ?? false)) {
      streetOptions.add(user!.userStreetNameRef!);
    }
    final initialStreet = _model.reportStreetValue ??
        (streetOptions.contains(user?.userStreetNameRef)
            ? user?.userStreetNameRef
            : streetOptions.firstOrNull);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F1F8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Color(0xFF2E78A6),
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    'Report Waste Incident',
                    style: GoogleFonts.comfortaa(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  context.pushNamed(PReportViewAllWidget.routeName);
                },
                child: Row(
                  children: [
                    Text(
                      'View All',
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
          const SizedBox(height: 6.0),
          Text(
            'Notify barangay crew of uncollected waste or community hazards.',
            style: GoogleFonts.inter(
              fontSize: 11.0,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14.0),

          // Subject Field
          Text(
            'Subject',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.reportSubjectTextController,
            focusNode: _model.reportSubjectFocusNode,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'e.g. Uncollected garbage, illegal dumping',
              hintStyle: GoogleFonts.inter(
                fontSize: 13.0,
                color: const Color(0xFF94A3B8),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFF2E78A6), width: 1.5),
              ),
            ),
            style: GoogleFonts.inter(fontSize: 13.0, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12.0),

          // Street Selector
          Text(
            'Street / Location',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: initialStreet,
                hint: Text(
                  'Select street location',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xFF2E78A6),
                ),
                items: streetOptions.map((st) {
                  return DropdownMenuItem<String>(
                    value: st,
                    child: Text(
                      st,
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  safeSetState(() {
                    _model.reportStreetValue = val;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Description Field
          Text(
            'Description',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6.0),
          TextFormField(
            controller: _model.reportDescTextController,
            focusNode: _model.reportDescFocusNode,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Describe the location details and waste condition...',
              hintStyle: GoogleFonts.inter(
                fontSize: 13.0,
                color: const Color(0xFF94A3B8),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Color(0xFF2E78A6), width: 1.5),
              ),
            ),
            style: GoogleFonts.inter(fontSize: 13.0, color: const Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12.0),

          // Photo Box Field
          Text(
            'Incident Photo (Optional)',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6.0),
          if (_model.reportUploadedFile.bytes != null &&
              _model.reportUploadedFile.bytes!.isNotEmpty)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.memory(
                    _model.reportUploadedFile.bytes!,
                    width: double.infinity,
                    height: 140.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: InkWell(
                    onTap: () {
                      safeSetState(() {
                        _model.reportUploadedFile =
                            FFUploadedFile(bytes: Uint8List.fromList([]));
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18.0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            InkWell(
              onTap: () async {
                final selectedMedia = await selectMediaWithSourceBottomSheet(
                  context: context,
                  maxWidth: 1024.0,
                  maxHeight: 1024.0,
                  imageQuality: 80,
                  allowPhoto: true,
                );
                if (selectedMedia != null &&
                    selectedMedia.every((m) =>
                        validateFileFormat(m.storagePath, context))) {
                  safeSetState(() {
                    _model.reportUploadedFile = FFUploadedFile(
                      name: selectedMedia.first.storagePath.split('/').last,
                      bytes: selectedMedia.first.bytes,
                      originalFilename: selectedMedia.first.originalFilename,
                    );
                  });
                }
              },
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color(0xFFA3C9D9),
                    width: 1.2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_a_photo_rounded,
                      color: Color(0xFF2E78A6),
                      size: 26.0,
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Tap to take or choose incident photo',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E78A6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16.0),

          // Submit Button
          if (_model.isSubmittingReport)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E78A6)),
                ),
              ),
            )
          else
            FFButtonWidget(
              onPressed: () async {
                final subject = _model.reportSubjectTextController?.text.trim() ?? '';
                final desc = _model.reportDescTextController?.text.trim() ?? '';
                final street = initialStreet ?? 'Unspecified Street';

                if (subject.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter an incident subject.',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFFDC2626),
                    ),
                  );
                  return;
                }
                if (desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please provide an incident description.',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFFDC2626),
                    ),
                  );
                  return;
                }

                safeSetState(() => _model.isSubmittingReport = true);
                try {
                  String? uploadedImageUrl;
                  if (_model.reportUploadedFile.bytes != null &&
                      _model.reportUploadedFile.bytes!.isNotEmpty) {
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    final ext = (_model.reportUploadedFile.originalFilename.isNotEmpty &&
                            _model.reportUploadedFile.originalFilename.contains('.'))
                        ? _model.reportUploadedFile.originalFilename.split('.').last
                        : (_model.reportUploadedFile.name != null &&
                                _model.reportUploadedFile.name!.contains('.'))
                            ? _model.reportUploadedFile.name!.split('.').last
                            : 'jpg';
                    final filename =
                        'report_${currentUserUid.isNotEmpty ? currentUserUid : "user"}_$timestamp.$ext';
                    final selectedFile = SelectedFile(
                      storagePath: 'Reports/$filename',
                      bytes: _model.reportUploadedFile.bytes!,
                      originalFilename:
                          _model.reportUploadedFile.originalFilename.isNotEmpty
                              ? _model.reportUploadedFile.originalFilename
                              : filename,
                    );
                    final downloadUrls = await uploadSupabaseStorageFiles(
                      bucketName: 'Image_Bucket',
                      selectedFiles: [selectedFile],
                    );
                    if (downloadUrls.isNotEmpty) {
                      uploadedImageUrl = downloadUrls.first;
                    }
                  }

                  await ReportTable().insert({
                    'report_subject': subject,
                    'report_description': desc,
                    'report_streetNameRef': street,
                    'reporter_userRef': currentUserUid,
                    'report_status': 'Pending',
                    'report_remarks': '',
                    'report_conductedDate': supaSerialize<DateTime>(
                        functions.getCurrentTime(getCurrentTimestamp)),
                    'created_at': supaSerialize<DateTime>(
                        functions.getCurrentTime(getCurrentTimestamp)),
                    'report_image_link': uploadedImageUrl,
                  });

                  _model.reportSubjectTextController?.clear();
                  _model.reportDescTextController?.clear();
                  _model.reportUploadedFile =
                      FFUploadedFile(bytes: Uint8List.fromList([]));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Incident report submitted successfully! Barangay crew has been notified.',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: const Color(0xFF31A11F),
                      ),
                    );
                  }
                } catch (e, stackTrace) {
                  debugPrint('Failed to submit report: $e\n$stackTrace');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to submit report. Please try again.',
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFFDC2626),
                      ),
                    );
                  }
                } finally {
                  safeSetState(() => _model.isSubmittingReport = false);
                }
              },
              text: 'Submit Report',
              icon: const Icon(
                Icons.send_rounded,
                size: 16.0,
                color: Colors.white,
              ),
              options: FFButtonOptions(
                width: double.infinity,
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
        ],
      ),
    );
  }

}
