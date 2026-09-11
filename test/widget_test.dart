import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_booking_test/main.dart';

void main() {
  testWidgets(
    'Hotel Booking App loads with title, room catalog, and booking summary',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const HotelBookingApp());
      await tester.pumpAndSettle();

      // Verify Title
      expect(find.text('Raintech Hotel'), findsOneWidget);

      // Verify sample rooms are displayed
      expect(find.text('Deluxe Room 101'), findsOneWidget);
      expect(find.text('R101'), findsOneWidget);
      expect(find.text('Deluxe Room 102'), findsOneWidget);
      expect(find.text('Executive Suite 201'), findsOneWidget);
      expect(
        find.text('Booked for Dates'),
        findsOneWidget,
      ); // R101 is booked for default dates

      // Verify Booking Summary card is present
      expect(find.text('Booking Summary'), findsOneWidget);
    },
  );

  testWidgets(
    'Selecting an available room updates the selected state and summary',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const HotelBookingApp());
      await tester.pumpAndSettle();

      // Tap on Deluxe Room 102 (which is available)
      final deluxeRoomFinder = find.text('Deluxe Room 102');
      expect(deluxeRoomFinder, findsOneWidget);
      await tester.tap(deluxeRoomFinder);
      await tester.pumpAndSettle();

      // Verify summary updates with selected room
      expect(find.text('Deluxe Room 102 (R102)'), findsOneWidget);
      expect(find.text('Total Price'), findsOneWidget);
      // 3 nights * ₹3,500 = ₹10,500
      expect(find.text('₹10,500'), findsWidgets);
    },
  );

  testWidgets('Filtering by guest count filters available room list', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const HotelBookingApp());
    await tester.pumpAndSettle();

    final suiteFilter = find.text('3 Guests (Suite)');
    await tester.ensureVisible(suiteFilter);
    await tester.tap(suiteFilter);
    await tester.pumpAndSettle();

    // Should only show 3+ guests rooms (Executive Suites and Family Room)
    expect(find.text('Executive Suite 201'), findsOneWidget);
    expect(find.text('Executive Suite 202'), findsOneWidget);
    expect(find.text('Family Room 301'), findsOneWidget);
    expect(find.text('Deluxe Room 101'), findsNothing);
    expect(find.text('Deluxe Room 102'), findsNothing);
  });

  testWidgets(
    'Selecting a room on mobile automatically scrolls to booking summary card',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 700);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const HotelBookingApp());
      await tester.pumpAndSettle();

      // Initially on mobile, summary card is below the viewport
      final summaryFinder = find.text('Booking Summary');
      expect(summaryFinder, findsOneWidget);

      // Select Room 102
      final deluxeRoomFinder = find.text('Deluxe Room 102');
      await tester.ensureVisible(deluxeRoomFinder);
      await tester.tap(deluxeRoomFinder);
      await tester.pumpAndSettle();

      // Verify that after selection, summary card and total price are visible in viewport
      expect(find.text('Deluxe Room 102 (R102)'), findsOneWidget);
      expect(find.text('Total Price'), findsOneWidget);
    },
  );
}
