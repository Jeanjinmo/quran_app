import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';

/// Generic error view with a retry action.
///
/// Maps a typed [Failure] to localized copy here (not in the BLoC) so error
/// messages stay translatable (EN/ID) and the BLoC stays UI-agnostic.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({required this.failure, required this.onRetry, super.key});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = switch (failure) {
      NetworkFailure() => l10n.errorNetwork,
      AudioFailure() => l10n.errorAudio,
      _ => l10n.errorServer,
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 56),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
