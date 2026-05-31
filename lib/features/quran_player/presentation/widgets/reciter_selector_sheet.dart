import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/edition/edition_bloc.dart';
import 'error_retry.dart';
import 'search_field.dart';

/// Bottom sheet for choosing a reciter ("artist"), with search-by-artist.
///
/// Reuses the app-level [EditionBloc] (passed in) so the selection persists
/// after the sheet closes and applies to subsequent playback.
class ReciterSelectorSheet extends StatelessWidget {
  const ReciterSelectorSheet({required this.bloc, super.key});

  final EditionBloc bloc;

  /// Opens the sheet, wiring the existing [EditionBloc] through so its state and
  /// selection are shared with the rest of the app.
  static Future<void> show(BuildContext context) {
    final bloc = context.read<EditionBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: ReciterSelectorSheet(bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.spacingL,
        right: AppDimensions.spacingL,
        bottom:
            MediaQuery.of(context).viewInsets.bottom + AppDimensions.spacingL,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Text(
              l10n.chooseReciter,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            SearchField(
              hint: l10n.searchArtistHint,
              onChanged: (q) => bloc.add(EditionSearchChanged(q)),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Expanded(
              child: BlocBuilder<EditionBloc, EditionState>(
                builder: (context, state) => switch (state) {
                  EditionLoaded() => _ReciterList(state: state),
                  EditionError(:final failure) => ErrorRetry(
                    failure: failure,
                    onRetry: () => bloc.add(const EditionsRequested()),
                  ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReciterList extends StatelessWidget {
  const _ReciterList({required this.state});

  final EditionLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.filtered.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context).emptySearch));
    }
    // Flutter 3.32+ manages radio selection via a RadioGroup ancestor; the tiles
    // only declare their value. Selecting one updates the EditionBloc and closes
    // the sheet.
    return RadioGroup<String>(
      groupValue: state.selected.id,
      onChanged: (id) {
        if (id == null) return;
        final edition = state.all.firstWhere((e) => e.id == id);
        context.read<EditionBloc>().add(EditionSelected(edition));
        Navigator.of(context).pop();
      },
      child: ListView.builder(
        itemCount: state.filtered.length,
        itemBuilder: (context, i) {
          final edition = state.filtered[i];
          return RadioListTile<String>(
            value: edition.id,
            title: Text(edition.name),
            subtitle: Text(
              edition.arabicName,
              textDirection: TextDirection.rtl,
            ),
          );
        },
      ),
    );
  }
}
