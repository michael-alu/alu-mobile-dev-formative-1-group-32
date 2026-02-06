import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/app_state.dart';
import '../../models/academic_session.dart';
import 'add_edit_session_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Calendar format (Week view by default)
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Helper to get sessions for a specific day
  List<AcademicSession> _getSessionsForDay(
      DateTime day, List<AcademicSession> allSessions) {
    return allSessions.where((session) {
      return isSameDay(session.date, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Get all sessions
        final allSessions = appState.sessions;

        // Get sessions for the currently selected day
        final selectedSessions = _getSessionsForDay(_selectedDay!, allSessions);
        selectedSessions.sort((a, b) =>
            (a.startTime.hour * 60 + a.startTime.minute)
                .compareTo(b.startTime.hour * 60 + b.startTime.minute));

        return Scaffold(
          appBar: AppBar(title: const Text('Schedule')),
          body: Column(
            children: [
              // Weekly Calendar
              TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,

                // Styling
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },

                // Marker builder to show dots on days with events
                eventLoader: (day) {
                  return _getSessionsForDay(day, allSessions);
                },
              ),
              const Divider(),

              // Session List for Selected Day
              Expanded(
                child: selectedSessions.isEmpty
                    ? const Center(child: Text('No sessions for this day.'))
                    : ListView.builder(
                        itemCount: selectedSessions.length,
                        itemBuilder: (context, index) {
                          final session = selectedSessions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            // Color code by type (optional visual flair)
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${session.endTime.hour}:${session.endTime.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              title: Text(session.title),
                              subtitle:
                                  Text('${session.type} • ${session.location}'),
                              trailing: IconButton(
                                icon: Icon(
                                  session.isPresent
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: session.isPresent
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  appState.toggleAttendance(session.id);
                                },
                              ),
                              onTap: () {
                                // Edit Session
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddEditSessionScreen(session: session),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add Session
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditSessionScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
