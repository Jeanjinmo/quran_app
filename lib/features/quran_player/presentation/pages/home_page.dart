import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/juz_constants.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/surah.dart';
import '../bloc/edition/edition_bloc.dart';
import '../bloc/player/player_bloc.dart';
import '../bloc/surah_list/surah_list_bloc.dart';
import '../widgets/error_retry.dart';
import '../widgets/language_theme_toggle.dart';
import '../widgets/loading_shimmer_list.dart';
import '../widgets/mini_player_bar.dart';
import '../widgets/random_play_card.dart';
import '../widgets/reciter_selector_sheet.dart';
import '../widgets/search_field.dart';
import '../widgets/surah_track_tile.dart';

/// Home: the music-list screen, laid out in the design's order — reciter
/// selector, a Random-play card, then Surah/Juz tabs over the list.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LanguageThemeToggle()],
      ),
      bottomNavigationBar: const MiniPlayerBar(),
      body: SafeArea(
        // Constrain width so the layout stays tidy in landscape / on tablets.
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SizedBox.expand(
              child: BlocBuilder<SurahListBloc, SurahListState>(
                builder: (context, state) => switch (state) {
                  SurahListLoaded() => _LoadedView(state: state),
                  SurahListError(:final failure) => ErrorRetry(
                    failure: failure,
                    onRetry: () => context.read<SurahListBloc>().add(
                      const SurahListRequested(),
                    ),
                  ),
                  _ => const LoadingShimmerList(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state});

  final SurahListLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // DefaultTabController provides the controller the TabBar/TabBarView share.
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ReciterRow(),
          _RandomPlayCardSection(all: state.all),
          TabBar(
            tabs: [
              Tab(text: l10n.tabSurah),
              Tab(text: l10n.tabJuz),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _SurahTab(state: state),
                _JuzTab(all: state.all),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Surah tab: search field + the scrollable surah list.
class _SurahTab extends StatelessWidget {
  const _SurahTab({required this.state});

  final SurahListLoaded state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: SearchField(
            hint: l10n.searchSurahHint,
            onChanged: (q) =>
                context.read<SurahListBloc>().add(SurahSearchChanged(q)),
          ),
        ),
        Expanded(
          child: state.filtered.isEmpty
              ? Center(child: Text(l10n.emptySearch))
              : ListView.separated(
                  itemCount: state.filtered.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final surah = state.filtered[i];
                    return SurahTrackTile(
                      surah: surah,
                      onTap: () => _playSurah(context, surah, state.all),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Juz tab: the 30 juz as expandable rows. Expanding a juz reveals the surahs
/// that fall in it (resolved from the loaded surah list); tapping a surah plays
/// the whole surah, same as the Surah tab. Juz→surah is fixed reference data
/// ([JuzConstants]); audio remains per-surah.
class _JuzTab extends StatelessWidget {
  const _JuzTab({required this.all});

  final List<Surah> all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView.builder(
      itemCount: JuzConstants.all.length,
      itemBuilder: (context, i) {
        final juz = JuzConstants.all[i];
        final surahs = juz.surahNumbers
            .map((n) => all.where((s) => s.number == n).firstOrNull)
            .whereType<Surah>()
            .toList();
        return ExpansionTile(
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.12),
            child: Text(
              '${juz.number}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          title: Text(l10n.juzLabel(juz.number)),
          subtitle: Text(l10n.surahCount(surahs.length)),
          childrenPadding: EdgeInsets.zero,
          children: [
            for (final surah in surahs)
              SurahTrackTile(
                surah: surah,
                onTap: () => _playSurah(context, surah, all),
              ),
          ],
        );
      },
    );
  }
}

/// Starts playback with the currently selected reciter, then opens the player.
/// Passes the full surah list as the playlist so next/prev/auto-advance span all
/// 114 surahs (the "album"), regardless of any active search filter.
void _playSurah(BuildContext context, Surah surah, List<Surah> playlist) {
  final editionState = context.read<EditionBloc>().state;
  if (editionState is! EditionLoaded) return;
  final edition = editionState.selected;
  context.read<PlayerBloc>().add(
    PlaySurahRequested(surah: surah, edition: edition, playlist: playlist),
  );
  // `go` to the nested route keeps HomePage mounted underneath (no rebuild/flash
  // on return); see app_router.dart for the rationale.
  context.go('/home/player/${surah.number}');
}

/// The "Random play" card section. Always shown once surahs are loaded (no
/// dependency on prior playback). Tapping plays a random surah with the selected
/// reciter, passing the full list as the playlist so next/prev keep working.
class _RandomPlayCardSection extends StatelessWidget {
  const _RandomPlayCardSection({required this.all});

  final List<Surah> all;

  @override
  Widget build(BuildContext context) {
    if (all.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingL,
        AppDimensions.spacingS,
        AppDimensions.spacingL,
        AppDimensions.spacingM,
      ),
      child: RandomPlayCard(onTap: () => _playRandom(context)),
    );
  }

  void _playRandom(BuildContext context) {
    final editionState = context.read<EditionBloc>().state;
    if (editionState is! EditionLoaded) return;
    final surah = all[Random().nextInt(all.length)];
    context.read<PlayerBloc>().add(
      PlaySurahRequested(
        surah: surah,
        edition: editionState.selected,
        playlist: all,
      ),
    );
    context.go('/home/player/${surah.number}');
  }
}

class _ReciterRow extends StatelessWidget {
  const _ReciterRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<EditionBloc, EditionState>(
      builder: (context, state) {
        final name = state is EditionLoaded ? state.selected.name : '—';
        return ListTile(
          leading: const Icon(Icons.record_voice_over_outlined),
          title: Text(l10n.reciterLabel),
          subtitle: Text(name),
          trailing: const Icon(Icons.expand_more),
          onTap: () => ReciterSelectorSheet.show(context),
        );
      },
    );
  }
}
