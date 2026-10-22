import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_dates_creation_model.dart';
export 'c_dates_creation_model.dart';

class CDatesCreationWidget extends StatefulWidget {
  const CDatesCreationWidget({super.key});

  @override
  State<CDatesCreationWidget> createState() => _CDatesCreationWidgetState();
}

class _CDatesCreationWidgetState extends State<CDatesCreationWidget> {
  late CDatesCreationModel _model;
  bool _isCreating = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CDatesCreationModel());
    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final startTimeStr = _model.datePicked1 != null
        ? dateTimeFormat("jm", _model.datePicked1)
        : 'Set Start Time';
    final endTimeStr = _model.datePicked2 != null
        ? dateTimeFormat("jm", _model.datePicked2)
        : 'Set End Time';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal drag handle
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
                      Icons.add_task_rounded,
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
                          'New Collection Schedule',
                          style: GoogleFonts.comfortaa(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF013448),
                          ),
                        ),
                        Text(
                          'Configure waste collection timing & route',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF94A3B8),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(
                height: 24.0,
                thickness: 1.0,
                color: Color(0xFFF1F5F9),
              ),

              // Street Selection
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
                  queryFn: (q) => q.order('street_name', ascending: true),
                ),
                builder: (context, snapshot) {
                  final streets = snapshot.data ?? [];
                  final streetNames = streets
                      .map((s) => s.streetName)
                      .where((s) => s.isNotEmpty)
                      .toList();

                  return FlutterFlowDropDown<String>(
                    controller: _model.streetDropDownValueController ??=
                        FormFieldController<String>(null),
                    options: streetNames,
                    onChanged: (val) => safeSetState(
                      () => _model.streetDropDownValue = val,
                    ),
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

              // Day of Week Selection
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
                controller: _model.dayDropDownValueController ??=
                    FormFieldController<String>(null),
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
                  () => _model.dayDropDownValue = val,
                ),
                width: double.infinity,
                height: 48.0,
                textStyle: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
                hintText: 'Select Day of Week',
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

              // Duration Timers
              Text(
                'Pickup Duration',
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
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 6, minute: 0),
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
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 48.0,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16.0),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start Time',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.0,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    startTimeStr,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E293B),
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
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 10, minute: 0),
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
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 48.0,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16.0),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End Time',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.0,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    endTimeStr,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E293B),
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
                controller: _model.descriptionTextController,
                focusNode: _model.descriptionFocusNode,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'E.g., Morning residential route...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: const Color(0xFF94A3B8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFCBD5E1),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFCBD5E1),
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
                  fontSize: 13.0,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 20.0),

              // Submit Button
              FFButtonWidget(
                onPressed: _isCreating
                    ? null
                    : () async {
                        if (_model.streetDropDownValue == null ||
                            _model.streetDropDownValue!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an assigned street.'),
                              backgroundColor: Color(0xFFDC2626),
                            ),
                          );
                          return;
                        }
                        if (_model.dayDropDownValue == null ||
                            _model.dayDropDownValue!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a collection day.'),
                              backgroundColor: Color(0xFFDC2626),
                            ),
                          );
                          return;
                        }
                        if (_model.datePicked1 == null ||
                            _model.datePicked2 == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please pick start and end collection times.',
                              ),
                              backgroundColor: Color(0xFFDC2626),
                            ),
                          );
                          return;
                        }

                        setState(() => _isCreating = true);
                        try {
                          await CollectionTable().insert({
                            'collection_description':
                                _model.descriptionTextController?.text ?? '',
                            'collection_streetNameRef':
                                _model.streetDropDownValue,
                            'collection_day': _model.dayDropDownValue,
                            'collection_timeDuration_start':
                                supaSerialize<PostgresTime>(
                              PostgresTime(_model.datePicked1),
                            ),
                            'collection_timeDuration_end':
                                supaSerialize<PostgresTime>(
                              PostgresTime(_model.datePicked2),
                            ),
                            'last_updatedTime': supaSerialize<DateTime>(
                              functions.getCurrentTime(getCurrentTimestamp),
                            ),
                            'last_updatedBy': currentUserUid,
                            'created_at': supaSerialize<DateTime>(
                              functions.getCurrentTime(getCurrentTimestamp),
                            ),
                          });

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Collection schedule created successfully!',
                                ),
                                backgroundColor: Color(0xFF31A11F),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to create schedule: $e'),
                                backgroundColor: const Color(0xFFDC2626),
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isCreating = false);
                          }
                        }
                      },
                text: _isCreating ? 'Creating...' : 'Create Schedule',
                icon: _isCreating
                    ? null
                    : const Icon(
                        Icons.add_rounded,
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
        ),
      ),
    );
  }
}
