import 'package:flutter/material.dart';
import 'package:hotel_booking_test/models/booking.dart';
import 'package:hotel_booking_test/models/room.dart';
import 'package:hotel_booking_test/services/booking_calculator.dart';
import 'package:hotel_booking_test/services/booking_validator.dart';
import 'package:hotel_booking_test/services/mock_data.dart';

class BookingController extends ChangeNotifier {
  final List<Room> _rooms = MockData.sampleRooms;
  final List<Booking> _existingBookings = MockData.getSampleExistingBookings();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  Room? _selectedRoom;
  int? _selectedGuestFilter;

  BookingController() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _checkInDate = today.add(const Duration(days: 1));
    _checkOutDate = today.add(const Duration(days: 4));
  }

  List<Room> get rooms => _rooms;
  List<Booking> get existingBookings => _existingBookings;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  Room? get selectedRoom => _selectedRoom;
  int? get selectedGuestFilter => _selectedGuestFilter;

  ValidationResult get validationResult {
    return BookingValidator.validateDates(
      checkIn: _checkInDate,
      checkOut: _checkOutDate,
    );
  }

  bool isRoomAvailable(Room room) {
    if (_checkInDate == null ||
        _checkOutDate == null ||
        !validationResult.isValid) {
      return true;
    }
    return BookingValidator.isRoomAvailable(
      room: room,
      checkIn: _checkInDate!,
      checkOut: _checkOutDate!,
      existingBookings: _existingBookings,
    );
  }

  List<Room> get filteredRooms {
    if (_selectedGuestFilter == null) {
      return _rooms;
    }
    return _rooms
        .where((room) => room.maxGuests >= _selectedGuestFilter!)
        .toList();
  }

  void setCheckInDate(DateTime? date) {
    _checkInDate = date;
    notifyListeners();
  }

  void setCheckOutDate(DateTime? date) {
    _checkOutDate = date;
    notifyListeners();
  }

  void setGuestFilter(int? filter) {
    _selectedGuestFilter = filter;
    notifyListeners();
  }

  final ScrollController scrollController = ScrollController();

  void selectRoom(Room? room) {
    _selectedRoom = room;
    notifyListeners();

    if (room != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Booking? confirmBooking() {
    if (_selectedRoom == null ||
        _checkInDate == null ||
        _checkOutDate == null ||
        !validationResult.isValid) {
      return null;
    }

    final nights = BookingCalculator.calculateNights(
      _checkInDate!,
      _checkOutDate!,
    );
    final total = BookingCalculator.calculateTotalPrice(
      nights: nights,
      pricePerNight: _selectedRoom!.pricePerNight,
    );

    final newBooking = Booking(
      id: 'BKG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      roomCode: _selectedRoom!.code,
      checkIn: _checkInDate!,
      checkOut: _checkOutDate!,
      guestName: 'Guest User',
      totalPrice: total,
    );

    _existingBookings.add(newBooking);
    notifyListeners();
    return newBooking;
  }
}
