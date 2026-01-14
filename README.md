# QuickCheck - Attendance Tracker

A simple and intuitive Flutter application for tracking student attendance across multiple classes.

## Features

### 📚 Class Management
- **Create Classes** - Add new classes with custom names and student lists
- **Edit Classes** - Modify class names and update student information
- **Delete Classes** - Remove classes with swipe-to-delete gesture

### 👨‍🎓 Student Management
- Add multiple students to each class
- Edit student names
- Remove students from classes
- View total student count per class

### ✅ Attendance Tracking
- Mark attendance as **Present**, **Absent**, or **Late**
- Select specific dates for attendance records
- Attendance data persists across app sessions
- View and update attendance status with a single tap

### 🔍 Search Functionality
- Search for classes by name
- Search for students by name
- View which class each student belongs to
- Quick navigation to attendance screen from search results

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: StatefulWidget
- **Local Storage**: SharedPreferences
- **Platform Support**: Android, iOS, Web, Windows, macOS, Linux

## Project Structure

```
lib/
├── main.dart
├── data/
│   ├── class_service.dart      # Data persistence & CRUD operations
│   └── ...
├── models/
│   ├── attendance.dart         # Attendance model
│   ├── class.dart              # Class model
│   └── student.dart            # Student model
└── ui/
    └── attendance_tracker/
        ├── home/
        │   ├── main_home.dart           # Main navigation
        │   ├── class_list.dart          # Home screen class list
        │   ├── create_class.dart        # Create new class form
        │   └── attendance_screen.dart   # Mark attendance
        ├── edit/
        │   └── edit_class.dart          # Edit class & students
        └── search screen/
            ├── search_screen.dart       # Search classes & students
            └── history_attendance.dart  # View attendance history
```

## Getting Started

### Prerequisites

- Flutter SDK (^3.10.4)
- Dart SDK
- Android Studio / VS Code with Flutter extension

### Installation

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd flutter_project
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

## Usage

1. **Create a Class**: Tap the `+` button on the home screen to create a new class with students
2. **Take Attendance**: Tap on a class to open the attendance screen, then mark each student's status
3. **View History**: Search for a student and tap their name to see their complete attendance history with summary statistics
4. **Search**: Use the search tab to find classes or students quickly
5. **Edit**: Go to the Edit Class tab to modify class or student information
6. **Delete**: Swipe left on a class in the home screen to delete it

## Validation Rules

- Class names must be more than 4 characters
- Student names must be more than 4 characters
- Names cannot contain numbers

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_svg | ^2.2.3 | SVG image support |
| path_provider | ^2.1.5 | File system paths |
| shared_preferences | ^2.5.4 | Local data persistence |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourBranchName`)
3. Commit your changes (`git commit -m 'Add some YourBranchName'`)
4. Push to the branch (`git push origin feature/YourBranchName`)
5. Open a Pull Request

## License

This project is for educational purposes at Cambodia Academy of Digital Technology (CADT).

## Author

**1. Chessman OL**  
**2. Vorn Naratheany**
Mobile Development - Year 3, Term 1  
Cambodia Academy of Digital Technology

---

Made with ❤️ using Flutter
