import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'c_dispute_decision_widget.dart' show CDisputeDecisionWidget;
import 'package:flutter/material.dart';

class CDisputeDecisionModel extends FlutterFlowModel<CDisputeDecisionWidget> {
  /// State fields for stateful widgets in this component.
  String selectedDisputeCategory = 'AI Misclassification';
  
  // State field(s) for disputeReason widget.
  FocusNode? disputeReasonFocusNode;
  TextEditingController? disputeReasonTextController;
  String? Function(BuildContext, String?)? disputeReasonTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    disputeReasonFocusNode?.dispose();
    disputeReasonTextController?.dispose();
  }
}
