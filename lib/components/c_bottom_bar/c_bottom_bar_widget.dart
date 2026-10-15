import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_bottom_bar_model.dart';
export 'c_bottom_bar_model.dart';

class CBottomBarWidget extends StatefulWidget {
  const CBottomBarWidget({
    super.key,
    this.activeRoute,
  });

  final String? activeRoute;

  @override
  State<CBottomBarWidget> createState() => _CBottomBarWidgetState();
}

class _CBottomBarWidgetState extends State<CBottomBarWidget> {
  late CBottomBarModel _model;
  static UserRole? _cachedRole;
  UserRole _currentRole = _cachedRole ?? UserRole.resident;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CBottomBarModel());
    _initializeUserRole();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _initializeUserRole() async {
    if (currentUserUid.isEmpty) {
      if (mounted && _currentRole != UserRole.guest) {
        safeSetState(() {
          _currentRole = UserRole.guest;
        });
      }
      return;
    }
    if (_cachedRole != null) {
      _currentRole = _cachedRole!;
    }
    try {
      final role = await RoleService.fetchCurrentUserRole();
      _cachedRole = role;
      if (mounted && _currentRole != role) {
        safeSetState(() {
          _currentRole = role;
        });
      }
    } catch (_) {
      // Safe fallback to default resident role
    }
  }

  String _getCurrentRoute(BuildContext context) {
    if (widget.activeRoute != null && widget.activeRoute!.isNotEmpty) {
      return widget.activeRoute!;
    }
    try {
      return GoRouterState.of(context).uri.toString();
    } catch (_) {
      return '';
    }
  }

  bool _isRouteActive(
    BuildContext context,
    String routeName,
    String routePath,
  ) {
    final current = _getCurrentRoute(context);
    if (current.isEmpty) {
      return false;
    }
    if (current == routePath || current.startsWith('$routePath/')) {
      return true;
    }
    if (widget.activeRoute != null && widget.activeRoute == routeName) {
      return true;
    }
    final cleanRouteName = routeName
        .toLowerCase()
        .replaceAll('widget', '')
        .replaceAll('page_', '');
    final cleanCurrent = current
        .toLowerCase()
        .replaceAll('widget', '')
        .replaceAll('page_', '')
        .replaceAll('/', '');
    return cleanCurrent == cleanRouteName;
  }

  void _onTabTapped(
    BuildContext context,
    String routeName,
    String routePath,
  ) {
    final current = _getCurrentRoute(context);
    if (current == routePath) {
      return;
    }
    context.pushNamed(routeName);
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String routeName,
    required String routePath,
    required VoidCallback onTap,
  }) {
    final isActive = _isRouteActive(context, routeName, routePath);
    final activeColor = FlutterFlowTheme.of(context).accent3;
    const inactiveColor = Color(0xFF64748B);

    return Expanded(
      child: Semantics(
        label: label,
        selected: isActive,
        button: true,
        child: InkWell(
          onTap: onTap,
          splashColor: activeColor.withValues(alpha: 0.08),
          highlightColor: Colors.transparent,
          child: SizedBox(
            height: 68.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? FlutterFlowTheme.of(context).secondaryBackground
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(
                    icon,
                    color: isActive ? activeColor : inactiveColor,
                    size: 22.0,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? activeColor : inactiveColor,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterCameraFab(BuildContext context) {
    return Positioned(
      bottom: 24.0,
      child: Semantics(
        label: 'Open AI Waste Scanner Camera',
        button: true,
        child: InkWell(
          onTap: () async {
            if (currentUserUid.isEmpty) {
              context.pushNamed(PImgUploadAGuestWidget.routeName);
            } else {
              final isResident = _currentRole != UserRole.admin;
              context.pushNamed(
                PImgUploadAAuthWidget.routeName,
                queryParameters: {
                  if (isResident)
                    'autoTriggerCamera': serializeParam(true, ParamType.bool),
                }.withoutNulls,
              );
            }
          },
          borderRadius: BorderRadius.circular(27.0),
          child: Container(
            width: 54.0,
            height: 54.0,
            decoration: BoxDecoration(
              color: const Color(0xFF2E78A6),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF31A11F),
                width: 2.5,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10.0,
                  color: Color(0x3531A11F),
                  offset: Offset(0, 3),
                ),
                BoxShadow(
                  blurRadius: 8.0,
                  color: Color(0x1E000000),
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.photo_camera_rounded,
                color: Colors.white,
                size: 26.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> navItems;

    if (_currentRole == UserRole.crew) {
      navItems = [
        _buildNavItem(
          context: context,
          icon: Icons.local_shipping_rounded,
          label: 'Routes',
          routeName: PageCrewDashboardWidget.routeName,
          routePath: PageCrewDashboardWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PageCrewDashboardWidget.routeName,
            PageCrewDashboardWidget.routePath,
          ),
        ),
        _buildNavItem(
          context: context,
          icon: Icons.checklist_rounded,
          label: 'Pickups',
          routeName: PDatesViewAllWidget.routeName,
          routePath: PDatesViewAllWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PDatesViewAllWidget.routeName,
            PDatesViewAllWidget.routePath,
          ),
        ),
        const SizedBox(width: 58.0),
        _buildNavItem(
          context: context,
          icon: Icons.report_problem_rounded,
          label: 'Reports',
          routeName: PReportViewAllWidget.routeName,
          routePath: PReportViewAllWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PReportViewAllWidget.routeName,
            PReportViewAllWidget.routePath,
          ),
        ),
        _buildNavItem(
          context: context,
          icon: Icons.person_rounded,
          label: 'Profile',
          routeName: PageProfileWidget.routeName,
          routePath: PageProfileWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PageProfileWidget.routeName,
            PageProfileWidget.routePath,
          ),
        ),
      ];
    } else if (_currentRole == UserRole.admin) {
      navItems = [
        _buildNavItem(
          context: context,
          icon: Icons.admin_panel_settings_rounded,
          label: 'Admin',
          routeName: PageAdminDashboardWidget.routeName,
          routePath: PageAdminDashboardWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PageAdminDashboardWidget.routeName,
            PageAdminDashboardWidget.routePath,
          ),
        ),
        _buildNavItem(
          context: context,
          icon: Icons.verified_user_rounded,
          label: 'Review',
          routeName: PImagesViewAllWidget.routeName,
          routePath: PImagesViewAllWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PImagesViewAllWidget.routeName,
            PImagesViewAllWidget.routePath,
          ),
        ),
        const SizedBox(width: 58.0),
        _buildNavItem(
          context: context,
          icon: Icons.calendar_month_rounded,
          label: 'Schedules',
          routeName: PDatesViewAllWidget.routeName,
          routePath: PDatesViewAllWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PDatesViewAllWidget.routeName,
            PDatesViewAllWidget.routePath,
          ),
        ),
        _buildNavItem(
          context: context,
          icon: Icons.group_rounded,
          label: 'Users',
          routeName: PageUserManagementWidget.routeName,
          routePath: PageUserManagementWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PageUserManagementWidget.routeName,
            PageUserManagementWidget.routePath,
          ),
        ),
      ];
    } else {
      // Resident & Guest navigation
      final isGuest = currentUserUid.isEmpty;
      navItems = [
        _buildNavItem(
          context: context,
          icon: Icons.space_dashboard_rounded,
          label: 'Home',
          routeName: PageHomepageWidget.routeName,
          routePath: PageHomepageWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PageHomepageWidget.routeName,
            PageHomepageWidget.routePath,
          ),
        ),
        _buildNavItem(
          context: context,
          icon: Icons.leaderboard_rounded,
          label: 'Rankings',
          routeName: PageLeaderboardWidget.routeName,
          routePath: PageLeaderboardWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PageLeaderboardWidget.routeName,
            PageLeaderboardWidget.routePath,
          ),
        ),
        const SizedBox(width: 58.0),
        _buildNavItem(
          context: context,
          icon: Icons.explore_rounded,
          label: 'Explore',
          routeName: PageViewSubFeaturesWidget.routeName,
          routePath: PageViewSubFeaturesWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            PageViewSubFeaturesWidget.routeName,
            PageViewSubFeaturesWidget.routePath,
          ),
        ),
        _buildNavItem(
          context: context,
          icon: Icons.person_rounded,
          label: isGuest ? 'Sign In' : 'Profile',
          routeName: isGuest
              ? LandingPageWidget.routeName
              : PageProfileWidget.routeName,
          routePath: isGuest
              ? LandingPageWidget.routePath
              : PageProfileWidget.routePath,
          onTap: () => _onTabTapped(
            context,
            isGuest
                ? LandingPageWidget.routeName
                : PageProfileWidget.routeName,
            isGuest
                ? LandingPageWidget.routePath
                : PageProfileWidget.routePath,
          ),
        ),
      ];
    }

    final secondaryBg = FlutterFlowTheme.of(context).secondaryBackground;
    final borderColor = secondaryBg == const Color(0xFFD5F2E2)
        ? const Color(0xFFD5F2E2)
        : const Color(0xFFE2E8F0);

    return Align(
      alignment: const AlignmentDirectional(0.0, 1.0),
      child: SizedBox(
        width: double.infinity,
        height: 82.0,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: const AlignmentDirectional(0.0, 1.0),
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 1.0),
              child: Container(
                width: double.infinity,
                height: 68.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: borderColor,
                      width: 1.0,
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Color(0x14000000),
                      offset: Offset(0.0, -2.0),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: navItems,
                ),
              ),
            ),
            _buildCenterCameraFab(context),
          ],
        ),
      ),
    );
  }
}
