import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/app_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date
    final now = DateTime.now();
    // Format it nicely like "Monday, Oct 25"
    final String dateString = DateFormat('EEEE, MMM d').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final double attendance = appState.calculateAttendancePercentage();

          // Filter for Today's Sessions
          final todaySessions = appState.sessions.where((s) {
            return _isSameDay(s.date, now);
          }).toList();
          // Sort by time
          todaySessions.sort((a, b) =>
              (a.startTime.hour * 60 + a.startTime.minute)
                  .compareTo(b.startTime.hour * 60 + b.startTime.minute));

          // Filter for Upcoming Assignments (Next 7 days)
          final upcomingAssignments = appState.assignments.where((a) {
            final difference = a.dueDate.difference(now).inDays;
            return !a.isCompleted && difference >= 0 && difference <= 7;
          }).toList();
          upcomingAssignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Header Section ---
                  Text(
                    'Welcome Back!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Today is $dateString',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),

                  // --- Attendance Card ---
                  Card(
                    color: attendance < 75 ? Colors.red[50] : Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            'Attendance Rate',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${attendance.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color:
                                  attendance < 75 ? Colors.red : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            attendance < 75
                                ? 'Warning! Attendance is below 75%'
                                : 'You are doing great!',
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Today's Classes ---
                  const Text(
                    "Today's Classes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (todaySessions.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No classes today! Enjoy your free time.'),
                      ),
                    )
                  else
                    ...todaySessions.map((session) => Card(
                          child: ListTile(
                            leading:
                                const Icon(Icons.class_, color: Colors.blue),
                            title: Text(session.title),
                            subtitle: Text(
                                '${session.startTime.format(context)} - ${session.location}'),
                            trailing: Icon(
                              session.isPresent
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: session.isPresent
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        )),

                  const SizedBox(height: 24),

                  // --- Upcoming Assignments ---
                  const Text(
                    "Upcoming Assignments",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (upcomingAssignments.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                            'No upcoming assignments. You are all caught up!'),
                      ),
                    )
                  else
                    ...upcomingAssignments.map((assignment) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.assignment,
                                color: Colors.orange),
                            title: Text(assignment.title),
                            subtitle: Text(
                                'Due: ${DateFormat('MMM dd').format(assignment.dueDate)} • ${assignment.courseName}'),
                          ),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
