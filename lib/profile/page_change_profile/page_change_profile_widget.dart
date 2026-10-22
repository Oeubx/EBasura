import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'page_change_profile_model.dart';
export 'page_change_profile_model.dart';

class PageChangeProfileWidget extends StatefulWidget {
  const PageChangeProfileWidget({super.key});

  static String routeName = 'Page_ChangeProfile';
  static String routePath = '/pageChangeProfile';

  @override
  State<PageChangeProfileWidget> createState() =>
      _PageChangeProfileWidgetState();
}

class _PageChangeProfileWidgetState extends State<PageChangeProfileWidget> {
  late PageChangeProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PageChangeProfileModel());
    _model.textFieldNameFocusNode ??= FocusNode();
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
                      title: 'Change Profile',
                      subtitle:
                          'Update your display name & registered community street',
                      icon: Icons.badge_rounded,
                    ),
                    FutureBuilder<List<UserRow>>(
                      future: UserTable().querySingleRow(
                        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
                      ),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    theme.accent3,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        final user = userSnapshot.data?.firstOrNull;
                        _model.textFieldNameTextController ??=
                            TextEditingController(
                          text: user?.userName ?? '',
                        );

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20.0),
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
                                'Display Name',
                                style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              TextFormField(
                                controller: _model.textFieldNameTextController,
                                focusNode: _model.textFieldNameFocusNode,
                                textCapitalization: TextCapitalization.words,
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: theme.primaryText,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter your name',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.person_outline_rounded,
                                    color: Color(0xFF2E78A6),
                                    size: 20.0,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE2E8F0),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFF2E78A6),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 14.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18.0),
                              Text(
                                'Registered Street',
                                style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              FutureBuilder<List<StreetRow>>(
                                future: StreetTable().queryRows(
                                  queryFn: (q) => q.order('street_name'),
                                ),
                                builder: (context, streetSnapshot) {
                                  if (!streetSnapshot.hasData) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: SizedBox(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  final streets = streetSnapshot.data!;
                                  return FlutterFlowDropDown<String>(
                                    controller:
                                        _model.dropDownStreetValueController ??=
                                            FormFieldController<String>(
                                      _model.dropDownStreetValue ??=
                                          user?.userStreetNameRef,
                                    ),
                                    options: streets
                                        .map((s) => s.streetName)
                                        .toList(),
                                    onChanged: (val) => safeSetState(
                                      () => _model.dropDownStreetValue = val,
                                    ),
                                    width: double.infinity,
                                    height: 50.0,
                                    textStyle: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: theme.primaryText,
                                    ),
                                    hintText: 'Select your street',
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF64748B),
                                      size: 22.0,
                                    ),
                                    fillColor: const Color(0xFFF8FAFC),
                                    elevation: 2.0,
                                    borderColor: const Color(0xFFE2E8F0),
                                    borderWidth: 1.0,
                                    borderRadius: 16.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 14.0,
                                    ),
                                    hidesUnderline: true,
                                  );
                                },
                              ),
                              const SizedBox(height: 24.0),
                              FFButtonWidget(
                                onPressed: _isSaving
                                    ? null
                                    : () async {
                                        final newName = _model
                                            .textFieldNameTextController?.text
                                            .trim();
                                        final newStreet =
                                            _model.dropDownStreetValue;

                                        if (newName == null ||
                                            newName.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Display name cannot be empty',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() => _isSaving = true);
                                        try {
                                          await UserTable().update(
                                            data: {
                                              'user_name': newName,
                                              'user_streetNameRef': newStreet,
                                            },
                                            matchingRows: (rows) =>
                                                rows.eqOrNull(
                                              'user_id',
                                              currentUserUid,
                                            ),
                                          );
                                          if (newStreet != null) {
                                            FFAppState().usersStreetName =
                                                newStreet;
                                          }
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Profile updated successfully!',
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
                                                  'Failed to update profile: $e',
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
                                text: _isSaving ? 'Saving...' : 'Save Profile',
                                icon: _isSaving
                                    ? null
                                    : const Icon(
                                        Icons.check_circle_outline_rounded,
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
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_Profile',
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
