import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/src/blocs/global_bloc.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/models/report.dart';
import 'package:sales_tracker/src/models/sales_record.dart';

class Repository {
  static Repository of(BuildContext context) =>
      GlobalBloc.of(context).repository;

  final User user;
  late final FirebaseFirestore firestore;
  late final CollectionReference<Product> _products;
  late final CollectionReference<SalesRecord> _sales;

  Repository({required this.user}) {
    firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(user.uid);
    _products = userDoc.collection("products").withConverter<Product>(
          fromFirestore: (snap, _) => Product.fromJson(snap.id, snap.data()!),
          toFirestore: (model, _) => model.toJson(),
        );
    _sales = userDoc.collection("sales").withConverter<SalesRecord>(
          fromFirestore: (snap, _) =>
              SalesRecord.fromJson(snap.id, snap.data()!),
          toFirestore: (model, _) => model.toJson(),
        );
  }

  /// Get all products
  Stream<List<Product>> get allProducts =>
      _products.snapshots().asyncMap(_mapProductResult);

  /// Get products with quantity > 0
  Stream<List<Product>> get nonZeroProducts => _products
      .where('quantity', isGreaterThan: 0)
      .snapshots()
      .asyncMap(_mapProductResult);

  static List<Product> _mapProductResult(QuerySnapshot<Product> event) {
    var result = event.docs.fold<List<Product>>([], (list, snapshot) {
      return list..add(snapshot.data());
    });
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  /// Get list of sales between start and stop dates (inclusive)
  Stream<Report> getSales(DateTime start, DateTime stop) => _sales
      .where(
        'date',
        isGreaterThanOrEqualTo: start.millisecondsSinceEpoch,
        isLessThanOrEqualTo: stop.millisecondsSinceEpoch,
      )
      .snapshots()
      .asyncMap(_mapSalesResult);

  static Report _mapSalesResult(QuerySnapshot<SalesRecord> event) {
    return Report(
      event.docs.fold(
        <SalesRecord>[],
        (list, snapshot) => list..add(snapshot.data()),
      ),
    );
  }

  Future<DocumentReference<Product>> addProduct(Product product) {
    return _products.add(product);
  }

  Future<DocumentSnapshot<Product>> getProduct(String? productId) {
    return _products.doc(productId).get();
  }

  Future<void> deleteProduct(String? productId) {
    return _products.doc(productId).delete();
  }

  Future<void> updateProduct(String? productId, Product updates) {
    return _products.doc(productId).update(updates.toJson());
  }

  Future<DocumentReference<SalesRecord>> addSalesRecord(SalesRecord sales) {
    assert(sales.quantity > 0);
    final doc = _products.doc(sales.productId);
    return doc.get().then((snapshot) {
      final product = snapshot.data()!;
      assert(product.quantity >= sales.quantity);
      doc.update({'quantity': product.quantity - sales.quantity});
      return _sales.add(sales);
    });
  }
}
