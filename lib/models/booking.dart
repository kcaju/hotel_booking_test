class Booking {
  final String id;
  final String roomCode;
  final DateTime checkIn;
  final DateTime checkOut;
  final String guestName;
  final double totalPrice;

  const Booking({
    required this.id,
    required this.roomCode,
    required this.checkIn,
    required this.checkOut,
    this.guestName = 'Guest',
    this.totalPrice = 0.0,
  });
}
