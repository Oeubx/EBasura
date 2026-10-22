import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_badges_creation_model.dart';
export 'c_badges_creation_model.dart';

class CBadgesCreationWidget extends StatefulWidget {
  const CBadgesCreationWidget({super.key});

  @override
  State<CBadgesCreationWidget> createState() => _CBadgesCreationWidgetState();
}

class _CBadgesCreationWidgetState extends State<CBadgesCreationWidget> {
  late CBadgesCreationModel _model;
  bool _isSaving = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CBadgesCreationModel());

    _model.textFieldNameTextController ??= TextEditingController();
    _model.textFieldNameFocusNode ??= FocusNode();

    _model.textFieldDescTextController ??= TextEditingController();
    _model.textFieldDescFocusNode ??= FocusNode();

    _model.textFieldMinTextController ??= TextEditingController(text: '0');
    _model.textFieldMinFocusNode ??= FocusNode();

    _model.textFieldMaxTextController ??= TextEditingController(text: '1000');
    _model.textFieldMaxFocusNode ??= FocusNode();

    _model.countControllerValue = 1;

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
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 20.0,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 12.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
            ),
            child: Form(
              key: _model.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Drag Handle
                  Center(
                    child: Container(
                      width: 44.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Title Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F1F8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.military_tech_rounded,
                          color: Color(0xFF2E78A6),
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Badge Record',
                              style: GoogleFonts.comfortaa(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF013448),
                              ),
                            ),
                            Text(
                              'Configure milestone tier, title, & point boundaries',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                color: theme.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18.0),

                  // Badge Name Field
                  Text(
                    'Badge Name',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _model.textFieldNameTextController,
                    focusNode: _model.textFieldNameFocusNode,
                    decoration: InputDecoration(
                      hintText: 'e.g. Eco Pioneer, Master Recycler',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: theme.secondaryText.withValues(alpha: 0.6),
                      ),
                      filled: true,
                      fillColor: theme.primaryBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: theme.accent4.withValues(alpha: 0.35),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF2E78A6),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFDC2626),
                          width: 1.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFDC2626),
                          width: 1.5,
                        ),
                      ),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: theme.primaryText,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please provide a badge name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14.0),

                  // Badge Description Field
                  Text(
                    'Description & Criteria',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextFormField(
                    controller: _model.textFieldDescTextController,
                    focusNode: _model.textFieldDescFocusNode,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Describe how residents unlock this badge...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: theme.secondaryText.withValues(alpha: 0.6),
                      ),
                      filled: true,
                      fillColor: theme.primaryBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                          color: theme.accent4.withValues(alpha: 0.35),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF2E78A6),
                          width: 1.5,
                        ),
                      ),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Badge Level Stepper
                  Text(
                    'Milestone Level Tier',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: theme.accent4.withValues(alpha: 0.35),
                        width: 1.0,
                      ),
                    ),
                    child: FlutterFlowCountController(
                      decrementIconBuilder: (enabled) => Icon(
                        Icons.remove_circle_outline_rounded,
                        color: enabled
                            ? const Color(0xFF2E78A6)
                            : theme.secondaryText.withValues(alpha: 0.3),
                        size: 24.0,
                      ),
                      incrementIconBuilder: (enabled) => Icon(
                        Icons.add_circle_outline_rounded,
                        color: enabled
                            ? const Color(0xFF2E78A6)
                            : theme.secondaryText.withValues(alpha: 0.3),
                        size: 24.0,
                      ),
                      countBuilder: (count) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            size: 18.0,
                            color: Color(0xFF70BF5A),
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            'Level $count',
                            style: GoogleFonts.inter(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                              color: theme.primaryText,
                            ),
                          ),
                        ],
                      ),
                      count: _model.countControllerValue ?? 1,
                      updateCount: (count) =>
                          safeSetState(() => _model.countControllerValue = count),
                      stepSize: 1,
                      minimum: 1,
                      maximum: 50,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  const SizedBox(height: 14.0),

                  // Points Range Row
                  Row(
                    children: [
                      // Min Points
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Min Points Threshold',
                              style: GoogleFonts.inter(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            TextFormField(
                              controller: _model.textFieldMinTextController,
                              focusNode: _model.textFieldMinFocusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.arrow_downward_rounded,
                                  size: 18.0,
                                  color: Color(0xFF70BF5A),
                                ),
                                filled: true,
                                fillColor: theme.primaryBackground,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 12.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(
                                    color: theme.accent4.withValues(alpha: 0.35),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF2E78A6),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      // Max Points
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Max Points Threshold',
                              style: GoogleFonts.inter(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            TextFormField(
                              controller: _model.textFieldMaxTextController,
                              focusNode: _model.textFieldMaxFocusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 18.0,
                                  color: Color(0xFF2E78A6),
                                ),
                                filled: true,
                                fillColor: theme.primaryBackground,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 12.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(
                                    color: theme.accent4.withValues(alpha: 0.35),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF2E78A6),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22.0),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () {
                            _model.textFieldNameTextController?.clear();
                            _model.textFieldDescTextController?.clear();
                            _model.textFieldMinTextController?.clear();
                            _model.textFieldMaxTextController?.clear();
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                          options: FFButtonOptions(
                            height: 44.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                        flex: 2,
                        child: FFButtonWidget(
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  if (!(_model.formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  setState(() => _isSaving = true);
                                  try {
                                    final minPts = int.tryParse(_model
                                            .textFieldMinTextController.text
                                            .trim()) ??
                                        0;
                                    final maxPts = int.tryParse(_model
                                            .textFieldMaxTextController.text
                                            .trim()) ??
                                        1000;

                                    await BadgeTable().insert({
                                      'badge_name': _model
                                          .textFieldNameTextController.text
                                          .trim(),
                                      'badge_description': _model
                                          .textFieldDescTextController.text
                                          .trim(),
                                      'created_at': supaSerialize<DateTime>(
                                        functions.getCurrentTime(
                                            getCurrentTimestamp),
                                      ),
                                      'created_by': currentUserUid,
                                      'badge_minPts': minPts,
                                      'badge_maxPts': maxPts,
                                      'updated_by': currentUserUid,
                                      'badge_level':
                                          _model.countControllerValue ?? 1,
                                    });

                                    if (!context.mounted) return;
                                    Navigator.pop(context, true);
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to save badge record: $e'),
                                          backgroundColor:
                                              const Color(0xFFDC2626),
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isSaving = false);
                                    }
                                  }
                                },
                          text: _isSaving ? 'Creating...' : 'Create Badge',
                          icon: _isSaving
                              ? null
                              : const Icon(
                                  Icons.add_task_rounded,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                          options: FFButtonOptions(
                            height: 44.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            color: const Color(0xFF2E78A6),
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
          ),
        ),
      ),
    );
  }
}
