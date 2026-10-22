import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_profile_about_a_d_e_t_model.dart';
export 'page_profile_about_a_d_e_t_model.dart';

class PageProfileAboutADETWidget extends StatefulWidget {
  const PageProfileAboutADETWidget({super.key});

  static String routeName = 'Page_ProfileAbout_ADET';
  static String routePath = '/pageProfileAboutADET';

  @override
  State<PageProfileAboutADETWidget> createState() =>
      _PageProfileAboutADETWidgetState();
}

class _PageProfileAboutADETWidgetState
    extends State<PageProfileAboutADETWidget> {
  late PageProfileAboutADETModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageProfileAboutADETModel());
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
                      title: 'About ADET Developers',
                      subtitle:
                          'Academic project details, platform features, & contributors',
                      icon: Icons.groups_rounded,
                    ),

                    // Card 1: Overview & Purpose
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
                                  Icons.eco_rounded,
                                  size: 18.0,
                                  color: Color(0xFF31A11F),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Platform Overview',
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
                            'EBASURA is a smart waste classification and segregation mobile application that helps users properly identify and dispose of waste materials using Artificial Intelligence (AI) and Computer Vision technology. By simply uploading or scanning waste images, users can receive instant classification results, segregation feedback, and educational guidance to encourage responsible waste management and environmental awareness.',
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
                            'Purpose',
                            style: GoogleFonts.comfortaa(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF013448),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'EBASURA aims to support communities, garbage collectors, and local administrators by improving waste segregation practices, reducing environmental pollution, and promoting sustainable environmental responsibility through emerging technologies.',
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

                    // Card 2: Key Features
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
                                  Icons.featured_play_list_rounded,
                                  size: 18.0,
                                  color: Color(0xFF2E78A6),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'Key Features',
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
                            icon: Icons.auto_awesome_rounded,
                            title: 'AI-Powered Waste Scanning',
                            description:
                                'Instant waste classification using Google Gemini multimodal vision.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.fact_check_outlined,
                            title: 'Instant Segregation Feedback',
                            description:
                                'Clear disposal steps and recyclability guidance upon scanning.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.verified_user_outlined,
                            title: 'Collector & Admin Verification',
                            description:
                                'Physical validation by waste collection crews and barangay officers.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.local_shipping_outlined,
                            title: 'Collection Schedules & Directory',
                            description:
                                'Integrated street schedule directory and real-time pickup tracking.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.lightbulb_outlined,
                            title: 'Educational Environmental Tips',
                            description:
                                'Practical zero-waste strategies and local segregation laws.',
                          ),
                          _buildFeatureItem(
                            icon: Icons.insights_outlined,
                            title: 'Gamified Activity Tracking',
                            description:
                                'Earn green points, unlock achievement badges, and climb community leaderboards.',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Card 3: Design & Development Credits
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
                                  Icons.palette_rounded,
                                  size: 18.0,
                                  color: Color(0xFFD97706),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                'UI / UX Designers',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          _buildContributorRow(
                            name: 'Coronado, Mikylla C.',
                            role: 'UI/UX Designer',
                            avatarColor: const Color(0xFF2E78A6),
                          ),
                          const Divider(
                            height: 16.0,
                            thickness: 1.0,
                            color: Color(0xFFF1F5F9),
                          ),
                          _buildContributorRow(
                            name: 'Caday, Sofia Faith M.',
                            role: 'UI/UX Designer',
                            avatarColor: const Color(0xFF31A11F),
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

  Widget _buildContributorRow({
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
