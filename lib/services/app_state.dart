import 'package:flutter/foundation.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';
import 'storage_service.dart';
import 'notification_service.dart'; // Member 5 Import

class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

  List<Assignment> _assignments = [];
  List<AcademicSession> _sessions = [];

  List<Assignment> get assignments => _assignments;
  List<AcademicSession> get sessions => _sessions;

  // Load data from local storage when app starts
  Future<void> loadData() async {
    _assignments = await _storageService.loadAssignments();
    _sessions = await _storageService.loadSessions();
    notifyListeners(); // Notify widgets to rebuild with loaded data
  }

  // --- Assignments ---

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    _saveAssignments();

    // Schedule reminder for 24 hours before due date
    if (!assignment.isCompleted) {
      _notificationService.scheduleNotification(
        id: assignment.id.hashCode,
        title: 'Assignment Due Soon!',
        body: '${assignment.title} is due tomorrow.',
        scheduledDate: assignment.dueDate.subtract(const Duration(hours: 24)),
      );
    }

    notifyListeners();
  }

  void deleteAssignment(String id) {
    _notificationService.cancelNotification(id.hashCode);
    _assignments.removeWhere((element) => element.id == id);
    _saveAssignments();
    notifyListeners();
  }

  void toggleAssignmentCompletion(String id) {
    final index = _assignments.indexWhere((element) => element.id == id);
    if (index != -1) {
      _assignments[index].isCompleted = !_assignments[index].isCompleted;
      _saveAssignments();
      notifyListeners();
    }
  }

  void _saveAssignments() {
    _storageService.saveAssignments(_assignments);
  }

  // --- Sessions ---

  void addSession(AcademicSession session) {
    _sessions.add(session);
    _saveSessions();
    notifyListeners();
  }

  void deleteSession(String id) {
    _sessions.removeWhere((element) => element.id == id);
    _saveSessions();
    notifyListeners();
  }

  void toggleAttendance(String id) {
    final index = _sessions.indexWhere((element) => element.id == id);
    if (index != -1) {
      _sessions[index].isPresent = !_sessions[index].isPresent;
      _saveSessions();
      notifyListeners();
    }
  }

  void _saveSessions() {
    _storageService.saveSessions(_sessions);
  }

  // --- Analytics ---

  double calculateAttendancePercentage() {
    // Only consider sessions that have already occurred
    final pastSessions =
        _sessions.where((s) => s.date.isBefore(DateTime.now())).toList();
    if (pastSessions.isEmpty) return 100.0;

    final attendedCount = pastSessions.where((s) => s.isPresent).length;
    return (attendedCount / pastSessions.length) * 100;
  }
}
