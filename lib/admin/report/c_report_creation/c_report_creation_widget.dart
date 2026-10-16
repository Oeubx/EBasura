import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_report_creation_model.dart';
export 'c_report_creation_model.dart';

class CReportCreationWidget extends StatefulWidget {
  const CReportCreationWidget({super.key});

  @override
  State<CReportCreationWidget> createState() => _CReportCreationWidgetState();
}

class _CReportCreationWidgetState extends State<CReportCreationWidget> {
  late CReportCreationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CReportCreationModel());

    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();

    _model.remarksTextController ??= TextEditingController();
    _model.remarksFocusNode ??= FocusNode();

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
      alignment: const AlignmentDirectional(0.0, 1.0),
      child: Material(
        color: Colors.transparent,
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            border: Border(
              top: BorderSide(
                color: theme.accent4.withValues(alpha: 0.5),
                width: 1.0,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44.0,
                      height: 4.0,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),

                  // Header with Title and Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: theme.accent3.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Icon(
                              Icons.post_add_rounded,
                              color: theme.accent3,
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            'New Collection Report',
                            style: GoogleFonts.interTight(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryText,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () {
                          _model.descriptionTextController?.clear();
                          _model.remarksTextController?.clear();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: theme.secondaryText,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Scrollable Form Fields
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Street Dropdown
                          Text(
                            'ASSIGNED STREET',
                            style: GoogleFonts.inter(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: theme.secondaryText,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          FutureBuilder<List<StreetRow>>(
                            future: StreetTable().queryRows(
                              queryFn: (q) => q.eqOrNull('has_storage', true),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  height: 46.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: theme.primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.accent3,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final streetList = snapshot.data!;
                              return Container(
                                height: 46.0,
                                decoration: BoxDecoration(
                                  color: theme.primaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: theme.accent4.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: FlutterFlowDropDown<String>(
                                  controller:
                                      _model.streetDropDownValueController ??=
                                          FormFieldController<String>(
                                    _model.streetDropDownValue ??=
                                        streetList.firstOrNull?.streetName,
                                  ),
                                  options: streetList
                                      .map((e) => e.streetName)
                                      .toList(),
                                  onChanged: (val) => safeSetState(
                                      () => _model.streetDropDownValue = val),
                                  width: double.infinity,
                                  height: 46.0,
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 13.0,
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
                                  borderRadius: 12.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  hidesUnderline: true,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 14.0),

                          // Date Picker Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: theme.accent4.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            'yMd',
                                            _model.datePicked ??
                                                getCurrentTimestamp,
                                          ),
                                          style: GoogleFonts.interTight(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: theme.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                EBasuraButton.button3(
                                  width: 108.0,
                                  height: 34.0,
                                  text: 'Pick Date',
                                  iconData: Icons.edit_calendar_rounded,
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _model.datePicked ??
                                          getCurrentTimestamp,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2050),
                                      builder: (context, child) {
                                        return wrapInMaterialDatePickerTheme(
                                          context,
                                          child!,
                                          headerBackgroundColor: theme.accent3,
                                          headerForegroundColor: Colors.white,
                                          headerTextStyle:
                                              GoogleFonts.interTight(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          pickerBackgroundColor: Colors.white,
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
                                    if (picked != null) {
                                      safeSetState(() {
                                        _model.datePicked = picked;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14.0),

                          // Description Field
                          Text(
                            'REPORT DESCRIPTION',
                            style: GoogleFonts.inter(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: theme.secondaryText,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          TextFormField(
                            controller: _model.descriptionTextController,
                            focusNode: _model.descriptionFocusNode,
                            autofocus: false,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText:
                                  'Enter collection summary or route details...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13.0,
                                color:
                                    theme.secondaryText.withValues(alpha: 0.6),
                              ),
                              filled: true,
                              fillColor: theme.primaryBackground,
                              contentPadding: const EdgeInsets.all(12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: theme.accent4.withValues(alpha: 0.5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: theme.accent4.withValues(alpha: 0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: theme.accent3,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              color: theme.primaryText,
                            ),
                          ),
                          const SizedBox(height: 14.0),

                          // Remarks Field
                          Text(
                            'REMARKS (OPTIONAL)',
                            style: GoogleFonts.inter(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: theme.secondaryText,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          TextFormField(
                            controller: _model.remarksTextController,
                            focusNode: _model.remarksFocusNode,
                            autofocus: false,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText:
                                  'Any special notes, incident reports, or instructions...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13.0,
                                color:
                                    theme.secondaryText.withValues(alpha: 0.6),
                              ),
                              filled: true,
                              fillColor: theme.primaryBackground,
                              contentPadding: const EdgeInsets.all(12.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: theme.accent4.withValues(alpha: 0.5),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: theme.accent4.withValues(alpha: 0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                  color: theme.accent3,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              color: theme.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18.0),

                  // Create Action Button
                  EBasuraButton.button2(
                    width: double.infinity,
                    height: 46.0,
                    text: 'Create Report',
                    iconData: Icons.add_task_rounded,
                    onPressed: () async {
                      final desc =
                          _model.descriptionTextController?.text.trim() ?? '';
                      if (desc.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please provide a report description.',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            duration: const Duration(milliseconds: 3000),
                            backgroundColor: const Color(0xFFC44545),
                          ),
                        );
                        return;
                      }

                      await ReportTable().insert({
                        'created_at': supaSerialize<DateTime>(
                          functions.getCurrentTime(getCurrentTimestamp),
                        ),
                        'report_description': desc,
                        'report_remarks':
                            _model.remarksTextController?.text.trim() ?? '',
                        'report_streetNameRef': _model.streetDropDownValue,
                        'report_conductedDate': supaSerialize<DateTime>(
                          _model.datePicked ?? getCurrentTimestamp,
                        ),
                        'reporter_userRef': currentUserUid,
                      });

                      safeSetState(() {
                        _model.descriptionTextController?.clear();
                        _model.remarksTextController?.clear();
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
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
