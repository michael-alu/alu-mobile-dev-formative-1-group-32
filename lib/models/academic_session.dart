import 'package:flutter/material.dart';

class AcademicSession {
  String id;
  String title;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String location;
  String type; 
  bool isPresent;

  AcademicSession({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    required this.type,
    this.isPresent = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      // TimeOfDay isn't directly serializable, so we store it as "HH:mm" string
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'location': location,
      'type': type,
      'isPresent': isPresent,
    };
  }

  factory AcademicSession.fromJson(Map<String, dynamic> json) {
    // We need to parse "HH:mm" string back into integer components for TimeOfDay
    final startParts = (json['startTime'] as String).split(':');
    final endParts = (json['endTime'] as String).split(':');

    return AcademicSession(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1])),
      endTime: TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1])),
      location: json['location'],
      type: json['type'],
      isPresent: json['isPresent'],
    );
  }
}
