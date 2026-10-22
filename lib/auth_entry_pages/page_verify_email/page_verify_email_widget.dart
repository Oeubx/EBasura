import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_verify_email_model.dart';
export 'page_verify_email_model.dart';

class PageVerifyEmailWidget extends StatefulWidget {
  const PageVerifyEmailWidget({
    super.key,
    required this.userEmail,
    required this.userPassword,
    required this.userConfirmPassword,
  });

  final String? userEmail;
  final String? userPassword;
  final String? userConfirmPassword;

  static String routeName = 'Page_verifyEmail';
  static String routePath = '/pageVerifyEmail';

  @override
  State<PageVerifyEmailWidget> createState() => _PageVerifyEmailWidgetState();
}

class _PageVerifyEmailWidgetState extends State<PageVerifyEmailWidget> {
  late PageVerifyEmailModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageVerifyEmailModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    if (widget.userPassword != widget.userConfirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords don't match!"),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      GoRouter.of(context).prepareAuthEvent();

      final user = await authManager.createAccountWithEmail(
        context,
        widget.userEmail!,
        widget.userPassword!,
      );

      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;
      context.goNamedAuth(PageSignUpWidget.routeName, context.mounted);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account creation error: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final email = widget.userEmail ?? 'your email';

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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with back button
                FlutterFlowIconButton(
                  borderColor: theme.accent4.withValues(alpha: 0.35),
                  borderRadius: 20.0,
                  buttonSize: 40.0,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: theme.primaryText,
                    size: 20.0,
                  ),
                  onPressed: () async => context.safePop(),
                ),

                const SizedBox(height: 16.0),

                // Brand Logo Header
                const Center(
                  child: CBrandLogoWidget(
                    fontSize: 34.0,
                    showSubtitle: true,
                    subtitle: 'Smart Community Waste Management',
                  ),
                ),

                const SizedBox(height: 28.0),

                // Elevated Verification Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: theme.accent4.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                    boxShadow: [
                      theme.designToken.shadow.sm,
                    ],
                  ),
                  child: Column(
                    children: [
                      // Circular Icon
                      Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD5F2E2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_unread_rounded,
                          size: 44.0,
                          color: Color(0xFF31A11F),
                        ),
                      ),
                      const SizedBox(height: 18.0),

                      Text(
                        'Email Verification',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comfortaa(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF013448),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'We are ready to register your account with:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: theme.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA3C9D9).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          email,
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E78A6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Click below to finalize registration. A verification link will be sent to your inbox to confirm your resident identity.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: theme.secondaryText,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      // Complete Registration CTA (Button 2)
                      EBasuraButton.button2(
                        text: 'Complete Registration',
                        width: double.infinity,
                        height: 48.0,
                        isLoading: _isLoading,
                        iconData: Icons.check_circle_outline_rounded,
                        onPressed: _handleCreateAccount,
                      ),

                      const SizedBox(height: 12.0),

                      // Return to Sign Up Button (Button 1)
                      EBasuraButton.button1(
                        text: 'Back to Sign Up',
                        width: double.infinity,
                        height: 44.0,
                        onPressed: () async {
                          context.goNamed(PageSignUpWidget.routeName);
                        },
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
