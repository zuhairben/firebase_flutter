import 'package:flutter/material.dart';
import 'package:firebase_flutter/models/task_model.dart';
import 'package:firebase_flutter/tasks/task_service.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  EditTaskPage({required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deadlineController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _deadlineController = TextEditingController(text: widget.task.dueDate.toIso8601String().substring(0, 10));
  }

  void _updateTask() async {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        assignedTo: widget.task.assignedTo, // Retain existing assignedTo value
        status: widget.task.status, // Retain existing status
        dueDate: DateTime.parse(_deadlineController.text),
        createdBy: widget.task.createdBy, // Retain existing createdBy value
      );

      await TaskService().updateTask(updatedTask);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task Updated Successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
                validator: (value) => value!.isEmpty ? 'Enter a valid deadline' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _updateTask, child: Text('Update Task')),
            ],
          ),
        ),
      ),
    );
  }
}
