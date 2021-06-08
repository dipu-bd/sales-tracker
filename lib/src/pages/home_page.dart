import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/src/blocs/repository.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/pages/report_page.dart';
import 'package:sales_tracker/src/pages/widgets/product_form_dialog.dart';
import 'package:sales_tracker/src/pages/widgets/error_message.dart';
import 'package:sales_tracker/src/pages/widgets/product_item.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: buildAppBar(context),
      floatingActionButton: buildAddItemButton(context),
      body: StreamBuilder<List<Product>>(
        stream: Repository.of(context).allProducts,
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
                return ErrorMessage(
                  messageText: 'Could not get product list',
                  errorDetails: snapshot.error,
                  onDismiss: () => FirebaseAuth.instance.signOut(),
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
      separatorBuilder: (context, index) => Container(height: 5),
      itemBuilder: (context, index) => ProductItemTile(products[index]),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Sales Tracker"),
      actions: [
        Container(
          height: 26,
          margin: EdgeInsets.all(10),
          child: ElevatedButton.icon(
            onPressed: () {
              ReportPage.display(context);
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
      onPressed: () => ProductFormDialog.display(context),
      child: Icon(Icons.add),
    );
  }
}
