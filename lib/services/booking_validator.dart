import '../models/booking.dart';
import '../models/room.dart';

enum ValidationStatus {
  valid,
  missingDates,
  pastCheckIn,
  sameDayCheckout,
  checkOutBeforeCheckIn,
  roomUnavailable,
  noRoomSelected,
}

class ValidationResult {
  final bool isValid;
  final ValidationStatus status;
  final String? errorMessage;

  const ValidationResult({
    required this.isValid,
    required this.status,
    this.errorMessage,
  });

  factory ValidationResult.valid() {
    return const ValidationResult(
      isValid: true,
      status: ValidationStatus.valid,
    );
  }

  factory ValidationResult.invalid(ValidationStatus status, String message) {
    return ValidationResult(
      isValid: false,
      status: status,
      errorMessage: message,
    );
  }
}

class BookingValidator {
  // Strips time components for pure calendar date comparisons
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Validates the check-in and check-out dates
  static ValidationResult validateDates({
    required DateTime? checkIn,
    required DateTime? checkOut,
    DateTime? referenceDate,
  }) {
    if (checkIn == null && checkOut == null) {
      return ValidationResult.invalid(
        ValidationStatus.missingDates,
        'Please select both check-in and check-out dates.',
      );
    }

    if (checkIn == null) {
      return ValidationResult.invalid(
        ValidationStatus.missingDates,
        'Please select a check-in date.',
      );
    }

    if (checkOut == null) {
      return ValidationResult.invalid(
        ValidationStatus.missingDates,
        'Please select a check-out date.',
      );
    }

    final normalizedCheckIn = normalizeDate(checkIn);
    final normalizedCheckOut = normalizeDate(checkOut);
    final today = normalizeDate(referenceDate ?? DateTime.now());

    // Check-in cannot be in the past
    if (normalizedCheckIn.isBefore(today)) {
      return ValidationResult.invalid(
        ValidationStatus.pastCheckIn,
        'Check-in date cannot be in the past.',
      );
    }

    // Check-out must be strictly after check-in
    if (normalizedCheckOut.isAtSameMomentAs(normalizedCheckIn)) {
      return ValidationResult.invalid(
        ValidationStatus.sameDayCheckout,
        'Check-out date must be after check-in (minimum stay is 1 night).',
      );
    }

    if (normalizedCheckOut.isBefore(normalizedCheckIn)) {
      return ValidationResult.invalid(
        ValidationStatus.checkOutBeforeCheckIn,
        'Check-out date must be after the check-in date.',
      );
    }

    return ValidationResult.valid();
  }

  // Checks if two date intervals [startA, endA) and [startB, endB) overlap.
  // Note: Same-day turnaround (e.g. check-out at 11 AM, check-in at 2 PM) is NOT an overlap.
  static bool doDatesOverlap({
    required DateTime startA,
    required DateTime endA,
    required DateTime startB,
    required DateTime endB,
  }) {
    final normStartA = normalizeDate(startA);
    final normEndA = normalizeDate(endA);
    final normStartB = normalizeDate(startB);
    final normEndB = normalizeDate(endB);

    return normStartA.isBefore(normEndB) && normEndA.isAfter(normStartB);
  }

  // Checks if a room is available for the given date range against existing bookings
  static bool isRoomAvailable({
    required Room room,
    required DateTime checkIn,
    required DateTime checkOut,
    required List<Booking> existingBookings,
  }) {
    final roomBookings = existingBookings.where((b) => b.roomCode == room.code);

    for (final booking in roomBookings) {
      if (doDatesOverlap(
        startA: checkIn,
        endA: checkOut,
        startB: booking.checkIn,
        endB: booking.checkOut,
      )) {
        return false;
      }
    }
    return true;
  }
}
