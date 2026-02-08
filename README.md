# Student Academic Platform

A Flutter application designed to help students manage their academic life, including assignments, schedules, and attendance tracking.

## Team Members & Roles

1.  **Michael (Team Lead)**: Architecture, State Management and Data Models.
2.  **Gloire**: Assignment Management.
3.  **Noel**: Academic Schedule.
4.  **Karabo**: Dashboard & Analytics.
5.  **Fred**: Notifications, Polish, & Documentation.

## Features

- **Dashboard**: View today's classes, upcoming assignments, and your attendance percentage.
- **Assignments**: CRUD operations for assignments.
- **Schedule**: Weekly calendar view of classes. Toggle attendance status.
- **Notifications**: Local reminders 24 hours before an assignment is due.
- **Data Persistence**: Uses `shared_preferences` to save data across app restarts.

## Setup Instructions

1.  **Prerequisites**: Ensure you have Flutter SDK installed (`flutter doctor`).
2.  **Clone the Repo**:
    ```bash
    git clone https://github.com/michael-alu/alu-mobile-dev-formative-1-group-32.git
    cd formative_assignment_1
    ```
3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run the App**:
    ```bash
    flutter run
    ```

## Architecture

- **State Management**: `Provider` pattern. The `AppState` class acts as the single source of truth.
- **Storage**: `StorageService` handles caching data to local storage (JSON).
- **Navigation**: `BottomNavigationBar` in `MainScreen` manages the 3 main tabs.

---
