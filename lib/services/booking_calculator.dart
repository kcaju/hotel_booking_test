import 'package:intl/intl.dart';

class BookingCalculator {
  // Calculates the number of nights between check-in and check-out
  static int calculateNights(DateTime checkIn, DateTime checkOut) {
    final start = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final end = DateTime(checkOut.year, checkOut.month, checkOut.day);

    final difference = end.difference(start).inDays;
    return difference > 0 ? difference : 0;
  }

  // Calculates the total price for the stay: nights * pricePerNight
  static double calculateTotalPrice({
    required int nights,
    required double pricePerNight,
  }) {
    if (nights <= 0 || pricePerNight <= 0) {
      return 0.0;
    }
    return nights * pricePerNight;
  }

  // Formats currency with INR symbol (₹) and Indian number grouping
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Formats date for clear display
  static String formatDate(DateTime date) {
    return DateFormat('EEE, dd MMM yyyy').format(date);
  }

  // Formats short date
  static String formatShortDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
