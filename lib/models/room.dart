class Room {
  final String code;
  final String name;
  final String type;
  final double pricePerNight;
  final int maxGuests;
  final String description;
  final List<String> amenities;

  const Room({
    required this.code,
    required this.name,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    this.description = '',
    this.amenities = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Room && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
