import 'package:flutter/material.dart';
import 'package:sales_tracker/src/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Text(
          '${product.quantity > 99 ? '99+' : product.quantity}',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Each unit costs '),
            TextSpan(
              text: product.unitPrice.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
            TextSpan(text: '/='),
            TextSpan(text: '\n'),
            TextSpan(text: 'Total cost is '),
            TextSpan(
              text: product.price.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            TextSpan(text: '/= '),
          ],
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          // TODO: open sales record create form
        },
        icon: Icon(Icons.add_shopping_cart_rounded),
      ),
    );
  }
}
