import 'package:birthday_beacon/core/enums/filter.dart';
import 'package:birthday_beacon/core/utils/extensions.dart';
import 'package:birthday_beacon/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterButton extends ConsumerWidget {
  final Filter filter;
  const FilterButton({super.key, required this.filter});

  @override
  Widget build(BuildContext context, ref) {
    final selectedFilter = ref.watch(filterProvider);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        ref.read(filterProvider.notifier).update((filter) {
          return this.filter;
        });
        ref.invalidate(fabVisibilityProvider);
      },
      child: Container(
        margin: EdgeInsets.only(right: size.width * 0.03),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.015),
        decoration: BoxDecoration(
          color: selectedFilter == filter ? theme.colorScheme.primaryContainer : null,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
        child: Text(
          filter.name.capitalize(),
          style: selectedFilter == filter ? TextStyle(color: theme.colorScheme.onPrimaryContainer) : null,
        ),
      ),
    );
  }
}
