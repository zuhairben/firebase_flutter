class Task {
  String id;
  String title;
  String description;
  String assignedTo; // Use email for readability
  String status;
  DateTime dueDate;
  String createdBy; // Use email for readability

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  static Task fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      status: map['status'] ?? 'To Do',
      dueDate: DateTime.parse(map['dueDate']),
      createdBy: map['createdBy'] ?? '',
    );
  }
}
