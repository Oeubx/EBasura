import '/components/c_page_header/c_page_header_widget.dart';
import '/components/ebasura_buttons.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'terms_and_conditions_model.dart';
export 'terms_and_conditions_model.dart';

class TermsAndConditionsWidget extends StatefulWidget {
  const TermsAndConditionsWidget({super.key});

  static String routeName = 'Terms_and_Conditions';
  static String routePath = '/termsAndConditions';

  @override
  State<TermsAndConditionsWidget> createState() =>
      _TermsAndConditionsWidgetState();
}

class _TermsAndConditionsWidgetState extends State<TermsAndConditionsWidget> {
  late TermsAndConditionsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermsAndConditionsModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.comfortaa(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF013448),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              color: const Color(0xFF334155),
              height: 1.5,
            ),
          ),
        ],
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with back button
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
                          Icons.close_rounded,
                          color: theme.primaryText,
                          size: 20.0,
                        ),
                        onPressed: () async => context.safePop(),
                      ),
                    ],
                  ),
                ),

                const CPageHeaderWidget(
                  title: 'Terms & Conditions',
                  subtitle:
                      'Barangay Batasan Hills Waste Segregation Guidelines & User Agreement',
                  icon: Icons.gavel_rounded,
                ),

                // Legal Content Document Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: theme.accent4.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                    boxShadow: [
                      theme.designToken.shadow.sm,
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to EBASURA',
                        style: GoogleFonts.comfortaa(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF013448),
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        'These Terms and Conditions govern the use of the EBASURA Mobile Application, a photo-verified and crew-validated waste segregation monitoring system developed for Barangay Batasan Hills, Quezon City. By accessing or using the application, users agree to comply with the terms stated below.',
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: const Color(0xFF334155),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Divider(
                        height: 1.0,
                        thickness: 1.0,
                        color: theme.accent4.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 18.0),

                      _buildSection(
                        '1. Purpose of the Application',
                        'EBASURA is designed to:\n• Promote proper waste segregation practices\n• Support barangay-level waste monitoring and reporting\n• Encourage environmental responsibility and community participation\n• Allow residents to upload waste photos for verification and validation\n\nThe application is intended solely for lawful and environmental waste management purposes.',
                      ),

                      _buildSection(
                        '2. User Responsibilities',
                        'By using the application, users agree to:\n• Provide accurate and truthful information during registration\n• Upload only legitimate and waste-related images\n• Follow proper waste segregation guidelines implemented by the barangay\n• Use the application responsibly and respectfully\n\nUsers must not:\n• Upload misleading, fake, inappropriate, or unrelated content\n• Attempt to manipulate leaderboard rankings or validation results\n• Use another person\'s account without permission\n• Interfere with the system\'s operation or security.',
                      ),

                      _buildSection(
                        '3. Photo Submission and Verification',
                        'Users may upload photos of waste for monitoring and validation purposes. All uploaded images:\n• Must reflect actual waste disposal activities\n• May be reviewed by authorized waste collection crew or barangay officials\n• Can be marked as "Segregated" or "Not Segregated" based on barangay standards\n\nThe application reserves the right to reject or remove invalid submissions.',
                      ),

                      _buildSection(
                        '4. User Data and Privacy',
                        'The application complies with the Data Privacy Act of 2012 (Republic Act No. 10173).\nCollected information may include:\n• User profile details\n• Uploaded waste images\n• Street or location references\n• Validation and activity records\n\nThe system does not collect unnecessary sensitive information such as financial or medical data. All collected data are securely stored and accessible only to authorized personnel.',
                      ),

                      _buildSection(
                        '5. Leaderboards, Rewards, and Badges',
                        'EBASURA includes gamification features (digital milestone badges, points, community leaderboards, and schedule reminders) to encourage active community participation. Users agree not to exploit or tamper with points calculations.',
                      ),

                      _buildSection(
                        '6. Account Suspension and Violations',
                        'Administrators reserve the right to suspend or remove accounts that repeatedly submit false content, abuse platform features, or violate barangay waste ordinances.',
                      ),

                      _buildSection(
                        '7. System Availability & Liability',
                        'The application is provided as a municipal monitoring tool. While developers strive for maximum uptime, the system may undergo routine maintenance and updates. The application is an educational and municipal support system.',
                      ),

                      _buildSection(
                        '8. Acceptance of Terms',
                        'By registering, accessing, or using EBASURA, you acknowledge that you have read, understood, and agreed to these Terms and Conditions.',
                      ),

                      const SizedBox(height: 12.0),

                      // Acknowledge Button
                      EBasuraButton.button2(
                        text: 'I Understand & Agree',
                        width: double.infinity,
                        height: 46.0,
                        iconData: Icons.check_circle_outline_rounded,
                        onPressed: () async => context.safePop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
