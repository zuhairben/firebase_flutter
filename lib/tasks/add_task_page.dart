import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_flutter/models/task_model.dart';
import 'package:firebase_flutter/tasks/task_service.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  String? _assignedToEmail; // Email of selected team member
  List<Map<String, String>> teamMembers = []; // List of team members

  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    try {
      // Fetch users with role "Team Member"
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Team Member') // Filter by role
          .get();

      final members = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'email': doc['email'] as String,
        };
      }).toList();

      setState(() {
        teamMembers = members;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching team members: $error')),
      );
    }
  }

  void _submitTask() async {
    if (_formKey.currentState!.validate()) {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final task = Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          assignedTo: _assignedToEmail ?? '',
          status: 'To Do',
          dueDate: DateTime.parse(_deadlineController.text),
          createdBy: currentUser.email ?? '',
        );

        await TaskService().addTask(task);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task Created Successfully!')),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: const Color(0xFF6264A7), // Teams purple
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                value!.isEmpty ? 'Enter a description' : null,
              ),
              DropdownButtonFormField<String>(
                value: _assignedToEmail,
                decoration: const InputDecoration(labelText: 'Assign To'),
                items: teamMembers.isEmpty
                    ? [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('No team members found'),
                  )
                ]
                    : teamMembers.map((member) {
                  return DropdownMenuItem(
                    value: member['email'],
                    child: Text(member['email']!),
                  );
                }).toList(),
                onChanged: teamMembers.isEmpty
                    ? null
                    : (value) => setState(() => _assignedToEmail = value),
                validator: (value) =>
                value == null ? 'Select a team member' : null,
              ),
              TextFormField(
                controller: _deadlineController,
                decoration: const InputDecoration(
                    labelText: 'Deadline (YYYY-MM-DD)'),
                validator: (value) =>
                value!.isEmpty ? 'Enter a valid deadline' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6264A7),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
