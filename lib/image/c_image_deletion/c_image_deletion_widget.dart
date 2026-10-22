import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_image_deletion_model.dart';
export 'c_image_deletion_model.dart';

class CImageDeletionWidget extends StatefulWidget {
  const CImageDeletionWidget({
    super.key,
    required this.imageRef,
    required this.userSubtableRef,
  });

  final ImageRow? imageRef;
  final UserSubtableRow? userSubtableRef;

  @override
  State<CImageDeletionWidget> createState() => _CImageDeletionWidgetState();
}

class _CImageDeletionWidgetState extends State<CImageDeletionWidget> {
  late CImageDeletionModel _model;
  bool _isDeleting = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CImageDeletionModel());
    _model.checkboxValue ??= true;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    setState(() {
      _isDeleting = true;
    });

    try {
      if (widget.imageRef?.imageId != null) {
        await ImageTable().delete(
          matchingRows: (rows) => rows.eq(
            'image_id',
            widget.imageRef!.imageId!,
          ),
        );
      }

      if (_model.checkboxValue == true &&
          widget.userSubtableRef?.userPoints != null &&
          widget.imageRef?.imgUploader != null) {
        await UserSubtableTable().update(
          data: {
            'user_points': functions.minusPoints(
              widget.userSubtableRef!.userPoints!,
              50,
            ),
          },
          matchingRows: (rows) => rows.eq(
            'user_idRef',
            widget.imageRef!.imgUploader,
          ),
        );
      }

      final refLink = widget.imageRef?.imgReferenceLink;
      if (refLink != null && refLink.isNotEmpty) {
        await deleteSupabaseFileFromPublicUrl(refLink);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waste record deleted successfully.'),
            backgroundColor: Color(0xFF31A11F),
          ),
        );
        Navigator.pop(context);
        context.goNamed(PImagesViewAllWidget.routeName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting image: $e'),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 340.0),
            padding: const EdgeInsets.all(22.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: const Color(0xFFD5F2E2),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x24000000),
                  blurRadius: 20.0,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Danger Badge
                Container(
                  width: 58.0,
                  height: 58.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color(0xFFD32F2F),
                    size: 32.0,
                  ),
                ),
                const SizedBox(height: 14.0),

                // Title
                Text(
                  'Delete Waste Image?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comfortaa(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E78A6),
                  ),
                ),
                const SizedBox(height: 8.0),

                // Description
                Text(
                  'Deleting this waste submission is permanent and irreversible. The image file will be removed from storage.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: Colors.black54,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14.0),

                // Unrelated Penalty Checkbox Tile
                InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    setState(() {
                      _model.checkboxValue = !(_model.checkboxValue ?? true);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: const Color(0xFFFFB74D),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _model.checkboxValue ?? true,
                          activeColor: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _model.checkboxValue = val ?? true;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Mark as unrelated waste\n(-50 points deduction)',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE65100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () => Navigator.pop(context),
                        text: 'Cancel',
                        options: FFButtonOptions(
                          height: 44.0,
                          color: const Color(0xFFF2F2F2),
                          textStyle: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: _isDeleting ? null : _handleDelete,
                        text: _isDeleting ? 'Deleting...' : 'Delete',
                        icon: const Icon(
                          Icons.delete_rounded,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        options: FFButtonOptions(
                          height: 44.0,
                          color: const Color(0xFFD32F2F),
                          textStyle: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          elevation: 1.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
