import 'package:sales_tracker/src/models/item.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/utils/formatters.dart';

export 'package:sales_tracker/src/models/item.dart';

class SalesRecord extends Item {
  late final String productId;
  late final String productName;
  late final double unitBuyPrice;
  late final double unitSellPrice;

  double get buyingPrice => quantity * unitBuyPrice;

  double get sellingPrice => quantity * unitSellPrice;

  double get profit => sellingPrice - buyingPrice;

  double get profitPerUnit => (sellingPrice - buyingPrice) / quantity;

  SalesRecord({
    required Product product,
    required this.unitSellPrice,
    required int quantity,
    required DateTime date,
  })  : assert(product.id != null),
        productId = product.id!,
        productName = product.name,
        unitBuyPrice = product.unitCost,
        super(
          date: date,
          quantity: quantity,
        );

  SalesRecord.fromJson(String id, Map<String, dynamic> data)
      : super.fromJson(id, data) {
    productId = data.remove('product_id');
    productName = data.remove('product_name');
    unitBuyPrice = data.remove('buy_price');
    unitSellPrice = data.remove('sell_price');
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['buy_price'] = unitBuyPrice;
    data['sell_price'] = unitSellPrice;
    return data;
  }
}

extension SalesRecordFormat on SalesRecord {
  String get unitBuyPriceStr => formatCurrency(unitBuyPrice);

  String get unitSellPriceStr => formatCurrency(unitSellPrice);

  String get buyingPriceStr => formatCurrency(buyingPrice);

  String get sellingPriceStr => formatCurrency(sellingPrice);

  String get profitStr => formatCurrency(profit);

  String get profitPerUnitStr => formatCurrency(profitPerUnit);
}
