import 'package:intl/intl.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/utils/formatters.dart';

class SalesRecord {
  final String? id;
  late final String productId;
  late final String productName;
  late final double unitBuyPrice;
  late final double unitSellPrice;
  late final int quantity;
  late final DateTime date;

  double get buyingPrice => quantity * unitBuyPrice;

  double get sellingPrice => quantity * unitSellPrice;

  double get profit => sellingPrice - buyingPrice;

  double get profitPerUnit => (sellingPrice - buyingPrice) / quantity;

  SalesRecord({
    required Product product,
    required this.unitSellPrice,
    required this.quantity,
    required this.date,
  })  : id = null,
        assert(product.id != null),
        productId = product.id!,
        productName = product.name,
        unitBuyPrice = product.unitPrice;

  SalesRecord.fromJson(String id, Map<String, dynamic> data) : id = id {
    productId = data['product_id'];
    productName = data['product_name'];
    unitBuyPrice = data['buy_price'] ?? 0;
    unitSellPrice = data['sell_price'] ?? 0;
    quantity = data['quantity'] ?? 0;
    date = DateTime.fromMillisecondsSinceEpoch(data['date'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
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
    return other is SalesRecord &&
        other.id == id &&
        other.productName == productName;
  }

  @override
  int get hashCode => [id, productName].hashCode;
}

extension SalesRecordFormat on SalesRecord {
  String get dateStr => DateFormat.yMMMd().format(date);

  String get unitBuyPriceStr => formatCurrency(unitBuyPrice);

  String get unitSellPriceStr => formatCurrency(unitSellPrice);

  String get buyingPriceStr => formatCurrency(buyingPrice);

  String get sellingPriceStr => formatCurrency(sellingPrice);

  String get profitStr => formatCurrency(profit);

  String get profitPerUnitStr => formatCurrency(profitPerUnit);
}
