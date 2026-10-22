import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_dispute_decision_model.dart';
export 'c_dispute_decision_model.dart';

class CDisputeDecisionWidget extends StatefulWidget {
  const CDisputeDecisionWidget({
    super.key,
    required this.imageRef,
  });

  final ImageRow imageRef;

  @override
  State<CDisputeDecisionWidget> createState() => _CDisputeDecisionWidgetState();
}

class _CDisputeDecisionWidgetState extends State<CDisputeDecisionWidget> {
  late CDisputeDecisionModel _model;
  bool _isSubmitting = false;

  final List<String> _disputeCategories = [
    'AI Misclassification',
    'Properly Segregated Waste',
    'Incorrect Category Assigned',
    'Other / Re-inspection Request'
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CDisputeDecisionModel());
    _model.disputeReasonFocusNode ??= FocusNode();
    _model.disputeReasonTextController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _submitDispute() async {
    final reasonText = _model.disputeReasonTextController?.text.trim() ?? '';
    if (reasonText.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an explanation (at least 5 characters).'),
          backgroundColor: Color(0xFFD32F2F),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final updatedRemark =
          '[DISPUTE - ${_model.selectedDisputeCategory}]: $reasonText';

      final imageId = widget.imageRef.imageId;
      if (imageId == null || imageId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot dispute an image without a valid image ID.'),
              backgroundColor: Color(0xFFD32F2F),
            ),
          );
        }
        return;
      }

      await ImageTable().update(
        data: {
          'status': 'Flagged',
          'verification_status': 'disputed',
          'remark': updatedRemark,
          'updated_by': currentUserUid,
          'updated_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq(
          'image_id',
          imageId,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dispute submitted successfully! Sent for verifier review.'),
            backgroundColor: Color(0xFF31A11F),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit dispute: $e'),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16.0,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 28.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 44.0,
                  height: 4.0,
                  margin: const EdgeInsets.only(bottom: 14.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),

              // Title and Close Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.gavel_rounded,
                          color: Color(0xFFD32F2F),
                          size: 22.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dispute Decision',
                            style: GoogleFonts.comfortaa(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2E78A6),
                            ),
                          ),
                          Text(
                            'Request secondary verifier re-inspection',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(18.0),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD5F2E2),
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.black54,
                        size: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),

              // Appeal Notice Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: const Color(0xFFFFE082),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFE65100),
                      size: 20.0,
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        'Appeal rejected validation for image #${widget.imageRef.imageId ?? 'N/A'}. A verifier will re-evaluate your scan against Barangay standards.',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          color: const Color(0xFFE65100),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Dropdown Category Field
              Text(
                'Select Dispute Reason',
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFD5F2E2),
                    width: 1.2,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _model.selectedDisputeCategory,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF2E78A6),
                    ),
                    items: _disputeCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _model.selectedDisputeCategory = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Detailed Explanation Form Field
              Text(
                'Detailed Explanation',
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _model.disputeReasonTextController,
                focusNode: _model.disputeReasonFocusNode,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Explain why this decision should be re-evaluated (e.g. materials inside bag are cleaned plastics)...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.black38,
                    fontSize: 13.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFD5F2E2),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2E78A6),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  contentPadding: const EdgeInsets.all(14.0),
                ),
                style: GoogleFonts.inter(fontSize: 13.5),
              ),
              const SizedBox(height: 22.0),

              // Submit CTA Pill Button
              FFButtonWidget(
                onPressed: _isSubmitting ? null : _submitDispute,
                text: _isSubmitting
                    ? 'Submitting Claim...'
                    : 'Submit Dispute Claim',
                icon: const Icon(
                  Icons.send_rounded,
                  size: 18.0,
                  color: Colors.white,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 48.0,
                  color: const Color(0xFFD32F2F),
                  textStyle: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(22.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
