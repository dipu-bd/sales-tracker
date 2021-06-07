import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sales_tracker/src/models/product.dart';

class ProductsModel with ChangeNotifier, DiagnosticableTreeMixin {
  Set<Product> _products = {};

  List<Product> get products => List.unmodifiable(_products);

  void save(Product product) {
    _products.remove(product);
    _products.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    _products.remove(product);
  }

  void loadList() {

  }

  void saveList() {

  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('product_count', _products.length));
  }
}
