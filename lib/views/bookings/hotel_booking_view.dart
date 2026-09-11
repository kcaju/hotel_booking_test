import 'package:flutter/material.dart';
import 'package:hotel_booking_test/controllers/booking_controller.dart';
import 'package:hotel_booking_test/services/booking_calculator.dart';
import 'package:hotel_booking_test/views/bookings/widgets/booking_summary_card.dart';
import 'package:hotel_booking_test/views/bookings/widgets/date_picker_section.dart';
import 'package:hotel_booking_test/views/bookings/widgets/guest_filter_bar.dart';
import 'package:hotel_booking_test/views/bookings/widgets/room_card.dart';
import 'package:provider/provider.dart';

class HotelBookingView extends StatelessWidget {
  const HotelBookingView({super.key});

  void _confirmBooking(BuildContext context, BookingController controller) {
    final newBooking = controller.confirmBooking();
    if (newBooking == null) return;

    final nights = BookingCalculator.calculateNights(
      controller.checkInDate!,
      controller.checkOutDate!,
    );
    final total = BookingCalculator.calculateTotalPrice(
      nights: nights,
      pricePerNight: controller.selectedRoom!.pricePerNight,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 26),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your reservation for ${controller.selectedRoom!.name} is confirmed.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _dialogRow('Booking ID', newBooking.id),
                  _dialogRow('Room Code', controller.selectedRoom!.code),
                  _dialogRow(
                    'Check-in',
                    BookingCalculator.formatDate(controller.checkInDate!),
                  ),
                  _dialogRow(
                    'Check-out',
                    BookingCalculator.formatDate(controller.checkOutDate!),
                  ),
                  _dialogRow('Duration', '$nights night(s)'),
                  const Divider(height: 16),
                  _dialogRow(
                    'Total Amount',
                    BookingCalculator.formatCurrency(total),
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _dialogRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    final theme = Theme.of(context);
    final isSelectedRoomAvailable =
        controller.selectedRoom == null ||
        controller.isRoomAvailable(controller.selectedRoom!);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Raintech Hotel',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Date picker, Guest Filter, Room List
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DatePickerSection(
                          checkInDate: controller.checkInDate,
                          checkOutDate: controller.checkOutDate,
                          validationResult: controller.validationResult,
                          onCheckInChanged: (date) =>
                              controller.setCheckInDate(date),
                          onCheckOutChanged: (date) =>
                              controller.setCheckOutDate(date),
                        ),
                        const SizedBox(height: 20),
                        GuestFilterBar(
                          selectedMaxGuests: controller.selectedGuestFilter,
                          onFilterChanged: (filter) =>
                              controller.setGuestFilter(filter),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Available Rooms (${controller.filteredRooms.length})',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (controller.selectedRoom != null)
                              TextButton(
                                onPressed: () => controller.selectRoom(null),
                                child: const Text('Clear Selection'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...controller.filteredRooms.map((room) {
                          final isAvailable = controller.isRoomAvailable(room);
                          return RoomCard(
                            room: room,
                            isSelected:
                                controller.selectedRoom?.code == room.code,
                            isAvailable: isAvailable,
                            onSelect: () => controller.selectRoom(room),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Right Column: Summary & Booking Action
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: BookingSummaryCard(
                      selectedRoom: controller.selectedRoom,
                      checkInDate: controller.checkInDate,
                      checkOutDate: controller.checkOutDate,
                      validationResult: controller.validationResult,
                      isRoomAvailable: isSelectedRoomAvailable,
                      onBookRoom: () => _confirmBooking(context, controller),
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DatePickerSection(
                    checkInDate: controller.checkInDate,
                    checkOutDate: controller.checkOutDate,
                    validationResult: controller.validationResult,
                    onCheckInChanged: (date) => controller.setCheckInDate(date),
                    onCheckOutChanged: (date) =>
                        controller.setCheckOutDate(date),
                  ),
                  const SizedBox(height: 16),
                  GuestFilterBar(
                    selectedMaxGuests: controller.selectedGuestFilter,
                    onFilterChanged: (filter) =>
                        controller.setGuestFilter(filter),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Available Rooms (${controller.filteredRooms.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (controller.selectedRoom != null)
                        TextButton(
                          onPressed: () => controller.selectRoom(null),
                          child: const Text('Clear Selection'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...controller.filteredRooms.map((room) {
                    final isAvailable = controller.isRoomAvailable(room);
                    return RoomCard(
                      room: room,
                      isSelected: controller.selectedRoom?.code == room.code,
                      isAvailable: isAvailable,
                      onSelect: () => controller.selectRoom(room),
                    );
                  }),
                  const SizedBox(height: 16),
                  BookingSummaryCard(
                    selectedRoom: controller.selectedRoom,
                    checkInDate: controller.checkInDate,
                    checkOutDate: controller.checkOutDate,
                    validationResult: controller.validationResult,
                    isRoomAvailable: isSelectedRoomAvailable,
                    onBookRoom: () => _confirmBooking(context, controller),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
