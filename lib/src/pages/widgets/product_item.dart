import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sales_tracker/src/blocs/repository.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/models/sales_record.dart';

class ProductItemTile extends StatelessWidget {
  final Product product;

  ProductItemTile(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(product.id),
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.18,
      child: Material(
        color: Colors.white,
        elevation: 1,
        child: ListTile(
          title: Text(product.name),
          leading: buildQuantity(),
          subtitle: buildSubtitle(),
          trailing: buildPrice(),
        ),
      ),
      actions: <Widget>[
        buildDeleteAction(context),
        buildEditAction(context),
      ],
      secondaryActions: product.quantity > 0
          ? <Widget>[
              buildSaleAction(context),
            ]
          : null,
    );
  }

  IconSlideAction buildSaleAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Sell',
      color: Colors.teal,
      icon: Icons.add_shopping_cart,
      onTap: () {
        // TODO: sell product
        Repository.of(context).addSalesRecord(
          SalesRecord(
            product: product,
            date: DateTime.now(),
            quantity: Random.secure().nextInt(product.quantity) + 1,
            unitSellPrice: Random.secure().nextDouble() * 10.0 + product.price,
          ),
        );
      },
    );
  }

  IconSlideAction buildEditAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Update',
      color: Colors.blueAccent,
      icon: Icons.edit,
      onTap: () {
        // TODO: update product
        Repository.of(context).updateProduct(
          product.id,
          Product(
            name: product.name,
            date: product.date,
            quantity: Random.secure().nextInt(100),
            unitPrice: Random.secure().nextDouble() * 100.0,
          ),
        );
        // TODO: update product
      },
    );
  }

  IconSlideAction buildDeleteAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Delete',
      color: Colors.redAccent,
      icon: Icons.delete,
      onTap: () {
        Repository.of(context).deleteProduct(product.id);
      },
    );
  }

  CircleAvatar buildQuantity() {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      child: Text(
        '${product.quantity > 99 ? '99+' : product.quantity}',
        style: TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Text buildSubtitle() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Each unit costs '),
          TextSpan(
            text: product.unitPriceStr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Text buildPrice() {
    return Text(
      product.priceStr,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'monospace',
      ),
    );
  }
}
