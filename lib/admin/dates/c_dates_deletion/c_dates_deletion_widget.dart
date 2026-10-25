import '/auth/role_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_dates_deletion_model.dart';
export 'c_dates_deletion_model.dart';

class CDatesDeletionWidget extends StatefulWidget {
  const CDatesDeletionWidget({
    super.key,
    required this.collectionRef,
  });

  final CollectionRow? collectionRef;

  @override
  State<CDatesDeletionWidget> createState() => _CDatesDeletionWidgetState();
}

class _CDatesDeletionWidgetState extends State<CDatesDeletionWidget> {
  late CDatesDeletionModel _model;
  bool _isDeleting = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CDatesDeletionModel());
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
                Icons.delete_forever_rounded,
                color: Color(0xFFDC2626),
                size: 32.0,
              ),
            ),
            const SizedBox(height: 14.0),
            Text(
              'Delete Schedule?',
              style: GoogleFonts.comfortaa(
                fontSize: 17.0,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF013448),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'This will permanently remove this collection schedule route. This action cannot be undone.',
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
                            final role = await RoleService.fetchCurrentUserRole();
                            if (role != UserRole.admin) {
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Unauthorized: Only administrators can delete collection schedules.'),
                                    backgroundColor: Color(0xFFDC2626),
                                  ),
                                );
                              }
                              return;
                            }
                            setState(() => _isDeleting = true);
                            try {
                              await CollectionTable().delete(
                                matchingRows: (rows) => rows.eqOrNull(
                                  'collection_id',
                                  widget.collectionRef?.collectionId,
                                ),
                              );

                              if (context.mounted) {
                                Navigator.pop(context);
                                context.goNamed(PDatesViewAllWidget.routeName);
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
