import 'package:flutter/material.dart';
import 'package:hotel_booking_test/controllers/booking_controller.dart';
import 'package:hotel_booking_test/views/bookings/hotel_booking_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingController(),
      child: MaterialApp(
        title: 'Hotel Room Booking - Raintech Assessment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E56A0),
            brightness: Brightness.light,
          ),
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const HotelBookingView(),
      ),
    );
  }
}
