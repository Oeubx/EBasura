import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  void _openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.only(
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
                    SizedBox(height: 16.0),
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
                    Divider(),
                    SizedBox(height: 12.0),
                    Text(
                      'Street / Location',
                      style: FlutterFlowTheme.of(context).labelLarge,
                    ),
                    SizedBox(height: 8.0),
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
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
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
                    SizedBox(height: 16.0),
                    Text(
                      'Waste Attributes',
                      style: FlutterFlowTheme.of(context).labelLarge,
                    ),
                    SizedBox(height: 8.0),
                    SwitchListTile.adaptive(
                      title: Text(
                        'Recyclable Waste Only',
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                      value: _model.filterRecyclable,
                      activeColor: FlutterFlowTheme.of(context).primary,
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
                      activeColor: FlutterFlowTheme.of(context).primary,
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
                      activeColor: FlutterFlowTheme.of(context).primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() {
                          _model.filterSegregated = val;
                        });
                        safeSetState(() {});
                      },
                    ),
                    SizedBox(height: 20.0),
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
                decoration: BoxDecoration(
                  color: Color(0xFFE8EDF2),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
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
                      Container(
                        width: double.infinity,
                        height: 525.0,
                        decoration: BoxDecoration(
                          color: Color(0xFFDFF1F1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: SingleChildScrollView(
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FutureBuilder<List<UserRow>>(
                                  future: UserTable().querySingleRow(
                                    queryFn: (q) => q.eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50.0,
                                          height: 50.0,
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
                                    List<UserRow> rowUserRowList =
                                        snapshot.data!;

                                    final rowUserRow = rowUserRowList.isNotEmpty
                                        ? rowUserRowList.first
                                        : null;

                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 25.0,
                                        ),
                                        RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Welcome user, ',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.black,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              TextSpan(
                                                text: rowUserRow!.userName!,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleLarge
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 5.0)),
                                    );
                                  },
                                ),
                                Text(
                                  'Click on the image to view their description.',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                                Divider(
                                  thickness: 2.0,
                                  color: Colors.black,
                                ),
                                // Quick Filter Chips & Advanced Filter Button
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 8.0),
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
                                                padding: EdgeInsetsDirectional
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
                                                        if (filterName ==
                                                            'All') {
                                                          _model.dropDownStatusValue =
                                                              'All';
                                                        } else if (filterName ==
                                                            'AI Categorized') {
                                                          _model.dropDownStatusValue =
                                                              'Categorized by Ai';
                                                        } else if (filterName ==
                                                                'Segregated' ||
                                                            filterName ==
                                                                'Unsegregated' ||
                                                            filterName ==
                                                                'Verified' ||
                                                            filterName ==
                                                                'Flagged') {
                                                          _model.dropDownStatusValue =
                                                              filterName;
                                                        } else {
                                                          _model.dropDownStatusValue =
                                                              'All';
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
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: _model
                                                    .hasActiveAdvancedFilters
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                    .withOpacity(0.15)
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
                                                SizedBox(width: 4.0),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
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
                                                    style: TextStyle(
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
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 425.0,
                                  decoration: BoxDecoration(),
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
                                                ascending: false)
                                            .limit(50)
                                            .map((list) => list
                                                .map((item) => ImageRow(item))
                                                .toList()),
                                    builder: (context, snapshot) {
                                      // Customize what your widget looks like when it's loading.
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
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
                                      List<ImageRow> staggeredViewImageRowList =
                                          snapshot.data!;

                                      List<ImageRow> displayedImages =
                                          staggeredViewImageRowList.where((img) {
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
                                        }

                                        // Street filter
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
                                            padding: EdgeInsets.all(24.0),
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
                                                SizedBox(height: 12.0),
                                                Text(
                                                  'No matching waste records found',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 6.0),
                                                Text(
                                                  'Try adjusting your filter options or clearing selected filters.',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 16.0),
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

                                      return MasonryGridView.builder(
                                        gridDelegate:
                                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        itemCount: displayedImages.length,
                                        itemBuilder:
                                            (context, staggeredViewIndex) {
                                          final staggeredViewImageRow =
                                              displayedImages[
                                                  staggeredViewIndex];
                                          return Stack(
                                            alignment:
                                                AlignmentDirectional(1.0, 1.0),
                                            children: [
                                              Stack(
                                                alignment: AlignmentDirectional(
                                                    0.0, 1.0),
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      context.pushNamed(
                                                        PImgViewVerifierWidget
                                                            .routeName,
                                                        queryParameters: {
                                                          'imageIDref':
                                                              serializeParam(
                                                            staggeredViewImageRow,
                                                            ParamType
                                                                .SupabaseRow,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: Image.network(
                                                        staggeredViewImageRow
                                                            .imgReferenceLink,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Opacity(
                                                    opacity: 0.5,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 35.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF263B6A),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: Colors.white,
                                                          size: 20.0,
                                                        ),
                                                        Text(
                                                          dateTimeFormat(
                                                              "Md",
                                                              staggeredViewImageRow
                                                                  .createdAt),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ].divide(
                                                          SizedBox(width: 5.0)),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Uncategorized')
                                                          Icon(
                                                            Icons
                                                                .question_mark_rounded,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Categorized by Ai')
                                                          Icon(
                                                            Icons.android,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Unsegregated')
                                                          Icon(
                                                            Icons
                                                                .delete_forever,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Segregated')
                                                          Icon(
                                                            Icons
                                                                .check_circle_outline_sharp,
                                                            color: Color(
                                                                0xFF468432),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Flagged')
                                                          Icon(
                                                            Icons.flag_outlined,
                                                            color: Color(
                                                                0xFFC44545),
                                                            size: 20.0,
                                                          ),
                                                        if (staggeredViewImageRow
                                                                .status ==
                                                            'Verified')
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .checkDouble,
                                                            color: Color(
                                                                0xFF468432),
                                                            size: 20.0,
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ].divide(SizedBox(height: 5.0)),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 5.0)),
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.cBottomBarModel,
                updateCallback: () => safeSetState(() {}),
                child: CBottomBarWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
