import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'c_camera_framing_overlay_model.dart';
export 'c_camera_framing_overlay_model.dart';

class CCameraFramingOverlayWidget extends StatefulWidget {
  const CCameraFramingOverlayWidget({
    super.key,
    this.height = 220.0,
    this.onToggleGrid,
  });

  final double height;
  final VoidCallback? onToggleGrid;

  @override
  State<CCameraFramingOverlayWidget> createState() => _CCameraFramingOverlayWidgetState();
}

class _CCameraFramingOverlayWidgetState extends State<CCameraFramingOverlayWidget> {
  late CCameraFramingOverlayModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CCameraFramingOverlayModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFF2E7D32).withOpacity(0.8),
          width: 2.0,
        ),
      ),
      child: Stack(
        children: [
          // Rule of thirds grid lines
          if (_model.showGridLines)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _GridPainter(
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              ),
            ),

          // Viewfinder corner brackets
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CornerBracketPainter(
                  color: const Color(0xFF00E676),
                ),
              ),
            ),
          ),

          // Header Instruction Banner
          Positioned(
            top: 10.0,
            left: 12.0,
            right: 12.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: const Color(0xFF00E676).withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.center_focus_strong,
                    color: Color(0xFF00E676),
                    size: 16.0,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'CENTER WASTE ITEM • ENSURE GOOD LIGHTING',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Quality Tips Row
          if (_model.showTips)
            Positioned(
              bottom: 10.0,
              left: 10.0,
              right: 10.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTipChip(Icons.wb_sunny_outlined, 'Bright Light'),
                    _buildTipChip(Icons.filter_center_focus, 'Clear Focus'),
                    _buildTipChip(Icons.crop_free, 'Single Item'),
                  ],
                ),
              ),
            ),

          // Toggle Grid Button
          Positioned(
            top: 6.0,
            right: 6.0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _model.showGridLines = !_model.showGridLines;
                });
                if (widget.onToggleGrid != null) {
                  widget.onToggleGrid!();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _model.showGridLines ? Icons.grid_on : Icons.grid_off,
                  color: Colors.white,
                  size: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF81C784), size: 14.0),
        const SizedBox(width: 4.0),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;

  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height;

    // Vertical grid lines (rule of thirds)
    canvas.drawLine(Offset(width / 3, 0), Offset(width / 3, height), paint);
    canvas.drawLine(Offset(width * 2 / 3, 0), Offset(width * 2 / 3, height), paint);

    // Horizontal grid lines (rule of thirds)
    canvas.drawLine(Offset(0, height / 3), Offset(width, height / 3), paint);
    canvas.drawLine(Offset(0, height * 2 / 3), Offset(width, height * 2 / 3), paint);
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;

  _CornerBracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 22.0;

    // Top-Left corner
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top-Right corner
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-Left corner
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom-Right corner
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) => false;
}
