import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_user_pts_model.dart';
export 'c_user_pts_model.dart';

class _ResidentEntry {
  final UserRow user;
  final int points;

  _ResidentEntry({
    required this.user,
    required this.points,
  });
}

class CUserPtsWidget extends StatefulWidget {
  const CUserPtsWidget({
    super.key,
    required this.streetRef,
  });

  final StreetRow? streetRef;

  @override
  State<CUserPtsWidget> createState() => _CUserPtsWidgetState();
}

class _CUserPtsWidgetState extends State<CUserPtsWidget> {
  late CUserPtsModel _model;
  Future<List<_ResidentEntry>>? _residentsFuture;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CUserPtsModel());
    _residentsFuture = _loadResidents();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<List<_ResidentEntry>> _loadResidents() async {
    final streetName = widget.streetRef?.streetName;
    if (streetName == null || streetName.isEmpty) return [];

    // Query only users belonging to this specific street
    final users = await UserTable().queryRows(
      queryFn: (q) => q.eqOrNull('user_streetNameRef', streetName),
    );

    if (users.isEmpty) return [];

    final userIds = users.map((u) => u.userId).whereType<String>().toList();
    final pointsMap = <String, int>{};

    // Single batch query for points instead of N+1 queries
    try {
      final subtables = await UserSubtableTable().queryRows(
        queryFn: (q) => q.inFilter('user_idRef', userIds),
      );
      for (final sub in subtables) {
        pointsMap[sub.userIdRef] = sub.userPoints ?? 0;
      }
    } catch (_) {
      // Graceful fallback if points query encounters issues
    }

    final entries = users.map((u) {
      return _ResidentEntry(
        user: u,
        points: pointsMap[u.userId ?? ''] ?? 0,
      );
    }).toList();

    entries.sort((a, b) => b.points.compareTo(a.points));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final streetName = widget.streetRef?.streetName ?? 'Street';

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
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
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modal Drag Handle
              const SizedBox(height: 12.0),
              Container(
                width: 44.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 14.0),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F1F8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF2E78A6),
                        size: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            streetName,
                            style: GoogleFonts.comfortaa(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF013448),
                            ),
                          ),
                          Text(
                            'Resident contributions & points',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              color: theme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderColor: theme.accent4.withValues(alpha: 0.35),
                      borderRadius: 18.0,
                      buttonSize: 36.0,
                      fillColor: theme.primaryBackground,
                      icon: Icon(
                        Icons.close_rounded,
                        color: theme.primaryText,
                        size: 18.0,
                      ),
                      onPressed: () async => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12.0),
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: theme.accent4.withValues(alpha: 0.25),
              ),

              // Residents List
              Expanded(
                child: FutureBuilder<List<_ResidentEntry>>(
                  future: _residentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: SizedBox(
                            width: 36.0,
                            height: 36.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2E78A6),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final residents = snapshot.data ?? [];

                    if (residents.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14.0),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F1F8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.people_outline_rounded,
                                  size: 32.0,
                                  color: Color(0xFF2E78A6),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                'No Residents Registered',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF013448),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'No residents have registered under $streetName yet.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 12.0,
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      itemCount: residents.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8.0),
                      itemBuilder: (context, index) {
                        final entry = residents[index];
                        final name = entry.user.userName ?? 'Resident';
                        final rank = index + 1;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryBackground,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(
                              color: theme.accent4.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Rank Badge
                              Container(
                                width: 28.0,
                                height: 28.0,
                                decoration: BoxDecoration(
                                  color: rank <= 3
                                      ? const Color(0xFFD5F2E2)
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$rank',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                      color: rank <= 3
                                          ? const Color(0xFF31A11F)
                                          : theme.secondaryText,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),

                              // Resident Name
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryText,
                                  ),
                                ),
                              ),

                              // Points Chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD5F2E2),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.stars_rounded,
                                      size: 14.0,
                                      color: Color(0xFF31A11F),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      '${formatNumber(entry.points, formatType: FormatType.compact)} pts',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF013448),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
    );
  }
}
