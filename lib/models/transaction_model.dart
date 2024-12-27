

import 'package:cloud_firestore/cloud_firestore.dart';

class AppTransaction {
  final String id;
  final double amount;
  final DateTime timestamp;
  final String description;

  AppTransaction({
    required this.id,
    required this.amount,
    required this.timestamp,
    required this.description,
  });

  factory AppTransaction.fromMap(Map<String, dynamic> map) {
    return AppTransaction(
      id: map['id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      description: map['description'] ?? 'No Description',
    );
  }
}
