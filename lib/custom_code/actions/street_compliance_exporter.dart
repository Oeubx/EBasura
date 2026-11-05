import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/supabase/supabase.dart';
import 'file_saver_util.dart';

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
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to generate CSV export: $e');
      }
    }
  }

  /// Exports Street Compliance Index (SCI) snapshots and active flags
  static Future<void> exportSnapshotsCSV({
    required BuildContext context,
    required List<StreetComplianceSnapshotRow> snapshots,
    List<StreetFlagRow>? flags,
  }) async {
    try {
      final flagMap = <String, StreetFlagRow>{};
      if (flags != null) {
        for (final f in flags) {
          if (!flagMap.containsKey(f.streetRef) || f.status != 'resolved') {
            flagMap[f.streetRef] = f;
          }
        }
      }

      final List<List<dynamic>> csvData = [
        [
          'Street Name',
          'Week Starting',
          'Verified Scans',
          'Segregated Scans',
          'Valid Reports',
          'Weekly SCI (%)',
          '4-Week Rolling SCI (%)',
          'Assigned Grade',
          'Flag Status',
          'Flag Action Note',
          'Computed At',
        ],
        ...snapshots.map((s) {
          final flag = flagMap[s.streetRef];
          return [
            s.streetRef,
            s.weekStart.toIso8601String().split('T').first,
            s.verifiedScans,
            s.segregatedScans,
            s.validReports,
            s.sciWeek != null ? s.sciWeek!.toStringAsFixed(1) : 'Insufficient Data',
            s.sciRolling4 != null ? s.sciRolling4!.toStringAsFixed(1) : 'Insufficient Data',
            s.grade ?? 'N/A (<5 scans)',
            flag?.status ?? 'None',
            flag?.actionNote ?? 'N/A',
            s.computedAt.toIso8601String(),
          ];
        }),
      ];

      final String csvString = const ListToCsvConverter().convert(csvData);
      final List<int> bytes = utf8.encode(csvString);
      final String fileName =
          'EBasura_Street_Compliance_Snapshots_${DateTime.now().millisecondsSinceEpoch}.csv';

      await _downloadOrSaveFile(
        context: context,
        bytes: bytes,
        fileName: fileName,
        mimeType: 'text/csv',
        fileTitle: 'Street Compliance Snapshots Exported',
      );
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to generate snapshots CSV: $e');
      }
    }
  }


  /// Exports complete ground-truth dual-evaluation dataset for Chapter 5 empirical research
  /// (Confusion Matrix, Cohen's Kappa, and Audit Latency).
  static Future<void> exportEvaluationDatasetCSV({
    required BuildContext context,
    required List<ImageRow> images,
  }) async {
    try {
      final List<List<dynamic>> csvData = [
        [
          'Image ID',
          'Street Name',
          'Moderation Status',
          'AI Classification',
          'AI Waste Type',
          'AI Confidence (%)',
          'Admin ID',
          'Admin Classification (Ground Truth)',
          'Admin Waste Type',
          'Verification Status',
          'Audit Latency (Seconds)',
          'Created At',
          'Verified At',
        ],
        ...images.map((img) => [
              img.imageId ?? 'N/A',
              img.imgStreetNameRef,
              img.status ?? 'Non-Verified',
              img.aiClassification ?? 'Unclassified',
              img.aiWasteType ?? 'Unidentified',
              img.aiConfidenceScore ?? 0.0,
              img.adminId ?? 'Unassigned',
              img.adminClassification ?? 'Pending',
              img.adminWasteType ?? 'Pending',
              img.verificationStatus ?? 'pending',
              img.verificationTimeSeconds ?? 0.0,
              img.createdAt.toIso8601String(),
              img.verifiedAt?.toIso8601String() ?? 'N/A',
            ]),
      ];

      final String csvString = const ListToCsvConverter().convert(csvData);
      final List<int> bytes = utf8.encode(csvString);
      final String fileName =
          'EBasura_Chapter5_Evaluation_Dataset_${DateTime.now().millisecondsSinceEpoch}.csv';

      await _downloadOrSaveFile(
        context: context,
        bytes: bytes,
        fileName: fileName,
        mimeType: 'text/csv',
        fileTitle: 'Chapter 5 Empirical Dataset Exported',
      );
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to generate evaluation dataset CSV: $e');
      }
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
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to generate PDF/Text report: $e');
      }
    }
  }

  static Future<void> _downloadOrSaveFile({
    required BuildContext context,
    required List<int> bytes,
    required String fileName,
    required String mimeType,
    required String fileTitle,
  }) async {
    try {
      final savedPath = await saveExportedFile(
        bytes: bytes,
        fileName: fileName,
        mimeType: mimeType,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  savedPath != null
                      ? 'Export saved: $savedPath'
                      : 'Export downloaded: $fileName',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1B5E20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error saving export file: $e');
      }
    }
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
