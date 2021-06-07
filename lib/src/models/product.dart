class Product {
  final String? id;
  late final String name;
  late final double unitPrice;
  late final int quantity;
  late final DateTime date;

  double get price => quantity * unitPrice;

  Product({
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.date,
  }) : id = null;

  Product.fromJson(String id, Map<String, dynamic> data) : id = id {
    name = data['name'];
    unitPrice = data['unit_price'];
    quantity = data['quantity'];
    date = DateTime.fromMillisecondsSinceEpoch(data['date'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
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
