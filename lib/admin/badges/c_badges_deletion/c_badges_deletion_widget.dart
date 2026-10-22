import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_badges_deletion_model.dart';
export 'c_badges_deletion_model.dart';

class CBadgesDeletionWidget extends StatefulWidget {
  const CBadgesDeletionWidget({
    super.key,
    required this.badgeRef,
  });

  final BadgeRow? badgeRef;

  @override
  State<CBadgesDeletionWidget> createState() => _CBadgesDeletionWidgetState();
}

class _CBadgesDeletionWidgetState extends State<CBadgesDeletionWidget> {
  late CBadgesDeletionModel _model;
  bool _isDeleting = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CBadgesDeletionModel());
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
    final badgeName = widget.badgeRef?.badgeName ?? 'this badge';

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
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFDC2626),
                size: 32.0,
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              'Delete Badge Record?',
              style: GoogleFonts.comfortaa(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF013448),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Deleting "$badgeName" is permanent and will remove it from gamification milestones. This cannot be undone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: theme.secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () => Navigator.of(context).pop(false),
                    text: 'Cancel',
                    options: FFButtonOptions(
                      height: 42.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      color: theme.primaryBackground,
                      textStyle: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: theme.secondaryText,
                      ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: theme.accent4.withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: FFButtonWidget(
                    onPressed: _isDeleting
                        ? null
                        : () async {
                            setState(() => _isDeleting = true);
                            try {
                              await BadgeTable().delete(
                                matchingRows: (rows) => rows.eqOrNull(
                                  'badge_id',
                                  widget.badgeRef?.badgeId,
                                ),
                              );
                              if (!context.mounted) return;
                              Navigator.of(context).pop(true);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete badge: $e'),
                                    backgroundColor: const Color(0xFFDC2626),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isDeleting = false);
                            }
                          },
                    text: _isDeleting ? 'Deleting...' : 'Delete',
                    icon: _isDeleting
                        ? null
                        : const Icon(
                            Icons.delete_outline_rounded,
                            size: 16.0,
                            color: Colors.white,
                          ),
                    options: FFButtonOptions(
                      height: 42.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      color: const Color(0xFFDC2626),
                      textStyle: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
