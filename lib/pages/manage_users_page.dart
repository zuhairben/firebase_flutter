import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({Key? key}) : super(key: key);

  final Color _teamsPurple = const Color(0xFF4A69BD);
  final Color _teamsGray = const Color(0xFFF3F2F1);

  Future<List<Map<String, dynamic>>> _fetchTeamMembers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Team Member')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _teamsGray,
      appBar: AppBar(
        backgroundColor: _teamsPurple,
        title: const Text('Manage Team Members', style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchTeamMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading team members'));
          }

          final teamMembers = snapshot.data ?? [];
          return ListView.builder(
            itemCount: teamMembers.length,
            itemBuilder: (context, index) {
              final member = teamMembers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                  title: Text(member['email']),
                  subtitle: const Text('Role: Team Member'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
