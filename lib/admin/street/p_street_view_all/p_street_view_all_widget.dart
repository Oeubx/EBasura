import '/admin/street/c_street_creation/c_street_creation_widget.dart';
import '/custom_code/actions/street_compliance_exporter.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_street_view_all_model.dart';
export 'p_street_view_all_model.dart';

class PStreetViewAllWidget extends StatefulWidget {
  const PStreetViewAllWidget({super.key});

  static String routeName = 'P_Street_ViewAll';
  static String routePath = '/pStreetViewAll';

  @override
  State<PStreetViewAllWidget> createState() => _PStreetViewAllWidgetState();
}

class _PStreetViewAllWidgetState extends State<PStreetViewAllWidget> {
  late PStreetViewAllModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PStreetViewAllModel());
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
                      title: 'Batasan Street Directory',
                      subtitle:
                          'Manage community streets, pickup routes, & compliance exports',
                      icon: Icons.alt_route_rounded,
                    ),

                    // Compliance Exporter Action Row
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: FFButtonWidget(
                              onPressed: _isExporting
                                  ? null
                                  : () async {
                                      setState(() => _isExporting = true);
                                      try {
                                        final streets = await StreetTable()
                                            .queryRows(queryFn: (q) => q);
                                        final images = await ImageTable()
                                            .queryRows(queryFn: (q) => q);
                                        final reports = await ReportTable()
                                            .queryRows(queryFn: (q) => q);
                                        if (context.mounted) {
                                          await StreetComplianceExporter
                                              .exportCSV(
                                            context: context,
                                            streets: streets,
                                            images: images,
                                            reports: reports,
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isExporting = false);
                                        }
                                      }
                                    },
                              text: 'Export CSV',
                              icon: const Icon(
                                Icons.table_chart_rounded,
                                size: 16.0,
                              ),
                              options: FFButtonOptions(
                                height: 42.0,
                                color: const Color(0xFF1B5E20),
                                textStyle: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: FFButtonWidget(
                              onPressed: _isExporting
                                  ? null
                                  : () async {
                                      setState(() => _isExporting = true);
                                      try {
                                        final streets = await StreetTable()
                                            .queryRows(queryFn: (q) => q);
                                        final images = await ImageTable()
                                            .queryRows(queryFn: (q) => q);
                                        final reports = await ReportTable()
                                            .queryRows(queryFn: (q) => q);
                                        if (context.mounted) {
                                          await StreetComplianceExporter
                                              .exportPDF(
                                            context: context,
                                            streets: streets,
                                            images: images,
                                            reports: reports,
                                          );
                                        }
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isExporting = false);
                                        }
                                      }
                                    },
                              text: 'Export PDF',
                              icon: const Icon(
                                Icons.picture_as_pdf_rounded,
                                size: 16.0,
                              ),
                              options: FFButtonOptions(
                                height: 42.0,
                                color: const Color(0xFFDC2626),
                                textStyle: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                elevation: 0.0,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Streets Listing
                    FutureBuilder<List<StreetRow>>(
                      future: StreetTable().queryRows(
                        queryFn: (q) => q.order('street_name', ascending: true),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF2E78A6),
                                ),
                              ),
                            ),
                          );
                        }

                        final streetList = snapshot.data!;

                        if (streetList.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(28.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.location_off_rounded,
                                  size: 40.0,
                                  color: Color(0xFF94A3B8),
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  'No Streets Registered',
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF013448),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Tap the + button below to add a new street record.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: streetList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10.0),
                          itemBuilder: (context, index) {
                            final street = streetList[index];
                            final hasStorage = street.hasStorage ?? false;
                            final desc = street.streetDescription;

                            return InkWell(
                              onTap: () async {
                                context.pushNamed(
                                  PStreetViewOneWidget.routeName,
                                  queryParameters: {
                                    'streetsRef': serializeParam(
                                      street,
                                      ParamType.SupabaseRow,
                                    ),
                                  }.withoutNulls,
                                );
                              },
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                    width: 1.0,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x06000000),
                                      blurRadius: 8.0,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42.0,
                                      height: 42.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F1F8),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        color: Color(0xFF2E78A6),
                                        size: 22.0,
                                      ),
                                    ),
                                    const SizedBox(width: 14.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            street.streetName,
                                            style: GoogleFonts.interTight(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF1E293B),
                                            ),
                                          ),
                                          if (desc != null && desc.isNotEmpty) ...[
                                            const SizedBox(height: 2.0),
                                            Text(
                                              desc,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 12.0,
                                                color: const Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 6.0),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 2.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: hasStorage
                                                  ? const Color(0xFFD5F2E2)
                                                  : const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              hasStorage
                                                  ? 'Waste Storage Facility'
                                                  : 'No Direct Storage',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                color: hasStorage
                                                    ? const Color(0xFF31A11F)
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      size: 22.0,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Floating Action Button
              Positioned(
                bottom: 86.0,
                right: 20.0,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x282E78A6),
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FlutterFlowIconButton(
                    borderRadius: 26.0,
                    buttonSize: 52.0,
                    fillColor: const Color(0xFF2E78A6),
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28.0,
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: const CStreetCreationWidget(),
                          );
                        },
                      ).then((_) => safeSetState(() {}));
                    },
                  ),
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
