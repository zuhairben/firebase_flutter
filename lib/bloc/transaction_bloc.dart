import 'package:bloc/bloc.dart';
import 'package:firebase_flutter/models/transaction_model.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionLoading()) {
    on<FetchTransactions>(_onFetchTransactions);
  }

  Future<void> _onFetchTransactions(
      FetchTransactions event, Emitter<TransactionState> emit) async {
    try {
      emit(TransactionLoading());
      final querySnapshot =
      await FirebaseFirestore.instance.collection('transactions').get();

      final transactions = querySnapshot.docs
          .map((doc) => AppTransaction.fromMap(doc.data()))
          .toList();

      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
