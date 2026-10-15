import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable canonical Brand Wordmark widget using Comfortaa typography
/// matching docs/brand_docs.md and docs/EBASURA_BRAND_AND_DESIGN_SYSTEM.md.
class CBrandLogoWidget extends StatelessWidget {
  const CBrandLogoWidget({
    super.key,
    this.fontSize = 28.0,
    this.iconSize,
    this.color,
    this.showIcon = true,
    this.showSubtitle = false,
    this.subtitle,
    this.alignment = CrossAxisAlignment.center,
  });

  final double fontSize;
  final double? iconSize;
  final Color? color;
  final bool showIcon;
  final bool showSubtitle;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final brandColor = color ?? theme.primaryText;
    final leafIconSize = iconSize ?? (fontSize * 0.85);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'EBasura',
              style: GoogleFonts.comfortaa(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: brandColor,
                letterSpacing: -0.5,
              ),
            ),
            if (showIcon) ...[
              const SizedBox(width: 4.0),
              Icon(
                Icons.eco_rounded,
                size: leafIconSize,
                color: theme.ecoPrimary,
              ),
            ],
          ],
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 2.0),
          Text(
            subtitle ?? 'Smart Community Waste Management',
            style: theme.labelSmall.override(
              font: GoogleFonts.inter(),
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ],
    );
  }
}
