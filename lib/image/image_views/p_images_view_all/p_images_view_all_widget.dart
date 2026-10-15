import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_images_view_all_model.dart';
export 'p_images_view_all_model.dart';

class PImagesViewAllWidget extends StatefulWidget {
  const PImagesViewAllWidget({super.key});

  static String routeName = 'P_Images_ViewAll';
  static String routePath = '/pImagesViewAll';

  @override
  State<PImagesViewAllWidget> createState() => _PImagesViewAllWidgetState();
}

class _PImagesViewAllWidgetState extends State<PImagesViewAllWidget> {
  late PImagesViewAllModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PImagesViewAllModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EDF2),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/Horizontal_Logo.png',
                          width: double.infinity,
                          height: 150.0,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDFF1F1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                12.0, 12.0, 12.0, 85.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // User info + Role header
                                FutureBuilder<List<UserRow>>(
                                  future: UserTable().querySingleRow(
                                    queryFn: (q) => q.eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                                  ),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox(height: 28.0);
                                    }
                                    final rowUser = snapshot.data!.isNotEmpty
                                        ? snapshot.data!.first
                                        : null;
                                    final isAdmin =
                                        rowUser?.userType == 'Admin';

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              isAdmin
                                                  ? Icons.admin_panel_settings
                                                  : Icons.person,
                                              color: FlutterFlowTheme.of(context)
                                                  .primaryText,
                                              size: 22.0,
                                            ),
                                            const SizedBox(width: 6.0),
                                            Text(
                                              rowUser?.userName ?? 'User',
                                              style: FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.interTight(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    color: Colors.black,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 3.0),
                                          decoration: BoxDecoration(
                                            color: isAdmin
                                                ? const Color(0xFF1B3B6F)
                                                : const Color(0xFF2E7D32),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Text(
                                            isAdmin
                                                ? 'Official / Admin'
                                                : 'Resident',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 8.0),

                                const CPageHeaderWidget(
                                  title: 'Waste Feed & Records',
                                  subtitle: 'Browse pending community submissions and verified waste records',
                                  icon: Icons.auto_awesome_motion_rounded,
                                ),
                                const SizedBox(height: 8.0),
                                // Dual Tab Filter: Non-Verified vs Verified
                                Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Tab 0: Non-Verified
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            safeSetState(() {
                                              _model.selectedTabIndex = 0;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: _model.selectedTabIndex == 0
                                                  ? const Color(0xFFE65100)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.hourglass_top_rounded,
                                                  size: 16.0,
                                                  color: _model.selectedTabIndex ==
                                                          0
                                                      ? Colors.white
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                ),
                                                const SizedBox(width: 6.0),
                                                Text(
                                                  'Non-Verified',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        color: _model
                                                                    .selectedTabIndex ==
                                                                0
                                                            ? Colors.white
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Tab 1: Verified
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            safeSetState(() {
                                              _model.selectedTabIndex = 1;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: _model.selectedTabIndex == 1
                                                  ? const Color(0xFF2E7D32)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(9.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.verified_rounded,
                                                  size: 16.0,
                                                  color: _model.selectedTabIndex ==
                                                          1
                                                      ? Colors.white
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                ),
                                                const SizedBox(width: 6.0),
                                                Text(
                                                  'Verified',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        color: _model
                                                                    .selectedTabIndex ==
                                                                1
                                                            ? Colors.white
                                                            : FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6.0),

                                // Subtitle
                                Text(
                                  _model.selectedTabIndex == 0
                                      ? 'Scanned by AI • Tap any item to inspect & verify'
                                      : 'Verified waste records reviewed by officials',
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                const SizedBox(height: 6.0),

                                // Stream of Images with client-side reactive filtering
                                Expanded(
                                  child: StreamBuilder<List<ImageRow>>(
                                    stream: _model
                                            .staggeredViewSupabaseStream ??=
                                        SupaFlow.client
                                            .from("Image")
                                            .stream(primaryKey: ['image_id'])
                                            .order('created_at',
                                                ascending: false)
                                            .limit(100)
                                            .map((list) => list
                                                .map((item) => ImageRow(item))
                                                .toList()),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 40.0,
                                            height: 40.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final allImages = snapshot.data!;
                                      final isVerifiedTab =
                                          _model.selectedTabIndex == 1;
                                      final filteredImages = isVerifiedTab
                                          ? allImages
                                              .where((img) =>
                                                  img.status == 'Verified')
                                              .toList()
                                          : allImages
                                              .where((img) =>
                                                  img.status != 'Verified')
                                              .toList();

                                      if (filteredImages.isEmpty) {
                                        return Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isVerifiedTab
                                                    ? Icons.inventory_2_outlined
                                                    : Icons.done_all_rounded,
                                                color: isVerifiedTab
                                                    ? Colors.grey
                                                    : const Color(0xFF2E7D32),
                                                size: 42.0,
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                isVerifiedTab
                                                    ? 'No verified waste records yet.'
                                                    : 'No pending non-verified waste!',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      font: GoogleFonts
                                                          .interTight(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                isVerifiedTab
                                                    ? 'Inspect non-verified items and verify them.'
                                                    : 'All scanned items have been reviewed.',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelSmall
                                                    .override(
                                                      font: GoogleFonts.inter(),
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryText,
                                                      letterSpacing: 0.0,
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
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                        itemCount: filteredImages.length,
                                        itemBuilder: (context, index) {
                                          final item = filteredImages[index];
                                          final isVerified =
                                              item.status == 'Verified';

                                          return Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            elevation: 2.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                context.pushNamed(
                                                  PImgViewVerifierWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'imageIDref':
                                                        serializeParam(
                                                      item,
                                                      ParamType.SupabaseRow,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  // Image with status badge overlay
                                                  Stack(
                                                    children: [
                                                      Image.network(
                                                        item.imgReferenceLink,
                                                        width: double.infinity,
                                                        height: 120.0,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (_, __, ___) =>
                                                                Container(
                                                          height: 120.0,
                                                          color: Colors
                                                              .grey.shade300,
                                                          child: const Icon(
                                                              Icons.broken_image,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 6.0,
                                                        left: 6.0,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      6.0,
                                                                  vertical: 2.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isVerified
                                                                ? const Color(
                                                                    0xFF2E7D32)
                                                                : const Color(
                                                                    0xFFE65100),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(
                                                                isVerified
                                                                    ? Icons
                                                                        .check_circle
                                                                    : Icons
                                                                        .hourglass_top,
                                                                color: Colors
                                                                    .white,
                                                                size: 11.0,
                                                              ),
                                                              const SizedBox(
                                                                  width: 3.0),
                                                              Text(
                                                                isVerified
                                                                    ? 'Verified'
                                                                    : 'Non-Verified',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Details padding
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Segregated badge
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      6.0,
                                                                  vertical: 2.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: item
                                                                        .isSegregated ==
                                                                    true
                                                                ? const Color(
                                                                    0xFFE8F5E9)
                                                                : const Color(
                                                                    0xFFFFEBEE),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            border: Border.all(
                                                              color: item
                                                                          .isSegregated ==
                                                                      true
                                                                  ? const Color(
                                                                      0xFF81C784)
                                                                  : const Color(
                                                                      0xFFE57373),
                                                              width: 0.5,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            item.isSegregated ==
                                                                    true
                                                                ? '✓ Segregated'
                                                                : '✗ Not Segregated',
                                                            style: TextStyle(
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: item
                                                                          .isSegregated ==
                                                                      true
                                                                  ? const Color(
                                                                      0xFF2E7D32)
                                                                  : const Color(
                                                                      0xFFC62828),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4.0),
                                                        // Category chips wrap
                                                        Wrap(
                                                          spacing: 4.0,
                                                          runSpacing: 2.0,
                                                          children: [
                                                            if (item
                                                                    .categoryRecycling ==
                                                                true)
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5.0,
                                                                    vertical:
                                                                        1.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade50,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3.0),
                                                                ),
                                                                child: Text(
                                                                  'Recyclable',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        9.0,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade800,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (item
                                                                    .categoryBiode ==
                                                                true)
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5.0,
                                                                    vertical:
                                                                        1.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .green
                                                                      .shade50,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3.0),
                                                                ),
                                                                child: Text(
                                                                  'Bio',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        9.0,
                                                                    color: Colors
                                                                        .green
                                                                        .shade800,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (item
                                                                    .categoryNonbiode ==
                                                                true)
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5.0,
                                                                    vertical:
                                                                        1.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .orange
                                                                      .shade50,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3.0),
                                                                ),
                                                                child: Text(
                                                                  'Non-Bio',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        9.0,
                                                                    color: Colors
                                                                        .orange
                                                                        .shade900,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 4.0),
                                                        // Street & date row
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                item
                                                                    .imgStreetNameRef,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: FlutterFlowTheme
                                                                        .of(context)
                                                                    .labelSmall
                                                                    .override(
                                                                      font:
                                                                          GoogleFonts
                                                                              .inter(),
                                                                      fontSize:
                                                                          10.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                    ),
                                                              ),
                                                            ),
                                                            Text(
                                                              dateTimeFormat(
                                                                  "Md",
                                                                  item
                                                                      .createdAt),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelSmall
                                                                  .override(
                                                                    font:
                                                                        GoogleFonts
                                                                            .inter(),
                                                                    fontSize:
                                                                        10.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                  ),
                                                            ),
                                                          ],
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
                    ].divide(const SizedBox(height: 5.0)),
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.cBottomBarModel,
                updateCallback: () => safeSetState(() {}),
                child: const CBottomBarWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
