import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/app_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
          // Get the attendance percentage from our "Brain" (AppState)
          final double attendance = appState.calculateAttendancePercentage();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // --- Header Section ---
                children: [
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
                  // I used a Card here to make it pop out
                  Card(
                    // Change color based on if attendance is good or bad
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
                              // Red text for warning, Green for good
                              color:
                                  attendance < 75 ? Colors.red : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            attendance < 75
                                ? '⚠️ Warning! Attendance is below 75%'
                                : '✅ You are doing great!',
                            style: const TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
