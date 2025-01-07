import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new task to Firestore
  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).set(task.toMap());
  }

  //update the status of the task assigned
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'status': newStatus, // Ensure only the status is updated
      });
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }


  //Update the task
  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }


  // Fetch all tasks as a stream
  Stream<List<Task>> getTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Fetch all team members from the users collection
  Future<List<Map<String, String>>> getTeamMembers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();

    // Convert Firestore data to a list of maps with string keys and values
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'uid': doc.id,
        'email': data['email'] as String, // Explicitly cast to String
      };
    }).toList();
  }
}
