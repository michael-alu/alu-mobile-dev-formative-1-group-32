import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/assignment.dart';
import '../../services/app_state.dart';

class AddEditAssignmentScreen extends StatefulWidget {
  final Assignment?
      assignment; // If null, we are adding. If set, we are editing.

  const AddEditAssignmentScreen({super.key, this.assignment});

  @override
  State<AddEditAssignmentScreen> createState() =>
      _AddEditAssignmentScreenState();
}

class _AddEditAssignmentScreenState extends State<AddEditAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _courseController;

  DateTime _selectedDate = DateTime.now();
  String _priority = 'Medium';

  @override
  void initState() {
    super.initState();
    // Pre-fill data if editing
    _titleController =
        TextEditingController(text: widget.assignment?.title ?? '');
    _courseController =
        TextEditingController(text: widget.assignment?.courseName ?? '');

    if (widget.assignment != null) {
      _selectedDate = widget.assignment!.dueDate;
      _priority = widget.assignment!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAssignment() {
    if (_formKey.currentState!.validate()) {
      // Access AppState to save data
      final appState = Provider.of<AppState>(context, listen: false);

      if (widget.assignment == null) {
        // Create new assignment
        final newAssignment = Assignment(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(), // Simple unique ID
          title: _titleController.text,
          dueDate: _selectedDate,
          courseName: _courseController.text,
          priority: _priority,
        );
        appState.addAssignment(newAssignment);
      } else {
        // Edit existing: Replace old with new
        appState.deleteAssignment(widget.assignment!.id);

        final updatedAssignment = Assignment(
          id: widget.assignment!.id,
          title: _titleController.text,
          dueDate: _selectedDate,
          courseName: _courseController.text,
          priority: _priority,
          isCompleted: widget.assignment!.isCompleted,
        );
        appState.addAssignment(updatedAssignment);
      }

      Navigator.pop(context); // Go back to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.assignment == null ? 'New Assignment' : 'Edit Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration:
                      const InputDecoration(labelText: 'Assignment Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),

                // Course Field
                TextFormField(
                  controller: _courseController,
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a course name' : null,
                ),
                const SizedBox(height: 16),

                // Date Picker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Due: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Change Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Priority Dropdown
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: ['High', 'Medium', 'Low'].map((String priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _priority = val!),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _saveAssignment,
                  child: const Text('Save Assignment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
