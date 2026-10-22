import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/image/image_views/c_img_view_user/c_img_view_user_widget.dart';
import '/image/image_views/p_img_view_verifier/p_img_view_verifier_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_images_view_all_user_model.dart';
export 'p_images_view_all_user_model.dart';

class PImagesViewAllUserWidget extends StatefulWidget {
  const PImagesViewAllUserWidget({super.key});

  static String routeName = 'P_Images_ViewAll_User';
  static String routePath = '/pImagesViewAllUser';

  @override
  State<PImagesViewAllUserWidget> createState() =>
      _PImagesViewAllUserWidgetState();
}

class _PImagesViewAllUserWidgetState extends State<PImagesViewAllUserWidget> {
  late PImagesViewAllUserModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<ImageRow>>? _imagesFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PImagesViewAllUserModel());
    _loadUserImages();
  }

  void _loadUserImages() {
    if (currentUserUid.isNotEmpty) {
      _imagesFuture = ImageTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('img_uploader', currentUserUid)
            .order('created_at', ascending: false)
            .limit(30),
      );
    } else {
      _imagesFuture = Future.value(<ImageRow>[]);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _loadUserImages();
    });
    await _imagesFuture;
  }

  @override
  void dispose() {
    _model.dispose();
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
      case 'Uncategorized':
      default:
        return Icons.help_outline_rounded;
    }
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
        backgroundColor: const Color(0xFFF2F2F2),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              RefreshIndicator(
                color: const Color(0xFF2E78A6),
                backgroundColor: Colors.white,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 120.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Brand Header Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: () => context.safePop(),
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD5F2E2),
                                  width: 1.0,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000),
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF2E78A6),
                                size: 20.0,
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/Horizontal_Logo.png',
                            height: 42.0,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 40.0),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Page Header Widget
                      const CPageHeaderWidget(
                        title: 'My Uploads',
                        subtitle:
                            'Personal waste scanning, segregation history & validation status',
                        icon: Icons.photo_library_rounded,
                      ),
                      const SizedBox(height: 16.0),

                      // Image Feed Future Builder
                      FutureBuilder<List<ImageRow>>(
                        future: _imagesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 60.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2E78A6),
                                  ),
                                ),
                              ),
                            );
                          }

                          final imageList = snapshot.data ?? [];

                          if (imageList.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 48.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: const Color(0xFFD5F2E2),
                                  width: 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000),
                                    blurRadius: 8.0,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 72.0,
                                    height: 72.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD5F2E2)
                                          .withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.photo_library_outlined,
                                      size: 36.0,
                                      color: Color(0xFF2E78A6),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'No Uploads Found',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF2E78A6),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'You haven\'t scanned or uploaded any waste photos yet. Tap the center camera button below to get started!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return MasonryGridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            itemCount: imageList.length,
                            itemBuilder: (context, index) {
                              final item = imageList[index];
                              final statusColor = _getStatusColor(item.status);
                              final statusIcon = _getStatusIcon(item.status);

                              return InkWell(
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () async {
                                  // Check user role: Admin / Crew go to verifier view, Residents view user details sheet
                                  final userRows = await UserTable().querySingleRow(
                                    queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
                                  );
                                  if (!context.mounted) return;
                                  final currentUser = userRows.isNotEmpty ? userRows.first : null;

                                  if (currentUser?.userType == 'Admin' ||
                                      currentUser?.userType == 'Crew') {
                                    context.pushNamed(
                                      PImgViewVerifierWidget.routeName,
                                      queryParameters: {
                                        'imageIDref': serializeParam(
                                          item,
                                          ParamType.SupabaseRow,
                                        ),
                                      }.withoutNulls,
                                    );
                                  } else {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: true,
                                      context: context,
                                      builder: (ctx) => Padding(
                                        padding: MediaQuery.viewInsetsOf(ctx),
                                        child: CImgViewUserWidget(
                                          imageIDref: item,
                                        ),
                                      ),
                                    );
                                    if (!context.mounted) return;
                                    _handleRefresh();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: const Color(0xFFD5F2E2),
                                      width: 1.2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x0A000000),
                                        blurRadius: 6.0,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Image Thumbnail
                                      Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1.0,
                                            child: Image.network(
                                              item.imgReferenceLink,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) =>
                                                      Container(
                                                color: const Color(0xFFF2F2F2),
                                                child: const Icon(
                                                  Icons.broken_image_rounded,
                                                  color: Colors.black26,
                                                  size: 32.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Status Pill Chip (Top Right)
                                          Positioned(
                                            top: 8.0,
                                            right: 8.0,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 4.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.65),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    statusIcon,
                                                    color: statusColor,
                                                    size: 13.0,
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  Text(
                                                    item.status ?? 'Pending',
                                                    style: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontSize: 10.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Card Footer Metadata
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time_rounded,
                                                  size: 13.0,
                                                  color: Colors.black45,
                                                ),
                                                const SizedBox(width: 4.0),
                                                Expanded(
                                                  child: Text(
                                                    dateTimeFormat(
                                                        "Md", item.createdAt),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 11.0,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6.0),
                                            // Category tag row
                                            Wrap(
                                              spacing: 4.0,
                                              runSpacing: 4.0,
                                              children: [
                                                if (item.categoryRecycling == true)
                                                  _buildCategoryChip('Recyclable', const Color(0xFF2E78A6)),
                                                if (item.categoryBiode == true)
                                                  _buildCategoryChip('Bio', const Color(0xFF70BF5A)),
                                                if (item.categoryNonbiode == true)
                                                  _buildCategoryChip('Non-Bio', const Color(0xFF546E7A)),
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
                    ],
                  ),
                ),
              ),

              // Pinned Bottom Dock
              Align(
                alignment: Alignment.bottomCenter,
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'Page_Profile',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
