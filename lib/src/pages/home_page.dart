import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/src/blocs/repository.dart';
import 'package:sales_tracker/src/models/product.dart';
import 'package:sales_tracker/src/pages/report_page.dart';
import 'package:sales_tracker/src/pages/widgets/error_message.dart';
import 'package:sales_tracker/src/pages/widgets/home_page_drawer.dart';
import 'package:sales_tracker/src/pages/widgets/product_form_dialog.dart';
import 'package:sales_tracker/src/pages/widgets/product_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: buildAppBar(context),
      floatingActionButton: buildAddItemButton(context),
      drawer: Drawer(
        child: HomePageDrawer(),
      ),
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
              return ProductListView(snapshot.requireData);
          }
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Sales Tracker"),
      actions: [
        ElevatedButton.icon(
          onPressed: () => ReportPage.display(context),
          icon: Icon(Icons.history),
          label: Text('Report'),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
          ),
        ),
        // IconButton(
        //   onPressed: () => FirebaseAuth.instance.signOut(),
        //   icon: Icon(Icons.logout),
        // ),
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
