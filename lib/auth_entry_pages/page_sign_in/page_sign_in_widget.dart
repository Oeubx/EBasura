import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_sign_in_model.dart';
export 'page_sign_in_model.dart';

class PageSignInWidget extends StatefulWidget {
  const PageSignInWidget({super.key});

  static String routeName = 'Page_signIn';
  static String routePath = '/pageSignIn';

  @override
  State<PageSignInWidget> createState() => _PageSignInWidgetState();
}

class _PageSignInWidgetState extends State<PageSignInWidget> {
  late PageSignInModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageSignInModel());

    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();

    _model.textFieldPasswordTextController ??= TextEditingController();
    _model.textFieldPasswordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!(_model.formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      GoRouter.of(context).prepareAuthEvent();

      final user = await authManager.signInWithEmail(
        context,
        _model.textFieldEmailTextController!.text.trim(),
        _model.textFieldPasswordTextController!.text,
      );

      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      // Fetch user profile to cache assigned street name
      _model.userQuery = await UserTable().queryRows(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid).limit(1),
      );

      final streetRef = _model.userQuery?.firstOrNull?.userStreetNameRef;
      FFAppState().usersStreetName =
          (streetRef != null && streetRef.isNotEmpty) ? streetRef : 'Street N';

      if (!mounted) return;
      context.goNamedAuth(PageHomepageWidget.routeName, context.mounted);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign In error: $e'),
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

                // Elevated Sign In Card
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
                          'Welcome Back',
                          style: GoogleFonts.comfortaa(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF013448),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Sign in to report waste, view schedules, & track points',
                          style: GoogleFonts.inter(
                            fontSize: 13.0,
                            color: theme.secondaryText,
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
                        const SizedBox(height: 14.0),

                        // Password Field
                        Text(
                          'Password',
                          style: GoogleFonts.inter(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        TextFormField(
                          controller: _model.textFieldPasswordTextController,
                          focusNode: _model.textFieldPasswordFocusNode,
                          obscureText: !_model.textFieldPasswordVisibility,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.0,
                              color: theme.secondaryText.withValues(alpha: 0.6),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              size: 18.0,
                              color: Color(0xFF2E78A6),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _model.textFieldPasswordVisibility =
                                      !_model.textFieldPasswordVisibility;
                                });
                              },
                              child: Icon(
                                _model.textFieldPasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 18.0,
                                color: theme.secondaryText,
                              ),
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
                              .textFieldPasswordTextControllerValidator
                              ?.asValidator(context),
                        ),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () async {
                                context.pushNamed(
                                    PageForgotPasswordWidget.routeName);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E78A6),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22.0),

                        // Sign In CTA Button (Button 2)
                        EBasuraButton.button2(
                          text: 'Sign In',
                          width: double.infinity,
                          height: 48.0,
                          isLoading: _isLoading,
                          iconData: Icons.login_rounded,
                          onPressed: _handleSignIn,
                        ),

                        const SizedBox(height: 20.0),

                        // Sign Up Link Row
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Don't have an Account? ",
                                style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  color: theme.secondaryText,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  context.pushNamed(
                                      PageSignUpWidget.routeName);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2E78A6),
                                  ),
                                ),
                              ),
                            ],
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
