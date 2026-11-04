import '/admin/street/c_street_deletion/c_street_deletion_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_street_view_one_model.dart';
export 'p_street_view_one_model.dart';

class PStreetViewOneWidget extends StatefulWidget {
  const PStreetViewOneWidget({
    super.key,
    required this.streetsRef,
  });

  final StreetRow? streetsRef;

  static String routeName = 'P_Street_ViewOne';
  static String routePath = '/pStreetViewOne';

  @override
  State<PStreetViewOneWidget> createState() => _PStreetViewOneWidgetState();
}

class _PStreetViewOneWidgetState extends State<PStreetViewOneWidget> {
  late PStreetViewOneModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false;
  bool _hasStorage = false;
  bool _initialized = false;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PStreetViewOneModel());
    _model.nameFocusNode ??= FocusNode();
    _model.descriptionFocusNode ??= FocusNode();
    _hasStorage = widget.streetsRef?.hasStorage ?? false;
    _checkRole();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _checkRole() async {
    try {
      final role = await RoleService.fetchCurrentUserRole();
      if (mounted) {
        safeSetState(() => _isAdmin = role == UserRole.admin);
      }
    } catch (_) {
      if (mounted) safeSetState(() => _isAdmin = false);
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

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
                            borderColor: theme.accent4.withValues(alpha: 0.35),
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
                      title: 'Street Profile',
                      subtitle:
                          'Review and update street details and waste storage status',
                      icon: Icons.edit_road_rounded,
                    ),

                    FutureBuilder<List<StreetRow>>(
                      future: StreetTable().querySingleRow(
                        queryFn: (q) => q.eqOrNull(
                          'street_id',
                          widget.streetsRef?.streetId,
                        ),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(48.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2E78A6),
                                ),
                              ),
                            ),
                          );
                        }

                        final rows = snapshot.data!;
                        final street =
                            rows.isNotEmpty ? rows.first : widget.streetsRef;

                        if (street == null) {
                          return Center(
                            child: Text(
                              'Street not found.',
                              style: GoogleFonts.inter(
                                color: theme.secondaryText,
                              ),
                            ),
                          );
                        }

                        if (!_initialized) {
                          _model.nameTextController ??= TextEditingController(
                            text: street.streetName,
                          );
                          _model.descriptionTextController ??=
                              TextEditingController(
                            text: street.streetDescription,
                          );
                          _hasStorage = street.hasStorage ?? false;
                          _initialized = true;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!_isAdmin)
                              Container(
                                margin: const EdgeInsets.only(bottom: 14.0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 10.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      size: 18.0,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        'Barangay Street Profile • View Only (Admin Required to Edit)',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1.0,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0A000000),
                                    blurRadius: 8.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Street Information',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF013448),
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),

                                  // Street Name
                                  Text(
                                    'Street Name',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  TextFormField(
                                    controller: _model.nameTextController,
                                    focusNode: _model.nameFocusNode,
                                    enabled: _isAdmin,
                                    readOnly: !_isAdmin,
                                    decoration: InputDecoration(
                                      hintText: 'Enter official street name',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      filled: true,
                                      fillColor: _isAdmin
                                          ? const Color(0xFFF8FAFC)
                                          : const Color(0xFFF1F5F9),
                                      contentPadding: const EdgeInsets.all(14.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E1),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E1),
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
                                      fontSize: 13.5,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),

                                  // Description
                                  Text(
                                    'Description / Landmark',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  TextFormField(
                                    controller:
                                        _model.descriptionTextController,
                                    focusNode: _model.descriptionFocusNode,
                                    enabled: _isAdmin,
                                    readOnly: !_isAdmin,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText:
                                          'E.g., Near Batasan National High School...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      filled: true,
                                      fillColor: _isAdmin
                                          ? const Color(0xFFF8FAFC)
                                          : const Color(0xFFF1F5F9),
                                      contentPadding: const EdgeInsets.all(14.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E1),
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFCBD5E1),
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
                                      fontSize: 13.5,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Waste Storage Toggle
                                  Container(
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius:
                                          BorderRadius.circular(14.0),
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: _hasStorage
                                                ? const Color(0xFFD5F2E2)
                                                : const Color(0xFFF1F5F9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.warehouse_rounded,
                                            size: 20.0,
                                            color: _hasStorage
                                                ? const Color(0xFF31A11F)
                                                : const Color(0xFF64748B),
                                          ),
                                        ),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Designated Storage Facility',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF1E293B),
                                                ),
                                              ),
                                              Text(
                                                'Has physical barangay bins or drop-off point',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11.0,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch.adaptive(
                                          value: _hasStorage,
                                          activeThumbColor:
                                              const Color(0xFF31A11F),
                                          onChanged: _isAdmin
                                              ? (val) {
                                                  setState(
                                                      () => _hasStorage = val);
                                                }
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_isAdmin) ...[
                              const SizedBox(height: 18.0),

                              // Save Changes Button
                              FFButtonWidget(
                                onPressed: _isSaving
                                    ? null
                                    : () async {
                                        if (!_isAdmin) return;
                                        final newName = _model
                                            .nameTextController?.text
                                            .trim();
                                        if (newName == null ||
                                            newName.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Street name cannot be empty.',
                                              ),
                                              backgroundColor:
                                                  Color(0xFFDC2626),
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() => _isSaving = true);
                                        try {
                                          await StreetTable().update(
                                            data: {
                                              'street_name': newName,
                                              'street_description': _model
                                                      .descriptionTextController
                                                      ?.text
                                                      .trim() ??
                                                  '',
                                              'has_storage': _hasStorage,
                                              'last_updatedBy': currentUserUid,
                                              'last_updatedTime':
                                                  supaSerialize<DateTime>(
                                                functions.getCurrentTime(
                                                  getCurrentTimestamp,
                                                ),
                                              ),
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'street_id',
                                              street.streetId,
                                            ),
                                          );

                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Street updated successfully!',
                                                ),
                                                backgroundColor:
                                                    Color(0xFF31A11F),
                                              ),
                                            );
                                            context.safePop();
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Failed to update: $e',
                                                ),
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
                                text: _isSaving
                                    ? 'Saving Changes...'
                                    : 'Save Changes',
                                icon: _isSaving
                                    ? null
                                    : const Icon(
                                        Icons.check_circle_rounded,
                                        size: 18.0,
                                      ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 48.0,
                                  color: const Color(0xFF2E78A6),
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              // Delete Button
                              FFButtonWidget(
                                onPressed: () async {
                                  if (!_isAdmin) return;
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: CStreetDeletionWidget(
                                          streetRef: street,
                                        ),
                                      );
                                    },
                                  );
                                },
                                text: 'Delete Street',
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18.0,
                                  color: Color(0xFFDC2626),
                                ),
                                options: FFButtonOptions(
                                  width: double.infinity,
                                  height: 44.0,
                                  color: const Color(0xFFFEE2E2),
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFDC2626),
                                  ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom Bar
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'P_Street_ViewAll',
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
