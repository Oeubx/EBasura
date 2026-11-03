import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/components/ebasura_buttons.dart';
import '/custom_code/actions/street_compliance_exporter.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_street_compliance_desk_model.dart';
export 'p_street_compliance_desk_model.dart';

class PStreetComplianceDeskWidget extends StatefulWidget {
  const PStreetComplianceDeskWidget({super.key});

  static String routeName = 'P_Street_Compliance_Desk';
  static String routePath = '/pStreetComplianceDesk';

  @override
  State<PStreetComplianceDeskWidget> createState() =>
      _PStreetComplianceDeskWidgetState();
}

class _PStreetComplianceDeskWidgetState
    extends State<PStreetComplianceDeskWidget> {
  late PStreetComplianceDeskModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedTab = 0; // 0 = Snapshots (SCI), 1 = Intervention Queue
  String _gradeFilter = 'ALL';
  String _flagFilter = 'ACTIVE'; // ACTIVE (open, notified, in_followup), ALL, RESOLVED
  bool _isRecomputing = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PStreetComplianceDeskModel());
    _model.searchTextController = TextEditingController();
    _model.searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _triggerRecompute() async {
    setState(() => _isRecomputing = true);
    try {
      await SupaFlow.client.rpc('fn_compute_street_compliance');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Street Compliance Index recomputed successfully.',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF31A11F),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error recomputing SCI: $e',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRecomputing = false);
      }
    }
  }

  Color _getGradeColor(String? grade) {
    switch (grade) {
      case 'A':
        return const Color(0xFF31A11F); // Eco Green
      case 'B':
        return const Color(0xFF70BF5A); // Leaf Green
      case 'C':
        return const Color(0xFFD97706); // Amber
      case 'D':
        return const Color(0xFFDC2626); // Coral Red
      default:
        return const Color(0xFF6B7280); // Neutral Gray
    }
  }

  Color _getFlagStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFFDC2626); // Red
      case 'notified':
        return const Color(0xFFD97706); // Amber
      case 'in_followup':
        return const Color(0xFF2E78A6); // Ocean Blue
      case 'resolved':
        return const Color(0xFF31A11F); // Eco Green
      default:
        return const Color(0xFF6B7280);
    }
  }

  void _showFlagActionDialog(StreetFlagRow flag) {
    final noteController = TextEditingController(text: flag.actionNote ?? '');
    String selectedStatus = flag.status;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = FlutterFlowTheme.of(context);
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.flag_rounded,
                  color: _getFlagStatusColor(selectedStatus),
                  size: 24.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'Intervention: ${flag.streetRef}',
                    style: GoogleFonts.interTight(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flag Status',
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'open',
                        child: Text('Open (Needs Action)'),
                      ),
                      DropdownMenuItem(
                        value: 'notified',
                        child: Text('Notified (Advisory Sent)'),
                      ),
                      DropdownMenuItem(
                        value: 'in_followup',
                        child: Text('In Follow-up (Field Inspection)'),
                      ),
                      DropdownMenuItem(
                        value: 'resolved',
                        child: Text('Resolved (Compliance Restored)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedStatus = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14.0),
                  Text(
                    'Intervention Notes / Action Taken',
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: theme.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    style: GoogleFonts.inter(fontSize: 13.0),
                    decoration: InputDecoration(
                      hintText:
                          'Record barangay follow-up, crew reminders, or education activities...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(color: theme.secondaryText),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () async {
                  Navigator.of(dialogCtx).pop();
                  final now = DateTime.now();
                  await StreetFlagTable().update(
                    data: {
                      'status': selectedStatus,
                      'action_note': noteController.text.trim(),
                      if (selectedStatus == 'resolved')
                        'resolved_at': now.toIso8601String(),
                    },
                    matchingRows: (q) => q.eq('flag_id', flag.flagId),
                  );
                  safeSetState(() {});
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Flag updated for ${flag.streetRef}',
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF31A11F),
                      ),
                    );
                  }
                },
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnapshotDetails(StreetComplianceSnapshotRow snap) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = FlutterFlowTheme.of(ctx);
        final grade = snap.grade ?? 'N/A';
        final gradeColor = _getGradeColor(snap.grade);
        final rolling = snap.sciRolling4 != null
            ? '${snap.sciRolling4!.toStringAsFixed(1)}%'
            : 'Insufficient Data';
        final weekly = snap.sciWeek != null
            ? '${snap.sciWeek!.toStringAsFixed(1)}%'
            : 'Insufficient Data';

        return Container(
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      snap.streetRef,
                      style: GoogleFonts.interTight(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryText,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: gradeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: gradeColor, width: 1.5),
                    ),
                    child: Text(
                      'Grade $grade',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: gradeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                'Week Starting: ${dateTimeFormat('MMM d, y', snap.weekStart)}',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: theme.secondaryText,
                ),
              ),
              const Divider(height: 24.0),
              _buildMetricDetailRow(
                context: ctx,
                label: '4-Week Rolling Cleanliness (SCI)',
                value: rolling,
                highlight: true,
              ),
              const SizedBox(height: 8.0),
              _buildMetricDetailRow(
                context: ctx,
                label: 'Current Week Cleanliness (SCI)',
                value: weekly,
                highlight: false,
              ),
              const SizedBox(height: 8.0),
              _buildMetricDetailRow(
                context: ctx,
                label: 'Verified Citizen Scans',
                value: '${snap.verifiedScans}',
                highlight: false,
              ),
              const SizedBox(height: 8.0),
              _buildMetricDetailRow(
                context: ctx,
                label: 'Segregated Scans',
                value: '${snap.segregatedScans}',
                highlight: false,
              ),
              const SizedBox(height: 8.0),
              _buildMetricDetailRow(
                context: ctx,
                label: 'Valid Incident Reports',
                value: '${snap.validReports}',
                highlight: false,
              ),
              const SizedBox(height: 14.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  'SCI Formula: 100 × (Segregated Scans / Verified Scans) - 5 × min(Reports, 4). '
                  'Sample size guard: Minimum 5 verified scans in target week required to assign a letter grade.',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: theme.secondaryText,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricDetailRow({
    required BuildContext context,
    required String label,
    required String value,
    required bool highlight,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.0,
            color: highlight ? theme.primaryText : theme.secondaryText,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: highlight ? theme.primary : theme.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildSnapshotView(BuildContext context) {
    return FutureBuilder<List<StreetComplianceSnapshotRow>>(
      future: StreetComplianceSnapshotTable().queryRows(
        queryFn: (q) => q.order('week_start', ascending: false),
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

        final allRows = snapshot.data!;
        // Pick latest snapshot per street
        final Map<String, StreetComplianceSnapshotRow> latestPerStreet = {};
        for (final row in allRows) {
          if (!latestPerStreet.containsKey(row.streetRef)) {
            latestPerStreet[row.streetRef] = row;
          }
        }

        var displayList = latestPerStreet.values.toList();

        // Search query filter
        final query = _model.searchTextController?.text.trim().toLowerCase() ?? '';
        if (query.isNotEmpty) {
          displayList = displayList
              .where((s) => s.streetRef.toLowerCase().contains(query))
              .toList();
        }

        // Grade filter
        if (_gradeFilter == 'GRADE_D') {
          displayList = displayList.where((s) => s.grade == 'D').toList();
        } else if (_gradeFilter == 'GRADE_C') {
          displayList = displayList.where((s) => s.grade == 'C').toList();
        } else if (_gradeFilter == 'GRADE_A_B') {
          displayList =
              displayList.where((s) => s.grade == 'A' || s.grade == 'B').toList();
        } else if (_gradeFilter == 'INSUFFICIENT') {
          displayList = displayList.where((s) => s.grade == null).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Summary Row
            _buildSnapshotsKpiRow(context, latestPerStreet.values.toList()),
            const SizedBox(height: 14.0),
            // Grade Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGradeChip('ALL', 'All (${latestPerStreet.length})'),
                  const SizedBox(width: 6.0),
                  _buildGradeChip(
                    'GRADE_D',
                    'Grade D (${latestPerStreet.values.where((s) => s.grade == 'D').length})',
                    color: const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 6.0),
                  _buildGradeChip(
                    'GRADE_C',
                    'Grade C (${latestPerStreet.values.where((s) => s.grade == 'C').length})',
                    color: const Color(0xFFD97706),
                  ),
                  const SizedBox(width: 6.0),
                  _buildGradeChip(
                    'GRADE_A_B',
                    'Grade A/B (${latestPerStreet.values.where((s) => s.grade == 'A' || s.grade == 'B').length})',
                    color: const Color(0xFF31A11F),
                  ),
                  const SizedBox(width: 6.0),
                  _buildGradeChip(
                    'INSUFFICIENT',
                    'Pending Data (${latestPerStreet.values.where((s) => s.grade == null).length})',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14.0),
            if (displayList.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    'No street compliance records matching filter.',
                    style: GoogleFonts.inter(
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                itemBuilder: (context, idx) {
                  final snap = displayList[idx];
                  return _buildSnapshotCard(context, snap);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildSnapshotsKpiRow(
    BuildContext context,
    List<StreetComplianceSnapshotRow> rows,
  ) {
    final gradeDCount = rows.where((r) => r.grade == 'D').length;
    final gradeCCount = rows.where((r) => r.grade == 'C').length;

    return Row(
      children: [
        Expanded(
          child: EBasuraCard(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monitored',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    Icon(
                      Icons.signpost_rounded,
                      size: 16.0,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${rows.length}',
                  style: GoogleFonts.interTight(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                Text(
                  'Active Streets',
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: EBasuraCard(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Critical (D)',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16.0,
                      color: Color(0xFFDC2626),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$gradeDCount',
                  style: GoogleFonts.interTight(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFDC2626),
                  ),
                ),
                Text(
                  'Auto-Flagged',
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: EBasuraCard(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'At Risk (C)',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        color: const Color(0xFFD97706),
                      ),
                    ),
                    const Icon(
                      Icons.priority_high_rounded,
                      size: 16.0,
                      color: Color(0xFFD97706),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$gradeCCount',
                  style: GoogleFonts.interTight(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD97706),
                  ),
                ),
                Text(
                  'Needs Education',
                  style: GoogleFonts.inter(
                    fontSize: 10.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGradeChip(String filterKey, String label, {Color? color}) {
    final isSelected = _gradeFilter == filterKey;
    final theme = FlutterFlowTheme.of(context);
    final activeColor = color ?? theme.primary;

    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.0,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : theme.primaryText,
        ),
      ),
      selected: isSelected,
      selectedColor: activeColor,
      backgroundColor: theme.secondaryBackground,
      onSelected: (_) {
        setState(() => _gradeFilter = filterKey);
      },
    );
  }

  Widget _buildSnapshotCard(
    BuildContext context,
    StreetComplianceSnapshotRow snap,
  ) {
    final theme = FlutterFlowTheme.of(context);
    final grade = snap.grade ?? 'N/A';
    final gradeColor = _getGradeColor(snap.grade);
    final rollingScore = snap.sciRolling4 != null
        ? '${snap.sciRolling4!.toStringAsFixed(1)}%'
        : 'Pending (<5 scans)';

    return InkWell(
      onTap: () => _showSnapshotDetails(snap),
      borderRadius: BorderRadius.circular(16.0),
      child: EBasuraCard(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 38.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color: gradeColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          grade == 'N/A' ? '?' : grade,
                          style: GoogleFonts.comfortaa(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: gradeColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snap.streetRef,
                              style: GoogleFonts.inter(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryText,
                              ),
                            ),
                            Text(
                              'Rolling SCI: $rollingScore',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                color: snap.sciRolling4 != null
                                    ? gradeColor
                                    : theme.secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.0,
                  color: theme.accent4,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCardMiniMetric(
                  'Verified Scans',
                  '${snap.verifiedScans}',
                  theme,
                ),
                _buildCardMiniMetric(
                  'Segregated',
                  '${snap.segregatedScans}',
                  theme,
                ),
                _buildCardMiniMetric(
                  'Reports',
                  '${snap.validReports}',
                  theme,
                ),
                _buildCardMiniMetric(
                  'Week SCI',
                  snap.sciWeek != null
                      ? '${snap.sciWeek!.toStringAsFixed(0)}%'
                      : 'N/A',
                  theme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMiniMetric(
    String label,
    String value,
    FlutterFlowTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.0,
            color: theme.secondaryText,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: theme.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildInterventionQueueView(BuildContext context) {
    return FutureBuilder<List<StreetFlagRow>>(
      future: StreetFlagTable().queryRows(
        queryFn: (q) => q.order('created_at', ascending: false),
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

        var flags = snapshot.data!;
        if (_flagFilter == 'ACTIVE') {
          flags = flags
              .where((f) => f.status != 'resolved')
              .toList();
        } else if (_flagFilter == 'RESOLVED') {
          flags = flags.where((f) => f.status == 'resolved').toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFlagFilterChip('ACTIVE', 'Active Flags (${flags.length})'),
                  const SizedBox(width: 6.0),
                  _buildFlagFilterChip('ALL', 'All Historical Flags'),
                  const SizedBox(width: 6.0),
                  _buildFlagFilterChip('RESOLVED', 'Resolved Cases'),
                ],
              ),
            ),
            const SizedBox(height: 14.0),
            if (flags.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF31A11F),
                        size: 40.0,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'No street intervention flags pending in this view.',
                        style: GoogleFonts.inter(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: flags.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                itemBuilder: (context, idx) {
                  final flag = flags[idx];
                  return _buildFlagCard(context, flag);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildFlagFilterChip(String key, String label) {
    final isSelected = _flagFilter == key;
    final theme = FlutterFlowTheme.of(context);

    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.0,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : theme.primaryText,
        ),
      ),
      selected: isSelected,
      selectedColor: theme.primary,
      backgroundColor: theme.secondaryBackground,
      onSelected: (_) {
        setState(() => _flagFilter = key);
      },
    );
  }

  Widget _buildFlagCard(BuildContext context, StreetFlagRow flag) {
    final theme = FlutterFlowTheme.of(context);
    final statusColor = _getFlagStatusColor(flag.status);

    return EBasuraCard(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.flag_rounded, color: statusColor, size: 20.0),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        flag.streetRef,
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  flag.status.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            flag.actionNote ?? 'No intervention notes recorded.',
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Opened: ${dateTimeFormat('MMM d, y', flag.openedWeek)}',
                style: GoogleFonts.inter(
                  fontSize: 10.0,
                  color: theme.secondaryText,
                ),
              ),
              InkWell(
                onTap: () => _showFlagActionDialog(flag),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_note_rounded, size: 16.0, color: theme.primary),
                      const SizedBox(width: 4.0),
                      Text(
                        'Update Action',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand top row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 18.0,
                              color: theme.primaryText,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/Horizontal_Logo.png',
                          height: 32.0,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 36.0),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    const CPageHeaderWidget(
                      title: 'Street Compliance Desk',
                      subtitle:
                          'Weekly Street Compliance Index (SCI), Rolling Cleanliness & Intervention Flags',
                      icon: Icons.analytics_rounded,
                    ),
                    const SizedBox(height: 14.0),

                    // Desk Control Bar
                    Row(
                      children: [
                        Expanded(
                          child: EBasuraButton(
                            text: _isRecomputing ? 'Computing...' : 'Recompute Now',
                            iconData: Icons.refresh_rounded,
                            isLoading: _isRecomputing,
                            onPressed: _isRecomputing ? () {} : _triggerRecompute,
                            style: EBasuraButtonStyle.button2Primary,
                            height: 42.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        InkWell(
                          onTap: _isExporting
                              ? null
                              : () async {
                                  setState(() => _isExporting = true);
                                  try {
                                    final snapshots =
                                        await StreetComplianceSnapshotTable()
                                            .queryRows(
                                      queryFn: (q) => q.order('week_start',
                                          ascending: false),
                                    );
                                    final flags =
                                        await StreetFlagTable().queryRows(
                                      queryFn: (q) => q,
                                    );
                                    if (context.mounted) {
                                      await StreetComplianceExporter
                                          .exportSnapshotsCSV(
                                        context: context,
                                        snapshots: snapshots,
                                        flags: flags,
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isExporting = false);
                                    }
                                  }
                                },
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            height: 42.0,
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: theme.accent4.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.file_download_outlined,
                                  size: 18.0,
                                  color: theme.primary,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Export',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // View Selector Tabs
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedTab = 0),
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 0
                                      ? theme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Street Snapshots (SCI)',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTab == 0
                                        ? Colors.white
                                        : theme.secondaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedTab = 1),
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == 1
                                      ? theme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Intervention Flags',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTab == 1
                                        ? Colors.white
                                        : theme.secondaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Active Tab View
                    if (_selectedTab == 0)
                      _buildSnapshotView(context)
                    else
                      _buildInterventionQueueView(context),
                  ],
                ),
              ),

              // Bottom Bar
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
