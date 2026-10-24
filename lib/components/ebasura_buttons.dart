import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Canonical Button Style Variants defined in docs/design_system/brand_and_design_system.md
enum EBasuraButtonStyle {
  /// Button 1: Neutral Canvas (#F2F2F2), Dark Text (#013448), Pill Radius, subtle shadow
  button1Neutral,

  /// Button 2: Primary Ocean Blue Solid (#2E78A6), White Text (#FFFFFF), Pill Radius, medium shadow
  button2Primary,

  /// Button 3: Sky Blue (#A3C9D9), Dark Text (#013448), Pill Radius, subtle shadow
  button3Sky,

  /// Button 4: Mint Sage Eco (#D5F2E2), Dark Text (#013448), Pill Radius, subtle shadow
  button4Mint,
}

/// Standardized canonical icon symbols for the EBasura application.
class EBasuraIcons {
  static const IconData home = Icons.space_dashboard_rounded;
  static const IconData leaderboard = Icons.leaderboard_rounded;
  static const IconData camera = Icons.photo_camera_rounded;
  static const IconData schedules = Icons.calendar_today_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData crew = Icons.local_shipping_rounded;
  static const IconData reports = Icons.report_problem_rounded;
  static const IconData eco = Icons.eco_rounded;
  static const IconData recycle = Icons.recycling_rounded;
  static const IconData verified = Icons.verified_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData checklist = Icons.checklist_rounded;
  static const IconData notifications = Icons.notifications_rounded;
  static const IconData back = Icons.arrow_back_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData streak = Icons.local_fire_department_rounded;
}

/// Factory widget generating high-contrast pill buttons compliant with the Brand Design System.
class EBasuraButton extends StatelessWidget {
  const EBasuraButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = EBasuraButtonStyle.button2Primary,
    this.width = 280.0,
    this.height = 48.0,
    this.icon,
    this.iconData,
    this.isLoading = false,
  });

  /// Button 1: Neutral Pill (#F2F2F2)
  const EBasuraButton.button1({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 280.0,
    this.height = 48.0,
    this.icon,
    this.iconData,
    this.isLoading = false,
  }) : style = EBasuraButtonStyle.button1Neutral;

  /// Button 2: Primary Solid Blue CTA (#2E78A6)
  const EBasuraButton.button2({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 280.0,
    this.height = 48.0,
    this.icon,
    this.iconData,
    this.isLoading = false,
  }) : style = EBasuraButtonStyle.button2Primary;

  /// Button 3: Sky Blue Action (#A3C9D9)
  const EBasuraButton.button3({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 280.0,
    this.height = 48.0,
    this.icon,
    this.iconData,
    this.isLoading = false,
  }) : style = EBasuraButtonStyle.button3Sky;

  /// Button 4: Mint Eco Action (#D5F2E2)
  const EBasuraButton.button4({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 280.0,
    this.height = 48.0,
    this.icon,
    this.iconData,
    this.isLoading = false,
  }) : style = EBasuraButtonStyle.button4Mint;

  final String text;
  final VoidCallback onPressed;
  final EBasuraButtonStyle style;
  final double width;
  final double height;
  final Widget? icon;
  final IconData? iconData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    Color bgColor;
    Color textColor;
    double elevation;
    BorderSide? borderSide;

    switch (style) {
      case EBasuraButtonStyle.button1Neutral:
        bgColor = theme.primaryBackground;
        textColor = theme.primaryText;
        elevation = 1.0;
        borderSide = BorderSide(color: theme.accent4.withValues(alpha: 0.5), width: 1.0);
        break;
      case EBasuraButtonStyle.button2Primary:
        bgColor = theme.accent3; // #2E78A6
        textColor = Colors.white;
        elevation = 2.0;
        borderSide = BorderSide.none;
        break;
      case EBasuraButtonStyle.button3Sky:
        bgColor = theme.accent4; // #A3C9D9
        textColor = theme.primaryText;
        elevation = 1.0;
        borderSide = BorderSide.none;
        break;
      case EBasuraButtonStyle.button4Mint:
        bgColor = theme.secondaryBackground; // #D5F2E2
        textColor = theme.primaryText;
        elevation = 1.0;
        borderSide = BorderSide.none;
        break;
    }

    return FFButtonWidget(
      text: text,
      onPressed: onPressed,
      icon: icon,
      iconData: iconData,
      showLoadingIndicator: isLoading,
      options: FFButtonOptions(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: bgColor,
        textStyle: GoogleFonts.inter(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.0,
        ),
        elevation: elevation,
        borderRadius: BorderRadius.circular(theme.designToken.radius.pill),
        borderSide: borderSide,
      ),
    );
  }
}

/// Standardized 16px grid content card container for EBasura.
class EBasuraCard extends StatelessWidget {
  const EBasuraCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.only(bottom: 12.0),
    this.borderColor,
    this.borderRadius = 16.0,
    this.onTap,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? borderColor;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final cardContent = Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? theme.accent4.withValues(alpha: 0.35),
          width: 1.0,
        ),
        boxShadow: [
          theme.designToken.shadow.sm,
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardContent,
      );
    }
    return cardContent;
  }
}
