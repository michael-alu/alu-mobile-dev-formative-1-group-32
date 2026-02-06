class Assignment {
  String id;
  String title;
  DateTime dueDate;
  String courseName;
  String priority; 
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.courseName,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(), // ISO8601 is a standard format safe for JSON storage
      'courseName': courseName,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate']), // Parse the string back to a valid DateTime object
      courseName: json['courseName'],
      priority: json['priority'],
      isCompleted: json['isCompleted'],
    );
  }
}
