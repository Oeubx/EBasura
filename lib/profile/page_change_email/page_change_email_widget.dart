import '/auth/supabase_auth/auth_util.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_change_email_model.dart';
export 'page_change_email_model.dart';

class PageChangeEmailWidget extends StatefulWidget {
  const PageChangeEmailWidget({super.key});

  static String routeName = 'Page_ChangeEmail';
  static String routePath = '/pageChangeEmail';

  @override
  State<PageChangeEmailWidget> createState() => _PageChangeEmailWidgetState();
}

class _PageChangeEmailWidgetState extends State<PageChangeEmailWidget> {
  late PageChangeEmailModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageChangeEmailModel());
    _model.textFieldEmailTextController ??= TextEditingController();
    _model.textFieldEmailFocusNode ??= FocusNode();
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
                      title: 'Change Email',
                      subtitle:
                          'Update your registered account authentication email',
                      icon: Icons.mail_rounded,
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
                            if (currentUserEmail.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F1F8),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      color: Color(0xFF2E78A6),
                                      size: 18.0,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Current: $currentUserEmail',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF2E78A6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                            Text(
                              'New Email Address',
                              style: GoogleFonts.inter(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF013448),
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            TextFormField(
                              controller: _model.textFieldEmailTextController,
                              focusNode: _model.textFieldEmailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                color: theme.primaryText,
                              ),
                              decoration: InputDecoration(
                                hintText: 'name@example.com',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  color: const Color(0xFF94A3B8),
                                ),
                                prefixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                  color: Color(0xFF2E78A6),
                                  size: 20.0,
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
                                  .textFieldEmailTextControllerValidator
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
                                      final newEmail = _model
                                          .textFieldEmailTextController?.text
                                          .trim();
                                      if (newEmail == null ||
                                          newEmail.isEmpty) {
                                        return;
                                      }

                                      setState(() => _isUpdating = true);
                                      try {
                                        await authManager.updateEmail(
                                          email: newEmail,
                                          context: context,
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Verification sent to your new email address!',
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
                                                'Failed to update email: $e',
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
                                  : 'Update Email',
                              icon: _isUpdating
                                  ? null
                                  : const Icon(
                                      Icons.send_rounded,
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
