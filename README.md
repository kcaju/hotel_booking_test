# Hotel Room Booking Application (MVC Architecture)

**Developer Skills Assessment for Raintech Software Limited**

A robust, production-grade Hotel Room Booking application built in **Flutter (Dart)** following strict **MVC (Model-View-Controller)** architecture, **Provider** state management, pure **StatelessWidget** UI composition, and **MediaQuery**-based responsive layouts for mobile, tablet, and desktop web.

---

## 🌟 Features & Requirements Implemented

### 1. Room Catalog
- Displays 5 sample rooms (`R101`, `R102`, `R201`, `R202`, `R301`) with prices (₹) and max guest capacity.
- Clean visual cards with pricing badges, capacity, amenities chips, and descriptions.

### 2. Date Selection & Real-Time Calculations
- Check-in and Check-out date pickers with intuitive calendar dialogs.
- Automatic calculation of stay duration (nights) and total price ($nights \times rate$).
- Formats currency in Indian Rupees (INR `₹`).

### 3. Comprehensive Validation & Error Handling
- Checks for missing dates and prompts user action.
- Validates against past check-in dates.
- Rejects same-day check-in/out or checkout before check-in.
- Displays contextual error banners with clear corrective instructions.

### 4. Bonus Features
- **Capacity Filter**: Filter rooms by maximum guest count (All, 2+ Guests, 3+ Guests, 4+ Guests).
- **Double-Booking Prevention**: Checks against hardcoded existing reservations to mark rooms as unavailable for overlapping dates.
- **Mobile Auto-Scroll**: Automatically scrolls smoothly to the booking summary card upon selecting a room on mobile screens.
- **Booking Confirmation**: Interactive confirmation modal with full stay details and reset capability.

---

## 🏛️ Architecture & Folder Structure (MVC Pattern)

```
lib/
├── models/
│   ├── room.dart                   # Room entity (code, name, type, pricePerNight, maxGuests, amenities)
│   └── booking.dart                # Booking record model (id, roomCode, checkIn, checkOut, totalPrice)
│
├── controllers/
│   └── booking_controller.dart     # Business logic & UI state management (Provider / ChangeNotifier)
│
├── services/
│   ├── booking_calculator.dart     # Pure functions: calculateNights, calculateTotalPrice, formatCurrency
│   ├── booking_validator.dart      # Pure functions: date range validation, interval overlap checks
│   └── mock_data.dart              # Hardcoded room catalog & existing bookings
│
├── views/
│   └── bookings/
│       ├── hotel_booking_view.dart # Main responsive booking screen
│       └── widgets/
│           ├── date_picker_section.dart   # Check-in & Check-out date pickers with error banner
│           ├── guest_filter_bar.dart      # Guest capacity filter chips
│           ├── room_card.dart             # Room listing card with availability badges
│           └── booking_summary_card.dart  # Night breakdown, total price & Confirm Booking CTA
│
└── main.dart                       # App entry point & theme configuration
```

---

## 🚀 How to Run the Project

> **Note:** Ensure you are in the project root directory (`hotel_booking_test`) before executing the following commands.

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
# Run on Chrome / Web
flutter run -d chrome

# Or run on mobile emulator / desktop
flutter run
```

### 3. Run Automated Tests
```bash
flutter test
```

### 4. Run Code Analysis
```bash
flutter analyze
```

---

## 🧪 Test Coverage
- **19 unit & widget tests** with a 100% pass rate.
- Tests cover `calculateNights`, `calculateTotalPrice`, `formatCurrency`, `validateBookingDates`, double-booking collision detection, guest filtering, and widget rendering.
- **0 analyzer warnings / errors** (`flutter analyze` clean).

