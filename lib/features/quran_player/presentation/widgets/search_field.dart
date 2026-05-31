import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';

/// Rounded search input used for the "search by title" field on Home.
class SearchField extends StatelessWidget {
  const SearchField({required this.hint, required this.onChanged, super.key});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
