import '/admin/report/c_report_deletion/c_report_deletion_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_report_view_one_model.dart';
export 'p_report_view_one_model.dart';

class PReportViewOneWidget extends StatefulWidget {
  const PReportViewOneWidget({
    super.key,
    required this.reportRef,
  });

  final ReportRow? reportRef;

  static String routeName = 'P_Report_ViewOne';
  static String routePath = '/pReportViewOne';

  @override
  State<PReportViewOneWidget> createState() => _PReportViewOneWidgetState();
}

class _PReportViewOneWidgetState extends State<PReportViewOneWidget> {
  late PReportViewOneModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PReportViewOneModel());
    _model.forEditDescFocusNode ??= FocusNode();
    _model.forEditRemarksFocusNode ??= FocusNode();
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
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Page Title & Return Action
                    CPageHeaderWidget(
                      title: 'Report Inspection',
                      subtitle: 'Review & update collection report details',
                      icon: Icons.edit_note_rounded,
                      trailing: InkWell(
                        onTap: () async {
                          context.safePop();
                        },
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: theme.accent4.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                size: 16.0,
                                color: theme.primaryText,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                'Back',
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: theme.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    // Main Report Query & Form Card
                    FutureBuilder<List<ReportRow>>(
                      future: ReportTable().querySingleRow(
                        queryFn: (q) => q.eqOrNull(
                          'report_id',
                          widget.reportRef?.reportId,
                        ),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final containerReportRowList = snapshot.data!;
                        final containerReportRow =
                            containerReportRowList.isNotEmpty
                                ? containerReportRowList.first
                                : null;

                        if (containerReportRow == null) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                'Report not found.',
                                style: theme.bodyMedium,
                              ),
                            ),
                          );
                        }

                        // Initialize field controllers once
                        _model.forEditDescTextController ??=
                            TextEditingController(
                          text: containerReportRow.reportDescription,
                        );
                        _model.forEditRemarksTextController ??=
                            TextEditingController(
                          text: containerReportRow.reportRemarks,
                        );
                        _model.streetDropDownValue ??=
                            containerReportRow.reportStreetNameRef;

                        final conductedDate = _model.datePicked ??
                            containerReportRow.reportConductedDate;

                        return EBasuraCard(
                          padding: const EdgeInsets.all(20.0),
                          margin: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Date Picker Row
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                  vertical: 10.0,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color:
                                        theme.accent4.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          color: theme.accent3,
                                          size: 20.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'COLLECTION DATE',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5,
                                                color: theme.secondaryText,
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),
                                            Text(
                                              dateTimeFormat(
                                                  'yMd', conductedDate),
                                              style: GoogleFonts.interTight(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color: theme.primaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    EBasuraButton.button3(
                                      width: 120.0,
                                      height: 36.0,
                                      text: 'Change Date',
                                      iconData: Icons.edit_calendar_rounded,
                                      onPressed: () async {
                                        final pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: conductedDate,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2050),
                                          builder: (context, child) {
                                            return wrapInMaterialDatePickerTheme(
                                              context,
                                              child!,
                                              headerBackgroundColor:
                                                  theme.accent3,
                                              headerForegroundColor:
                                                  Colors.white,
                                              headerTextStyle:
                                                  GoogleFonts.interTight(
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              pickerBackgroundColor:
                                                  Colors.white,
                                              pickerForegroundColor:
                                                  theme.primaryText,
                                              selectedDateTimeBackgroundColor:
                                                  theme.accent3,
                                              selectedDateTimeForegroundColor:
                                                  Colors.white,
                                              actionButtonForegroundColor:
                                                  theme.accent3,
                                              iconSize: 24.0,
                                            );
                                          },
                                        );

                                        if (pickedDate != null) {
                                          safeSetState(() {
                                            _model.datePicked = DateTime(
                                              pickedDate.year,
                                              pickedDate.month,
                                              pickedDate.day,
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // 2. Street Selector Dropdown
                              Text(
                                'ASSIGNED STREET',
                                style: GoogleFonts.inter(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: theme.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              FutureBuilder<List<StreetRow>>(
                                future: StreetTable().queryRows(
                                  queryFn: (q) => q
                                      .eqOrNull('has_storage', true)
                                      .order('street_name'),
                                ),
                                builder: (context, streetSnapshot) {
                                  final streetNames = streetSnapshot.hasData
                                      ? streetSnapshot.data!
                                          .map((e) => e.streetName)
                                          .toList()
                                      : <String>[];

                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: theme.accent4
                                            .withValues(alpha: 0.5),
                                        width: 1.0,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                    ),
                                    child: FlutterFlowDropDown<String>(
                                      controller: _model
                                              .streetDropDownValueController ??=
                                          FormFieldController<String>(
                                        _model.streetDropDownValue ??=
                                            containerReportRow
                                                .reportStreetNameRef,
                                      ),
                                      options: streetNames,
                                      onChanged: (val) => safeSetState(
                                          () => _model.streetDropDownValue =
                                              val),
                                      height: 44.0,
                                      textStyle: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: theme.primaryText,
                                      ),
                                      hintText: 'Select a Street...',
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: theme.secondaryText,
                                        size: 22.0,
                                      ),
                                      fillColor: Colors.transparent,
                                      elevation: 2.0,
                                      borderColor: Colors.transparent,
                                      borderWidth: 0.0,
                                      borderRadius: 0.0,
                                      margin: EdgeInsets.zero,
                                      hidesUnderline: true,
                                      isOverButton: false,
                                      isSearchable: false,
                                      isMultiSelect: false,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16.0),

                              // 3. Report Description Input
                              Text(
                                'REPORT DESCRIPTION',
                                style: GoogleFonts.inter(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: theme.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              TextFormField(
                                controller:
                                    _model.forEditDescTextController,
                                focusNode: _model.forEditDescFocusNode,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter collection summary and notes...',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    color: theme.secondaryText,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.accent4
                                          .withValues(alpha: 0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.accent3,
                                      width: 1.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: const EdgeInsets.all(14.0),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 16.0),

                              // 4. Remarks Input
                              Text(
                                'ADDITIONAL REMARKS',
                                style: GoogleFonts.inter(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: theme.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              TextFormField(
                                controller:
                                    _model.forEditRemarksTextController,
                                focusNode: _model.forEditRemarksFocusNode,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter crew observations or flags...',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 13.0,
                                    color: theme.secondaryText,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.accent4
                                          .withValues(alpha: 0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.accent3,
                                      width: 1.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: const EdgeInsets.all(14.0),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 24.0),

                              // 5. Action Buttons (Delete & Update)
                              Row(
                                children: [
                                  // Danger Pill Button (Delete)
                                  Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          enableDrag: false,
                                          context: context,
                                          builder: (context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child:
                                                    CReportDeletionWidget(
                                                  reportRef:
                                                      containerReportRow,
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) =>
                                            safeSetState(() {}));
                                      },
                                      borderRadius:
                                          BorderRadius.circular(22.0),
                                      child: Container(
                                        height: 44.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFDE8E8),
                                          borderRadius:
                                              BorderRadius.circular(22.0),
                                          border: Border.all(
                                            color: const Color(0xFFF8B4B4),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.delete_outline_rounded,
                                              color: Color(0xFFC44545),
                                              size: 18.0,
                                            ),
                                            const SizedBox(width: 6.0),
                                            Text(
                                              'Delete',
                                              style: GoogleFonts.inter(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFFC44545),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),

                                  // Button 2 Ocean Blue Pill (Update)
                                  Expanded(
                                    flex: 3,
                                    child: EBasuraButton.button2(
                                      width: double.infinity,
                                      height: 44.0,
                                      text: 'Save Changes',
                                      iconData: Icons.save_rounded,
                                      onPressed: () async {
                                        await ReportTable().update(
                                          data: {
                                            'created_at':
                                                supaSerialize<DateTime>(
                                                    functions.getCurrentTime(
                                                        getCurrentTimestamp)),
                                            'reporter_userRef': currentUserUid,
                                            'report_description': _model
                                                .forEditDescTextController
                                                ?.text,
                                            'report_remarks': _model
                                                .forEditRemarksTextController
                                                ?.text,
                                            'report_conductedDate':
                                                supaSerialize<DateTime>(
                                                    _model.datePicked ??
                                                        containerReportRow
                                                            .reportConductedDate),
                                            'report_streetNameRef':
                                                _model.streetDropDownValue ??
                                                    containerReportRow
                                                        .reportStreetNameRef,
                                          },
                                          matchingRows: (rows) =>
                                              rows.eqOrNull(
                                            'report_id',
                                            containerReportRow.reportId,
                                          ),
                                        );

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Report successfully updated.',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                ),
                                              ),
                                              duration: const Duration(
                                                  milliseconds: 3000),
                                              backgroundColor:
                                                  theme.accent3,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom Navigation Bar
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
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
