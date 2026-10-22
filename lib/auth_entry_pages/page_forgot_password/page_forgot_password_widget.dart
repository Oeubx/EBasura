import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_forgot_password_model.dart';
export 'page_forgot_password_model.dart';

class PageForgotPasswordWidget extends StatefulWidget {
  const PageForgotPasswordWidget({super.key});

  static String routeName = 'Page_forgotPassword';
  static String routePath = '/pageForgotPassword';

  @override
  State<PageForgotPasswordWidget> createState() =>
      _PageForgotPasswordWidgetState();
}

class _PageForgotPasswordWidgetState extends State<PageForgotPasswordWidget> {
  late PageForgotPasswordModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageForgotPasswordModel());

    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!(_model.formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _model.textFieldEmailTextController!.text.trim();
      await authManager.resetPassword(
        email: email,
        context: context,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset link sent to $email'),
          backgroundColor: const Color(0xFF31A11F),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reset link: $e'),
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

                const SizedBox(height: 24.0),

                // Elevated Forgot Password Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22.0),
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
                  child: Form(
                    key: _model.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Forgot Password',
                          style: GoogleFonts.comfortaa(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF013448),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          "Enter your email address and we'll send you a password recovery link.",
                          style: GoogleFonts.inter(
                            fontSize: 13.0,
                            color: theme.secondaryText,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Email Field
                        Text(
                          'Email Address',
                          style: GoogleFonts.inter(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        TextFormField(
                          controller: _model.textFieldEmailTextController,
                          focusNode: _model.textFieldEmailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'name@example.com',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.0,
                              color: theme.secondaryText.withValues(alpha: 0.6),
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              size: 18.0,
                              color: Color(0xFF2E78A6),
                            ),
                            filled: true,
                            fillColor: theme.primaryBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(
                                color: theme.accent4.withValues(alpha: 0.35),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF2E78A6),
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFDC2626),
                                width: 1.0,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFDC2626),
                                width: 1.5,
                              ),
                            ),
                          ),
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: theme.primaryText,
                          ),
                          validator: _model
                              .textFieldEmailTextControllerValidator
                              ?.asValidator(context),
                        ),

                        const SizedBox(height: 22.0),

                        // Send Link CTA (Button 2)
                        EBasuraButton.button2(
                          text: 'Send Recovery Link',
                          width: double.infinity,
                          height: 48.0,
                          isLoading: _isLoading,
                          iconData: Icons.send_rounded,
                          onPressed: _handleResetPassword,
                        ),

                        const SizedBox(height: 20.0),

                        // Back to Sign In Link Row
                        Center(
                          child: InkWell(
                            onTap: () async {
                              context.pushNamed(PageSignInWidget.routeName);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.arrow_back_rounded,
                                  size: 16.0,
                                  color: Color(0xFF2E78A6),
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Back to Sign In',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2E78A6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
