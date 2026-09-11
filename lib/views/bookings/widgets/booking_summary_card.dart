import 'package:flutter/material.dart';
import 'package:hotel_booking_test/models/room.dart';
import 'package:hotel_booking_test/services/booking_calculator.dart';
import 'package:hotel_booking_test/services/booking_validator.dart';

class BookingSummaryCard extends StatelessWidget {
  final Room? selectedRoom;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final ValidationResult validationResult;
  final bool isRoomAvailable;
  final VoidCallback onBookRoom;

  const BookingSummaryCard({
    super.key,
    required this.selectedRoom,
    required this.checkInDate,
    required this.checkOutDate,
    required this.validationResult,
    required this.isRoomAvailable,
    required this.onBookRoom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate nights & total price if dates and room are valid
    final hasDates = checkInDate != null && checkOutDate != null;
    final isDateValid = validationResult.isValid;
    final nights = (hasDates && isDateValid)
        ? BookingCalculator.calculateNights(checkInDate!, checkOutDate!)
        : 0;

    final totalPrice = (selectedRoom != null && nights > 0)
        ? BookingCalculator.calculateTotalPrice(
            nights: nights,
            pricePerNight: selectedRoom!.pricePerNight,
          )
        : 0.0;

    final isReadyToBook =
        selectedRoom != null &&
        hasDates &&
        isDateValid &&
        isRoomAvailable &&
        nights > 0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Booking Summary',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Missing selection hints if incomplete
          if (selectedRoom == null || !hasDates || !isDateValid) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To see calculation & total price:',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _RequirementItem(
                    text:
                        checkInDate != null &&
                            checkOutDate != null &&
                            isDateValid
                        ? 'Dates selected: ${BookingCalculator.formatShortDate(checkInDate!)} - ${BookingCalculator.formatShortDate(checkOutDate!)}'
                        : (!isDateValid && validationResult.errorMessage != null
                              ? validationResult.errorMessage!
                              : 'Select valid check-in & check-out dates'),
                    isSatisfied: hasDates && isDateValid,
                    hasError:
                        !isDateValid &&
                        validationResult.status !=
                            ValidationStatus.missingDates,
                  ),
                  const SizedBox(height: 4),
                  _RequirementItem(
                    text: selectedRoom != null
                        ? 'Selected Room: ${selectedRoom!.name} (${selectedRoom!.code})'
                        : 'Select a room from the list',
                    isSatisfied: selectedRoom != null,
                    hasError: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Detailed Breakdown Table if selected
          if (selectedRoom != null) ...[
            _SummaryRow(
              label: 'Selected Room',
              value: '${selectedRoom!.name} (${selectedRoom!.code})',
              isBold: true,
            ),
            _SummaryRow(
              label: 'Room Rate',
              value:
                  '${BookingCalculator.formatCurrency(selectedRoom!.pricePerNight)} / night',
            ),
          ],

          if (hasDates && isDateValid) ...[
            _SummaryRow(
              label: 'Duration',
              value:
                  '$nights ${nights == 1 ? "night" : "nights"} (${BookingCalculator.formatShortDate(checkInDate!)} → ${BookingCalculator.formatShortDate(checkOutDate!)})',
            ),
          ],

          const Divider(height: 24),

          // Total Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (nights > 0 && selectedRoom != null)
                      Text(
                        '$nights nights × ${BookingCalculator.formatCurrency(selectedRoom!.pricePerNight)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                BookingCalculator.formatCurrency(totalPrice),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Confirmation CTA Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: isReadyToBook ? onBookRoom : null,
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: Text(
                isReadyToBook
                    ? 'Confirm Booking (${BookingCalculator.formatCurrency(totalPrice)})'
                    : (!isRoomAvailable && selectedRoom != null
                          ? 'Room Unavailable for Dates'
                          : 'Complete Selection to Book'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isSatisfied;
  final bool hasError;

  const _RequirementItem({
    required this.text,
    required this.isSatisfied,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = hasError
        ? theme.colorScheme.error
        : (isSatisfied ? Colors.green : theme.colorScheme.outline);

    final icon = hasError
        ? Icons.cancel_outlined
        : (isSatisfied
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded);

    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: hasError
                  ? theme.colorScheme.error
                  : (isSatisfied
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant),
              fontWeight: isSatisfied || hasError
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
