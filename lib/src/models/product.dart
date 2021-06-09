import 'package:sales_tracker/src/models/item.dart';
import 'package:sales_tracker/src/utils/formatters.dart';

export 'package:sales_tracker/src/models/item.dart';

class Product extends Item {
  late final String name;
  late final double unitCost;

  double get cost => quantity * unitCost;

  Product({
    required this.name,
    required this.unitCost,
    required int quantity,
    required DateTime date,
  }) : super(
          date: date,
          quantity: quantity,
        );

  Product.fromJson(String id, Map<String, dynamic> data)
      : super.fromJson(id, data) {
    name = data.remove('name');
    unitCost = data.remove('unit_price');
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['name'] = name;
    data['unit_price'] = unitCost;
    return data;
  }
}

extension ProductFormat on Product {
  String get unitCostStr => formatCurrency(unitCost);

  String get costStr => formatCurrency(cost);
}
