import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_street_creation_model.dart';
export 'c_street_creation_model.dart';

class CStreetCreationWidget extends StatefulWidget {
  const CStreetCreationWidget({super.key});

  @override
  State<CStreetCreationWidget> createState() => _CStreetCreationWidgetState();
}

class _CStreetCreationWidgetState extends State<CStreetCreationWidget> {
  late CStreetCreationModel _model;
  bool _isCreating = false;
  bool _hasStorage = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CStreetCreationModel());
    _model.nameTextController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();
    _model.descriptionTextController ??= TextEditingController();
    _model.descriptionFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 12.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
          ),
          child: Form(
            key: _model.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modal Drag Handle
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

                // Title Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F1F8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_road_rounded,
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
                            'Register Batasan Street',
                            style: GoogleFonts.comfortaa(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF013448),
                            ),
                          ),
                          Text(
                            'Add a new street record for collection tracking',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(
                  height: 24.0,
                  thickness: 1.0,
                  color: Color(0xFFF1F5F9),
                ),

                // Street Name
                Text(
                  'Street Name',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6.0),
                TextFormField(
                  controller: _model.nameTextController,
                  focusNode: _model.nameFocusNode,
                  validator: _model.nameTextControllerValidator
                      .asValidator(context),
                  decoration: InputDecoration(
                    hintText: 'E.g., San Mateo Road, Commonwealth Ext...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.all(14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFCBD5E1),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFCBD5E1),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF2E78A6),
                        width: 1.5,
                      ),
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 14.0),

                // Description
                Text(
                  'Description / Landmark',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6.0),
                TextFormField(
                  controller: _model.descriptionTextController,
                  focusNode: _model.descriptionFocusNode,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'E.g., Purok 4 area, near community chapel...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.all(14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFCBD5E1),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFCBD5E1),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF2E78A6),
                        width: 1.5,
                      ),
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Waste Storage Toggle
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: _hasStorage
                              ? const Color(0xFFD5F2E2)
                              : const Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warehouse_rounded,
                          size: 20.0,
                          color: _hasStorage
                              ? const Color(0xFF31A11F)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Designated Storage Facility',
                              style: GoogleFonts.inter(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              'Has physical barangay bins or drop-off point',
                              style: GoogleFonts.inter(
                                fontSize: 11.0,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _hasStorage,
                        activeThumbColor: const Color(0xFF31A11F),
                        onChanged: (val) {
                          setState(() => _hasStorage = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Submit Button
                FFButtonWidget(
                  onPressed: _isCreating
                      ? null
                      : () async {
                          if (!_model.formKey.currentState!.validate()) {
                            return;
                          }
                          final streetName =
                              _model.nameTextController?.text.trim() ?? '';
                          if (streetName.isEmpty) return;

                          setState(() => _isCreating = true);
                          try {
                            final duplicates = await StreetTable().queryRows(
                              queryFn: (q) =>
                                  q.ilike('street_name', streetName),
                            );

                            if (duplicates.isNotEmpty) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'A street with this name already exists.',
                                    ),
                                    backgroundColor: Color(0xFFDC2626),
                                  ),
                                );
                              }
                              return;
                            }

                            await StreetTable().insert({
                              'street_name': streetName,
                              'street_description': _model
                                      .descriptionTextController?.text
                                      .trim() ??
                                  '',
                              'has_storage': _hasStorage,
                              'last_updatedBy': currentUserUid,
                            });

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Street registered successfully!',
                                  ),
                                  backgroundColor: Color(0xFF31A11F),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to register: $e'),
                                  backgroundColor: const Color(0xFFDC2626),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isCreating = false);
                            }
                          }
                        },
                  text: _isCreating ? 'Registering...' : 'Register Street',
                  icon: _isCreating
                      ? null
                      : const Icon(
                          Icons.add_rounded,
                          size: 18.0,
                        ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    color: const Color(0xFF2E78A6),
                    textStyle: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
