import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/pages/manage_tasks_page.dart';
import 'package:firebase_flutter/pages/team_activity_page.dart';
import 'package:firebase_flutter/pages/manage_users_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  String? email;
  String? role;

  final List<Widget> _pages = [
    ManageTasksPage(),
    const ManageUsersPage(),
    TeamActivityPage(),
  ];

  final Color _primaryColor = const Color(0xFF4A69BD);
  final Color _secondaryColor = const Color(0xFF8E8CD8);

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        email = user.email;
        role = snapshot['role'];
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
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
                  colors: [_primaryColor, _secondaryColor],
                ),
              ),
              accountName: Text(role ?? 'Admin'),
              accountEmail: Text(email ?? 'admin@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: _primaryColor,
                  ),
                ),
              ),
            ),
            ...[
              {'icon': Icons.task, 'label': 'Manage Tasks', 'index': 0},
              {'icon': Icons.group, 'label': 'Manage Users', 'index': 1},
              {'icon': Icons.analytics, 'label': 'Team Activity', 'index': 2},
            ].map((item) => ListTile(
              leading: Icon(item['icon'] as IconData, color: Colors.black),
              title: Text(item['label'] as String),
              onTap: () {
                setState(() {
                  _currentIndex = item['index'] as int;
                });
                Navigator.pop(context);
              },
            )),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}
