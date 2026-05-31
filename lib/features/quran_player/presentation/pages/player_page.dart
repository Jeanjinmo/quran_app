import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/player/player_bloc.dart';
import '../widgets/album_art.dart';
import '../widgets/audio_progress_bar.dart';
import '../widgets/error_retry.dart';
import '../widgets/player_controls.dart';

/// The "now playing" screen containing playback controls, progress indicator,
/// and reciter details. Adapts to device orientation (stacked in portrait,
/// side-by-side in landscape).
class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.nowPlaying)),
      body: SafeArea(
        child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) => switch (state) {
            PlayerReady() => _PlayerView(state: state),
            PlayerFailure(:final failure) => ErrorRetry(
              failure: failure,
              onRetry: () {
                if (state.surah != null && state.edition != null) {
                  context.read<PlayerBloc>().add(
                    PlaySurahRequested(
                      surah: state.surah!,
                      edition: state.edition!,
                    ),
                  );
                }
              },
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

class _PlayerView extends StatelessWidget {
  const _PlayerView({required this.state});

  final PlayerReady state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: isLandscape ? _landscape(context) : _portrait(context),
        );
      },
    );
  }

  Widget _portrait(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const AlbumArt(),
        const SizedBox(height: AppDimensions.spacingXl),
        _Info(state: state),
        const Spacer(),
        _Controls(state: state),
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  Widget _landscape(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(child: Center(child: AlbumArt(size: 160))),
        const SizedBox(width: AppDimensions.spacingXl),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Info(state: state),
              const SizedBox(height: AppDimensions.spacingL),
              _Controls(state: state),
            ],
          ),
        ),
      ],
    );
  }
}

/// Surah title, translation, reciter, and metadata block.
class _Info extends StatelessWidget {
  const _Info({required this.state});

  final PlayerReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final surah = state.surah;
    final revelation = surah.revelationType == 'Meccan'
        ? l10n.revelationMeccan
        : l10n.revelationMedinan;
    return Column(
      children: [
        Text(
          surah.englishName,
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(surah.englishNameTranslation, style: textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          state.edition.name,
          style: textTheme.bodyMedium?.copyWith(color: scheme.primary),
        ),
        const SizedBox(height: 4),
        Text(
          '$revelation · ${l10n.versesCount(surah.numberOfAyahs)}',
          style: textTheme.bodySmall?.copyWith(
            color: scheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

/// Progress bar + play/pause, wired to [PlayerBloc].
class _Controls extends StatelessWidget {
  const _Controls({required this.state});

  final PlayerReady state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return Column(
      children: [
        AudioProgressBar(
          position: state.position,
          duration: state.duration,
          onSeek: (pos) => bloc.add(PlayerSeekRequested(pos)),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        PlayerControls(
          isPlaying: state.isPlaying,
          isBuffering: state.isBuffering,
          hasNext: state.hasNext,
          hasPrevious: state.hasPrevious,
          onPlayPause: () => bloc.add(
            state.isPlaying
                ? const PlayerPauseRequested()
                : const PlayerResumeRequested(),
          ),
          onNext: () => bloc.add(const PlayerNextRequested()),
          onPrevious: () => bloc.add(const PlayerPreviousRequested()),
        ),
      ],
    );
  }
}
