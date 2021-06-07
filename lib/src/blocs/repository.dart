import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/models/sale.dart';

class Repository extends InheritedWidget with DiagnosticableTreeMixin {
  final User user;
  late final FirebaseFirestore firestore;
  late final CollectionReference<Map<String, dynamic>> _products;
  late final CollectionReference<Map<String, dynamic>> _sales;

  Repository({
    Key? key,
    required this.user,
    required Widget child,
  }) : super(key: key, child: child) {
    firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(user.uid);
    _products = userDoc.collection("products");
    _sales = userDoc.collection("sales");
    print('>>>>>>>>>> ' + _products.path);
  }

  static Repository of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<Repository>()!;

  // Stream<List<Product>> get allProducts =>
  //     _products.snapshots().asyncMap((event) {
  //       return event.docs.fold<List<Product>>([], (list, doc) {
  //         return list..add(Product.fromJson(doc.id, doc.data()));
  //       });
  //     });

  /// Get products with quantity > 0
  Stream<List<Product>> get nonZeroProducts => _products
          .where('quantity', isGreaterThan: 0)
          .snapshots()
          .asyncMap((event) {
        var result = event.docs.fold<List<Product>>([], (list, doc) {
          return list..add(Product.fromJson(doc.id, doc.data()));
        });
        result.sort((a, b) => a.date.compareTo(b.date));
        return result;
      });

  /// Get list of sales between start and stop dates (inclusive)
  Stream<List<SalesRecord>> getSales(DateTime start, DateTime stop) => _sales
          .where(
            'date',
            isGreaterThanOrEqualTo: start.millisecondsSinceEpoch,
            isLessThanOrEqualTo: stop.millisecondsSinceEpoch,
          )
          .snapshots()
          .asyncMap((event) {
        return event.docs.fold<List<SalesRecord>>([], (list, doc) {
          return list..add(SalesRecord.fromJson(doc.id, doc.data()));
        });
      });

  Future addProduct(Product product) async {
    return _products.add(product.toJson());
  }

  Future addSalesRecord(SalesRecord sales) async {
    return _sales.add(sales.toJson());
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget old) {
    return old is Repository && old.user.uid != user.uid;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('user_id', user.uid));
    properties.add(StringProperty('user_email', user.email));
    properties.add(StringProperty('user_name', user.displayName));
  }
}
