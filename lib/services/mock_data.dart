import 'package:hotel_booking_test/models/booking.dart';
import 'package:hotel_booking_test/models/room.dart';

class MockData {
  // Hardcoded 5 sample rooms from the coding assessment
  static const List<Room> sampleRooms = [
    Room(
      code: 'R101',
      name: 'Deluxe Room 101',
      type: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
      description:
          'Cozy and modern room with city view, king-size bed, and fast Wi-Fi.',
      amenities: ['King Bed', 'Free Wi-Fi', 'Air Conditioning', 'Ensuite Bath'],
    ),
    Room(
      code: 'R102',
      name: 'Deluxe Room 102',
      type: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
      description:
          'Comfortable deluxe room with garden view, premium bedding, and work desk.',
      amenities: ['Queen Bed', 'Free Wi-Fi', 'Garden View', 'Mini Bar'],
    ),
    Room(
      code: 'R201',
      name: 'Executive Suite 201',
      type: 'Executive Suite',
      pricePerNight: 5800.0,
      maxGuests: 3,
      description:
          'Spacious suite featuring a separate living area, balcony, and luxury bath.',
      amenities: ['King + Sofa Bed', 'Balcony', 'Free Breakfast', 'Smart TV'],
    ),
    Room(
      code: 'R202',
      name: 'Executive Suite 202',
      type: 'Executive Suite',
      pricePerNight: 5800.0,
      maxGuests: 3,
      description:
          'Premium executive suite with panoramic views, lounge access, and espresso bar.',
      amenities: [
        'King + Sofa Bed',
        'Lounge Access',
        'Espresso Bar',
        'Jacuzzi',
      ],
    ),
    Room(
      code: 'R301',
      name: 'Family Room 301',
      type: 'Family Room',
      pricePerNight: 4200.0,
      maxGuests: 4,
      description:
          'Large family-friendly room equipped with two queen beds and dining table.',
      amenities: [
        '2 Queen Beds',
        'Family Dining Area',
        'Kids Play Corner',
        'Free Breakfast',
      ],
    ),
  ];

  // Hardcoded existing bookings to test the double-booking prevention bonus feature
  static List<Booking> getSampleExistingBookings() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      Booking(
        id: 'BKG-001',
        roomCode: 'R101',
        checkIn: today.add(const Duration(days: 1)),
        checkOut: today.add(const Duration(days: 3)),
        guestName: 'John Doe',
        totalPrice: 7000.0,
      ),
      Booking(
        id: 'BKG-002',
        roomCode: 'R201',
        checkIn: today.add(const Duration(days: 5)),
        checkOut: today.add(const Duration(days: 7)),
        guestName: 'Sarah Smith',
        totalPrice: 11600.0,
      ),
    ];
  }
}
