import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sales_tracker/src/models/report.dart';
import 'package:sales_tracker/src/models/sales_record.dart';

Future<Uint8List> generateReport(Report report) async {
  final regularFont = await rootBundle.load('lib/res/RobotoSlab-Regular.ttf');
  final boldFont = await rootBundle.load('lib/res/RobotoSlab-Bold.ttf');

  final pdf = pw.Document(
    compress: true,
    producer: 'Sales Tracker',
    subject: 'Report_${report.startTimeMinStr}_${report.endTimeMinStr}',
    theme: pw.ThemeData.withFont(
      base: pw.Font.ttf(regularFont),
      bold: pw.Font.ttf(boldFont),
      italic: pw.Font.ttf(regularFont),
      boldItalic: pw.Font.ttf(boldFont),
    ),
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(50),
      build: (context) {
        return [
          buildHeader(report),
          buildSalesTable(report),
          pw.Divider(
            height: 20,
            thickness: 1,
            color: PdfColors.grey300,
          ),
          buildSummaryItem('Total Items', '${report.totalItems} ps.'),
          buildSummaryItem('Production Cost', report.totalCostStr),
          buildSummaryItem('Selling Price', report.totalPriceStr),
          pw.Divider(
            height: 20,
            thickness: 1,
            color: PdfColors.grey300,
          ),
          buildSummaryItem('Net Profit', report.profitStr),
        ];
      },
      header: (context) {
        return pw.Container();
      },
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.center,
          padding: pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
              color: PdfColors.grey600,
            ),
          ),
        );
      },
    ),
  );

  Uint8List data = await pdf.save();
  return data;
}

pw.Widget buildSalesTable(Report report) {
  return pw.Table(
    children: [
      pw.TableRow(
        children: [
          buildHeadCell('Date'),
          buildHeadCell('Item Name'),
          buildHeadCell('Quantity'),
          buildHeadCell('Cost'),
          buildHeadCell('Price'),
          buildHeadCell('Profit'),
        ],
        decoration: pw.BoxDecoration(
          color: PdfColors.grey200,
        ),
      ),
      ...report.sales.map(
        (record) => pw.TableRow(
          children: [
            buildItemCell(record.dateStr),
            buildItemCell(record.productName),
            buildItemCell('${record.quantity}'),
            buildItemCell(record.buyingPriceStr),
            buildItemCell(record.sellingPriceStr),
            buildItemCell(record.profitStr),
          ],
        ),
      ),
    ],
  );
}

pw.Widget buildHeader(Report report) {
  return pw.Container(
    padding: pw.EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    margin: pw.EdgeInsets.only(bottom: 20),
    alignment: pw.Alignment.center,
    child: pw.Text(
      'Sales Report (${report.startTimeStr} to ${report.endTimeStr})',
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontSize: 24.0,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget buildHeadCell(String text) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget buildItemCell(String text) {
  return pw.Padding(
    padding: pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
    ),
  );
}

pw.Widget buildSummaryItem(String label, String value) {
  return pw.Container(
    padding: pw.EdgeInsets.all(5),
    alignment: pw.Alignment.centerRight,
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          label,
          textAlign: pw.TextAlign.right,
        ),
        pw.Container(
          width: 100,
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
