import '/components/ebasura_buttons.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final theme = FlutterFlowTheme.of(context);

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 320.0,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(22.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1E000000),
              blurRadius: 16.0,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F1F8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.engineering_rounded,
                color: Color(0xFF2E78A6),
                size: 32.0,
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              'Feature In Progress',
              style: GoogleFonts.comfortaa(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF013448),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'This module is currently being finalized for Barangay Batasan Hills. Thank you for your patience!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: theme.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20.0),
            EBasuraButton.button2(
              text: 'Got It',
              width: double.infinity,
              height: 42.0,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
