import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/surah.dart';

/// One row in the surah list, styled like a track row: number badge, name +
/// metadata, and the Arabic name on the trailing side.
class SurahTrackTile extends StatelessWidget {
  const SurahTrackTile({required this.surah, required this.onTap, super.key});

  final Surah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final revelation = surah.revelationType == 'Meccan'
        ? l10n.revelationMeccan
        : l10n.revelationMedinan;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingM,
        ),
        child: Row(
          children: [
            _NumberBadge(number: surah.number),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.englishName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$revelation · ${l10n.versesCount(surah.numberOfAyahs)}',
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              surah.name,
              style: textTheme.titleMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple rounded violet outline with the surah number centered.
///
/// Drawn in code (not the design's number PNG): that PNG has a number baked into
/// it, so overlaying our dynamic number produced a doubled/ghosted digit — most
/// visible in dark mode. A drawn badge stays crisp and theme-correct.
class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: AppDimensions.surahBadgeSize,
      height: AppDimensions.surahBadgeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: scheme.primary, width: 1.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusTag),
      ),
      child: Text(
        '$number',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
