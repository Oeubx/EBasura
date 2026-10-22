import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'c_street_creation_widget.dart' show CStreetCreationWidget;
import 'package:flutter/material.dart';

class CStreetCreationModel extends FlutterFlowModel<CStreetCreationWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  String? _nameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Street name is required';
    }
    return null;
  }

  // State field(s) for Description widget.
  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;
  String? Function(BuildContext, String?)? descriptionTextControllerValidator;

  // Stores action output result for duplicate check
  List<StreetRow>? alreadyExistingStreetName;

  @override
  void initState(BuildContext context) {
    nameTextControllerValidator = _nameTextControllerValidator;
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
  }
}
