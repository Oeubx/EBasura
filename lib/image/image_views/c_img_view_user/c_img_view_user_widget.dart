import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/image/c_dispute_decision/c_dispute_decision_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_img_view_user_model.dart';
export 'c_img_view_user_model.dart';

class CImgViewUserWidget extends StatefulWidget {
  const CImgViewUserWidget({
    super.key,
    required this.imageIDref,
  });

  final ImageRow? imageIDref;

  @override
  State<CImgViewUserWidget> createState() => _CImgViewUserWidgetState();
}

class _CImgViewUserWidgetState extends State<CImgViewUserWidget> {
  late CImgViewUserModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CImgViewUserModel());

    _model.expandableExpandableController =
        ExpandableController(initialExpanded: false)
          ..addListener(() => safeSetState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Verified':
        return const Color(0xFF31A11F); // Eco Green
      case 'Segregated':
        return const Color(0xFF70BF5A); // Leaf Green
      case 'Categorized by Ai':
        return const Color(0xFF2E78A6); // Ocean Blue
      case 'Unsegregated':
      case 'Flagged':
        return const Color(0xFFD32F2F); // Danger Red
      case 'Disputed':
        return const Color(0xFFFF8F00); // Amber
      case 'Uncategorized':
      default:
        return const Color(0xFFE65100); // Warning Orange
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Verified':
        return Icons.verified_rounded;
      case 'Segregated':
        return Icons.check_circle_rounded;
      case 'Categorized by Ai':
        return Icons.smart_toy_rounded;
      case 'Unsegregated':
        return Icons.delete_sweep_rounded;
      case 'Flagged':
        return Icons.flag_rounded;
      case 'Disputed':
        return Icons.hourglass_top_rounded;
      case 'Uncategorized':
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: StreamBuilder<List<ImageRow>>(
        stream: _model.containerSupabaseStream ??= SupaFlow.client
            .from("Image")
            .stream(primaryKey: ['image_id'])
            .eqOrNull(
              'image_id',
              widget.imageIDref?.imageId,
            )
            .map((list) => list.map((item) => ImageRow(item)).toList()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 250.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: const Center(
                child: SizedBox(
                  width: 44.0,
                  height: 44.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF2E78A6),
                    ),
                  ),
                ),
              ),
            );
          }
          final containerImageRowList = snapshot.data!;
          final containerImageRow = containerImageRowList.isNotEmpty
              ? containerImageRowList.first
              : null;

          if (containerImageRow == null) {
            return Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: const Center(
                child: Text('Waste record not found.'),
              ),
            );
          }

          final statusColor = _getStatusColor(containerImageRow.status);
          final statusIcon = _getStatusIcon(containerImageRow.status);

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.90,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 16.0,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44.0,
                      height: 4.0,
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),

                  // Header with Title and Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD5F2E2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Icon(
                              Icons.photo_size_select_actual_rounded,
                              color: Color(0xFF2E78A6),
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scan Details',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E78A6),
                                ),
                              ),
                              Text(
                                'Image verification & categorization breakdown',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (containerImageRow.allowFlagging == true &&
                              containerImageRow.status != 'Flagged')
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF2E78A6),
                                size: 22.0,
                              ),
                              tooltip: 'Flagging Help',
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ),
                                      title: Text(
                                        'Verification Notice',
                                        style: GoogleFonts.comfortaa(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      content: Text(
                                        'Tap the Red Flag icon if you believe the automated categorization or verification decision is incorrect.',
                                        style: GoogleFonts.inter(fontSize: 13.0),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          InkWell(
                            borderRadius: BorderRadius.circular(18.0),
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD5F2E2),
                                  width: 1.0,
                                ),
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.black54,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  // Image Preview Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: const Color(0xFFD5F2E2),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 8.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 10,
                          child: Image.network(
                            containerImageRow.imgReferenceLink,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: const Color(0xFFF2F2F2),
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  color: Colors.black26,
                                  size: 40.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Top Status Pill
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.70),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon,
                                  color: statusColor,
                                  size: 14.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(
                                  containerImageRow.status ?? 'Pending',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Flag Action Icon (if allowed)
                        if (containerImageRow.allowFlagging == true &&
                            containerImageRow.status != 'Flagged')
                          Positioned(
                            top: 10.0,
                            left: 10.0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () async {
                                await ImageTable().update(
                                  data: {
                                    'status': 'Flagged',
                                  },
                                  matchingRows: (rows) => rows.eqOrNull(
                                    'image_id',
                                    containerImageRow.imageId,
                                  ),
                                );
                                safeSetState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 5.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD32F2F),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      blurRadius: 4.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.flag_rounded,
                                      color: Colors.white,
                                      size: 14.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      'Flag Decision',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        // Bottom Metadata Bar
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.80),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FutureBuilder<List<UserRow>>(
                                  future: UserTable().querySingleRow(
                                    queryFn: (q) => q.eqOrNull(
                                      'user_id',
                                      containerImageRow.imgUploader,
                                    ),
                                  ),
                                  builder: (context, snapshot) {
                                    final uploader = snapshot.data?.isNotEmpty == true
                                        ? snapshot.data!.first
                                        : null;
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.person_rounded,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          uploader?.userName ??
                                              ((containerImageRow.imgUploader == null ||
                                                      containerImageRow.imgUploader ==
                                                          '00000000-0000-0000-0000-000000000000')
                                                  ? 'Guest'
                                                  : 'Resident'),
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.white70,
                                      size: 14.0,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      dateTimeFormat(
                                          "Md", containerImageRow.createdAt),
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 11.5,
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
                  const SizedBox(height: 14.0),

                  // Waste Category Chips Row
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildPillChip(
                        label: 'Segregated',
                        isActive: containerImageRow.isSegregated == true,
                        activeColor: const Color(0xFF31A11F),
                        icon: Icons.check_circle_rounded,
                      ),
                      _buildPillChip(
                        label: 'Recyclable',
                        isActive: containerImageRow.categoryRecycling == true,
                        activeColor: const Color(0xFF2E78A6),
                        icon: Icons.recycling_rounded,
                      ),
                      _buildPillChip(
                        label: 'Biodegradable',
                        isActive: containerImageRow.categoryBiode == true,
                        activeColor: const Color(0xFF70BF5A),
                        icon: Icons.eco_rounded,
                      ),
                      _buildPillChip(
                        label: 'Non-Bio',
                        isActive: containerImageRow.categoryNonbiode == true,
                        activeColor: const Color(0xFF546E7A),
                        icon: Icons.delete_outline_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  // Expandable Detailed Description Panel
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color(0xFFD5F2E2),
                        width: 1.0,
                      ),
                    ),
                    child: ExpandableNotifier(
                      controller: _model.expandableExpandableController,
                      child: ExpandablePanel(
                        header: Row(
                          children: [
                            const Icon(
                              Icons.description_rounded,
                              color: Color(0xFF2E78A6),
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Verification Notes & Audit',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E78A6),
                              ),
                            ),
                          ],
                        ),
                        collapsed: Text(
                          containerImageRow.remark?.isNotEmpty == true
                              ? containerImageRow.remark!
                              : 'Tap to view verifier remarks and detailed timestamps.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            FutureBuilder<List<UserRow>>(
                              future: UserTable().querySingleRow(
                                queryFn: (q) => q.eqOrNull(
                                  'user_id',
                                  containerImageRow.updatedBy,
                                ),
                              ),
                              builder: (context, snapshot) {
                                final verifier = snapshot.data?.isNotEmpty == true
                                    ? snapshot.data!.first
                                    : null;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.verified_user_rounded,
                                          color: Color(0xFF31A11F),
                                          size: 16.0,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          containerImageRow.updatedBy?.isNotEmpty == true
                                              ? (verifier?.userName ?? 'Verifier')
                                              : 'Automated AI Detection',
                                          style: GoogleFonts.inter(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (containerImageRow.updatedAt != null)
                                      Text(
                                        dateTimeFormat("Md", containerImageRow.updatedAt!),
                                        style: GoogleFonts.inter(
                                          fontSize: 11.0,
                                          color: Colors.black54,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: const Color(0xFFD5F2E2),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                containerImageRow.remark?.isNotEmpty == true
                                    ? containerImageRow.remark!
                                    : 'No additional notes provided.',
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  color: Colors.black87,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        theme: const ExpandableThemeData(
                          tapHeaderToExpand: true,
                          tapBodyToExpand: false,
                          tapBodyToCollapse: false,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          hasIcon: true,
                          iconColor: Color(0xFF2E78A6),
                        ),
                      ),
                    ),
                  ),

                  // Dispute Decision Button (if flagged, rejected, or unsegregated)
                  if (containerImageRow.status == 'Flagged' ||
                      containerImageRow.status == 'Rejected' ||
                      containerImageRow.status == 'Unsegregated')
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => Padding(
                              padding: MediaQuery.viewInsetsOf(context),
                              child: CDisputeDecisionWidget(
                                imageRef: containerImageRow,
                              ),
                            ),
                          );
                        },
                        text: 'Dispute Verification Decision',
                        icon: const Icon(
                          Icons.gavel_rounded,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 48.0,
                          color: const Color(0xFFD32F2F),
                          textStyle: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                      ),
                    ),

                  // Dispute Pending Banner (if disputed)
                  if (containerImageRow.status == 'Disputed')
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 14.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: const Color(0xFFFFB300),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.hourglass_top_rounded,
                            color: Color(0xFFFF8F00),
                            size: 20.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Dispute Pending Verifier Review',
                            style: GoogleFonts.inter(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF8F00),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPillChip({
    required String label,
    required bool isActive,
    required Color activeColor,
    required IconData icon,
  }) {
    final color = isActive ? activeColor : Colors.black38;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withValues(alpha: 0.12)
            : const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isActive
              ? activeColor.withValues(alpha: 0.4)
              : Colors.black12,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.0,
            color: color,
          ),
          const SizedBox(width: 5.0),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
