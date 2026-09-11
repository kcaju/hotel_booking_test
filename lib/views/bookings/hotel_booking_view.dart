import 'package:flutter/material.dart';
import 'package:hotel_booking_test/controllers/booking_controller.dart';
import 'package:provider/provider.dart';

class HotelBookingView extends StatelessWidget {
  const HotelBookingView({super.key});

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
                        // DatePickerSection(
                        //   checkInDate: controller.checkInDate,
                        //   checkOutDate: controller.checkOutDate,
                        //   validationResult: controller.validationResult,
                        //   onCheckInChanged: (date) =>
                        //       controller.setCheckInDate(date),
                        //   onCheckOutChanged: (date) =>
                        //       controller.setCheckOutDate(date),
                        // ),
                        const SizedBox(height: 20),
                        // GuestFilterBar(
                        //   selectedMaxGuests: controller.selectedGuestFilter,
                        //   onFilterChanged: (filter) =>
                        //       controller.setGuestFilter(filter),
                        // ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Text(
                            //   'Available Rooms (${controller.filteredRooms.length})',
                            //   style: theme.textTheme.titleMedium?.copyWith(
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            const Spacer(),
                            // if (controller.selectedRoom != null)
                            //   TextButton(
                            //     onPressed: () => controller.selectRoom(null),
                            //     child: const Text('Clear Selection'),
                            //   ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // ...controller.filteredRooms.map((room) {
                        //   final isAvailable = controller.isRoomAvailable(room);
                        //   return RoomCard(
                        //     room: room,
                        //     isSelected:
                        //         controller.selectedRoom?.code == room.code,
                        //     isAvailable: isAvailable,
                        //     onSelect: () => controller.selectRoom(room),
                        //   );
                        // }),
                      ],
                    ),
                  ),
                ),

                // Right Column: Summary & Booking Action
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    // child: BookingSummaryCard(
                    //   selectedRoom: controller.selectedRoom,
                    //   checkInDate: controller.checkInDate,
                    //   checkOutDate: controller.checkOutDate,
                    //   validationResult: controller.validationResult,
                    //   isRoomAvailable: isSelectedRoomAvailable,
                    //   onBookRoom: () => _confirmBooking(context, controller),
                    // ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              // controller: controller.scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DatePickerSection(
                  //   checkInDate: controller.checkInDate,
                  //   checkOutDate: controller.checkOutDate,
                  //   validationResult: controller.validationResult,
                  //   onCheckInChanged: (date) => controller.setCheckInDate(date),
                  //   onCheckOutChanged: (date) =>
                  //       controller.setCheckOutDate(date),
                  // ),
                  const SizedBox(height: 16),
                  // GuestFilterBar(
                  //   selectedMaxGuests: controller.selectedGuestFilter,
                  //   onFilterChanged: (filter) =>
                  //       controller.setGuestFilter(filter),
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Text(
                      //   'Available Rooms (${controller.filteredRooms.length})',
                      //   style: theme.textTheme.titleMedium?.copyWith(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      const Spacer(),
                      // if (controller.selectedRoom != null)
                      //   TextButton(
                      //     onPressed: () => controller.selectRoom(null),
                      //     child: const Text('Clear Selection'),
                      //   ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // ...controller.filteredRooms.map((room) {
                  //   final isAvailable = controller.isRoomAvailable(room);
                  //   return RoomCard(
                  //     room: room,
                  //     isSelected: controller.selectedRoom?.code == room.code,
                  //     isAvailable: isAvailable,
                  //     onSelect: () => controller.selectRoom(room),
                  //   );
                  // }),
                  const SizedBox(height: 16),
                  // BookingSummaryCard(
                  //   selectedRoom: controller.selectedRoom,
                  //   checkInDate: controller.checkInDate,
                  //   checkOutDate: controller.checkOutDate,
                  //   validationResult: controller.validationResult,
                  //   isRoomAvailable: isSelectedRoomAvailable,
                  //   onBookRoom: () => _confirmBooking(context, controller),
                  // ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
