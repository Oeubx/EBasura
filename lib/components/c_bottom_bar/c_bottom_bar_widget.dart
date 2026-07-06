import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_bottom_bar_model.dart';
export 'c_bottom_bar_model.dart';

class CBottomBarWidget extends StatefulWidget {
  const CBottomBarWidget({super.key});

  @override
  State<CBottomBarWidget> createState() => _CBottomBarWidgetState();
}

class _CBottomBarWidgetState extends State<CBottomBarWidget> {
  late CBottomBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CBottomBarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (currentUserUid == null || currentUserUid == '')
          Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: Container(
                  width: double.infinity,
                  height: 75.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondary,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5.0,
                        color: Color(0x3B1D2429),
                        offset: Offset(
                          0.0,
                          -3.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(25.0, 15.0, 25.0, 15.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 50.0,
                          fillColor: FlutterFlowTheme.of(context).secondary,
                          icon: Icon(
                            Icons.space_dashboard_rounded,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(PageHomepageWidget.routeName);
                          },
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 50.0,
                          fillColor: FlutterFlowTheme.of(context).secondary,
                          icon: FaIcon(
                            FontAwesomeIcons.list,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(PageLeaderboardWidget.routeName);
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 15.0, 0.0),
                          child: Container(
                            width: 100.0,
                            decoration: BoxDecoration(),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 50.0,
                          fillColor: FlutterFlowTheme.of(context).secondary,
                          icon: FaIcon(
                            FontAwesomeIcons.scroll,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            context
                                .pushNamed(PageViewSubFeaturesWidget.routeName);
                          },
                        ),
                        if (currentUserUid == null || currentUserUid == '')
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 50.0,
                            icon: Icon(
                              Icons.logout_rounded,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              context.goNamed(LandingPageWidget.routeName);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: FlutterFlowIconButton(
                  borderRadius: 75.0,
                  borderWidth: 0.0,
                  buttonSize: 125.0,
                  fillColor: Color(0xFF263B6A),
                  icon: Icon(
                    Icons.camera,
                    color: Color(0xFFE8EDF2),
                    size: 75.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(PImgUploadAGuestWidget.routeName);
                  },
                ),
              ),
            ],
          ),
        if (currentUserUid != null && currentUserUid != '')
          FutureBuilder<List<UserRow>>(
            future: UserTable().querySingleRow(
              queryFn: (q) => q.eqOrNull(
                'user_id',
                currentUserUid,
              ),
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              List<UserRow> stackUserRowList = snapshot.data!;

              final stackUserRow =
                  stackUserRowList.isNotEmpty ? stackUserRowList.first : null;

              return Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Container(
                      width: double.infinity,
                      height: 75.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF263B6A),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5.0,
                            color: Color(0x3B1D2429),
                            offset: Offset(
                              0.0,
                              -3.0,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            25.0, 15.0, 25.0, 15.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 50.0,
                              fillColor: Color(0xFF263B6A),
                              icon: Icon(
                                Icons.space_dashboard_rounded,
                                color: Color(0xFFE8EDF2),
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.pushNamed(PageHomepageWidget.routeName);
                              },
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (stackUserRow?.userType != 'Admin')
                                  FlutterFlowIconButton(
                                    borderRadius: 8.0,
                                    buttonSize: 50.0,
                                    icon: FaIcon(
                                      FontAwesomeIcons.list,
                                      color: Colors.white,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      context.pushNamed(
                                          PageLeaderboardWidget.routeName);
                                    },
                                  ),
                                if (stackUserRow?.userType == 'Admin')
                                  FlutterFlowIconButton(
                                    borderRadius: 8.0,
                                    buttonSize: 50.0,
                                    fillColor: Colors.white,
                                    icon: FaIcon(
                                      FontAwesomeIcons.list,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      context.pushNamed(
                                          PageAdminDashboardWidget.routeName);
                                    },
                                  ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15.0, 0.0, 15.0, 0.0),
                              child: Container(
                                width: 100.0,
                                decoration: BoxDecoration(),
                              ),
                            ),
                            FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 50.0,
                              fillColor: Color(0xFF263B6A),
                              icon: FaIcon(
                                FontAwesomeIcons.scroll,
                                color: Color(0xFFE8EDF2),
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.pushNamed(
                                    PageViewSubFeaturesWidget.routeName);
                              },
                            ),
                            FlutterFlowIconButton(
                              borderRadius: 8.0,
                              buttonSize: 50.0,
                              fillColor: Color(0xFF263B6A),
                              icon: Icon(
                                Icons.person_3,
                                color: Color(0xFFE8EDF2),
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.pushNamed(PageProfileWidget.routeName);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 75.0,
                      borderWidth: 0.0,
                      buttonSize: 125.0,
                      fillColor: Color(0xFF263B6A),
                      icon: Icon(
                        Icons.camera,
                        color: Color(0xFFE8EDF2),
                        size: 75.0,
                      ),
                      onPressed: () async {
                        context.pushNamed(PImgUploadAAuthWidget.routeName);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
