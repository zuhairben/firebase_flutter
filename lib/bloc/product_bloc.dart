import 'package:bloc/bloc.dart';
import 'package:firebase_flutter/models/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoading()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading());

      final querySnapshot =
      await FirebaseFirestore.instance.collection('products').get();

      final products = querySnapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();

      if (products.isEmpty) {
        emit(ProductEmpty());
      } else {
        emit(ProductLoaded(products));
      }
    } catch (e) {
      emit(ProductError('Failed to fetch products: $e'));
    }
  }
}
