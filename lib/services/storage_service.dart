import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assignment.dart';
import '../models/academic_session.dart';

class StorageService {
  static const String _assignmentsKey = 'assignments_data';
  static const String _sessionsKey = 'sessions_data';

  Future<void> saveAssignments(List<Assignment> assignments) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert list of objects -> list of JSON maps -> single JSON string for storage
    final String data = jsonEncode(assignments.map((e) => e.toJson()).toList());
    await prefs.setString(_assignmentsKey, data);
  }

  Future<List<Assignment>> loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_assignmentsKey);
    
    if (data == null) return [];

    // Decode JSON string -> List of dynamic maps -> List of Assignment objects
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => Assignment.fromJson(e)).toList();
  }

  Future<void> saveSessions(List<AcademicSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(sessions.map((e) => e.toJson()).toList());
    await prefs.setString(_sessionsKey, data);
  }

  Future<List<AcademicSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_sessionsKey);
    
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => AcademicSession.fromJson(e)).toList();
  }
}
