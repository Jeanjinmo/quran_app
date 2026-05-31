import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Gradient "cover" used as the now-playing artwork. The API provides no images,
/// so we render a branded placeholder (book glyph on the brand gradient) instead
/// of a network image.
class AlbumArt extends StatelessWidget {
  const AlbumArt({this.size = AppDimensions.albumArtSize, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: size * 0.4,
        color: AppColors.textOnPrimary.withValues(alpha: 0.9),
      ),
    );
  }
}
