import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_filtered_images_model.dart';
export 'page_filtered_images_model.dart';

class PageFilteredImagesWidget extends StatefulWidget {
  const PageFilteredImagesWidget({super.key});

  static String routeName = 'Page_FilteredImages';
  static String routePath = '/pageFilteredImages';

  @override
  State<PageFilteredImagesWidget> createState() =>
      _PageFilteredImagesWidgetState();
}

class _PageFilteredImagesWidgetState extends State<PageFilteredImagesWidget> {
  late PageFilteredImagesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageFilteredImagesModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
        backgroundColor: const Color(0xFFF2F2F2),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Brand Header Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: () => context.safePop(),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD5F2E2),
                                width: 1.0,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 4.0,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF2E78A6),
                              size: 20.0,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/Horizontal_Logo.png',
                          height: 42.0,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 40.0),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Page Header Widget
                    const CPageHeaderWidget(
                      title: 'Filtered Waste Feeds',
                      subtitle:
                          'Quickly jump into waste records segmented by AI status, compliance, or moderation flags',
                      icon: Icons.filter_alt_rounded,
                    ),
                    const SizedBox(height: 16.0),

                    // Filter Quick Action Cards
                    _buildFilterCard(
                      title: 'Categorized by AI',
                      subtitle: 'Waste images analyzed by Gemini AI awaiting crew confirmation',
                      icon: Icons.smart_toy_rounded,
                      iconColor: const Color(0xFF2E78A6),
                      badgeText: 'AI Scan',
                      onTap: () => context.pushNamed(PImagesViewAllAiWidget.routeName),
                    ),
                    const SizedBox(height: 12.0),

                    _buildFilterCard(
                      title: 'Segregated Waste',
                      subtitle: 'Submissions marked as compliant with proper source separation',
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF31A11F),
                      badgeText: 'Compliant',
                      onTap: () => context.pushNamed(PImagesViewAllSegregatedWidget.routeName),
                    ),
                    const SizedBox(height: 12.0),

                    _buildFilterCard(
                      title: 'Unsegregated Waste',
                      subtitle: 'Mixed or improperly sorted waste requiring collection warnings',
                      icon: Icons.delete_sweep_rounded,
                      iconColor: const Color(0xFFE65100),
                      badgeText: 'Needs Attention',
                      onTap: () => context.pushNamed(PImagesViewAllUnsegregatedWidget.routeName),
                    ),
                    const SizedBox(height: 12.0),

                    _buildFilterCard(
                      title: 'Verified Records',
                      subtitle: 'Audited submissions approved by Barangay collection personnel',
                      icon: Icons.verified_rounded,
                      iconColor: const Color(0xFF70BF5A),
                      badgeText: 'Official',
                      onTap: () => context.pushNamed(PImagesViewAllVerifiedWidget.routeName),
                    ),
                    const SizedBox(height: 12.0),

                    _buildFilterCard(
                      title: 'Flagged & Disputed',
                      subtitle: 'Records contested by residents or flagged for secondary verification',
                      icon: Icons.flag_rounded,
                      iconColor: const Color(0xFFD32F2F),
                      badgeText: 'Review Queue',
                      onTap: () => context.pushNamed(PImagesViewAllFlaggedWidget.routeName),
                    ),
                    const SizedBox(height: 12.0),

                    _buildFilterCard(
                      title: 'Uncategorized Waste',
                      subtitle: 'Raw uploads pending automated AI categorization or manual sorting',
                      icon: Icons.help_outline_rounded,
                      iconColor: const Color(0xFF546E7A),
                      badgeText: 'Pending',
                      onTap: () => context.pushNamed(PImagesViewAllUncategorizedWidget.routeName),
                    ),
                  ],
                ),
              ),

              // Pinned Bottom Dock
              Align(
                alignment: Alignment.bottomCenter,
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'P_Images_ViewAll',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String badgeText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.0),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: const Color(0xFFD5F2E2),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.0,
              height: 46.0,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.0,
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2E78A6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          badgeText,
                          style: GoogleFonts.inter(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFD5F2E2),
                  width: 1.0,
                ),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF2E78A6),
                size: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
