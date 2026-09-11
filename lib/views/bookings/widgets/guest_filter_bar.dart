import 'package:flutter/material.dart';

class GuestFilterBar extends StatelessWidget {
  final int? selectedMaxGuests;
  final ValueChanged<int?> onFilterChanged;

  const GuestFilterBar({
    super.key,
    required this.selectedMaxGuests,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterOptions = [
      {'label': 'All Rooms', 'value': null},
      {'label': '2 Guests (Deluxe)', 'value': 2},
      {'label': '3 Guests (Suite)', 'value': 3},
      {'label': '4 Guests (Family)', 'value': 4},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Filter by Guests',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filterOptions.map((opt) {
              final val = opt['value'] as int?;
              final isSelected = selectedMaxGuests == val;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(opt['label'] as String),
                  selected: isSelected,
                  onSelected: (_) => onFilterChanged(val),
                  avatar: val != null
                      ? Icon(
                          Icons.person_rounded,
                          size: 16,
                          color: isSelected
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurfaceVariant,
                        )
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  showCheckmark: false,
                  selectedColor: theme.colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
