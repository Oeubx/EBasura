import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_profile_about_model.dart';
export 'page_profile_about_model.dart';

class PageProfileAboutWidget extends StatefulWidget {
  const PageProfileAboutWidget({super.key});

  static String routeName = 'Page_ProfileAbout';
  static String routePath = '/pageProfileAbout';

  @override
  State<PageProfileAboutWidget> createState() => _PageProfileAboutWidgetState();
}

class _PageProfileAboutWidgetState extends State<PageProfileAboutWidget> {
  late PageProfileAboutModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSavingFeedback = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageProfileAboutModel());
    _model.textFieldFeedbackFocusNode ??= FocusNode();
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
                      title: 'About EBasura',
                      subtitle:
                          'Explore platform mission, academic research & share feedback',
                      icon: Icons.eco_rounded,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18.0),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Related Documentation',
                            style: GoogleFonts.comfortaa(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF013448),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          _buildNavRow(
                            icon: Icons.biotech_outlined,
                            title: 'Research Methodology',
                            subtitle: 'Quezon City study design & validation',
                            onTap: () => context.pushNamed(
                              PageProfileAboutResearchWidget.routeName,
                            ),
                          ),
                          const Divider(
                            height: 16.0,
                            thickness: 1.0,
                            color: Color(0xFFF1F5F9),
                          ),
                          _buildNavRow(
                            icon: Icons.groups_outlined,
                            title: 'About ADET Developers',
                            subtitle: 'Development team & course info',
                            onTap: () => context.pushNamed(
                              PageProfileAboutADETWidget.routeName,
                            ),
                          ),
                          const Divider(
                            height: 16.0,
                            thickness: 1.0,
                            color: Color(0xFFF1F5F9),
                          ),
                          _buildNavRow(
                            icon: Icons.open_in_new_rounded,
                            title: 'View Research Paper',
                            subtitle: 'Official academic study site',
                            onTap: () async {
                              await launchURL(
                                'https://sites.google.com/view/gr6studyforwastesegregationpup/home',
                              );
                            },
                          ),
                          const Divider(
                            height: 16.0,
                            thickness: 1.0,
                            color: Color(0xFFF1F5F9),
                          ),
                          _buildNavRow(
                            icon: Icons.assignment_outlined,
                            title: 'Answer Research Survey',
                            subtitle: 'Help improve waste segregation tools',
                            onTap: () async {
                              await launchURL(
                                'https://docs.google.com/forms/d/e/1FAIpQLSebfxJFuMIrrYfMWg4Fy_Mdg52ETbPGQO7WXdJj2nqDdHFxRg/viewform',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18.0),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Feedback',
                            style: GoogleFonts.comfortaa(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF013448),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Share your suggestions or report issues with the app',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          FutureBuilder<List<UserSubtableRow>>(
                            future: UserSubtableTable().querySingleRow(
                              queryFn: (q) => q.eqOrNull(
                                'user_idRef',
                                currentUserUid,
                              ),
                            ),
                            builder: (context, snapshot) {
                              final existingFeedback =
                                  snapshot.data?.firstOrNull?.feedback ?? '';
                              _model.textFieldFeedbackTextController ??=
                                  TextEditingController(
                                text: existingFeedback,
                              );

                              return Column(
                                children: [
                                  TextFormField(
                                    controller:
                                        _model.textFieldFeedbackTextController,
                                    focusNode:
                                        _model.textFieldFeedbackFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textFieldFeedbackTextController',
                                      const Duration(milliseconds: 100),
                                      () => safeSetState(() {}),
                                    ),
                                    maxLines: 4,
                                    maxLength: 500,
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.enforced,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: theme.primaryText,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your feedback here...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF8FAFC),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE2E8F0),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF2E78A6),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      contentPadding: const EdgeInsets.all(14.0),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  FFButtonWidget(
                                    onPressed: _isSavingFeedback
                                        ? null
                                        : () async {
                                            final feedback = _model
                                                .textFieldFeedbackTextController
                                                ?.text
                                                .trim();
                                            setState(
                                              () => _isSavingFeedback = true,
                                            );
                                            try {
                                              await UserSubtableTable().update(
                                                data: {
                                                  'feedback': feedback ?? '',
                                                },
                                                matchingRows: (rows) =>
                                                    rows.eqOrNull(
                                                  'user_idRef',
                                                  currentUserUid,
                                                ),
                                              );
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Thank you! Feedback saved.',
                                                    ),
                                                    backgroundColor:
                                                        Color(0xFF31A11F),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Failed to save feedback: $e',
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xFFDC2626),
                                                  ),
                                                );
                                              }
                                            } finally {
                                              if (mounted) {
                                                setState(
                                                  () => _isSavingFeedback =
                                                      false,
                                                );
                                              }
                                            }
                                          },
                                    text: _isSavingFeedback
                                        ? 'Saving...'
                                        : 'Submit Feedback',
                                    icon: _isSavingFeedback
                                        ? null
                                        : const Icon(
                                            Icons.send_rounded,
                                            size: 16.0,
                                          ),
                                    options: FFButtonOptions(
                                      width: double.infinity,
                                      height: 44.0,
                                      color: const Color(0xFF2E78A6),
                                      textStyle: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                      elevation: 0.0,
                                      borderRadius:
                                          BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
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

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F1F8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18.0,
                color: const Color(0xFF2E78A6),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.0,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20.0,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
