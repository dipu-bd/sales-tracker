import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/models/report.dart';
import 'package:sales_tracker/src/utils/formatters.dart';

export 'package:sales_tracker/src/models/report.dart';

class ProductReport extends Report<Product> {
  late final double totalCost;

  ProductReport({
    required DateTime startTime,
    required DateTime endTime,
    required List<Product> products,
  }) : super(
          startTime: startTime,
          endTime: endTime,
          items: products,
        ) {
    double cost = 0;
    for (final item in products) {
      cost += item.cost;
    }
    totalCost = cost;
  }
}

extension ProductReportFormat on ProductReport {
  String get totalCostStr => formatCurrency(totalCost);
}
