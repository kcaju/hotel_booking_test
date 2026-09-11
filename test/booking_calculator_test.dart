import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking_test/models/booking.dart';
import 'package:hotel_booking_test/models/room.dart';
import 'package:hotel_booking_test/services/booking_calculator.dart';
import 'package:hotel_booking_test/services/booking_validator.dart';
import 'package:hotel_booking_test/services/mock_data.dart';

void main() {
  group('BookingCalculator Tests', () {
    test('calculateNights correctly calculates difference in days', () {
      final checkIn = DateTime(2026, 10, 1);
      final checkOut = DateTime(2026, 10, 5);

      final nights = BookingCalculator.calculateNights(checkIn, checkOut);
      expect(nights, 4);
    });

    test('calculateNights returns 1 for consecutive days', () {
      final checkIn = DateTime(2026, 12, 31);
      final checkOut = DateTime(2027, 1, 1);

      final nights = BookingCalculator.calculateNights(checkIn, checkOut);
      expect(nights, 1);
    });

    test('calculateNights returns 0 for same-day or reverse dates', () {
      final date = DateTime(2026, 5, 10);
      expect(BookingCalculator.calculateNights(date, date), 0);

      final checkIn = DateTime(2026, 5, 15);
      final checkOut = DateTime(2026, 5, 10);
      expect(BookingCalculator.calculateNights(checkIn, checkOut), 0);
    });

    test('calculateTotalPrice computes nights * rate correctly', () {
      // Deluxe Room (₹3,500) for 3 nights
      expect(
        BookingCalculator.calculateTotalPrice(nights: 3, pricePerNight: 3500.0),
        10500.0,
      );

      // Executive Suite (₹5,800) for 2 nights
      expect(
        BookingCalculator.calculateTotalPrice(nights: 2, pricePerNight: 5800.0),
        11600.0,
      );

      // Family Room (₹4,200) for 5 nights
      expect(
        BookingCalculator.calculateTotalPrice(nights: 5, pricePerNight: 4200.0),
        21000.0,
      );

      // 0 nights
      expect(
        BookingCalculator.calculateTotalPrice(nights: 0, pricePerNight: 3500.0),
        0.0,
      );
    });

    test('formatCurrency formats Indian Rupee correctly', () {
      final formatted = BookingCalculator.formatCurrency(3500.0);
      expect(formatted.contains('3,500'), isTrue);
      expect(formatted.contains('₹'), isTrue);
    });
  });

  group('BookingValidator Tests', () {
    final fixedToday = DateTime(2026, 9, 11);

    test('returns valid result for future date range', () {
      final checkIn = DateTime(2026, 9, 15);
      final checkOut = DateTime(2026, 9, 18);

      final result = BookingValidator.validateDates(
        checkIn: checkIn,
        checkOut: checkOut,
        referenceDate: fixedToday,
      );

      expect(result.isValid, isTrue);
      expect(result.status, ValidationStatus.valid);
      expect(result.errorMessage, isNull);
    });

    test('returns valid result when check-in is today', () {
      final checkIn = DateTime(2026, 9, 11, 14, 30); // 2:30 PM today
      final checkOut = DateTime(2026, 9, 13);

      final result = BookingValidator.validateDates(
        checkIn: checkIn,
        checkOut: checkOut,
        referenceDate: fixedToday,
      );

      expect(result.isValid, isTrue);
    });

    test('flags missing dates when either date is null', () {
      final r1 = BookingValidator.validateDates(
        checkIn: null,
        checkOut: null,
        referenceDate: fixedToday,
      );
      expect(r1.isValid, isFalse);
      expect(r1.status, ValidationStatus.missingDates);

      final r2 = BookingValidator.validateDates(
        checkIn: DateTime(2026, 9, 15),
        checkOut: null,
        referenceDate: fixedToday,
      );
      expect(r2.isValid, isFalse);
      expect(r2.status, ValidationStatus.missingDates);
    });

    test('flags past check-in dates as invalid', () {
      final pastDate = DateTime(
        2026,
        9,
        10,
      ); // Yesterday relative to 2026-09-11
      final checkOut = DateTime(2026, 9, 15);

      final result = BookingValidator.validateDates(
        checkIn: pastDate,
        checkOut: checkOut,
        referenceDate: fixedToday,
      );

      expect(result.isValid, isFalse);
      expect(result.status, ValidationStatus.pastCheckIn);
      expect(result.errorMessage, contains('cannot be in the past'));
    });

    test('flags same-day check-in and check-out as invalid', () {
      final sameDay = DateTime(2026, 9, 20);

      final result = BookingValidator.validateDates(
        checkIn: sameDay,
        checkOut: sameDay,
        referenceDate: fixedToday,
      );

      expect(result.isValid, isFalse);
      expect(result.status, ValidationStatus.sameDayCheckout);
      expect(result.errorMessage, contains('minimum stay is 1 night'));
    });

    test('flags check-out before check-in as invalid', () {
      final checkIn = DateTime(2026, 9, 25);
      final checkOut = DateTime(2026, 9, 20);

      final result = BookingValidator.validateDates(
        checkIn: checkIn,
        checkOut: checkOut,
        referenceDate: fixedToday,
      );

      expect(result.isValid, isFalse);
      expect(result.status, ValidationStatus.checkOutBeforeCheckIn);
    });
  });

  group('Room Availability & Overlap Tests (Bonus)', () {
    const testRoom = Room(
      code: 'R101',
      name: 'Deluxe Room 101',
      type: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
    );

    final existingBookings = [
      Booking(
        id: 'B1',
        roomCode: 'R101',
        checkIn: DateTime(2026, 10, 10),
        checkOut: DateTime(2026, 10, 15),
      ),
    ];

    test('room is unavailable when dates overlap existing booking', () {
      // Overlap case 1: exact match
      final isAvail1 = BookingValidator.isRoomAvailable(
        room: testRoom,
        checkIn: DateTime(2026, 10, 10),
        checkOut: DateTime(2026, 10, 15),
        existingBookings: existingBookings,
      );
      expect(isAvail1, isFalse);

      // Overlap case 2: falls completely inside
      final isAvail2 = BookingValidator.isRoomAvailable(
        room: testRoom,
        checkIn: DateTime(2026, 10, 11),
        checkOut: DateTime(2026, 10, 13),
        existingBookings: existingBookings,
      );
      expect(isAvail2, isFalse);

      // Overlap case 3: spans across boundary
      final isAvail3 = BookingValidator.isRoomAvailable(
        room: testRoom,
        checkIn: DateTime(2026, 10, 8),
        checkOut: DateTime(2026, 10, 12),
        existingBookings: existingBookings,
      );
      expect(isAvail3, isFalse);
    });

    test('room is available for non-overlapping dates', () {
      // Prior to existing booking
      final isAvailBefore = BookingValidator.isRoomAvailable(
        room: testRoom,
        checkIn: DateTime(2026, 10, 1),
        checkOut: DateTime(2026, 10, 5),
        existingBookings: existingBookings,
      );
      expect(isAvailBefore, isTrue);

      // After existing booking
      final isAvailAfter = BookingValidator.isRoomAvailable(
        room: testRoom,
        checkIn: DateTime(2026, 10, 20),
        checkOut: DateTime(2026, 10, 25),
        existingBookings: existingBookings,
      );
      expect(isAvailAfter, isTrue);
    });

    test(
      'adjacent booking (check-in on another booking check-out date) is available',
      () {
        // Check-in on 15th when existing booking checks out on 15th
        final isAvailAdjacent = BookingValidator.isRoomAvailable(
          room: testRoom,
          checkIn: DateTime(2026, 10, 15),
          checkOut: DateTime(2026, 10, 18),
          existingBookings: existingBookings,
        );
        expect(isAvailAdjacent, isTrue);

        // Check-out on 10th when existing booking checks in on 10th
        final isAvailAdjacentBefore = BookingValidator.isRoomAvailable(
          room: testRoom,
          checkIn: DateTime(2026, 10, 5),
          checkOut: DateTime(2026, 10, 10),
          existingBookings: existingBookings,
        );
        expect(isAvailAdjacentBefore, isTrue);
      },
    );
  });

  group('Sample Room Dataset Verification', () {
    test('sample room dataset contains all required rooms', () {
      final rooms = MockData.sampleRooms;
      expect(rooms.length, 5);

      final r101 = rooms.firstWhere((r) => r.code == 'R101');
      expect(r101.type, 'Deluxe Room');
      expect(r101.pricePerNight, 3500.0);
      expect(r101.maxGuests, 2);

      final r102 = rooms.firstWhere((r) => r.code == 'R102');
      expect(r102.type, 'Deluxe Room');
      expect(r102.pricePerNight, 3500.0);
      expect(r102.maxGuests, 2);

      final r201 = rooms.firstWhere((r) => r.code == 'R201');
      expect(r201.type, 'Executive Suite');
      expect(r201.pricePerNight, 5800.0);
      expect(r201.maxGuests, 3);

      final r202 = rooms.firstWhere((r) => r.code == 'R202');
      expect(r202.type, 'Executive Suite');
      expect(r202.pricePerNight, 5800.0);
      expect(r202.maxGuests, 3);

      final r301 = rooms.firstWhere((r) => r.code == 'R301');
      expect(r301.type, 'Family Room');
      expect(r301.pricePerNight, 4200.0);
      expect(r301.maxGuests, 4);
    });
  });
}
