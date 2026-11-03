import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CBadgeCelebrationWidget extends StatelessWidget {
  const CBadgeCelebrationWidget({
    super.key,
    required this.badgeId,
    required this.badgeName,
    required this.badgeDescription,
    required this.badgeLevel,
    required this.ruleType,
    required this.ruleThreshold,
  });

  final String badgeId;
  final String badgeName;
  final String badgeDescription;
  final int badgeLevel;
  final String ruleType;
  final int ruleThreshold;

  static Future<void> show({
    required BuildContext context,
    required String badgeId,
    required String badgeName,
    required String badgeDescription,
    required int badgeLevel,
    required String ruleType,
    required int ruleThreshold,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CBadgeCelebrationWidget(
        badgeId: badgeId,
        badgeName: badgeName,
        badgeDescription: badgeDescription,
        badgeLevel: badgeLevel,
        ruleType: ruleType,
        ruleThreshold: ruleThreshold,
      ),
    );
  }

  String get _achievementMilestoneText {
    switch (ruleType) {
      case 'streak':
        return 'Achieved a $ruleThreshold-week continuous waste segregation streak!';
      case 'segregated_count':
        return 'Completed $ruleThreshold verified segregated waste scans!';
      case 'recyclable_count':
        return 'Diverted $ruleThreshold verified recyclable waste items!';
      case 'report_count':
        return 'Resolved $ruleThreshold validated community incident reports!';
      case 'points':
      default:
        return 'Accumulated $ruleThreshold lifetime eco-points!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 380.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 20.0,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top celebratory gradient header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E78A6), Color(0xFF1B4D6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72.0,
                    height: 72.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD5F2E2),
                        width: 2.0,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFFF59E0B),
                        size: 40.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'NEW BADGE UNLOCKED!',
                    style: GoogleFonts.comfortaa(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD5F2E2),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 3.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF31A11F),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      'Level $badgeLevel Milestone',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content body
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    badgeName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.comfortaa(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF013448),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    badgeDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: const Color(0xFF475569),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1F8),
                      borderRadius: BorderRadius.circular(14.0),
                      border: Border.all(
                        color: const Color(0xFFA3C9D9),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF2E78A6),
                          size: 18.0,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            _achievementMilestoneText,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF013448),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  FFButtonWidget(
                    onPressed: () async {
                      try {
                        await SupaFlow.client.rpc(
                          'mark_badge_seen',
                          params: {'p_badge_id': badgeId},
                        );
                      } catch (e) {
                        debugPrint('Error marking badge seen: $e');
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    text: 'Awesome, Claim Badge!',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 44.0,
                      color: const Color(0xFF31A11F),
                      textStyle: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
