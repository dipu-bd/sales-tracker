import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView.separated(
        itemCount: 10,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
            subtitle: Text('2 items x 40 taka = 80 taka'),
            leading: Icon(Icons.ac_unit),
          );
        },
      ),
      floatingActionButton: buildAddItemButton(),
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
            onPressed: () {},
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

  FloatingActionButton buildAddItemButton() {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.add),
    );
  }
}
