import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_images_view_all_model.dart';
export 'p_images_view_all_model.dart';

class PImagesViewAllWidget extends StatefulWidget {
  const PImagesViewAllWidget({
    super.key,
    this.initialTabIndex = 0,
    this.initialStatus,
    this.initialStreet,
  });

  final int initialTabIndex;
  final String? initialStatus;
  final String? initialStreet;

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
    _model.selectedTabIndex = widget.initialTabIndex;

    if (widget.initialStreet != null && widget.initialStreet!.isNotEmpty) {
      _model.selectedStreet = widget.initialStreet!;
    }

    if (widget.initialStatus != null && widget.initialStatus!.isNotEmpty) {
      final s = widget.initialStatus!;
      if (s == 'Non-Verified' || s == 'NON-VERIFIED') {
        _model.activeQuickFilter = 'All';
        _model.dropDownStatusValue = 'All';
        _model.selectedTabIndex = 0;
      } else if (s == 'Categorized by Ai' || s == 'AI Categorized') {
        _model.activeQuickFilter = 'AI Categorized';
        _model.dropDownStatusValue = 'Categorized by Ai';
        _model.selectedTabIndex = 0;
      } else if (s == 'Uncategorized') {
        _model.activeQuickFilter = 'Uncategorized';
        _model.dropDownStatusValue = 'Uncategorized';
        _model.selectedTabIndex = 0;
      } else if (s == 'Segregated') {
        _model.activeQuickFilter = 'Segregated';
        _model.dropDownStatusValue = 'Segregated';
        _model.selectedTabIndex = 0;
      } else if (s == 'Unsegregated') {
        _model.activeQuickFilter = 'Unsegregated';
        _model.dropDownStatusValue = 'Unsegregated';
        _model.selectedTabIndex = 0;
      } else if (s == 'Verified') {
        _model.activeQuickFilter = 'Verified';
        _model.dropDownStatusValue = 'Verified';
        _model.selectedTabIndex = 1;
      } else if (s == 'Flagged') {
        _model.activeQuickFilter = 'Flagged';
        _model.dropDownStatusValue = 'Flagged';
        _model.selectedTabIndex = 0;
      } else if (s == 'Recyclable') {
        _model.activeQuickFilter = 'Recyclable';
        _model.dropDownStatusValue = 'All';
        _model.selectedTabIndex = 0;
      } else if (s == 'Biodegradable') {
        _model.activeQuickFilter = 'Biodegradable';
        _model.dropDownStatusValue = 'All';
        _model.selectedTabIndex = 0;
      }
    } else if (widget.initialTabIndex == 1) {
      _model.activeQuickFilter = 'Verified';
      _model.dropDownStatusValue = 'Verified';
      _model.selectedTabIndex = 1;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).alternate,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Advanced Filters',
                          style: FlutterFlowTheme.of(context).titleLarge,
                        ),
                        if (_model.hasActiveAdvancedFilters)
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                _model.resetAllFilters();
                              });
                              safeSetState(() {});
                            },
                            child: Text(
                              'Reset All',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).error,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12.0),
                    Text(
                      'Street / Location',
                      style: FlutterFlowTheme.of(context).labelLarge,
                    ),
                    const SizedBox(height: 8.0),
                    FutureBuilder<List<StreetRow>>(
                      future: StreetTable().queryRows(
                        queryFn: (q) => q.order('street_name'),
                      ),
                      builder: (context, snapshot) {
                        List<String> streetOptions = ['All'];
                        if (snapshot.hasData && snapshot.data != null) {
                          streetOptions.addAll(
                            snapshot.data!
                                .map((s) => s.streetName)
                                .where((s) => s.isNotEmpty)
                                .toSet()
                                .toList(),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: streetOptions.contains(_model.selectedStreet)
                                  ? _model.selectedStreet
                                  : 'All',
                              items: streetOptions.map((street) {
                                return DropdownMenuItem<String>(
                                  value: street,
                                  child: Text(
                                    street == 'All' ? 'All Streets' : street,
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() {
                                    _model.selectedStreet = val;
                                  });
                                  safeSetState(() {});
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Waste Attributes',
                      style: FlutterFlowTheme.of(context).labelLarge,
                    ),
                    const SizedBox(height: 8.0),
                    SwitchListTile.adaptive(
                      title: Text(
                        'Recyclable Waste Only',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      value: _model.filterRecyclable,
                      activeTrackColor: FlutterFlowTheme.of(context).primary,
                      activeThumbColor: FlutterFlowTheme.of(context).primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() {
                          _model.filterRecyclable = val;
                        });
                        safeSetState(() {});
                      },
                    ),
                    SwitchListTile.adaptive(
                      title: Text(
                        'Biodegradable Waste Only',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      value: _model.filterBiodegradable,
                      activeTrackColor: FlutterFlowTheme.of(context).primary,
                      activeThumbColor: FlutterFlowTheme.of(context).primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() {
                          _model.filterBiodegradable = val;
                        });
                        safeSetState(() {});
                      },
                    ),
                    SwitchListTile.adaptive(
                      title: Text(
                        'Segregated Waste Only',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      value: _model.filterSegregated,
                      activeTrackColor: FlutterFlowTheme.of(context).primary,
                      activeThumbColor: FlutterFlowTheme.of(context).primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() {
                          _model.filterSegregated = val;
                        });
                        safeSetState(() {});
                      },
                    ),
                    const SizedBox(height: 14.0),
                    Text(
                      'Sort Direction',
                      style: FlutterFlowTheme.of(context).labelLarge,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                'Newest First',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: _model.sortNewestFirst
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: _model.sortNewestFirst
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            selected: _model.sortNewestFirst,
                            selectedColor: FlutterFlowTheme.of(context).primary,
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                color: _model.sortNewestFirst
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            onSelected: (val) {
                              if (val) {
                                setModalState(() {
                                  _model.sortNewestFirst = true;
                                  _model.resetStream();
                                });
                                safeSetState(() {});
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                'Oldest First',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: !_model.sortNewestFirst
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: !_model.sortNewestFirst
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            selected: !_model.sortNewestFirst,
                            selectedColor: FlutterFlowTheme.of(context).primary,
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                color: !_model.sortNewestFirst
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            onSelected: (val) {
                              if (val) {
                                setModalState(() {
                                  _model.sortNewestFirst = false;
                                  _model.resetStream();
                                });
                                safeSetState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    FFButtonWidget(
                      onPressed: () {
                        Navigator.pop(context);
                        safeSetState(() {});
                      },
                      text: 'Apply Filters',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 44.0,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              font: GoogleFonts.interTight(),
                              color: Colors.white,
                            ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                          height: 90.0,
                          fit: BoxFit.contain,
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
                                const SizedBox(height: 6.0),

                                const CPageHeaderWidget(
                                  title: 'Waste Feed & Records',
                                  subtitle: 'Browse community submissions and verified waste records',
                                  icon: Icons.auto_awesome_motion_rounded,
                                ),
                                const SizedBox(height: 6.0),

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
                                              if (_model.activeQuickFilter == 'Verified') {
                                                _model.activeQuickFilter = 'All';
                                                _model.dropDownStatusValue = 'All';
                                              }
                                              _model.resetStream();
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
                                              _model.activeQuickFilter = 'Verified';
                                              _model.dropDownStatusValue = 'Verified';
                                              _model.resetStream();
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

                                // Real-Time Search Bar
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 2.0, 0.0, 4.0),
                                  child: TextFormField(
                                    controller: _model.searchController,
                                    focusNode: _model.searchFocusNode,
                                    onChanged: (val) {
                                      safeSetState(() {
                                        _model.searchQuery =
                                            val.trim().toLowerCase();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          'Search street, status, or tags...',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 8.0, 12.0, 8.0),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 20.0,
                                      ),
                                      suffixIcon: _model.searchQuery.isNotEmpty
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.clear_rounded,
                                                size: 18.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                              onPressed: () {
                                                _model.searchController?.clear();
                                                safeSetState(() {
                                                  _model.searchQuery = '';
                                                });
                                              },
                                            )
                                          : null,
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ),

                                // Quick Filter Chips & Advanced Controls Row
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 2.0, 0.0, 6.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              'All',
                                              'Segregated',
                                              'Unsegregated',
                                              'Recyclable',
                                              'Biodegradable',
                                              'Verified',
                                              'Flagged',
                                              'AI Categorized',
                                            ].map((filterName) {
                                              final isSelected =
                                                  _model.activeQuickFilter ==
                                                      filterName;
                                              return Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 6.0, 0.0),
                                                child: ChoiceChip(
                                                  label: Text(
                                                    filterName,
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                  selected: isSelected,
                                                  selectedColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    side: BorderSide(
                                                      color: isSelected
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primary
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                    ),
                                                  ),
                                                  onSelected: (selected) {
                                                    if (selected) {
                                                      safeSetState(() {
                                                        _model.activeQuickFilter =
                                                            filterName;
                                                        if (filterName == 'All') {
                                                          _model.dropDownStatusValue =
                                                              'All';
                                                        } else if (filterName ==
                                                            'AI Categorized') {
                                                          _model.dropDownStatusValue =
                                                              'Categorized by Ai';
                                                          _model.selectedTabIndex = 0;
                                                        } else if (filterName ==
                                                            'Verified') {
                                                          _model.dropDownStatusValue =
                                                              'Verified';
                                                          _model.selectedTabIndex = 1;
                                                        } else if (filterName ==
                                                                'Segregated' ||
                                                            filterName ==
                                                                'Unsegregated' ||
                                                            filterName ==
                                                                'Uncategorized' ||
                                                            filterName ==
                                                                'Flagged') {
                                                          _model.dropDownStatusValue =
                                                              filterName;
                                                          _model.selectedTabIndex = 0;
                                                        } else {
                                                          _model.dropDownStatusValue =
                                                              'All';
                                                          _model.selectedTabIndex = 0;
                                                        }
                                                        _model.resetStream();
                                                      });
                                                    }
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            _openFilterBottomSheet(context),
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: _model
                                                    .hasActiveAdvancedFilters
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                    .withValues(alpha: 0.15)
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: _model
                                                      .hasActiveAdvancedFilters
                                                  ? FlutterFlowTheme.of(context)
                                                      .primary
                                                  : FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.tune_rounded,
                                                size: 20.0,
                                                color: _model
                                                        .hasActiveAdvancedFilters
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primary
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                              ),
                                              if (_model.activeFilterCount > 0) ...[
                                                const SizedBox(width: 4.0),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 1.0),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Text(
                                                    '${_model.activeFilterCount}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6.0),
                                      InkWell(
                                        onTap: () {
                                          safeSetState(() {
                                            _model.sortNewestFirst =
                                                !_model.sortNewestFirst;
                                            _model.resetStream();
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _model.sortNewestFirst
                                                    ? Icons.south_rounded
                                                    : Icons.north_rounded,
                                                size: 16.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                              ),
                                              const SizedBox(width: 2.0),
                                              Text(
                                                _model.sortNewestFirst
                                                    ? 'New'
                                                    : 'Old',
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Active Street Filter Indicator
                                if (_model.selectedStreet != 'All' &&
                                    _model.selectedStreet.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 6.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .accent3
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            border: Border.all(
                                              color: FlutterFlowTheme.of(context)
                                                  .accent3,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.place_rounded,
                                                size: 14.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .accent3,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                'Filtered by Street: ${_model.selectedStreet}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .accent3,
                                                ),
                                              ),
                                              const SizedBox(width: 6.0),
                                              InkWell(
                                                onTap: () {
                                                  safeSetState(() {
                                                    _model.selectedStreet =
                                                        'All';
                                                    _model.resetStream();
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close_rounded,
                                                  size: 14.0,
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .accent3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Grid Feed Stream with client-side reactive filtering and pagination
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(),
                                    child: StreamBuilder<List<ImageRow>>(
                                      stream: _model
                                              .staggeredViewSupabaseStream ??=
                                          SupaFlow.client
                                              .from("Image")
                                              .stream(primaryKey: ['image_id'])
                                              .eqOrNull(
                                                'status',
                                                _model.dropDownStatusValue == 'All'
                                                    ? null
                                                    : _model.dropDownStatusValue,
                                              )
                                              .order('created_at',
                                                  ascending:
                                                      !_model.sortNewestFirst)
                                              .limit(_model.pageSize)
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
                                        final rawImages = snapshot.data!;

                                        final displayedImages =
                                            rawImages.where((img) {
                                          // Dual Tab separation
                                          if (_model.selectedTabIndex == 1 &&
                                              img.status != 'Verified') {
                                            return false;
                                          }
                                          if (_model.selectedTabIndex == 0 &&
                                              _model.dropDownStatusValue == 'All' &&
                                              img.status == 'Verified') {
                                            return false;
                                          }

                                          // Real-time search query filter
                                          if (_model.searchQuery.isNotEmpty) {
                                            final q = _model.searchQuery;
                                            final streetMatches = img
                                                .imgStreetNameRef
                                                .toLowerCase()
                                                .contains(q);
                                            final statusMatches = (img.status ?? '')
                                                .toLowerCase()
                                                .contains(q);
                                            final remarkMatches = (img.remark ?? '')
                                                .toLowerCase()
                                                .contains(q);
                                            if (!streetMatches &&
                                                !statusMatches &&
                                                !remarkMatches) {
                                              return false;
                                            }
                                          }

                                          // Quick filter
                                          if (_model.activeQuickFilter ==
                                              'Segregated') {
                                            if (!(img.isSegregated == true ||
                                                img.status == 'Segregated')) {
                                              return false;
                                            }
                                          } else if (_model.activeQuickFilter ==
                                              'Unsegregated') {
                                            if (!(img.isSegregated == false ||
                                                img.status == 'Unsegregated')) {
                                              return false;
                                            }
                                          } else if (_model.activeQuickFilter ==
                                              'Recyclable') {
                                            if (img.categoryRecycling != true) {
                                              return false;
                                            }
                                          } else if (_model.activeQuickFilter ==
                                              'Biodegradable') {
                                            if (img.categoryBiode != true) {
                                              return false;
                                            }
                                          } else if (_model.activeQuickFilter ==
                                              'Verified') {
                                            if (img.status != 'Verified') {
                                              return false;
                                            }
                                          } else if (_model.activeQuickFilter ==
                                              'Flagged') {
                                            if (img.status != 'Flagged') {
                                              return false;
                                            }
                                          } else if (_model.activeQuickFilter ==
                                              'AI Categorized') {
                                            if (img.status !=
                                                'Categorized by Ai') {
                                              return false;
                                            }
                                          } else if (_model.activeQuickFilter ==
                                              'Uncategorized') {
                                            if (img.status != 'Uncategorized') {
                                              return false;
                                            }
                                          }

                                          // Street location filter
                                          if (_model.selectedStreet != 'All' &&
                                              _model.selectedStreet.isNotEmpty) {
                                            if (img.imgStreetNameRef
                                                    .toLowerCase() !=
                                                _model.selectedStreet
                                                    .toLowerCase()) {
                                              return false;
                                            }
                                          }

                                          // Fine-grained attribute toggles
                                          if (_model.filterRecyclable &&
                                              img.categoryRecycling != true) {
                                            return false;
                                          }
                                          if (_model.filterBiodegradable &&
                                              img.categoryBiode != true) {
                                            return false;
                                          }
                                          if (_model.filterSegregated &&
                                              img.isSegregated != true) {
                                            return false;
                                          }

                                          return true;
                                        }).toList();

                                        if (displayedImages.isEmpty) {
                                          return Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(24.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.filter_alt_off_rounded,
                                                    size: 48.0,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                                  const SizedBox(height: 12.0),
                                                  Text(
                                                    'No matching waste records found',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 6.0),
                                                  Text(
                                                    'Try adjusting your search or clearing selected filters.',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 16.0),
                                                  FFButtonWidget(
                                                    onPressed: () {
                                                      safeSetState(() {
                                                        _model.resetAllFilters();
                                                      });
                                                    },
                                                    text: 'Clear Filters',
                                                    options: FFButtonOptions(
                                                      height: 36.0,
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                      textStyle: FlutterFlowTheme
                                                              .of(context)
                                                          .titleSmall
                                                          .override(
                                                            font: GoogleFonts
                                                                .interTight(),
                                                            color: Colors.white,
                                                            fontSize: 13.0,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }

                                        return RefreshIndicator(
                                          color: FlutterFlowTheme.of(context).primary,
                                          onRefresh: () async {
                                            safeSetState(() {
                                              _model.resetStream();
                                            });
                                          },
                                          child: NotificationListener<ScrollNotification>(
                                            onNotification: (scrollInfo) {
                                              if (scrollInfo.metrics.pixels >=
                                                      scrollInfo.metrics.maxScrollExtent - 200 &&
                                                  !_model.isLoadingMore &&
                                                  _model.hasMoreItems) {
                                                safeSetState(() {
                                                  _model.loadMoreItems(rawImages.length);
                                                });
                                              }
                                              return false;
                                            },
                                            child: MasonryGridView.builder(
                                              physics: const AlwaysScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                              ),
                                              crossAxisSpacing: 8.0,
                                              mainAxisSpacing: 8.0,
                                              itemCount: displayedImages.length,
                                              itemBuilder: (context, index) {
                                                final item = displayedImages[index];
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
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize.min,
                                                                children: [
                                                                  Container(
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
                                                                  if (!isVerified && item.status == 'Categorized by Ai') ...[
                                                                    const SizedBox(width: 4.0),
                                                                    Container(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.black.withValues(alpha: 0.65),
                                                                        borderRadius: BorderRadius.circular(4.0),
                                                                      ),
                                                                      child: const Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.auto_awesome,
                                                                            color: Color(0xFF80D8FF),
                                                                            size: 10.0,
                                                                          ),
                                                                          SizedBox(width: 2.0),
                                                                          Text(
                                                                            'AI Scanned',
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 9.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                  if (!isVerified && item.status == 'Flagged') ...[
                                                                    const SizedBox(width: 4.0),
                                                                    Container(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                                                      decoration: BoxDecoration(
                                                                        color: const Color(0xFFC44545),
                                                                        borderRadius: BorderRadius.circular(4.0),
                                                                      ),
                                                                      child: const Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.flag_rounded,
                                                                            color: Colors.white,
                                                                            size: 10.0,
                                                                          ),
                                                                          SizedBox(width: 2.0),
                                                                          Text(
                                                                            'Flagged',
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 9.0,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ],
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
                                            ),
                                          ),
                                        );
                                      },
                                    ),
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
