import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/models/task_model.dart';
import 'package:firebase_flutter/tasks/task_service.dart';
import 'package:firebase_flutter/tasks/add_task_page.dart';
import 'package:firebase_flutter/tasks/edit_task_page.dart';
import 'package:firebase_flutter/comments/comments_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageTasksPage extends StatefulWidget {
  const ManageTasksPage({super.key});

  @override
  State<ManageTasksPage> createState() => _ManageTasksPageState();
}

class _ManageTasksPageState extends State<ManageTasksPage> {
  String selectedFilter = 'All';
  String selectedSort = 'Deadline Ascending';
  String? adminEmail;

  final Color _teamsPurple = const Color(0xFF4A69BD);
  final Color _teamsGray = const Color(0xFFF3F2F1);

  @override
  void initState() {
    super.initState();
    _fetchAdminEmail();
  }

  Future<void> _fetchAdminEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        adminEmail = user.email;
      });
    }
  }

  Query? getFilteredAndSortedQuery() {
    if (adminEmail == null) return null;

    Query tasksQuery = FirebaseFirestore.instance.collection('tasks');

    // Filter by tasks created by the admin
    tasksQuery = tasksQuery.where('createdBy', isEqualTo: adminEmail);

    // Apply additional filters
    if (selectedFilter == 'To Do') {
      tasksQuery = tasksQuery.where('status', isEqualTo: 'To Do');
    } else if (selectedFilter == 'In Progress') {
      tasksQuery = tasksQuery.where('status', isEqualTo: 'In Progress');
    } else if (selectedFilter == 'Complete') {
      tasksQuery = tasksQuery.where('status', isEqualTo: 'Complete');
    } else if (selectedFilter == 'Overdue') {
      tasksQuery = tasksQuery.where('dueDate', isLessThan: Timestamp.now());
    }

    // Apply sorting
    if (selectedSort == 'Deadline Ascending') {
      tasksQuery = tasksQuery.orderBy('dueDate', descending: false);
    } else if (selectedSort == 'Deadline Descending') {
      tasksQuery = tasksQuery.orderBy('dueDate', descending: true);
    } else if (selectedSort == 'Creation Date') {
      tasksQuery = tasksQuery.orderBy('creationDate', descending: false);
    }

    return tasksQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _teamsGray,
      appBar: AppBar(
        title: const Text('Manage Tasks', style: TextStyle(color: Colors.white),),
        backgroundColor: _teamsPurple,
      ),
      body: adminEmail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Filtering and Sorting Dropdowns
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                value: selectedFilter,
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Tasks')),
                  DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                  DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                  DropdownMenuItem(value: 'Complete', child: Text('Complete')),
                  DropdownMenuItem(value: 'Overdue', child: Text('Overdue')),
                ],
              ),
              DropdownButton<String>(
                value: selectedSort,
                onChanged: (value) {
                  setState(() {
                    selectedSort = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(
                      value: 'Deadline Ascending', child: Text('Deadline Ascending')),
                  DropdownMenuItem(
                      value: 'Deadline Descending', child: Text('Deadline Descending')),
                  DropdownMenuItem(value: 'Creation Date', child: Text('Creation Date')),
                ],
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getFilteredAndSortedQuery()?.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading tasks'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!.docs.map((doc) {
                  return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Description: ${task.description}'),
                            Text('Assigned To: ${task.assignedTo}'),
                            Text(
                              'Due Date: ${task.dueDate.toLocal()}',
                              style: TextStyle(
                                color: task.dueDate.isBefore(DateTime.now())
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownButton<String>(
                                  value: task.status,
                                  items: ['To Do', 'In Progress', 'Complete']
                                      .map((status) {
                                    return DropdownMenuItem(
                                        value: status, child: Text(status));
                                  }).toList(),
                                  onChanged: (newStatus) {
                                    if (newStatus != null) {
                                      TaskService().updateTaskStatus(task.id, newStatus);
                                    }
                                  },
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue,),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditTaskPage(task: task),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.comment, color: Colors.red,),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommentsPage(taskId: task.id),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _teamsPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        icon: const Icon(Icons.add),
        foregroundColor: Colors.white,
        label: const Text('Add Task', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
