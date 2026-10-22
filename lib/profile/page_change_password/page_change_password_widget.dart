import '/auth/supabase_auth/auth_util.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_change_password_model.dart';
export 'page_change_password_model.dart';

class PageChangePasswordWidget extends StatefulWidget {
  const PageChangePasswordWidget({super.key});

  static String routeName = 'Page_ChangePassword';
  static String routePath = '/pageChangePassword';

  @override
  State<PageChangePasswordWidget> createState() =>
      _PageChangePasswordWidgetState();
}

class _PageChangePasswordWidgetState extends State<PageChangePasswordWidget> {
  late PageChangePasswordModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageChangePasswordModel());
    _model.textFieldPasswordTextController ??= TextEditingController();
    _model.textFieldPasswordFocusNode ??= FocusNode();
    _model.textFieldPasswordVisibility = false;

    _model.textfieldCpasswordTextController ??= TextEditingController();
    _model.textfieldCpasswordFocusNode ??= FocusNode();
    _model.textfieldCpasswordVisibility = false;

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
                      title: 'Change Password',
                      subtitle:
                          'Update and rotate your account login password',
                      icon: Icons.lock_rounded,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
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
                      child: Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Password',
                              style: GoogleFonts.inter(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF013448),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            TextFormField(
                              controller:
                                  _model.textFieldPasswordTextController,
                              focusNode: _model.textFieldPasswordFocusNode,
                              obscureText: !_model.textFieldPasswordVisibility,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: theme.primaryText,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Minimum 8 characters',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  color: const Color(0xFF94A3B8),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFF2E78A6),
                                  size: 20.0,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(
                                    () => _model.textFieldPasswordVisibility =
                                        !_model.textFieldPasswordVisibility,
                                  ),
                                  child: Icon(
                                    _model.textFieldPasswordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF64748B),
                                    size: 20.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF2E78A6),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 14.0,
                                ),
                              ),
                              validator: _model
                                  .textFieldPasswordTextControllerValidator
                                  .asValidator(context),
                            ),
                            const SizedBox(height: 18.0),
                            Text(
                              'Confirm Password',
                              style: GoogleFonts.inter(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF013448),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            TextFormField(
                              controller:
                                  _model.textfieldCpasswordTextController,
                              focusNode: _model.textfieldCpasswordFocusNode,
                              obscureText:
                                  !_model.textfieldCpasswordVisibility,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: theme.primaryText,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Re-enter your new password',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  color: const Color(0xFF94A3B8),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_reset_rounded,
                                  color: Color(0xFF2E78A6),
                                  size: 20.0,
                                ),
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(
                                    () => _model.textfieldCpasswordVisibility =
                                        !_model.textfieldCpasswordVisibility,
                                  ),
                                  child: Icon(
                                    _model.textfieldCpasswordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF64748B),
                                    size: 20.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFF2E78A6),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDC2626),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 14.0,
                                ),
                              ),
                              validator: _model
                                  .textfieldCpasswordTextControllerValidator
                                  .asValidator(context),
                            ),
                            const SizedBox(height: 24.0),
                            FFButtonWidget(
                              onPressed: _isUpdating
                                  ? null
                                  : () async {
                                      if (!_model.formKey.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      final p1 = _model
                                          .textFieldPasswordTextController?.text;
                                      final p2 = _model
                                          .textfieldCpasswordTextController
                                          ?.text;
                                      if (p1 != p2) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Passwords do not match!',
                                            ),
                                            backgroundColor: Color(0xFFDC2626),
                                          ),
                                        );
                                        return;
                                      }

                                      setState(() => _isUpdating = true);
                                      try {
                                        await authManager.updatePassword(
                                          newPassword: p1!,
                                          context: context,
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Password changed successfully!',
                                              ),
                                              backgroundColor:
                                                  Color(0xFF31A11F),
                                            ),
                                          );
                                          context.safePop();
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to update password: $e',
                                              ),
                                              backgroundColor:
                                                  const Color(0xFFDC2626),
                                            ),
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isUpdating = false);
                                        }
                                      }
                                    },
                              text: _isUpdating
                                  ? 'Updating...'
                                  : 'Update Password',
                              icon: _isUpdating
                                  ? null
                                  : const Icon(
                                      Icons.security_rounded,
                                      size: 18.0,
                                    ),
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48.0,
                                color: const Color(0xFF2E78A6),
                                textStyle: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
}
