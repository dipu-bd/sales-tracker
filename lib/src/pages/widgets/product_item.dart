import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sales_tracker/src/blocs/repository.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/pages/widgets/product_form_dialog.dart';
import 'package:sales_tracker/src/pages/widgets/sale_form_dialog.dart';

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
          onLongPress: () => _saleProduct(context),
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
      onTap: () => _saleProduct(context),
    );
  }

  IconSlideAction buildEditAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Update',
      color: Colors.blueAccent,
      icon: Icons.edit,
      onTap: () => ProductFormDialog.display(context, product),
    );
  }

  IconSlideAction buildDeleteAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Delete',
      color: Colors.redAccent,
      icon: Icons.delete,
      onTap: () => _confirmAndDelete(context),
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
            text: product.unitCostStr,
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
      product.costStr,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'monospace',
      ),
    );
  }

  void _saleProduct(BuildContext context) {
    if (product.quantity > 0) {
      SaleFormDialog.display(context, product);
    }
  }

  void _confirmAndDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Repository.of(context).deleteProduct(product.id);
              Navigator.of(context).pop();
            },
            child: Text('YES'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
