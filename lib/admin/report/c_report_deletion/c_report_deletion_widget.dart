import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_report_deletion_model.dart';
export 'c_report_deletion_model.dart';

class CReportDeletionWidget extends StatefulWidget {
  const CReportDeletionWidget({
    super.key,
    required this.reportRef,
  });

  final ReportRow? reportRef;

  @override
  State<CReportDeletionWidget> createState() => _CReportDeletionWidgetState();
}

class _CReportDeletionWidgetState extends State<CReportDeletionWidget> {
  late CReportDeletionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CReportDeletionModel());

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
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: 320.0,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: theme.accent4.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon Badge
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE8E8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFC44545).withValues(alpha: 0.25),
                  ),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFC44545),
                  size: 32.0,
                ),
              ),
              const SizedBox(height: 16.0),

              // Title
              Text(
                'Delete Collection Report?',
                textAlign: TextAlign.center,
                style: GoogleFonts.interTight(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(height: 8.0),

              // Description
              Text(
                'This action is irreversible. All summary metrics for this route will be permanently deleted.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  color: theme.secondaryText,
                  height: 1.4,
                ),
              ),

              // Street & Date preview chip if available
              if (widget.reportRef != null) ...[
                const SizedBox(height: 14.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: theme.accent4.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.0,
                        color: theme.accent3,
                      ),
                      const SizedBox(width: 4.0),
                      Flexible(
                        child: Text(
                          widget.reportRef!.reportStreetNameRef,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.interTight(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '|',
                        style: TextStyle(
                          color: theme.secondaryText.withValues(alpha: 0.4),
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        dateTimeFormat(
                          'yMd',
                          widget.reportRef!.reportConductedDate,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 22.0),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: EBasuraButton.button1(
                      height: 42.0,
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Material(
                      color: const Color(0xFFC44545),
                      borderRadius: BorderRadius.circular(22.0),
                      elevation: 1.0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22.0),
                        onTap: () async {
                          await ReportTable().delete(
                            matchingRows: (rows) => rows.eqOrNull(
                              'report_id',
                              widget.reportRef?.reportId,
                            ),
                          );

                          if (context.mounted) {
                            context.goNamed(PReportViewAllWidget.routeName);
                          }
                        },
                        child: Container(
                          height: 42.0,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                'Delete',
                                style: GoogleFonts.interTight(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
