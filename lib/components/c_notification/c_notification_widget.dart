import '/backend/supabase/supabase.dart';
import '/components/ebasura_buttons.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_notification_model.dart';
export 'c_notification_model.dart';

class CNotificationWidget extends StatefulWidget {
  const CNotificationWidget({
    super.key,
    required this.authIdRef,
  });

  final String? authIdRef;

  @override
  State<CNotificationWidget> createState() => _CNotificationWidgetState();
}

class _CNotificationWidgetState extends State<CNotificationWidget> {
  late CNotificationModel _model;
  bool _isDismissing = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CNotificationModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _handleAcknowledge() async {
    setState(() => _isDismissing = true);
    try {
      if (widget.authIdRef != null && widget.authIdRef!.isNotEmpty) {
        await UserSubtableTable().update(
          data: {
            'notification': false,
          },
          matchingRows: (rows) => rows.eqOrNull(
            'user_idRef',
            widget.authIdRef,
          ),
        );
      }
    } catch (_) {
      // Graceful fallback
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
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
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Color(0xFFD97706),
                size: 32.0,
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              'Sanitation Notice',
              style: GoogleFonts.comfortaa(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF013448),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Please ensure your waste is properly segregated next time. Proper segregation protects collection personnel and keeps our community clean.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: theme.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20.0),
            EBasuraButton.button2(
              text: 'Acknowledge',
              width: double.infinity,
              height: 42.0,
              isLoading: _isDismissing,
              onPressed: _handleAcknowledge,
            ),
          ],
        ),
      ),
    );
  }
}
