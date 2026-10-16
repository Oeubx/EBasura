import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_report_view_images_model.dart';
export 'c_report_view_images_model.dart';

class CReportViewImagesWidget extends StatefulWidget {
  const CReportViewImagesWidget({
    super.key,
    required this.reportIDref,
  });

  final ReportRow? reportIDref;

  @override
  State<CReportViewImagesWidget> createState() =>
      _CReportViewImagesWidgetState();
}

class _CReportViewImagesWidgetState extends State<CReportViewImagesWidget> {
  late CReportViewImagesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CReportViewImagesModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildStatusBadge(String? status, FlutterFlowTheme theme) {
    Color badgeColor;
    IconData badgeIcon;
    String label;

    switch (status) {
      case 'Verified':
        badgeColor = const Color(0xFF31A11F);
        badgeIcon = Icons.verified_rounded;
        label = 'Verified';
        break;
      case 'Segregated':
        badgeColor = const Color(0xFF31A11F);
        badgeIcon = Icons.check_circle_rounded;
        label = 'Segregated';
        break;
      case 'Unsegregated':
        badgeColor = const Color(0xFFC44545);
        badgeIcon = Icons.delete_sweep_rounded;
        label = 'Unsegregated';
        break;
      case 'Flagged':
        badgeColor = const Color(0xFFC44545);
        badgeIcon = Icons.flag_rounded;
        label = 'Flagged';
        break;
      case 'Uncategorized':
      default:
        badgeColor = const Color(0xFFC44545);
        badgeIcon = Icons.help_outline_rounded;
        label = status ?? 'Uncategorized';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            color: badgeColor,
            size: 13.0,
          ),
          const SizedBox(width: 3.0),
          Text(
            label,
            style: GoogleFonts.interTight(
              fontSize: 10.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final streetName = widget.reportIDref?.reportStreetNameRef ?? 'Street';
    final conductedDate = widget.reportIDref?.reportConductedDate;

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
            minHeight: 280.0,
            maxHeight: MediaQuery.sizeOf(context).height * 0.75,
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
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44.0,
                      height: 4.0,
                      margin: const EdgeInsets.only(bottom: 14.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),

                  // Header with Street, Date, and Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.photo_library_rounded,
                                  color: theme.accent3,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    '$streetName Photos',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.interTight(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (conductedDate != null) ...[
                              const SizedBox(height: 2.0),
                              Text(
                                'Recorded on ${dateTimeFormat('yMMMd', conductedDate)}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () => Navigator.pop(context),
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

                  // Image Grid / FutureBuilder
                  Flexible(
                    child: FutureBuilder<List<ImageRow>>(
                      future: ImageTable().queryRows(
                        queryFn: (q) => q
                            .eqOrNull(
                              'img_streetNameRef',
                              widget.reportIDref?.reportStreetNameRef,
                            )
                            .eqOrNull(
                              'created_atDate',
                              supaSerialize<DateTime>(
                                widget.reportIDref?.reportConductedDate,
                              ),
                            )
                            .order('created_at'),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 32.0,
                              height: 32.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.accent3,
                                ),
                              ),
                            ),
                          );
                        }

                        final imageList = snapshot.data!;
                        if (imageList.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 36.0,
                              horizontal: 20.0,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14.0),
                                  decoration: BoxDecoration(
                                    color: theme.primaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 32.0,
                                    color: theme.secondaryText,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  'No waste images found',
                                  style: GoogleFonts.interTight(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'No photos were recorded for this route on this date.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    color: theme.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return MasonryGridView.builder(
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          itemCount: imageList.length,
                          itemBuilder: (context, index) {
                            final imageRow = imageList[index];

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: theme.accent4.withValues(alpha: 0.35),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.network(
                                      imageRow.imgReferenceLink,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        height: 120.0,
                                        color: theme.primaryBackground,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: theme.secondaryText,
                                          size: 28.0,
                                        ),
                                      ),
                                    ),

                                    // Gradient Overlay Bar at Bottom
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 6.0,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withValues(alpha: 0.8),
                                            Colors.black.withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time_rounded,
                                                color: Colors.white,
                                                size: 12.0,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                dateTimeFormat(
                                                  'jm',
                                                  imageRow.createdAt,
                                                ),
                                                style: GoogleFonts.inter(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          _buildStatusBadge(
                                            imageRow.status,
                                            theme,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
