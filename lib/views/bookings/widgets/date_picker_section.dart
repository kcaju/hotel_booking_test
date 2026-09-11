import 'package:flutter/material.dart';
import 'package:hotel_booking_test/services/booking_calculator.dart';
import 'package:hotel_booking_test/services/booking_validator.dart';

class DatePickerSection extends StatelessWidget {
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final ValidationResult validationResult;
  final ValueChanged<DateTime?> onCheckInChanged;
  final ValueChanged<DateTime?> onCheckOutChanged;

  const DatePickerSection({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.validationResult,
    required this.onCheckInChanged,
    required this.onCheckOutChanged,
  });

  Future<void> _selectDate({
    required BuildContext context,
    required bool isCheckIn,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final initialDate = isCheckIn
        ? (checkInDate ?? today)
        : (checkOutDate ??
              (checkInDate != null
                  ? checkInDate!.add(const Duration(days: 1))
                  : today.add(const Duration(days: 1))));

    // Allow selecting dates from 30 days ago to 1 year ahead
    // (To easily test past date validation error)
    final firstDate = today.subtract(const Duration(days: 30));
    final lastDate = today.add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate)
          ? firstDate
          : (initialDate.isAfter(lastDate) ? lastDate : initialDate),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: isCheckIn ? 'SELECT CHECK-IN DATE' : 'SELECT CHECK-OUT DATE',
      confirmText: 'SELECT',
      cancelText: 'CANCEL',
    );

    if (picked != null) {
      if (isCheckIn) {
        onCheckInChanged(picked);
      } else {
        onCheckOutChanged(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError =
        !validationResult.isValid &&
        validationResult.status != ValidationStatus.missingDates;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 550;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: hasError
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: hasError ? 1.5 : 1.0,
        ),
      ),
      color: theme.colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Dates',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (checkInDate != null || checkOutDate != null)
                  TextButton.icon(
                    onPressed: () {
                      onCheckInChanged(null);
                      onCheckOutChanged(null);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Reset Dates'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Date Pickers row responsive
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _DateTile(
                      label: 'Check-In Date',
                      icon: Icons.login_rounded,
                      date: checkInDate,
                      placeholder: 'Select check-in',
                      onTap: () =>
                          _selectDate(context: context, isCheckIn: true),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: _DateTile(
                      label: 'Check-Out Date',
                      icon: Icons.logout_rounded,
                      date: checkOutDate,
                      placeholder: 'Select check-out',
                      onTap: () =>
                          _selectDate(context: context, isCheckIn: false),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _DateTile(
                    label: 'Check-In Date',
                    icon: Icons.login_rounded,
                    date: checkInDate,
                    placeholder: 'Select check-in',
                    onTap: () => _selectDate(context: context, isCheckIn: true),
                  ),
                  const SizedBox(height: 10),
                  _DateTile(
                    label: 'Check-Out Date',
                    icon: Icons.logout_rounded,
                    date: checkOutDate,
                    placeholder: 'Select check-out',
                    onTap: () =>
                        _selectDate(context: context, isCheckIn: false),
                  ),
                ],
              ),

            // Error banner if dates are invalid
            if (hasError && validationResult.errorMessage != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        validationResult.errorMessage!,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final DateTime? date;
  final String placeholder;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.icon,
    required this.date,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDate = date != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasDate
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(12),
          color: hasDate
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.25)
              : theme.colorScheme.surface,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasDate
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: hasDate
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasDate
                        ? BookingCalculator.formatShortDate(date!)
                        : placeholder,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: hasDate ? FontWeight.bold : FontWeight.w400,
                      color: hasDate
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.outline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
