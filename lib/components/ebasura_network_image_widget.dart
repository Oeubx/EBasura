import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EBasuraNetworkImage extends StatefulWidget {
  const EBasuraNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.autoLoad = false, // Default is OFF (Data Saver mode)
    this.onTapCard,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool autoLoad;
  final VoidCallback? onTapCard;

  @override
  State<EBasuraNetworkImage> createState() => _EBasuraNetworkImageState();
}

class _EBasuraNetworkImageState extends State<EBasuraNetworkImage> {
  late bool _isLoaded;

  @override
  void initState() {
    super.initState();
    _isLoaded = widget.autoLoad;
  }

  @override
  void didUpdateWidget(covariant EBasuraNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoLoad && !_isLoaded) {
      setState(() => _isLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.zero;

    if (!_isLoaded) {
      return InkWell(
        onTap: widget.onTapCard,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: radius,
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // System Logo Placeholder
              Opacity(
                opacity: 0.45,
                child: Image.asset(
                  'assets/images/Ebasura_icon.png',
                  width: 52.0,
                  height: 52.0,
                  fit: BoxFit.contain,
                ),
              ),
              // "Load Photo" Pill Button
              Positioned(
                bottom: 10.0,
                child: InkWell(
                  onTap: () => setState(() => _isLoaded = true),
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E78A6),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 4.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.photo_camera_outlined,
                          size: 13.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'Load Photo',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Full Cached Image View
    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        memCacheWidth: 600, // Downscale raw photos to eliminate high memory and OOMs
        placeholder: (context, url) => Container(
          width: widget.width,
          height: widget.height,
          color: const Color(0xFFF8FAFC),
          child: const Center(
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31A11F)),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: widget.width,
          height: widget.height,
          color: const Color(0xFFF1F5F9),
          child: const Center(
            child: Icon(
              Icons.broken_image_rounded,
              color: Color(0xFF94A3B8),
              size: 28.0,
            ),
          ),
        ),
      ),
    );
  }
}
