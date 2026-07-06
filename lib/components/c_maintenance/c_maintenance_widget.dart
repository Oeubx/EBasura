import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'c_maintenance_model.dart';
export 'c_maintenance_model.dart';

class CMaintenanceWidget extends StatefulWidget {
  const CMaintenanceWidget({super.key});

  @override
  State<CMaintenanceWidget> createState() => _CMaintenanceWidgetState();
}

class _CMaintenanceWidgetState extends State<CMaintenanceWidget> {
  late CMaintenanceModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CMaintenanceModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          Navigator.pop(context);
        },
        child: Container(
          width: 250.0,
          height: 300.0,
          decoration: BoxDecoration(
            color: Color(0xFFBFC9D1),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Horizontal_Logo.png',
                  width: double.infinity,
                  height: 105.0,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Divider(
                thickness: 2.0,
                color: Color(0xFF2C3947),
              ),
              Text(
                'This feature\nhas yet to be implemented.\nWe ask for your understanding',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                      ),
                      color: Color(0xFF2C3947),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelMedium.fontStyle,
                    ),
              ),
              Divider(
                thickness: 2.0,
                color: Color(0xFF2C3947),
              ),
              Text(
                '(C) E-Basura developer',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelSmall.fontStyle,
                      ),
                      color: Color(0xFF2C3947),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelSmall.fontStyle,
                    ),
              ),
            ].divide(SizedBox(height: 15.0)).around(SizedBox(height: 15.0)),
          ),
        ),
      ),
    );
  }
}
