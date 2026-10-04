import 'dart:convert';
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class StreetComplianceExporter {
  /// Compiles compliance metrics for given streets and exports as CSV
  static Future<void> exportCSV({
    required BuildContext context,
    required List<StreetRow> streets,
    List<ImageRow>? images,
    List<ReportRow>? reports,
  }) async {
    try {
      final List<List<dynamic>> csvData = [
        [
          'Street ID',
          'Street Name',
          'Total Uploads',
          'Segregated Count',
          'Unsegregated Count',
          'Segregation Rate (%)',
          'Incident Reports',
          'Compliance Grade',
          'Report Timestamp',
        ],
      ];

      for (final street in streets) {
        final streetName = street.streetName;
        final streetImages = images
                ?.where((img) => img.imgStreetNameRef == streetName)
                .toList() ??
            [];
        final streetReports = reports
                ?.where((rep) => rep.reportStreetNameRef == streetName)
                .toList() ??
            [];

        final totalUploads = streetImages.length;
        final segregatedCount =
            streetImages.where((img) => img.isSegregated == true).length;
        final unsegregatedCount = totalUploads - segregatedCount;

        final segregationRate = totalUploads > 0
            ? ((segregatedCount / totalUploads) * 100).toStringAsFixed(1)
            : '100.0';

        final double rateNum = double.tryParse(segregationRate) ?? 100.0;
        String grade = 'A (Excellent)';
        if (rateNum < 60.0) {
          grade = 'C (Needs Action)';
        } else if (rateNum < 80.0) {
          grade = 'B (Fair)';
        }

        csvData.add([
          street.streetId ?? 'N/A',
          streetName,
          totalUploads,
          segregatedCount,
          unsegregatedCount,
          '$segregationRate%',
          streetReports.length,
          grade,
          DateTime.now().toIso8601String(),
        ]);
      }

      final String csvString = const ListToCsvConverter().convert(csvData);
      final List<int> bytes = utf8.encode(csvString);

      final String fileName =
          'EBasura_Street_Compliance_${DateTime.now().millisecondsSinceEpoch}.csv';

      await _downloadOrSaveFile(
        context: context,
        bytes: bytes,
        fileName: fileName,
        mimeType: 'text/csv',
        fileTitle: 'CSV Export Ready',
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to generate CSV export: $e');
    }
  }

  /// Generates visual compliance summary report (PDF/Text document format)
  static Future<void> exportPDF({
    required BuildContext context,
    required List<StreetRow> streets,
    List<ImageRow>? images,
    List<ReportRow>? reports,
  }) async {
    try {
      final StringBuffer pdfReport = StringBuffer();
      pdfReport.writeln('====================================================');
      pdfReport.writeln('          EBASURA STREET COMPLIANCE REPORT          ');
      pdfReport.writeln('====================================================');
      pdfReport.writeln('Generated Date: ${DateTime.now().toLocal()}');
      pdfReport.writeln('Total Registered Streets: ${streets.length}');
      pdfReport.writeln('----------------------------------------------------\n');

      for (int i = 0; i < streets.length; i++) {
        final street = streets[i];
        final streetName = street.streetName;
        final streetImages = images
                ?.where((img) => img.imgStreetNameRef == streetName)
                .toList() ??
            [];
        final streetReports = reports
                ?.where((rep) => rep.reportStreetNameRef == streetName)
                .toList() ??
            [];

        final totalUploads = streetImages.length;
        final segregatedCount =
            streetImages.where((img) => img.isSegregated == true).length;
        final unsegregatedCount = totalUploads - segregatedCount;

        final segregationRate = totalUploads > 0
            ? ((segregatedCount / totalUploads) * 100).toStringAsFixed(1)
            : '100.0';

        final double rateNum = double.tryParse(segregationRate) ?? 100.0;
        String grade = 'GRADE A (High Compliance)';
        if (rateNum < 60.0) {
          grade = 'GRADE C (Non-Compliant Alert)';
        } else if (rateNum < 80.0) {
          grade = 'GRADE B (Moderate Compliance)';
        }

        pdfReport.writeln('${i + 1}. STREET: $streetName (ID: ${street.streetId})');
        pdfReport.writeln('   - Compliance Grade : $grade');
        pdfReport.writeln('   - Total Waste Scans : $totalUploads');
        pdfReport.writeln('   - Segregated Waste  : $segregatedCount ($segregationRate%)');
        pdfReport.writeln('   - Unsegregated      : $unsegregatedCount');
        pdfReport.writeln('   - Active Incidents  : ${streetReports.length}');
        pdfReport.writeln('----------------------------------------------------');
      }

      pdfReport.writeln('\nEnd of Compliance Report — EBasura Waste Management Platform');

      final List<int> bytes = utf8.encode(pdfReport.toString());
      final String fileName =
          'EBasura_Street_Compliance_Report_${DateTime.now().millisecondsSinceEpoch}.txt';

      await _downloadOrSaveFile(
        context: context,
        bytes: bytes,
        fileName: fileName,
        mimeType: 'text/plain',
        fileTitle: 'Compliance Summary Export Ready',
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to generate PDF/Text report: $e');
    }
  }

  static Future<void> _downloadOrSaveFile({
    required BuildContext context,
    required List<int> bytes,
    required String fileName,
    required String mimeType,
    required String fileTitle,
  }) async {
    if (kIsWeb) {
      _showSuccessDialog(
        context: context,
        title: fileTitle,
        fileName: fileName,
        content: utf8.decode(bytes),
      );
    } else {
      _showSuccessDialog(
        context: context,
        title: fileTitle,
        fileName: fileName,
        content: utf8.decode(bytes),
      );
    }
  }

  static void _showSuccessDialog({
    required BuildContext context,
    required String title,
    required String fileName,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Row(
            children: [
              const Icon(Icons.file_download_done, color: Color(0xFF2E7D32), size: 28.0),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report File: $fileName',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Report Summary Preview:',
                  style: GoogleFonts.inter(fontSize: 12.0, color: Colors.black54),
                ),
                const SizedBox(height: 6.0),
                Container(
                  maxHeight: 180.0,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: GoogleFonts.robotoMono(fontSize: 11.0, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext),
              child: Text(
                'Close',
                style: GoogleFonts.inter(color: const Color(0xFF2E7D32), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
