import '/admin/badges/c_badges_deletion/c_badges_deletion_widget.dart';
import '/admin/badges/p_badge_view_all/p_badge_view_all_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_badge_view_one_model.dart';
export 'p_badge_view_one_model.dart';

class PBadgeViewOneWidget extends StatefulWidget {
  const PBadgeViewOneWidget({
    super.key,
    required this.badgeRef,
  });

  final BadgeRow? badgeRef;

  static String routeName = 'P_Badge_ViewOne';
  static String routePath = '/pBadgeViewOne';

  @override
  State<PBadgeViewOneWidget> createState() => _PBadgeViewOneWidgetState();
}

class _PBadgeViewOneWidgetState extends State<PBadgeViewOneWidget> {
  late PBadgeViewOneModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PBadgeViewOneModel());

    final badge = widget.badgeRef;

    _model.textFieldNameTextController ??=
        TextEditingController(text: badge?.badgeName ?? '');
    _model.textFieldNameFocusNode ??= FocusNode();

    _model.textFieldDescTextController ??=
        TextEditingController(text: badge?.badgeDescription ?? '');
    _model.textFieldDescFocusNode ??= FocusNode();

    _model.textFieldMinTextController ??=
        TextEditingController(text: (badge?.badgeMinPts ?? 0).toString());
    _model.textFieldMinFocusNode ??= FocusNode();

    _model.textFieldMaxTextController ??=
        TextEditingController(text: (badge?.badgeMaxPts ?? 1000).toString());
    _model.textFieldMaxFocusNode ??= FocusNode();

    _model.countControllerValue = badge?.badgeLevel ?? 1;

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final badge = widget.badgeRef;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: 120.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand topbar with back button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/Horizontal_Logo.png',
                            height: 38.0,
                            fit: BoxFit.contain,
                          ),
                          FlutterFlowIconButton(
                            borderColor:
                                theme.accent4.withValues(alpha: 0.35),
                            borderRadius: 20.0,
                            buttonSize: 38.0,
                            fillColor: Colors.white,
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: theme.primaryText,
                              size: 20.0,
                            ),
                            onPressed: () async => context.safePop(),
                          ),
                        ],
                      ),
                    ),

                    const CPageHeaderWidget(
                      title: 'Badge Configuration',
                      subtitle:
                          'Update milestone parameters, point limits, & badge details',
                      icon: Icons.military_tech_rounded,
                    ),

                    // Badge Hero Preview Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF013448), Color(0xFF2E78A6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x28013448),
                            blurRadius: 12.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2.0,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.military_tech_rounded,
                                color: Color(0xFFD5F2E2),
                                size: 36.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 3.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF70BF5A),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: Text(
                                        'Tier Level ${_model.countControllerValue ?? badge?.badgeLevel ?? 1}',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      '${_model.textFieldMinTextController?.text ?? 0} - ${_model.textFieldMaxTextController?.text ?? 1000} pts',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.0,
                                        color: const Color(0xFFA3C9D9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  _model.textFieldNameTextController?.text
                                              .isNotEmpty ??
                                          false
                                      ? _model.textFieldNameTextController!.text
                                      : (badge?.badgeName ?? 'Badge Title'),
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                if (badge?.badgeDescription != null &&
                                    badge!.badgeDescription!.isNotEmpty) ...[
                                  const SizedBox(height: 4.0),
                                  Text(
                                    badge.badgeDescription!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main Form Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: theme.accent4.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                        boxShadow: [
                          theme.designToken.shadow.sm,
                        ],
                      ),
                      child: Form(
                        key: _model.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Header
                            Row(
                              children: [
                                const Icon(
                                  Icons.edit_note_rounded,
                                  size: 20.0,
                                  color: Color(0xFF2E78A6),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Edit Badge Properties',
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF013448),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),

                            // Badge Name
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
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Badge Name',
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
                                  return 'Badge name cannot be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14.0),

                            // Badge Description
                            Text(
                              'Description',
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
                              onChanged: (_) => setState(() {}),
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Enter badge criteria...',
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
                                      : theme.secondaryText
                                          .withValues(alpha: 0.3),
                                  size: 24.0,
                                ),
                                incrementIconBuilder: (enabled) => Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: enabled
                                      ? const Color(0xFF2E78A6)
                                      : theme.secondaryText
                                          .withValues(alpha: 0.3),
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
                                updateCount: (count) => safeSetState(
                                    () => _model.countControllerValue = count),
                                stepSize: 1,
                                minimum: 1,
                                maximum: 50,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                              ),
                            ),
                            const SizedBox(height: 14.0),

                            // Points Range Row
                            Row(
                              children: [
                                // Min Points
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Min Points',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: theme.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      TextFormField(
                                        controller:
                                            _model.textFieldMinTextController,
                                        focusNode:
                                            _model.textFieldMinFocusNode,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (_) => setState(() {}),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.arrow_downward_rounded,
                                            size: 18.0,
                                            color: Color(0xFF70BF5A),
                                          ),
                                          filled: true,
                                          fillColor: theme.primaryBackground,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14.0,
                                            vertical: 12.0,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            borderSide: BorderSide(
                                              color: theme.accent4
                                                  .withValues(alpha: 0.35),
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Max Points',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w600,
                                          color: theme.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      TextFormField(
                                        controller:
                                            _model.textFieldMaxTextController,
                                        focusNode:
                                            _model.textFieldMaxFocusNode,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (_) => setState(() {}),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.arrow_upward_rounded,
                                            size: 18.0,
                                            color: Color(0xFF2E78A6),
                                          ),
                                          filled: true,
                                          fillColor: theme.primaryBackground,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 14.0,
                                            vertical: 12.0,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            borderSide: BorderSide(
                                              color: theme.accent4
                                                  .withValues(alpha: 0.35),
                                              width: 1.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
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
                            const SizedBox(height: 24.0),

                            // Action Buttons: Delete and Update
                            Row(
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      final deleted =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding:
                                                const EdgeInsets.all(16.0),
                                            child: CBadgesDeletionWidget(
                                              badgeRef: widget.badgeRef,
                                            ),
                                          );
                                        },
                                      );
                                      if (deleted == true && context.mounted) {
                                        context.goNamed(
                                            PBadgeViewAllWidget.routeName);
                                      }
                                    },
                                    text: 'Delete',
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18.0,
                                      color: Colors.white,
                                    ),
                                    options: FFButtonOptions(
                                      height: 44.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      color: const Color(0xFFDC2626),
                                      textStyle: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      elevation: 0.0,
                                      borderRadius:
                                          BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  flex: 2,
                                  child: FFButtonWidget(
                                    onPressed: _isUpdating
                                        ? null
                                        : () async {
                                            if (!(_model.formKey.currentState
                                                    ?.validate() ??
                                                false)) {
                                              return;
                                            }
                                            setState(() => _isUpdating = true);
                                            try {
                                              final minPts = int.tryParse(
                                                      _model
                                                          .textFieldMinTextController
                                                          .text
                                                          .trim()) ??
                                                  0;
                                              final maxPts = int.tryParse(
                                                      _model
                                                          .textFieldMaxTextController
                                                          .text
                                                          .trim()) ??
                                                  1000;

                                              await BadgeTable().update(
                                                data: {
                                                  'badge_name': _model
                                                      .textFieldNameTextController
                                                      .text
                                                      .trim(),
                                                  'badge_description': _model
                                                      .textFieldDescTextController
                                                      .text
                                                      .trim(),
                                                  'badge_minPts': minPts,
                                                  'badge_maxPts': maxPts,
                                                  'updated_by': currentUserUid,
                                                  'badge_level': _model
                                                          .countControllerValue ??
                                                      1,
                                                },
                                                matchingRows: (rows) =>
                                                    rows.eqOrNull(
                                                  'badge_id',
                                                  widget.badgeRef?.badgeId,
                                                ),
                                              );

                                              if (!context.mounted) return;
                                              context.goNamed(
                                                  PBadgeViewAllWidget
                                                      .routeName);
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to update badge: $e'),
                                                    backgroundColor:
                                                        const Color(0xFFDC2626),
                                                  ),
                                                );
                                              }
                                            } finally {
                                              if (mounted) {
                                                setState(
                                                    () => _isUpdating = false);
                                              }
                                            }
                                          },
                                    text: _isUpdating
                                        ? 'Saving...'
                                        : 'Save Changes',
                                    icon: _isUpdating
                                        ? null
                                        : const Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                    options: FFButtonOptions(
                                      height: 44.0,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      color: const Color(0xFF2E78A6),
                                      textStyle: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      elevation: 0.0,
                                      borderRadius:
                                          BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Navigation Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_AdminDashboard',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
