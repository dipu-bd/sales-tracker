import 'package:uuid/uuid.dart';

class Product {
  final String id;
  final String name;
  final double unitPrice;
  final int quantity;
  final DateTime date;

  double get price => quantity * unitPrice;

  Product({
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.date,
  }) : id = Uuid().v4();

  Product.fromJsonMap(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        unitPrice = data['unit_price'],
        quantity = data['quantity'],
        date = DateTime.fromMillisecondsSinceEpoch(data['date'] ?? 0);

  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['unit_price'] = unitPrice;
    data['quantity'] = quantity;
    data['date'] = date.millisecondsSinceEpoch;
    return data;
  }

  @override
  bool operator ==(Object other) {
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
