import '/admin/dates/c_dates_creation/c_dates_creation_widget.dart';
import '/backend/supabase/supabase.dart';
import '/components/c_bottom_bar/c_bottom_bar_widget.dart';
import '/components/c_page_header/c_page_header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'p_dates_view_all_model.dart';
export 'p_dates_view_all_model.dart';

class PDatesViewAllWidget extends StatefulWidget {
  const PDatesViewAllWidget({super.key});

  static String routeName = 'P_Dates_ViewAll';
  static String routePath = '/pDatesViewAll';

  @override
  State<PDatesViewAllWidget> createState() => _PDatesViewAllWidgetState();
}

class _PDatesViewAllWidgetState extends State<PDatesViewAllWidget> {
  late PDatesViewAllModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PDatesViewAllModel());

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
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 12.0, 16.0, 120.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/Horizontal_Logo.png',
                              height: 44.0,
                              fit: BoxFit.contain,
                            ),
                            FlutterFlowIconButton(
                              borderColor:
                                  theme.accent4.withValues(alpha: 0.35),
                              borderRadius: 20.0,
                              buttonSize: 40.0,
                              fillColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: theme.primaryText,
                                size: 22.0,
                              ),
                              onPressed: () async => context.safePop(),
                            ),
                          ],
                        ),
                      ),
                      const CPageHeaderWidget(
                        title: 'Collection Dates',
                        subtitle: 'Review & manage scheduled collection routes',
                        icon: Icons.calendar_month_rounded,
                      ),
                      FutureBuilder<List<CollectionRow>>(
                        future: CollectionTable().queryRows(
                          queryFn: (q) => q,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: SizedBox(
                                  width: 44.0,
                                  height: 44.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          List<CollectionRow> listViewCollectionRowList =
                              snapshot.data!;

                          if (listViewCollectionRowList.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 36.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: theme.accent4.withValues(alpha: 0.4),
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  theme.designToken.shadow.sm,
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: theme.secondaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.event_busy_rounded,
                                      size: 36.0,
                                      color: theme.ecoPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'No Collection Dates Scheduled',
                                    style: GoogleFonts.interTight(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    'Tap the + button below to create the first collection schedule.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: theme.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listViewCollectionRowList.length,
                            itemBuilder: (context, listViewIndex) {
                              final listViewCollectionRow =
                                  listViewCollectionRowList[listViewIndex];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16.0),
                                  onTap: () async {
                                    context.pushNamed(
                                      PDatesViewOneWidget.routeName,
                                      queryParameters: {
                                        'collectionRef': serializeParam(
                                          listViewCollectionRow,
                                          ParamType.SupabaseRow,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: theme.accent4
                                            .withValues(alpha: 0.4),
                                        width: 1.0,
                                      ),
                                      boxShadow: [
                                        theme.designToken.shadow.sm,
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 44.0,
                                                height: 44.0,
                                                decoration: BoxDecoration(
                                                  color: theme.accent3
                                                      .withValues(alpha: 0.12),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Icon(
                                                  Icons.calendar_month_rounded,
                                                  color: theme.accent3,
                                                  size: 24.0,
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      listViewCollectionRow
                                                          .collectionStreetNameRef,
                                                      style: GoogleFonts
                                                          .interTight(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: theme
                                                            .primaryText,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6.0),
                                                    Wrap(
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      spacing: 8.0,
                                                      runSpacing: 4.0,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                  vertical:
                                                                      3.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: theme
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                          ),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              listViewCollectionRow
                                                                  .collectionDay,
                                                              'Day',
                                                            ),
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: theme
                                                                  .ecoPrimary,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .schedule_rounded,
                                                              size: 14.0,
                                                              color: theme
                                                                  .secondaryText,
                                                            ),
                                                            const SizedBox(
                                                                width: 4.0),
                                                            Text(
                                                              '${dateTimeFormat("jm", listViewCollectionRow.collectionTimeDurationStart.time)} - ${dateTimeFormat("jm", listViewCollectionRow.collectionTimeDurationEnd.time)}',
                                                              style:
                                                                  GoogleFonts
                                                                      .inter(
                                                                fontSize: 12.0,
                                                                color: theme
                                                                    .secondaryText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                Icons.chevron_right_rounded,
                                                color: theme.secondaryText,
                                                size: 22.0,
                                              ),
                                            ],
                                          ),
                                          if ((listViewCollectionRow
                                                  .collectionDescription ??
                                              '')
                                          .isNotEmpty) ...[
                                            const SizedBox(height: 10.0),
                                            Text(
                                              listViewCollectionRow
                                                  .collectionDescription!,
                                              style: GoogleFonts.inter(
                                                fontSize: 13.0,
                                                color: theme.secondaryText,
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 12.0),
                                          Divider(
                                            height: 1.0,
                                            thickness: 0.8,
                                            color: theme.accent4
                                                .withValues(alpha: 0.3),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.history_rounded,
                                                color: theme.secondaryText,
                                                size: 14.0,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                'Updated ${dateTimeFormat("relative", listViewCollectionRow.lastUpdatedTime)}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11.0,
                                                  color: theme.secondaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
              Align(
                alignment: const AlignmentDirectional(1.0, 1.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 0.0, 20.0, 96.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        theme.designToken.shadow.md,
                      ],
                    ),
                    child: FlutterFlowIconButton(
                      borderRadius: 22.0,
                      buttonSize: 52.0,
                      fillColor: theme.accent3,
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
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: const CDatesCreationWidget(),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.cBottomBarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: const CBottomBarWidget(
                    activeRoute: 'P_Dates_ViewAll',
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
