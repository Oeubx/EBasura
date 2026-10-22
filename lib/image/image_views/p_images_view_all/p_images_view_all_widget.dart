import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
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
    final theme = FlutterFlowTheme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 20.0,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Advanced Filters',
                          style: GoogleFonts.comfortaa(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: theme.primaryText,
                          ),
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
                              style: GoogleFonts.inter(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFDC2626),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Divider(height: 24.0),
                    Text(
                      'Street / Location',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            border: Border.all(
                              color: theme.accent4.withValues(alpha: 0.35),
                            ),
                            borderRadius: BorderRadius.circular(16.0),
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
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: theme.primaryText,
                                    ),
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
                    const SizedBox(height: 18.0),
                    Text(
                      'Waste Attributes',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SwitchListTile.adaptive(
                      title: Text(
                        'Recyclable Waste Only',
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: theme.primaryText,
                        ),
                      ),
                      value: _model.filterRecyclable,
                      activeTrackColor: theme.ecoPrimary,
                      activeThumbColor: Colors.white,
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
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: theme.primaryText,
                        ),
                      ),
                      value: _model.filterBiodegradable,
                      activeTrackColor: theme.ecoPrimary,
                      activeThumbColor: Colors.white,
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
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: theme.primaryText,
                        ),
                      ),
                      value: _model.filterSegregated,
                      activeTrackColor: theme.ecoPrimary,
                      activeThumbColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() {
                          _model.filterSegregated = val;
                        });
                        safeSetState(() {});
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Sort Direction',
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Center(
                              child: Text(
                                'Newest First',
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  color: _model.sortNewestFirst
                                      ? Colors.white
                                      : theme.primaryText,
                                  fontWeight: _model.sortNewestFirst
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            selected: _model.sortNewestFirst,
                            selectedColor: theme.accent3,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(
                                color: _model.sortNewestFirst
                                    ? theme.accent3
                                    : theme.accent4.withValues(alpha: 0.35),
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
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  color: !_model.sortNewestFirst
                                      ? Colors.white
                                      : theme.primaryText,
                                  fontWeight: !_model.sortNewestFirst
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            selected: !_model.sortNewestFirst,
                            selectedColor: theme.accent3,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(
                                color: !_model.sortNewestFirst
                                    ? theme.accent3
                                    : theme.accent4.withValues(alpha: 0.35),
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
                    const SizedBox(height: 24.0),
                    Center(
                      child: EBasuraButton.button2(
                        width: double.infinity,
                        height: 46.0,
                        text: 'Apply Filters',
                        onPressed: () {
                          Navigator.pop(context);
                          safeSetState(() {});
                        },
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
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Modern Compact Top App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/Horizontal_Logo.png',
                          height: 38.0,
                          fit: BoxFit.contain,
                        ),
                        if (Navigator.of(context).canPop())
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
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                      ],
                    ),
                  ),

                  // User Info + Role Header Row
                  FutureBuilder<List<UserRow>>(
                    future: UserTable().querySingleRow(
                      queryFn: (q) => q.eqOrNull(
                        'user_id',
                        currentUserUid,
                      ),
                    ),
                    builder: (context, snapshot) {
                      final rowUser = snapshot.data?.isNotEmpty == true
                          ? snapshot.data!.first
                          : null;
                      final isAdmin = rowUser?.userType == 'Admin';
                      final isCrew = rowUser?.userType == 'Crew';

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    color: isAdmin
                                        ? theme.accent3.withValues(alpha: 0.12)
                                        : theme.secondaryBackground,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isAdmin
                                        ? Icons.admin_panel_settings_rounded
                                        : (isCrew
                                            ? Icons.local_shipping_rounded
                                            : Icons.person_rounded),
                                    color: isAdmin
                                        ? theme.accent3
                                        : theme.ecoPrimary,
                                    size: 18.0,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  rowUser?.userName ?? 'User',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryText,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: isAdmin
                                    ? theme.accent3
                                    : theme.secondaryBackground,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: isAdmin
                                      ? theme.accent3
                                      : theme.ecoPrimary
                                          .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                isAdmin
                                    ? 'Official / Admin'
                                    : (isCrew
                                        ? 'Collection Crew'
                                        : 'Resident'),
                                style: GoogleFonts.inter(
                                  color: isAdmin
                                      ? Colors.white
                                      : theme.ecoPrimary,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Page Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                    child: CPageHeaderWidget(
                      title: 'Waste Feed & Records',
                      subtitle:
                          'Browse community submissions and verified waste records',
                      icon: Icons.auto_awesome_motion_rounded,
                    ),
                  ),

                  // Dual Tab Filter: Non-Verified vs Verified
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: theme.accent4.withValues(alpha: 0.35),
                          width: 1.0,
                        ),
                        boxShadow: [
                          theme.designToken.shadow.sm,
                        ],
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
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: _model.selectedTabIndex == 0
                                      ? theme.accent3
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.hourglass_top_rounded,
                                      size: 16.0,
                                      color: _model.selectedTabIndex == 0
                                          ? Colors.white
                                          : theme.secondaryText,
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      'Non-Verified',
                                      style: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w700,
                                        color: _model.selectedTabIndex == 0
                                            ? Colors.white
                                            : theme.secondaryText,
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
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: _model.selectedTabIndex == 1
                                      ? theme.ecoPrimary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.verified_rounded,
                                      size: 16.0,
                                      color: _model.selectedTabIndex == 1
                                          ? Colors.white
                                          : theme.secondaryText,
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      'Verified',
                                      style: GoogleFonts.inter(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w700,
                                        color: _model.selectedTabIndex == 1
                                            ? Colors.white
                                            : theme.secondaryText,
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
                  ),

                  // Real-Time Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 2.0,
                    ),
                    child: TextFormField(
                      controller: _model.searchController,
                      focusNode: _model.searchFocusNode,
                      onChanged: (val) {
                        safeSetState(() {
                          _model.searchQuery = val.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search street, status, or tags...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13.0,
                          color: theme.secondaryText,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.accent4.withValues(alpha: 0.35),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.accent3,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: theme.secondaryText,
                          size: 20.0,
                        ),
                        suffixIcon: _model.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  size: 18.0,
                                  color: theme.secondaryText,
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
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: theme.primaryText,
                      ),
                    ),
                  ),

                  // Quick Filter Chips & Advanced Controls Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
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
                                    _model.activeQuickFilter == filterName;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: ChoiceChip(
                                    label: Text(
                                      filterName,
                                      style: GoogleFonts.inter(
                                        color: isSelected
                                            ? Colors.white
                                            : theme.primaryText,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    selected: isSelected,
                                    selectedColor: theme.accent3,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0),
                                      side: BorderSide(
                                        color: isSelected
                                            ? theme.accent3
                                            : theme.accent4
                                                .withValues(alpha: 0.35),
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
                          onTap: () => _openFilterBottomSheet(context),
                          borderRadius: BorderRadius.circular(14.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: _model.hasActiveAdvancedFilters
                                  ? theme.accent3.withValues(alpha: 0.15)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: _model.hasActiveAdvancedFilters
                                    ? theme.accent3
                                    : theme.accent4.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 18.0,
                                  color: _model.hasActiveAdvancedFilters
                                      ? theme.accent3
                                      : theme.secondaryText,
                                ),
                                if (_model.activeFilterCount > 0) ...[
                                  const SizedBox(width: 4.0),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                      vertical: 1.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.accent3,
                                      borderRadius:
                                          BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      '${_model.activeFilterCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
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
                          borderRadius: BorderRadius.circular(14.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                color: theme.accent4.withValues(alpha: 0.35),
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
                                  color: theme.accent3,
                                ),
                                const SizedBox(width: 2.0),
                                Text(
                                  _model.sortNewestFirst ? 'New' : 'Old',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryText,
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 2.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: theme.ecoPrimary.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.place_rounded,
                                  size: 14.0,
                                  color: theme.ecoPrimary,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  'Filtered: ${_model.selectedStreet}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryText,
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                InkWell(
                                  onTap: () {
                                    safeSetState(() {
                                      _model.selectedStreet = 'All';
                                      _model.resetStream();
                                    });
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 14.0,
                                    color: theme.secondaryText,
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
                    child: StreamBuilder<List<ImageRow>>(
                      stream: _model.staggeredViewSupabaseStream ??= SupaFlow
                          .client
                          .from("Image")
                          .stream(primaryKey: ['image_id'])
                          .eqOrNull(
                            'status',
                            _model.dropDownStatusValue == 'All'
                                ? null
                                : _model.dropDownStatusValue,
                          )
                          .order('created_at',
                              ascending: !_model.sortNewestFirst)
                          .limit(_model.pageSize)
                          .map((list) =>
                              list.map((item) => ImageRow(item)).toList()),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 36.0,
                              height: 36.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.accent3,
                                ),
                              ),
                            ),
                          );
                        }
                        final rawImages = snapshot.data!;

                        final displayedImages = rawImages.where((img) {
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
                            final streetMatches = img.imgStreetNameRef
                                .toLowerCase()
                                .contains(q);
                            final statusMatches =
                                (img.status ?? '').toLowerCase().contains(q);
                            final remarkMatches =
                                (img.remark ?? '').toLowerCase().contains(q);
                            if (!streetMatches &&
                                !statusMatches &&
                                !remarkMatches) {
                              return false;
                            }
                          }

                          // Quick filter
                          if (_model.activeQuickFilter == 'Segregated') {
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
                          } else if (_model.activeQuickFilter == 'Verified') {
                            if (img.status != 'Verified') {
                              return false;
                            }
                          } else if (_model.activeQuickFilter == 'Flagged') {
                            if (img.status != 'Flagged') {
                              return false;
                            }
                          } else if (_model.activeQuickFilter ==
                              'AI Categorized') {
                            if (img.status != 'Categorized by Ai') {
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
                            if (img.imgStreetNameRef.toLowerCase() !=
                                _model.selectedStreet.toLowerCase()) {
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
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: theme.accent3
                                          .withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.filter_alt_off_rounded,
                                      size: 40.0,
                                      color: theme.accent3,
                                    ),
                                  ),
                                  const SizedBox(height: 14.0),
                                  Text(
                                    'No matching waste records found',
                                    style: GoogleFonts.comfortaa(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                      color: theme.primaryText,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    'Try adjusting your search or clearing selected filters.',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: theme.secondaryText,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 18.0),
                                  EBasuraButton.button1(
                                    width: 180.0,
                                    height: 40.0,
                                    text: 'Clear Filters',
                                    onPressed: () {
                                      safeSetState(() {
                                        _model.resetAllFilters();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: theme.accent3,
                          onRefresh: () async {
                            safeSetState(() {
                              _model.resetStream();
                            });
                          },
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (scrollInfo) {
                              if (scrollInfo.metrics.pixels >=
                                      scrollInfo.metrics.maxScrollExtent -
                                          200 &&
                                  !_model.isLoadingMore &&
                                  _model.hasMoreItems) {
                                safeSetState(() {
                                  _model.loadMoreItems(rawImages.length);
                                });
                              }
                              return false;
                            },
                            child: MasonryGridView.builder(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                6.0,
                                16.0,
                                95.0,
                              ),
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              itemCount: displayedImages.length,
                              itemBuilder: (context, index) {
                                final item = displayedImages[index];
                                final isVerified =
                                    item.status == 'Verified';

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(16.0),
                                    border: Border.all(
                                      color: theme.accent4
                                          .withValues(alpha: 0.35),
                                      width: 1.0,
                                    ),
                                    boxShadow: [
                                      theme.designToken.shadow.sm,
                                    ],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () async {
                                      context.pushNamed(
                                        PImgViewVerifierWidget.routeName,
                                        queryParameters: {
                                          'imageIDref': serializeParam(
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
                                              height: 125.0,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  Container(
                                                height: 125.0,
                                                color: const Color(0xFFF1F5F9),
                                                child: const Icon(
                                                  Icons.broken_image_rounded,
                                                  color: Color(0xFF94A3B8),
                                                ),
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
                                                      horizontal: 7.0,
                                                      vertical: 3.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: isVerified
                                                          ? theme.ecoPrimary
                                                          : theme.accent3,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  12.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          isVerified
                                                              ? Icons
                                                                  .check_circle_rounded
                                                              : Icons
                                                                  .hourglass_top_rounded,
                                                          color: Colors.white,
                                                          size: 11.0,
                                                        ),
                                                        const SizedBox(
                                                            width: 3.0),
                                                        Text(
                                                          isVerified
                                                              ? 'Verified'
                                                              : 'Non-Verified',
                                                          style:
                                                              GoogleFonts
                                                                  .inter(
                                                            color: Colors
                                                                .white,
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!isVerified &&
                                                      item.status ==
                                                          'Categorized by Ai') ...[
                                                    const SizedBox(
                                                        width: 4.0),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 3.0,
                                                      ),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha:
                                                                    0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    12.0),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .auto_awesome,
                                                            color: Color(
                                                                0xFF80D8FF),
                                                            size: 10.0,
                                                          ),
                                                          SizedBox(
                                                              width: 2.0),
                                                          Text(
                                                            'AI',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 9.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  if (!isVerified &&
                                                      item.status ==
                                                          'Flagged') ...[
                                                    const SizedBox(
                                                        width: 4.0),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 3.0,
                                                      ),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: const Color(
                                                            0xFFDC2626),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    12.0),
                                                      ),
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .flag_rounded,
                                                            color: Colors
                                                                .white,
                                                            size: 10.0,
                                                          ),
                                                          SizedBox(
                                                              width: 2.0),
                                                          Text(
                                                            'Flagged',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 9.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                              const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Segregated badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 3.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: item.isSegregated ==
                                                          true
                                                      ? theme
                                                          .secondaryBackground
                                                      : const Color(
                                                          0xFFFEE2E2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: item.isSegregated ==
                                                            true
                                                        ? theme.ecoPrimary
                                                            .withValues(
                                                                alpha: 0.35)
                                                        : const Color(
                                                            0xFFFCA5A5),
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  item.isSegregated == true
                                                      ? '✓ Segregated'
                                                      : '✗ Not Segregated',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.0,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: item.isSegregated ==
                                                            true
                                                        ? theme.ecoPrimary
                                                        : const Color(
                                                            0xFFDC2626),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6.0),
                                              // Category chips wrap
                                              Wrap(
                                                spacing: 4.0,
                                                runSpacing: 3.0,
                                                children: [
                                                  if (item.categoryRecycling ==
                                                      true)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2.0,
                                                      ),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: const Color(
                                                            0xFFE0F2FE),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    6.0),
                                                      ),
                                                      child: Text(
                                                        'Recyclable',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 9.0,
                                                          color: const Color(
                                                              0xFF0284C7),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  if (item.categoryBiode ==
                                                      true)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2.0,
                                                      ),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: const Color(
                                                            0xFFDCFCE7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    6.0),
                                                      ),
                                                      child: Text(
                                                        'Bio',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 9.0,
                                                          color: const Color(
                                                              0xFF16A34A),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  if (item.categoryNonbiode ==
                                                      true)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2.0,
                                                      ),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: const Color(
                                                            0xFFFFEDD5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    6.0),
                                                      ),
                                                      child: Text(
                                                        'Non-Bio',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 9.0,
                                                          color: const Color(
                                                              0xFFEA580C),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 6.0),
                                              // Street & date row
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.imgStreetNameRef,
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      style:
                                                          GoogleFonts.inter(
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: theme
                                                            .secondaryText,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    dateTimeFormat(
                                                        "Md", item.createdAt),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.0,
                                                      color:
                                                          theme.secondaryText,
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
                ],
              ),
              wrapWithModel(
                model: _model.cBottomBarModel,
                updateCallback: () => safeSetState(() {}),
                child: const CBottomBarWidget(
                  activeRoute: 'P_Images_ViewAll',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
