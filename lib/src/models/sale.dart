import 'package:sales_tracker/src/models/product.dart';
import 'package:uuid/uuid.dart';

class SaleRecord {
  final String id;
  final String productId;
  final String productName;
  final double unitBuyPrice;
  final double unitSellPrice;
  final int quantity;
  final DateTime date;

  double get buyingPrice => quantity * unitBuyPrice;

  double get sellingPrice => quantity * unitSellPrice;

  double get profit => sellingPrice - buyingPrice;

  SaleRecord({
    required Product product,
    required this.unitSellPrice,
    required this.quantity,
    required this.date,
  })  : id = Uuid().v4(),
        productId = product.id,
        productName = product.name,
        unitBuyPrice = product.unitPrice;

  SaleRecord.fromJsonMap(Map<String, dynamic> data)
      : id = data['id'],
        productId = data['product_id'],
        productName = data['product_name'],
        unitBuyPrice = data['buy_price'] ?? 0,
        unitSellPrice = data['sell_price'] ?? 0,
        quantity = data['quantity'] ?? 0,
        date = DateTime.fromMillisecondsSinceEpoch(data['date'] ?? 0);

  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['buy_price'] = unitBuyPrice;
    data['sell_price'] = unitSellPrice;
    data['quantity'] = quantity;
    data['date'] = date.millisecondsSinceEpoch;
    return data;
  }

  @override
  bool operator ==(Object other) {
    return other is SaleRecord && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
