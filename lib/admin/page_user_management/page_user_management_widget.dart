import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_user_management_model.dart';
export 'page_user_management_model.dart';

class PageUserManagementWidget extends StatefulWidget {
  const PageUserManagementWidget({super.key});

  static String routeName = 'Page_UserManagement';
  static String routePath = '/pageUserManagement';

  @override
  State<PageUserManagementWidget> createState() =>
      _PageUserManagementWidgetState();
}

class _PageUserManagementWidgetState extends State<PageUserManagementWidget> {
  late PageUserManagementModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageUserManagementModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Color _getRoleColor(String? role, FlutterFlowTheme theme) {
    switch (role) {
      case 'Admin':
        return theme.accent3; // #2E78A6 Ocean Blue
      case 'Crew':
        return theme.ecoPrimary; // #31A11F Eco Green
      case 'User':
      default:
        return theme.accent4; // #A3C9D9 Sky Blue
    }
  }

  Widget _getRoleIcon(String? role, FlutterFlowTheme theme) {
    switch (role) {
      case 'Admin':
        return Icon(
          Icons.admin_panel_settings_rounded,
          color: theme.accent3,
          size: 22.0,
        );
      case 'Crew':
        return Icon(
          Icons.engineering_rounded,
          color: theme.ecoPrimary,
          size: 22.0,
        );
      case 'User':
      default:
        return Icon(
          Icons.person_rounded,
          color: theme.accent3,
          size: 22.0,
        );
    }
  }

  Color _getRoleBadgeBackground(String? role, FlutterFlowTheme theme) {
    switch (role) {
      case 'Admin':
        return theme.accent3;
      case 'Crew':
        return theme.ecoPrimary;
      case 'User':
      default:
        return theme.secondaryBackground; // #D5F2E2 mint
    }
  }

  Color _getRoleBadgeTextColor(String? role, FlutterFlowTheme theme) {
    switch (role) {
      case 'Admin':
      case 'Crew':
        return Colors.white;
      case 'User':
      default:
        return theme.ecoPrimary;
    }
  }

  Future<void> _updateUserRole(
      String userId, String targetRole, String userName) async {
    try {
      await UserTable().update(
        data: {
          'user_type': targetRole,
        },
        matchingRows: (rows) => rows.eqOrNull('user_id', userId),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$userName is now assigned as "$targetRole".',
              style: GoogleFonts.interTight(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            duration: const Duration(milliseconds: 3000),
            backgroundColor: FlutterFlowTheme.of(context).accent3,
          ),
        );
        safeSetState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update role: $e',
              style: GoogleFonts.interTight(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            duration: const Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Widget _buildRolePill({
    required BuildContext context,
    required UserRow userRow,
    required String roleName,
    required IconData icon,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final isCurrent = userRow.userType == roleName;
    final primaryColor = _getRoleColor(roleName, theme);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: FFButtonWidget(
          onPressed: () async {
            if (isCurrent) return;
            await _updateUserRole(
              userRow.userId ?? '',
              roleName,
              userRow.userName ?? 'User',
            );
          },
          text: roleName,
          icon: Icon(
            isCurrent ? Icons.check_circle_rounded : icon,
            size: 15.0,
            color: isCurrent ? Colors.white : theme.primaryText,
          ),
          options: FFButtonOptions(
            height: 38.0,
            padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
            iconPadding:
                const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0),
            color: isCurrent ? primaryColor : const Color(0xFFF2F2F2),
            textStyle: GoogleFonts.interTight(
              fontSize: 12.0,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
              color: isCurrent ? Colors.white : theme.primaryText,
            ),
            elevation: isCurrent ? 1.0 : 0.0,
            borderSide: BorderSide(
              color: isCurrent
                  ? primaryColor
                  : theme.accent4.withValues(alpha: 0.6),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
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
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 12.0, 16.0, 120.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/Horizontal_Logo.png',
                              height: 44.0,
                              fit: BoxFit.contain,
                            ),
                            FlutterFlowIconButton(
                              borderColor:
                                  theme.accent4.withValues(alpha: 0.35),
                              borderRadius: 20.0,
                              buttonSize: 40.0,
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: theme.primaryText,
                                size: 22.0,
                              ),
                              onPressed: () async => context.safePop(),
                            ),
                          ],
                        ),
                      ),
                      const CPageHeaderWidget(
                        title: 'User Management',
                        subtitle:
                            'Manage account roles, crew status & permissions',
                        icon: Icons.manage_accounts_rounded,
                      ),
                      StreamBuilder<List<UserRow>>(
                        stream: _model.listViewSupabaseStream ??= SupaFlow
                            .client
                            .from("User")
                            .stream(primaryKey: ['user_id'])
                            .neqOrNull('user_id', currentUserUid)
                            .order('created_at')
                            .map((list) =>
                                list.map((item) => UserRow(item)).toList()),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: SizedBox(
                                  width: 44.0,
                                  height: 44.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          List<UserRow> listViewUserRowList = snapshot.data!;

                          if (listViewUserRowList.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 36.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: theme.accent4.withValues(alpha: 0.4),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  theme.designToken.shadow.sm,
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: theme.secondaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.group_off_rounded,
                                      size: 36.0,
                                      color: theme.ecoPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'No Other Users Found',
                                    style: GoogleFonts.interTight(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    'All registered users other than your account will appear here.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listViewUserRowList.length,
                            itemBuilder: (context, listViewIndex) {
                              final listViewUserRow =
                                  listViewUserRowList[listViewIndex];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color:
                                          theme.accent4.withValues(alpha: 0.4),
                                      width: 1.0,
                                    ),
                                    boxShadow: [
                                      theme.designToken.shadow.sm,
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 44.0,
                                              height: 44.0,
                                              decoration: BoxDecoration(
                                                color: _getRoleColor(
                                                        listViewUserRow
                                                            .userType,
                                                        theme)
                                                    .withValues(alpha: 0.12),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Center(
                                                child: _getRoleIcon(
                                                    listViewUserRow.userType,
                                                    theme),
                                              ),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      listViewUserRow.userName,
                                                      'Unnamed User',
                                                    ),
                                                    style:
                                                        GoogleFonts.interTight(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: theme.primaryText,
                                                    ),
                                                  ),
                                                  if ((listViewUserRow
                                                              .userEmail ??
                                                          '')
                                                      .isNotEmpty) ...[
                                                    const SizedBox(height: 2.0),
                                                    Text(
                                                      listViewUserRow
                                                          .userEmail!,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12.0,
                                                        color:
                                                            theme.secondaryText,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                  if ((listViewUserRow
                                                              .userStreetNameRef ??
                                                          '')
                                                      .isNotEmpty) ...[
                                                    const SizedBox(height: 4.0),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          size: 13.0,
                                                          color: theme
                                                              .secondaryText,
                                                        ),
                                                        const SizedBox(
                                                            width: 3.0),
                                                        Text(
                                                          listViewUserRow
                                                              .userStreetNameRef!,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 11.0,
                                                            color: theme
                                                                .secondaryText,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: _getRoleBadgeBackground(
                                                    listViewUserRow.userType,
                                                    theme),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Text(
                                                listViewUserRow.userType ??
                                                    'User',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: _getRoleBadgeTextColor(
                                                      listViewUserRow.userType,
                                                      theme),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14.0),
                                        Divider(
                                          height: 1.0,
                                          thickness: 0.8,
                                          color: theme.accent4
                                              .withValues(alpha: 0.3),
                                        ),
                                        const SizedBox(height: 12.0),
                                        Text(
                                          'Change Role:',
                                          style: GoogleFonts.inter(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w600,
                                            color: theme.secondaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildRolePill(
                                              context: context,
                                              userRow: listViewUserRow,
                                              roleName: 'User',
                                              icon: Icons.person_outline_rounded,
                                            ),
                                            _buildRolePill(
                                              context: context,
                                              userRow: listViewUserRow,
                                              roleName: 'Crew',
                                              icon: Icons.engineering_rounded,
                                            ),
                                            _buildRolePill(
                                              context: context,
                                              userRow: listViewUserRow,
                                              roleName: 'Admin',
                                              icon: Icons
                                                  .admin_panel_settings_outlined,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_UserManagement',
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
