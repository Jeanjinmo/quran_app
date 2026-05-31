import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Skeleton placeholder shown while the surah list loads.
class LoadingShimmerList extends StatelessWidget {
  const LoadingShimmerList({this.itemCount = 8, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      highlightColor: isDark
          ? AppColors.surfaceDark.withValues(alpha: 0.4)
          : Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
        itemCount: itemCount,
        itemBuilder: (context, _) => const _ShimmerRow(),
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
      child: Row(
        children: [
          Container(
            width: AppDimensions.surahBadgeSize,
            height: AppDimensions.surahBadgeSize,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 140, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 12, width: 90, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
