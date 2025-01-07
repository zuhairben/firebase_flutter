import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/models/task_model.dart';
import 'package:firebase_flutter/tasks/task_service.dart';
import 'package:firebase_flutter/comments/comments_page.dart';

class TeamMemberDashboard extends StatefulWidget {
  const TeamMemberDashboard({super.key});

  @override
  State<TeamMemberDashboard> createState() => _TeamMemberDashboardState();
}

class _TeamMemberDashboardState extends State<TeamMemberDashboard> {
  String? userEmail;
  String? role;
  String selectedFilter = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userEmail = user.email;
          role = snapshot['role'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showError('User not found');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Failed to fetch user details: $e');
    }
  }

  Query getFilteredQuery() {
    if (userEmail == null) {
      return FirebaseFirestore.instance.collection('tasks').where('assignedTo', isEqualTo: '');
    }

    Query tasksQuery = FirebaseFirestore.instance
        .collection('tasks')
        .where('assignedTo', isEqualTo: userEmail);

    if (selectedFilter == 'To Do') {
      tasksQuery = tasksQuery.where('status', isEqualTo: 'To Do');
    } else if (selectedFilter == 'In Progress') {
      tasksQuery = tasksQuery.where('status', isEqualTo: 'In Progress');
    } else if (selectedFilter == 'Complete') {
      tasksQuery = tasksQuery.where('status', isEqualTo: 'Complete');
    }

    return tasksQuery;
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF6264A7);
    final Color secondaryColor = const Color(0xFF8E8CD8);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Team Member Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                ),
              ),
              accountName: Text(role ?? 'Loading...'),
              accountEmail: Text(userEmail ?? 'Loading...'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userEmail != null ? userEmail![0].toUpperCase() : '?',
                  style: TextStyle(fontSize: 24.0, color: primaryColor),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text('Role: ${role ?? "Loading..."}'),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: getFilteredQuery().snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading tasks'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data?.docs.map((doc) {
            return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList() ??
              [];

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final bool isOverdue = task.dueDate.isBefore(DateTime.now());

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isOverdue ? Colors.red : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Description: ${task.description}'),
                      Text('Assigned To: ${task.assignedTo}'),
                      Text(
                        'Due Date: ${task.dueDate.toLocal()}',
                        style: TextStyle(
                          color: isOverdue ? Colors.red : Colors.black,
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
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                TaskService().updateTaskStatus(task.id, newStatus);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment, color: Colors.blueAccent),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
