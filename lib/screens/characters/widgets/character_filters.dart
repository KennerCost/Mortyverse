import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

enum CharacterStatusFilter { all, alive, dead, unknown }

class CharacterFilters extends StatelessWidget {
  final CharacterStatusFilter selected;
  final ValueChanged<CharacterStatusFilter> onChanged;

  const CharacterFilters({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  static const _items = [
    (CharacterStatusFilter.all, 'All'),
    (CharacterStatusFilter.alive, 'Alive'),
    (CharacterStatusFilter.dead, 'Dead'),
    (CharacterStatusFilter.unknown, 'unknown'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in _items) ...[
            _FilterChip(
              label: item.$2,
              selected: selected == item.$1,
              onTap: () => onChanged(item.$1),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.darkButton : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.darkButton : colors.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
