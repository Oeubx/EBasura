import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_image_informational_dialog_model.dart';
export 'c_image_informational_dialog_model.dart';

class CImageInformationalDialogWidget extends StatefulWidget {
  const CImageInformationalDialogWidget({super.key});

  @override
  State<CImageInformationalDialogWidget> createState() =>
      _CImageInformationalDialogWidgetState();
}

class _CImageInformationalDialogWidgetState
    extends State<CImageInformationalDialogWidget>
    with TickerProviderStateMixin {
  late CImageInformationalDialogModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CImageInformationalDialogModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16.0,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12.0),
          Center(
            child: Container(
              width: 44.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Top Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5F2E2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.lightbulb_rounded,
                        color: Color(0xFF2E78A6),
                        size: 22.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How It Works',
                          style: GoogleFonts.comfortaa(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2E78A6),
                          ),
                        ),
                        Text(
                          'Scanning guidelines, point awards & badges',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(18.0),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD5F2E2),
                        width: 1.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.black54,
                      size: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14.0),

          // Pill TabBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 44.0,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: TabBar(
                controller: _model.tabBarController,
                indicator: BoxDecoration(
                  color: const Color(0xFF2E78A6),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                labelStyle: GoogleFonts.inter(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Guide'),
                  Tab(text: 'Points'),
                  Tab(text: 'Badges'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // TabBar Views
          Expanded(
            child: TabBarView(
              controller: _model.tabBarController,
              children: [
                _buildGuideTab(),
                _buildPointsTab(),
                _buildBadgesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 24.0),
      child: Column(
        children: [
          _buildStepCard(
            stepNumber: '1',
            icon: Icons.camera_alt_rounded,
            title: 'Capture Segregated Waste',
            subtitle:
                'Take a clear, well-lit photo of your segregated waste before pickup. Ensure items are categorized properly (Biodegradable, Recyclable, or Non-Bio).',
            pillText: 'No points yet at upload',
            pillColor: const Color(0xFFE65100),
          ),
          const SizedBox(height: 12.0),
          _buildStepCard(
            stepNumber: '2',
            icon: Icons.auto_awesome_rounded,
            title: 'AI & Verifier Moderation',
            subtitle:
                'Google Gemini AI automatically inspects the image contents. Barangay waste collection crew or administrators then audit and confirm the segregation.',
            pillText: 'Pending Crew Audit',
            pillColor: const Color(0xFF2E78A6),
          ),
          const SizedBox(height: 12.0),
          _buildStepCard(
            stepNumber: '3',
            icon: Icons.emoji_events_rounded,
            title: 'Receive Points & Unlock Badges',
            subtitle:
                'Once verified, eco-points are immediately credited to your account! Climb the community leaderboard and unlock recognition badges.',
            pillText: '+20 Eco Points on verification',
            pillColor: const Color(0xFF31A11F),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required IconData icon,
    required String title,
    required String subtitle,
    required String pillText,
    required Color pillColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFD5F2E2),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.0,
            height: 38.0,
            decoration: const BoxDecoration(
              color: Color(0xFF2E78A6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: GoogleFonts.comfortaa(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E78A6),
                        ),
                      ),
                    ),
                    Icon(icon, size: 18.0, color: const Color(0xFF2E78A6)),
                  ],
                ),
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: Colors.black54,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    color: pillColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: pillColor.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    pillText,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: pillColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Points System Rules',
            style: GoogleFonts.comfortaa(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E78A6),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Eco points are awarded upon successful verification and deducted for fraudulent or unrelated content.',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14.0),
          _buildPointItem(
            points: '+20 pts',
            title: 'Verified Segregated Waste',
            desc: 'Household waste properly segregated according to Barangay Batasan categories.',
            isPositive: true,
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(height: 10.0),
          _buildPointItem(
            points: '+15 pts',
            title: 'Clean Recyclables Captured',
            desc: 'Plastic bottles, cartons, glass containers, and metal scraps ready for recycling.',
            isPositive: true,
            icon: Icons.recycling_rounded,
          ),
          const SizedBox(height: 10.0),
          _buildPointItem(
            points: '+10 pts',
            title: 'Daily Scanning Streak',
            desc: 'Consecutive daily activity bonus for consistently logging household disposal.',
            isPositive: true,
            icon: Icons.local_fire_department_rounded,
          ),
          const SizedBox(height: 10.0),
          _buildPointItem(
            points: '-50 pts',
            title: 'Unrelated / Invalid Content',
            desc: 'Uploading fake photos, unrelated images, or spam incurs an automated penalty.',
            isPositive: false,
            icon: Icons.warning_amber_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPointItem({
    required String points,
    required String title,
    required String desc,
    required bool isPositive,
    required IconData icon,
  }) {
    final color = isPositive ? const Color(0xFF31A11F) : const Color(0xFFD32F2F);
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isPositive ? const Color(0xFFF1F8E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: isPositive ? const Color(0xFFC8E6C9) : const Color(0xFFFFCDD2),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              points,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16.0, color: color),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.0),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    return FutureBuilder<List<BadgeRow>>(
      future: BadgeTable().queryRows(
        queryFn: (q) => q.order('badge_level'),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E78A6)),
            ),
          );
        }

        final badges = snapshot.data ?? [];

        if (badges.isEmpty) {
          return Center(
            child: Text(
              'No badges configured yet.',
              style: GoogleFonts.inter(color: Colors.black54),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 24.0),
          itemCount: badges.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10.0),
          itemBuilder: (context, index) {
            final badge = badges[index];
            return Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: const Color(0xFFD5F2E2),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5F2E2),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Center(
                      child: Text(
                        '#${badge.badgeLevel ?? (index + 1)}',
                        style: GoogleFonts.comfortaa(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E78A6),
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
                          badge.badgeName ?? 'Eco Badge',
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2E78A6),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          badge.badgeDescription ?? 'Achieve waste management milestones',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF31A11F).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${badge.badgeMinPts ?? 0} pts',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF31A11F),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
