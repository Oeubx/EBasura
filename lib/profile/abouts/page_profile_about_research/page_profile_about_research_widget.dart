import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_profile_about_research_model.dart';
export 'page_profile_about_research_model.dart';

class PageProfileAboutResearchWidget extends StatefulWidget {
  const PageProfileAboutResearchWidget({super.key});

  static String routeName = 'Page_ProfileAbout_Research';
  static String routePath = '/pageProfileAboutResearch';

  @override
  State<PageProfileAboutResearchWidget> createState() =>
      _PageProfileAboutResearchWidgetState();
}

class _PageProfileAboutResearchWidgetState
    extends State<PageProfileAboutResearchWidget> {
  late PageProfileAboutResearchModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageProfileAboutResearchModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
              SingleChildScrollView(
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

                    const CPageHeaderWidget(
                      title: 'Research Methodology',
                      subtitle:
                          'Academic study for Barangay Batasan Hills, Quezon City',
                      icon: Icons.biotech_rounded,
                    ),

                    // Card 1: Study Overview & Purpose
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Icons.menu_book_rounded,
                                  size: 18.0,
                                  color: Color(0xFF2E78A6),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Study Overview',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'The study focuses on evaluating the effectiveness of a Mobile Photo-Verified and Crew-Validated Waste Segregation Monitoring System designed for Barangay Batasan Hills, Quezon City. The system aims to improve waste segregation practices by promoting accountability, community participation, and proper monitoring through digital technology and behavioral reinforcement features.',
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              height: 1.5,
                              color: const Color(0xFF334155),
                            ),
                          ),
                          const Divider(
                            height: 24.0,
                            thickness: 1.0,
                            color: Color(0xFFF1F5F9),
                          ),
                          Text(
                            'Purpose of the Study',
                            style: GoogleFonts.comfortaa(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF013448),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'The research aims to address improper waste segregation caused by weak enforcement and lack of accountability. By combining technology with behavioral and community-based approaches, the system encourages residents to develop consistent waste segregation habits and supports barangay officials in monitoring compliance more efficiently.',
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              height: 1.5,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Card 2: Key Methodology Features
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD5F2E2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.checklist_rounded,
                                  size: 18.0,
                                  color: Color(0xFF31A11F),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Key Methodology Features',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          _buildFeatureItem(
                            icon: Icons.camera_alt_outlined,
                            title: 'Photo-Based Submission & Verification',
                            description:
                                'Pre-collection photo logging by residents for traceable disposal records.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.verified_user_outlined,
                            title: 'Collector & Barangay Crew Validation',
                            description:
                                'Manual audit and physical confirmation by collection crew upon pickup.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.monitor_heart_outlined,
                            title: 'Real-Time Monitoring & Reporting',
                            description:
                                'Real-time street reports and compliance tracking dashboard.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.emoji_events_outlined,
                            title: 'Gamified Behavioral Reinforcement',
                            description:
                                'Leaderboards, reward badges, and push notifications to sustain participation.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.people_outline_rounded,
                            title: 'Community-Based Accountability',
                            description:
                                'Street directory level transparency and shared environmental responsibility.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.cloud_done_outlined,
                            title: 'Cloud Database Architecture',
                            description:
                                'Mobile-accessible platform powered by Supabase Postgres cloud storage.',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Card 3: Expected Impact
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFEF3C7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.trending_up_rounded,
                                  size: 18.0,
                                  color: Color(0xFFD97706),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Expected Impact',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          _buildImpactRow(
                            'Improve waste segregation compliance within the barangay',
                          ),
                          _buildImpactRow(
                            'Promote environmental awareness and sustainable habits',
                          ),
                          _buildImpactRow(
                            'Support waste collectors and officials through efficient monitoring tools',
                          ),
                          _buildImpactRow(
                            'Reduce illegal dumping and improper disposal practices',
                          ),
                          _buildImpactRow(
                            'Encourage long-term community participation in waste management',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Card 4: Researchers
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Icons.school_rounded,
                                  size: 18.0,
                                  color: Color(0xFF2E78A6),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Research Team',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          _buildResearcherRow(
                            name: 'Esquivel, Municht A.',
                            role: 'Researcher',
                            avatarColor: const Color(0xFF2E78A6),
                          ),
                          const Divider(
                            height: 16.0,
                            thickness: 1.0,
                            color: Color(0xFFF1F5F9),
                          ),
                          _buildResearcherRow(
                            name: 'Muralidharan, Samuel T.',
                            role: 'Researcher',
                            avatarColor: const Color(0xFF31A11F),
                          ),
                          const Divider(
                            height: 16.0,
                            thickness: 1.0,
                            color: Color(0xFFF1F5F9),
                          ),
                          _buildResearcherRow(
                            name: 'Remo, Prince Amorsolo C.',
                            role: 'Researcher',
                            avatarColor: const Color(0xFF70BF5A),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Bar
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

  Widget _buildCard({required Widget child}) {
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
      child: child,
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0.0 : 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            margin: const EdgeInsets.only(top: 2.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2E78A6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              size: 16.0,
              color: const Color(0xFF2E78A6),
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
                    fontSize: 13.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactRow(String text, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0.0 : 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Icon(
              Icons.check_circle_rounded,
              size: 16.0,
              color: Color(0xFF31A11F),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF334155),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResearcherRow({
    required String name,
    required String role,
    required Color avatarColor,
  }) {
    final initials = name
        .split(',')
        .first
        .trim()
        .substring(0, 1)
        .toUpperCase();

    return Row(
      children: [
        CircleAvatar(
          radius: 18.0,
          backgroundColor: avatarColor.withValues(alpha: 0.15),
          child: Text(
            initials,
            style: GoogleFonts.comfortaa(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: avatarColor,
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                role,
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
