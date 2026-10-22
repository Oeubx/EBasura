import '/components/ebasura_buttons.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_template_informational_dialog_copy_model.dart';
export 'c_template_informational_dialog_copy_model.dart';

class CTemplateInformationalDialogCopyWidget extends StatefulWidget {
  const CTemplateInformationalDialogCopyWidget({super.key});

  @override
  State<CTemplateInformationalDialogCopyWidget> createState() =>
      _CTemplateInformationalDialogCopyWidgetState();
}

class _CTemplateInformationalDialogCopyWidgetState
    extends State<CTemplateInformationalDialogCopyWidget> {
  late CTemplateInformationalDialogCopyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => CTemplateInformationalDialogCopyModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Widget _buildStepCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: theme.accent4.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              icon,
              size: 20.0,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.comfortaa(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF013448),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: theme.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 20.0,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 12.0,
              bottom: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
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
                const SizedBox(height: 16.0),

                // Title Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F1F8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF2E78A6),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Waste Management Guide',
                            style: GoogleFonts.comfortaa(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF013448),
                            ),
                          ),
                          Text(
                            'How EBasura verifies waste & awards points',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: theme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderColor: theme.accent4.withValues(alpha: 0.35),
                      borderRadius: 18.0,
                      buttonSize: 36.0,
                      fillColor: theme.primaryBackground,
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.primaryText,
                        size: 18.0,
                      ),
                      onPressed: () async => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: theme.accent4.withValues(alpha: 0.25),
                ),
                const SizedBox(height: 16.0),

                // Step Cards
                _buildStepCard(
                  context: context,
                  icon: Icons.photo_camera_rounded,
                  iconColor: const Color(0xFF2E78A6),
                  bgColor: const Color(0xFFE8F1F8),
                  title: '1. Snap Waste Photo',
                  description:
                      'Capture clear photos of properly segregated waste before collection. Our Gemini AI automatically detects recyclability and segregation.',
                ),
                const SizedBox(height: 12.0),

                _buildStepCard(
                  context: context,
                  icon: Icons.verified_rounded,
                  iconColor: const Color(0xFF31A11F),
                  bgColor: const Color(0xFFD5F2E2),
                  title: '2. Sanitation Crew Moderation',
                  description:
                      'Authorized collection crew reviews your upload during pickup, validating compliance with Barangay Batasan Hills guidelines.',
                ),
                const SizedBox(height: 12.0),

                _buildStepCard(
                  context: context,
                  icon: Icons.military_tech_rounded,
                  iconColor: const Color(0xFFD97706),
                  bgColor: const Color(0xFFFEF3C7),
                  title: '3. Earn Milestone Badges',
                  description:
                      'Gain gamification points for valid and segregated waste. Unlock tier badges and contribute to your street leaderboard ranking.',
                ),

                const SizedBox(height: 22.0),

                // Dismiss Button
                EBasuraButton.button2(
                  text: 'Got It',
                  width: double.infinity,
                  height: 44.0,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
