import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_user_pts_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_homepage_model.dart';
export 'page_homepage_model.dart';

class PageHomepageWidget extends StatefulWidget {
  const PageHomepageWidget({super.key});

  static String routeName = 'Page_Homepage';
  static String routePath = '/pageHomepage';

  @override
  State<PageHomepageWidget> createState() => _PageHomepageWidgetState();
}

class _PageHomepageWidgetState extends State<PageHomepageWidget> {
  late PageHomepageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageHomepageModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'EBasura',
                style: FlutterFlowTheme.of(context).brandWordmark.override(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
              ),
              const SizedBox(width: 4.0),
              Container(
                width: 8.0,
                height: 8.0,
                decoration: const BoxDecoration(
                  color: Color(0xFF31A11F),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Semantics(
                label: 'Notifications',
                button: true,
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'No new notifications at this time.',
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).accent3,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD5F2E2),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: FlutterFlowTheme.of(context).accent3,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              Icons.info_outline_rounded,
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
                  'Exploring as Guest',
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                Text(
                  'Sign in to save points, claim rewards & track streaks.',
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

  Widget _buildHeroGreeting(BuildContext context, UserRow? user) {
    final isGuest = currentUserUid.isEmpty || user == null;
    final displayName = isGuest
        ? 'Eco Explorer'
        : (user.userName == 'EBasura User' || user.userName == null
            ? (user.userEmail?.split('@').first ?? 'Neighbor')
            : user.userName!);
    final streetRef = user?.userStreetNameRef ?? 'Barangay Central Zone';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).mintTint,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46.0,
            height: 46.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent3,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'E',
                style: GoogleFonts.inter(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                  'Hello, $displayName 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.interTight(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  streetRef,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: isGuest
                  ? FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.25)
                  : FlutterFlowTheme.of(context).ecoSecondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isGuest ? Icons.eco_rounded : Icons.local_fire_department_rounded,
                  color: isGuest
                      ? FlutterFlowTheme.of(context).accent3
                      : FlutterFlowTheme.of(context).ecoPrimary,
                  size: 15.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  isGuest ? 'Guest' : 'Active',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: isGuest
                        ? FlutterFlowTheme.of(context).accent3
                        : FlutterFlowTheme.of(context).ecoPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsAndScanCard(BuildContext context) {
    final isGuest = currentUserUid.isEmpty;

    return EBasuraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ECO POINTS BALANCE',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    if (isGuest)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '0',
                            style: GoogleFonts.interTight(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).ecoPrimary,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'pts (Preview)',
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: FlutterFlowTheme.of(context).accent3,
                            ),
                          ),
                        ],
                      )
                    else
                      FutureBuilder<List<UserSubtableRow>>(
                        future: UserSubtableTable().queryRows(
                          queryFn: (q) => q.eqOrNull('user_idRef', currentUserUid),
                        ),
                        builder: (context, snapshot) {
                          final pts = snapshot.hasData && snapshot.data!.isNotEmpty
                              ? snapshot.data!.first.userPoints ?? 0
                              : 0;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$pts',
                                style: GoogleFonts.interTight(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).ecoPrimary,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                'pts',
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    const SizedBox(height: 4.0),
                    Text(
                      isGuest
                          ? 'Earn +25 pts per verified recyclable scan'
                          : 'Top contributor in your community',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: EBasuraButton.button2(
              text: 'Scan Waste with AI',
              icon: const Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
                size: 20.0,
              ),
              onPressed: () async {
                if (isGuest) {
                  context.pushNamed(PImgUploadAGuestWidget.routeName);
                } else {
                  context.pushNamed(
                    PImgUploadAAuthWidget.routeName,
                    queryParameters: {
                      'autoTriggerCamera': serializeParam(true, ParamType.bool),
                    }.withoutNulls,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCountdownCard(BuildContext context) {
    return FutureBuilder<List<CollectionRow>>(
      future: CollectionTable().queryRows(
        queryFn: (q) => q.order('collection_day'),
      ),
      builder: (context, snapshot) {
        final collections = snapshot.data ?? [];
        final nextCollection = collections.isNotEmpty ? collections.first : null;

        return EBasuraCard(
          child: InkWell(
            onTap: () async {
              context.pushNamed(PDatesViewAllWidget.routeName);
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Row(
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
                        'NEXT COLLECTION PICKUP',
                        style: GoogleFonts.inter(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        nextCollection != null
                            ? '${nextCollection.collectionDay} • ${nextCollection.collectionStreetNameRef}'
                            : 'Daily Barangay Schedule',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.interTight(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      Text(
                        nextCollection != null
                            ? '${nextCollection.collectionTimeDurationStart} - ${nextCollection.collectionTimeDurationEnd}'
                            : 'Tap to view all collection dates',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: FlutterFlowTheme.of(context).accent4,
                  size: 16.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreetTrendsSection(BuildContext context) {
    return FutureBuilder<List<StreetRow>>(
      future: StreetTable().queryRows(
        queryFn: (q) => q.eqOrNull('has_storage', true),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final streets = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Street Waste Monitoring',
                  style: GoogleFonts.interTight(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                Text(
                  '${streets.length} Zones',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).accent3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: streets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final street = streets[index];
                return InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: CUserPtsWidget(streetRef: street),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: EBasuraCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.0,
                          height: 38.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent4.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.signpost_rounded,
                            color: FlutterFlowTheme.of(context).accent3,
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                street.streetName,
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              if (street.streetDescription != null)
                                Text(
                                  street.streetDescription!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.insights_rounded,
                          color: FlutterFlowTheme.of(context).ecoPrimary,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCollectionDatesSection(BuildContext context) {
    return FutureBuilder<List<CollectionRow>>(
      future: CollectionTable().queryRows(
        queryFn: (q) => q,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final collections = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Collection Schedules',
                  style: GoogleFonts.interTight(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.pushNamed(PDatesViewAllWidget.routeName);
                  },
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).accent3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: collections.length > 3 ? 3 : collections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final item = collections[index];
                return InkWell(
                  onTap: () async {
                    context.pushNamed(
                      PDatesViewOneWidget.routeName,
                      queryParameters: {
                        'collectionRef': serializeParam(
                          item,
                          ParamType.SupabaseRow,
                        ),
                      }.withoutNulls,
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: EBasuraCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).mintTint,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            item.collectionDay,
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).accent3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.collectionStreetNameRef,
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              Text(
                                '${item.collectionTimeDurationStart} - ${item.collectionTimeDurationEnd}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: FlutterFlowTheme.of(context).accent4,
                          size: 14.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
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
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopAppBar(context),
                    if (isGuest) ...[
                      const SizedBox(height: 8.0),
                      _buildGuestBanner(context),
                    ],
                    const SizedBox(height: 12.0),
                    if (!isGuest)
                      FutureBuilder<List<UserRow>>(
                        future: UserTable().querySingleRow(
                          queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
                        ),
                        builder: (context, snapshot) {
                          final user = snapshot.hasData && snapshot.data!.isNotEmpty
                              ? snapshot.data!.first
                              : null;
                          return _buildHeroGreeting(context, user);
                        },
                      )
                    else
                      _buildHeroGreeting(context, null),
                    const SizedBox(height: 14.0),
                    _buildPointsAndScanCard(context),
                    const SizedBox(height: 14.0),
                    _buildCollectionCountdownCard(context),
                    const SizedBox(height: 18.0),
                    _buildStreetTrendsSection(context),
                    const SizedBox(height: 18.0),
                    _buildCollectionDatesSection(context),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: CBottomBarWidget(activeRoute: 'Page_Homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
