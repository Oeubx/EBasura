import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CPageHeaderWidget extends StatelessWidget {
  const CPageHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.badgeText,
    this.badgeColor,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final String? badgeText;
  final Color? badgeColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: theme.accent3,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(
                icon,
                size: 22.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12.0),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.interTight(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryText,
                          letterSpacing: 0.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeText != null && badgeText!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                        decoration: BoxDecoration(
                          color: badgeColor ?? theme.ecoPrimary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          badgeText!,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3.0),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal,
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8.0),
            trailing!,
          ],
        ],
      ),
    );
  }
}
