import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
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
          content: Text('Please provide a dispute explanation (at least 5 characters).'),
          backgroundColor: Colors.redAccent,
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

      await ImageTable().update(
        data: {
          'status': 'Disputed',
          'remark': updatedRemark,
          'updated_by': currentUserUid,
          'updated_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq(
          'image_id',
          widget.imageRef.imageId,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dispute submitted successfully! Sent for verifier review.'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit dispute: $e'),
            backgroundColor: Colors.red,
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
        color: Color(0xFFF1F4F8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.gavel_rounded,
                        color: Color(0xFFD32F2F),
                        size: 26.0,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Dispute Decision',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.interTight(fontWeight: FontWeight.bold),
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 38.0,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 20.0,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(thickness: 1.0, color: Colors.black12),
              const SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFFE65100), size: 22.0),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Text(
                        'Appeal rejected validation for image #${widget.imageRef.imageId ?? 'N/A'}. A verifier will re-evaluate your scan.',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: const Color(0xFFE65100),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                'Select Dispute Reason:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black26),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _model.selectedDisputeCategory,
                    isExpanded: true,
                    items: _disputeCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: GoogleFonts.inter(fontSize: 14.0),
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
              const SizedBox(height: 15.0),
              Text(
                'Detailed Explanation:',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _model.disputeReasonTextController,
                focusNode: _model.disputeReasonFocusNode,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Explain why this decision should be re-evaluated...',
                  hintStyle: GoogleFonts.inter(color: Colors.black38, fontSize: 13.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF1B5E20), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12.0),
                ),
                style: GoogleFonts.inter(fontSize: 14.0),
              ),
              const SizedBox(height: 20.0),
              FFButtonWidget(
                onPressed: _isSubmitting ? null : _submitDispute,
                text: _isSubmitting ? 'Submitting Dispute...' : 'Submit Dispute Claim',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 46.0,
                  color: const Color(0xFFD32F2F),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        color: Colors.white,
                      ),
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
