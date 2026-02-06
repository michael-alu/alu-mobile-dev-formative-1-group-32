import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/app_state.dart';
import 'add_edit_assignment_screen.dart';

class AssignmentListScreen extends StatelessWidget {
  const AssignmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final assignments = appState.assignments;

        // Sort: Earliest due date first
        assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Assignments'),
          ),
          body: assignments.isEmpty
              ? const Center(
                  child: Text('No assignments yet.\nTap + to add one!'),
                )
              : ListView.builder(
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];

                    return Dismissible(
                      // Unique key for the widget
                      key: Key(assignment.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        // Logic to delete
                        appState.deleteAssignment(assignment.id);

                        // User feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('${assignment.title} deleted')),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: assignment.isCompleted,
                            onChanged: (val) {
                              appState
                                  .toggleAssignmentCompletion(assignment.id);
                            },
                          ),
                          title: Text(
                            assignment.title,
                            style: TextStyle(
                              decoration: assignment.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            '${assignment.courseName} • Due ${DateFormat('MM/dd').format(assignment.dueDate)}',
                            style: TextStyle(
                              // Red if overdue and not done
                              color: !assignment.isCompleted &&
                                      assignment.dueDate
                                          .isBefore(DateTime.now())
                                  ? Colors.red
                                  : Colors.black54,
                            ),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Go to Edit Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditAssignmentScreen(
                                    assignment: assignment),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Go to Add Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditAssignmentScreen(),
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
