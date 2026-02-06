import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/academic_session.dart';
import '../../services/app_state.dart';

class AddEditSessionScreen extends StatefulWidget {
  final AcademicSession? session; // Null = Add, Not Null = Edit

  const AddEditSessionScreen({super.key, this.session});

  @override
  State<AddEditSessionScreen> createState() => _AddEditSessionScreenState();
}

class _AddEditSessionScreenState extends State<AddEditSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _locationController;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  String _type = 'Class'; // Default type

  final List<String> _sessionTypes = [
    'Class',
    'Mastery Session',
    'Study Group',
    'PSL Meeting'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.session?.title ?? '');
    _locationController =
        TextEditingController(text: widget.session?.location ?? '');

    if (widget.session != null) {
      _selectedDate = widget.session!.date;
      _startTime = widget.session!.startTime;
      _endTime = widget.session!.endTime;
      _type = widget.session!.type;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Pick the date
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Pick time (Reuseable for start and end time)
  Future<void> _pickTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _saveSession() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);

      if (widget.session == null) {
        // Add New
        final newSession = AcademicSession(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          date: _selectedDate,
          startTime: _startTime,
          endTime: _endTime,
          location: _locationController.text,
          type: _type,
        );
        appState.addSession(newSession);
      } else {
        // Update Existing
        appState.deleteSession(widget.session!.id);

        final updatedSession = AcademicSession(
          id: widget.session!.id,
          title: _titleController.text,
          date: _selectedDate,
          startTime: _startTime,
          endTime: _endTime,
          location: _locationController.text,
          type: _type,
          isPresent: widget.session!.isPresent, // Keep attendance status
        );
        appState.addSession(updatedSession);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session == null ? 'New Session' : 'Edit Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Session Title'),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _locationController,
                  decoration:
                      const InputDecoration(labelText: 'Location (Optional)'),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Session Type'),
                  items: _sessionTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) => setState(() => _type = val!),
                ),
                const SizedBox(height: 16),

                // Date & Time Pickers
                ListTile(
                  title: Text(
                      'Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
                ListTile(
                  title: Text('Start Time: ${_startTime.format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _pickTime(true),
                ),
                ListTile(
                  title: Text('End Time: ${_endTime.format(context)}'),
                  trailing: const Icon(Icons.access_time_filled),
                  onTap: () => _pickTime(false),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _saveSession,
                  child: const Text('Save Session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
