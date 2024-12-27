import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_flutter/bloc/transaction_bloc.dart';
import 'package:firebase_flutter/bloc/transaction_event.dart';
import 'package:firebase_flutter/bloc/transaction_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: BlocProvider(
        create: (context) => TransactionBloc()..add(FetchTransactions()),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TransactionError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is TransactionLoaded) {
              final transactions = state.transactions;
              if (transactions.isEmpty) {
                return const Center(child: Text('No transactions found.'));
              }
              return ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return ListTile(
                    title: Text(transaction.description),
                    subtitle: Text(
                        'Date: ${formatDate(transaction.timestamp)}'),
                    trailing:
                    Text('\$${transaction.amount.toStringAsFixed(2)}'),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.toLocal().toString().split(' ')[0]}';
    }
  }
}
