import 'package:intl/intl.dart';
import 'package:sales_tracker/src/models/sales_record.dart';
import 'package:sales_tracker/src/utils/formatters.dart';

class Report {
  final List<SalesRecord> sales;
  late final int totalItems;
  late final double totalCost;
  late final double totalPrice;
  final Map<DateTime, List<SalesRecord>> groups = {};

  double get profit => totalPrice - totalCost;

  Report(this.sales) {
    sales.sort((a, b) => a.date.compareTo(b.date));

    int items = 0;
    double cost = 0, price = 0;
    for (SalesRecord record in sales) {
      items += record.quantity;
      cost += record.buyingPrice;
      price += record.sellingPrice;
      DateTime group = DateTime(
        record.date.year,
        record.date.month,
        record.date.day,
      );
      groups.putIfAbsent(group, () => []);
      groups[group]!.add(record);
    }

    totalItems = items;
    totalCost = cost;
    totalPrice = price;
  }
}

extension ReportFormat on Report {
  String get totalPriceStr => formatCurrency(totalPrice);

  String get totalCostStr => formatCurrency(totalCost);

  String get profitStr => formatCurrency(profit);

  DateTime get startTime =>
      groups.keys.reduce((a, b) => a.compareTo(b) < 0 ? a : b);

  DateTime get endTime =>
      groups.keys.reduce((a, b) => a.compareTo(b) > 0 ? a : b);

  String get startTimeStr => DateFormat.yMMMd().format(startTime);

  String get endTimeStr => DateFormat.yMMMd().format(endTime);

  String get startTimeMinStr => DateFormat('yyyy-MM-dd').format(startTime);

  String get endTimeMinStr => DateFormat('yyyy-MM-dd').format(endTime);
}
