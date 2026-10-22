import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_sign_up_model.dart';
export 'page_sign_up_model.dart';

class PageSignUpWidget extends StatefulWidget {
  const PageSignUpWidget({super.key});

  static String routeName = 'Page_signUp';
  static String routePath = '/pageSignUp';

  @override
  State<PageSignUpWidget> createState() => _PageSignUpWidgetState();
}

class _PageSignUpWidgetState extends State<PageSignUpWidget> {
  late PageSignUpModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageSignUpModel());

    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();

    _model.textFieldPasswordTextController ??= TextEditingController();
    _model.textFieldPasswordFocusNode ??= FocusNode();

    _model.textfieldCpasswordTextController ??= TextEditingController();
    _model.textfieldCpasswordFocusNode ??= FocusNode();

    _model.checkboxValue = false;

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!(_model.formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_model.checkboxValue != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms and Conditions to proceed.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _model.textFieldEmailTextController!.text.trim();
      final password = _model.textFieldPasswordTextController!.text;
      final confirmPassword = _model.textfieldCpasswordTextController!.text;

      _model.signUpError = await actions.signUpValidation(
        email,
        password,
        confirmPassword,
      );

      if (_model.signUpError != null && _model.signUpError!.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_model.signUpError!),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
        return;
      }

      if (!mounted) return;
      context.goNamed(
        PageVerifyEmailWidget.routeName,
        queryParameters: {
          'userEmail': serializeParam(email, ParamType.String),
          'userPassword': serializeParam(password, ParamType.String),
          'userConfirmPassword':
              serializeParam(confirmPassword, ParamType.String),
        }.withoutNulls,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: $e'),
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

                // Elevated Sign Up Card
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
                          'Create Account',
                          style: GoogleFonts.comfortaa(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF013448),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Join your community to report waste and earn badges',
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
                            hintText: 'Minimum 8 characters',
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
                        const SizedBox(height: 14.0),

                        // Confirm Password Field
                        Text(
                          'Confirm Password',
                          style: GoogleFonts.inter(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        TextFormField(
                          controller: _model.textfieldCpasswordTextController,
                          focusNode: _model.textfieldCpasswordFocusNode,
                          obscureText: !_model.textfieldCpasswordVisibility,
                          decoration: InputDecoration(
                            hintText: 'Re-enter your password',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.0,
                              color: theme.secondaryText.withValues(alpha: 0.6),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_reset_rounded,
                              size: 18.0,
                              color: Color(0xFF2E78A6),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _model.textfieldCpasswordVisibility =
                                      !_model.textfieldCpasswordVisibility;
                                });
                              },
                              child: Icon(
                                _model.textfieldCpasswordVisibility
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
                              .textfieldCpasswordTextControllerValidator
                              ?.asValidator(context),
                        ),
                        const SizedBox(height: 14.0),

                        // Terms and Conditions Checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _model.checkboxValue ?? false,
                              activeColor: const Color(0xFF2E78A6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              onChanged: (val) {
                                setState(() => _model.checkboxValue = val);
                              },
                            ),
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'I agree to the ',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      context.pushNamed(
                                          TermsAndConditionsWidget.routeName);
                                    },
                                    child: Text(
                                      'Terms and Conditions',
                                      style: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2E78A6),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18.0),

                        // Sign Up CTA Button (Button 2)
                        EBasuraButton.button2(
                          text: 'Sign Up',
                          width: double.infinity,
                          height: 48.0,
                          isLoading: _isLoading,
                          iconData: Icons.person_add_rounded,
                          onPressed: _handleSignUp,
                        ),

                        const SizedBox(height: 20.0),

                        // Sign In Link Row
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Already have an Account? ',
                                style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  color: theme.secondaryText,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  context.pushNamed(
                                      PageSignInWidget.routeName);
                                },
                                child: Text(
                                  'Sign In',
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
