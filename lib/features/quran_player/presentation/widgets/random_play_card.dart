import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';

/// Gradient "Random play" card on Home (reuses the design's "Last Read" card
/// visual): a shuffle label + subtitle on the left, the open-Quran illustration
/// bleeding off the right. Tapping plays a random surah — a discovery action
/// that, unlike "continue listening", is always meaningful even on first launch.
///
/// The card is composed in code (gradient + live text) so it stays
/// theme-correct; only the illustration is a bundled asset.
class RandomPlayCard extends StatelessWidget {
  const RandomPlayCard({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        // Clip so the illustration can bleed to the card's rounded edge.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shuffle_rounded,
                            size: 18,
                            color: AppColors.textOnPrimary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.randomPlay,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textOnPrimary.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingM),
                      Text(
                        l10n.randomPlay,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        l10n.randomPlaySubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textOnPrimary.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: AppDimensions.spacingS),
                child: Image.asset(
                  AppAssets.quran,
                  height: 96,
                  fit: BoxFit.contain,
                  // Every image declares an errorBuilder so a missing asset
                  // degrades gracefully instead of throwing.
                  errorBuilder: (_, _, _) => const SizedBox(width: 96),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
