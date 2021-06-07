import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/src/blocs/repository.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/pages/widgets/product_item.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildAddItemButton(context),
      body: StreamBuilder<List<Product>>(
        stream: Repository.of(context).nonZeroProducts,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return ErrorWidget.withDetails(
                  message: 'Could not get product list',
                  error: FlutterError("${snapshot.error}"),
                );
              }
              return buildListView(context, snapshot.requireData);
          }
        },
      ),
    );
  }

  Widget buildListView(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return Container(
        color: Color(0xffe0e0e0),
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Text(
          'Click on the + button below to add new items',
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.separated(
      itemCount: products.length,
      padding: EdgeInsets.only(bottom: 100, top: 15),
      separatorBuilder: (context, index) => Divider(height: 5),
      itemBuilder: (context, index) => ProductItem(products[index]),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Sales Tracker"),
      actions: [
        Container(
          height: 26,
          margin: EdgeInsets.all(10),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: open report page
            },
            icon: Icon(Icons.history),
            label: Text('Report'),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          icon: Icon(Icons.logout),
        ),
      ],
    );
  }

  FloatingActionButton buildAddItemButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // AddProductDialog.display(context); // TODO
        print('adding new product...');
        Repository.of(context).addProduct(
          Product(
            name: 'Dummy #' + (Random.secure().nextInt(1023)).toRadixString(16),
            date: DateTime.now(),
            quantity: Random.secure().nextInt(100),
            unitPrice: Random.secure().nextDouble() * 100.0,
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }
}
