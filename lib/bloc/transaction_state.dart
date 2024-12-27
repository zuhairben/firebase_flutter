import 'package:equatable/equatable.dart';
import 'package:firebase_flutter/models/transaction_model.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<AppTransaction> transactions;

  TransactionLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
