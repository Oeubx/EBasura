import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_street_deletion_model.dart';
export 'c_street_deletion_model.dart';

class CStreetDeletionWidget extends StatefulWidget {
  const CStreetDeletionWidget({
    super.key,
    required this.streetRef,
  });

  final StreetRow? streetRef;

  @override
  State<CStreetDeletionWidget> createState() => _CStreetDeletionWidgetState();
}

class _CStreetDeletionWidgetState extends State<CStreetDeletionWidget> {
  late CStreetDeletionModel _model;
  bool _isDeleting = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CStreetDeletionModel());
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
              'Delete Street Record?',
              style: GoogleFonts.comfortaa(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF013448),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Deleting this street is irreversible and will affect associated resident profiles and collection routes.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    text: 'Cancel',
                    options: FFButtonOptions(
                      height: 42.0,
                      color: const Color(0xFFF1F5F9),
                      textStyle: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: FFButtonWidget(
                    onPressed: _isDeleting
                        ? null
                        : () async {
                            setState(() => _isDeleting = true);
                            try {
                              await StreetTable().delete(
                                matchingRows: (rows) => rows.eqOrNull(
                                  'street_id',
                                  widget.streetRef?.streetId,
                                ),
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                                context.goNamed(PStreetViewAllWidget.routeName);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete: $e'),
                                    backgroundColor: const Color(0xFFDC2626),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _isDeleting = false);
                              }
                            }
                          },
                    text: _isDeleting ? 'Deleting...' : 'Delete',
                    options: FFButtonOptions(
                      height: 42.0,
                      color: const Color(0xFFDC2626),
                      textStyle: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
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
