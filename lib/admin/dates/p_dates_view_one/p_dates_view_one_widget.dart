import '/admin/dates/c_dates_deletion/c_dates_deletion_widget.dart';
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
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_dates_view_one_model.dart';
export 'p_dates_view_one_model.dart';

class PDatesViewOneWidget extends StatefulWidget {
  const PDatesViewOneWidget({
    super.key,
    required this.collectionRef,
  });

  final CollectionRow? collectionRef;

  static String routeName = 'P_Dates_ViewOne';
  static String routePath = '/pDatesViewOne';

  @override
  State<PDatesViewOneWidget> createState() => _PDatesViewOneWidgetState();
}

class _PDatesViewOneWidgetState extends State<PDatesViewOneWidget> {
  late PDatesViewOneModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PDatesViewOneModel());
    _model.descriptionFocusNode ??= FocusNode();
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
                      title: 'Collection Details',
                      subtitle:
                          'Manage collection day, timings, & street assignment',
                      icon: Icons.event_note_rounded,
                    ),

                    FutureBuilder<List<CollectionRow>>(
                      future: CollectionTable().querySingleRow(
                        queryFn: (q) => q.eqOrNull(
                          'collection_id',
                          widget.collectionRef?.collectionId,
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
                        final collection =
                            rows.isNotEmpty ? rows.first : widget.collectionRef;

                        if (collection == null) {
                          return Center(
                            child: Text(
                              'Collection schedule not found.',
                              style: GoogleFonts.inter(
                                color: theme.secondaryText,
                              ),
                            ),
                          );
                        }

                        // Pre-populate fields once
                        _model.dayDropDownValue ??= collection.collectionDay;
                        _model.streetDropDownValue ??=
                            collection.collectionStreetNameRef;
                        _model.descriptionTextController ??=
                            TextEditingController(
                          text: collection.collectionDescription,
                        );

                        final startTimeStr = _model.datePicked1 != null
                            ? dateTimeFormat("jm", _model.datePicked1)
                            : dateTimeFormat(
                                "jm",
                                collection
                                    .collectionTimeDurationStart.time,
                              );

                        final endTimeStr = _model.datePicked2 != null
                            ? dateTimeFormat("jm", _model.datePicked2)
                            : dateTimeFormat(
                                "jm",
                                collection.collectionTimeDurationEnd.time,
                              );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card 1: Schedule Parameters
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
                                    'Schedule Assignment',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF013448),
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),

                                  // Street Assignment Dropdown
                                  Text(
                                    'Assigned Street',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  FutureBuilder<List<StreetRow>>(
                                    future: StreetTable().queryRows(
                                      queryFn: (q) => q.order(
                                        'street_name',
                                        ascending: true,
                                      ),
                                    ),
                                    builder: (context, streetSnap) {
                                      final streetRows =
                                          streetSnap.data ?? [];
                                      final streetOptions = streetRows
                                          .map((s) => s.streetName)
                                          .where((s) => s.isNotEmpty)
                                          .toList();

                                      if (_model.streetDropDownValue != null &&
                                          !streetOptions.contains(
                                              _model.streetDropDownValue)) {
                                        streetOptions.add(
                                            _model.streetDropDownValue!);
                                      }

                                      return FlutterFlowDropDown<String>(
                                        controller: _model
                                                .streetDropDownValueController ??=
                                            FormFieldController<String>(
                                          _model.streetDropDownValue,
                                        ),
                                        options: streetOptions,
                                        onChanged: (val) => safeSetState(
                                            () => _model
                                                .streetDropDownValue = val),
                                        width: double.infinity,
                                        height: 48.0,
                                        textStyle: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E293B),
                                        ),
                                        hintText: 'Select Batasan Street',
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Color(0xFF64748B),
                                          size: 20.0,
                                        ),
                                        fillColor: const Color(0xFFF8FAFC),
                                        elevation: 2.0,
                                        borderColor: const Color(0xFFCBD5E1),
                                        borderWidth: 1.0,
                                        borderRadius: 16.0,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 14.0,
                                          vertical: 4.0,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 14.0),

                                  // Day of Week Dropdown
                                  Text(
                                    'Collection Day',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  FlutterFlowDropDown<String>(
                                    controller: _model
                                            .dayDropDownValueController ??=
                                        FormFieldController<String>(
                                      _model.dayDropDownValue,
                                    ),
                                    options: const [
                                      'Monday',
                                      'Tuesday',
                                      'Wednesday',
                                      'Thursday',
                                      'Friday',
                                      'Saturday',
                                      'Sunday'
                                    ],
                                    onChanged: (val) => safeSetState(
                                        () => _model.dayDropDownValue = val),
                                    width: double.infinity,
                                    height: 48.0,
                                    textStyle: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E293B),
                                    ),
                                    hintText: 'Select Collection Day',
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF64748B),
                                      size: 20.0,
                                    ),
                                    fillColor: const Color(0xFFF8FAFC),
                                    elevation: 2.0,
                                    borderColor: const Color(0xFFCBD5E1),
                                    borderWidth: 1.0,
                                    borderRadius: 16.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 14.0,
                                      vertical: 4.0,
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),

                                  // Pickup Duration Timers
                                  Text(
                                    'Collection Duration',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            final picked =
                                                await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                _model.datePicked1 ??
                                                    DateTime.now(),
                                              ),
                                            );
                                            if (picked != null) {
                                              safeSetState(() {
                                                final now = DateTime.now();
                                                _model.datePicked1 = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                  picked.hour,
                                                  picked.minute,
                                                );
                                              });
                                            }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Container(
                                            height: 48.0,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              border: Border.all(
                                                color: const Color(0xFFCBD5E1),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.schedule_rounded,
                                                  size: 18.0,
                                                  color: Color(0xFF2E78A6),
                                                ),
                                                const SizedBox(width: 8.0),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Start Time',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 10.0,
                                                          color: const Color(
                                                              0xFF64748B),
                                                        ),
                                                      ),
                                                      Text(
                                                        startTimeStr,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 12.5,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                              0xFF1E293B),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            final picked =
                                                await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                _model.datePicked2 ??
                                                    DateTime.now(),
                                              ),
                                            );
                                            if (picked != null) {
                                              safeSetState(() {
                                                final now = DateTime.now();
                                                _model.datePicked2 = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                  picked.hour,
                                                  picked.minute,
                                                );
                                              });
                                            }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Container(
                                            height: 48.0,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              border: Border.all(
                                                color: const Color(0xFFCBD5E1),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.timelapse_rounded,
                                                  size: 18.0,
                                                  color: Color(0xFF31A11F),
                                                ),
                                                const SizedBox(width: 8.0),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'End Time',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 10.0,
                                                          color: const Color(
                                                              0xFF64748B),
                                                        ),
                                                      ),
                                                      Text(
                                                        endTimeStr,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 12.5,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                              0xFF1E293B),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14.0),

                                  // Description Text Area
                                  Text(
                                    'Route Instructions / Notes',
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
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText:
                                          'E.g., Morning regular pickup, truck entrance via gate 2...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF8FAFC),
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 18.0),

                            // Action Buttons
                            FFButtonWidget(
                              onPressed: _isSaving
                                  ? null
                                  : () async {
                                      setState(() => _isSaving = true);
                                      try {
                                        final startVal = _model.datePicked1 ??
                                            collection
                                                .collectionTimeDurationStart
                                                .time;
                                        final endVal = _model.datePicked2 ??
                                            collection
                                                .collectionTimeDurationEnd
                                                .time;

                                        await CollectionTable().update(
                                          data: {
                                            'collection_description': _model
                                                .descriptionTextController
                                                ?.text,
                                            'collection_streetNameRef':
                                                _model.streetDropDownValue,
                                            'collection_day':
                                                _model.dayDropDownValue,
                                            if (startVal != null)
                                              'collection_timeDuration_start':
                                                  supaSerialize<PostgresTime>(
                                                PostgresTime(startVal),
                                              ),
                                            if (endVal != null)
                                              'collection_timeDuration_end':
                                                  supaSerialize<PostgresTime>(
                                                PostgresTime(endVal),
                                              ),
                                            'last_updatedBy': currentUserUid,
                                            'last_updatedTime':
                                                supaSerialize<DateTime>(
                                              functions.getCurrentTime(
                                                getCurrentTimestamp,
                                              ),
                                            ),
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'collection_id',
                                            collection.collectionId,
                                          ),
                                        );

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Collection schedule updated successfully!',
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

                            // Delete Action Button
                            FFButtonWidget(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: CDatesDeletionWidget(
                                        collectionRef: collection,
                                      ),
                                    );
                                  },
                                );
                              },
                              text: 'Delete Schedule',
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
                    activeRoute: 'P_Dates_ViewAll',
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
