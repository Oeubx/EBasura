with open('lib/admin/street/p_street_view_all/p_street_view_all_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read().replace('\r\n', '\n')

import_target = "import '/admin/street/c_street_creation/c_street_creation_widget.dart';"
import_repl = import_target + "\nimport '/custom_code/actions/street_compliance_exporter.dart';"
content = content.replace(import_target, import_repl, 1)

target = """                                Divider(
                                  thickness: 2.0,
                                  color: Colors.black,
                                ),"""

replacement = """                                Divider(
                                  thickness: 2.0,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            final streets = await StreetTable().queryRows(queryFn: (q) => q);
                                            final images = await ImageTable().queryRows(queryFn: (q) => q);
                                            final reports = await ReportTable().queryRows(queryFn: (q) => q);
                                            if (context.mounted) {
                                              await StreetComplianceExporter.exportCSV(
                                                context: context,
                                                streets: streets,
                                                images: images,
                                                reports: reports,
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.table_chart, size: 16.0, color: Colors.white),
                                          label: Text('Export CSV', style: GoogleFonts.inter(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF1B5E20),
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            final streets = await StreetTable().queryRows(queryFn: (q) => q);
                                            final images = await ImageTable().queryRows(queryFn: (q) => q);
                                            final reports = await ReportTable().queryRows(queryFn: (q) => q);
                                            if (context.mounted) {
                                              await StreetComplianceExporter.exportPDF(
                                                context: context,
                                                streets: streets,
                                                images: images,
                                                reports: reports,
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.picture_as_pdf, size: 16.0, color: Colors.white),
                                          label: Text('Export PDF', style: GoogleFonts.inter(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFD32F2F),
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),"""

if target in content:
    content = content.replace(target, replacement, 1)
    with open('lib/admin/street/p_street_view_all/p_street_view_all_widget.dart', 'w', encoding='utf-8') as f:
        f.write(content)
    print('SUCCESS EXPORT INJECT')
else:
    print('TARGET NOT FOUND IN EXPORT')
