import '/auth/supabase_auth/auth_util.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_profile_settings_model.dart';
export 'page_profile_settings_model.dart';

class PageProfileSettingsWidget extends StatefulWidget {
  const PageProfileSettingsWidget({super.key});

  static String routeName = 'Page_ProfileSettings';
  static String routePath = '/pageProfileSettings';

  @override
  State<PageProfileSettingsWidget> createState() =>
      _PageProfileSettingsWidgetState();
}

class _PageProfileSettingsWidgetState extends State<PageProfileSettingsWidget> {
  late PageProfileSettingsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageProfileSettingsModel());
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
                      title: 'Account Settings',
                      subtitle:
                          'Manage profile info, security credentials & explore documentation',
                      icon: Icons.settings_rounded,
                    ),
                    _buildSettingsGroup(
                      title: 'Profile & Credentials',
                      items: [
                        _SettingsItem(
                          icon: Icons.badge_outlined,
                          title: 'Change Profile',
                          subtitle: 'Update your display name & street',
                          onTap: () => context.pushNamed(
                            PageChangeProfileWidget.routeName,
                          ),
                        ),
                        _SettingsItem(
                          icon: Icons.mail_outline_rounded,
                          title: 'Change Email',
                          subtitle: 'Modify your login email address',
                          onTap: () => context.pushNamed(
                            PageChangeEmailWidget.routeName,
                          ),
                        ),
                        _SettingsItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          subtitle: 'Rotate account security password',
                          onTap: () => context.pushNamed(
                            PageChangePasswordWidget.routeName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildSettingsGroup(
                      title: 'Application Information',
                      items: [
                        _SettingsItem(
                          icon: Icons.eco_outlined,
                          title: 'About EBasura',
                          subtitle: 'Platform mission & smart waste vision',
                          onTap: () => context.pushNamed(
                            PageProfileAboutWidget.routeName,
                          ),
                        ),
                        _SettingsItem(
                          icon: Icons.groups_outlined,
                          title: 'Development Team',
                          subtitle: 'ADET academic developers & credits',
                          onTap: () => context.pushNamed(
                            PageProfileAboutADETWidget.routeName,
                          ),
                        ),
                        _SettingsItem(
                          icon: Icons.biotech_outlined,
                          title: 'AI & Research Study',
                          subtitle: 'Methodology, dataset & accuracy insights',
                          onTap: () => context.pushNamed(
                            PageProfileAboutResearchWidget.routeName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildSignOutTile(context, theme),
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

  Widget _buildSettingsGroup({
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: GoogleFonts.comfortaa(
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF013448),
            ),
          ),
        ),
        Container(
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
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: Color(0xFFF1F5F9),
                  ),
                InkWell(
                  onTap: items[i].onTap,
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? const Radius.circular(16.0) : Radius.zero,
                    bottom: i == items.length - 1
                        ? const Radius.circular(16.0)
                        : Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F1F8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            items[i].icon,
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
                                items[i].title,
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                items[i].subtitle,
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
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutTile(BuildContext context, FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFFCA5A5),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () async {
          FFAppState().deleteUsersStreetName();
          FFAppState().usersStreetName = '';

          final router = GoRouter.of(context);
          router.prepareAuthEvent();
          await authManager.signOut();
          router.clearRedirectLocation();

          if (context.mounted) {
            context.goNamedAuth(
              LandingPageWidget.routeName,
              context.mounted,
            );
          }
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 18.0,
                  color: Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Out',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                    Text(
                      'Log out of this device and session',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        color: const Color(0xFF991B1B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18.0,
                color: Color(0xFFDC2626),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsItem {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
