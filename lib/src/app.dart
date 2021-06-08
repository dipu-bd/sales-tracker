import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/src/blocs/global_bloc.dart';
import 'package:sales_tracker/src/pages/home_page.dart';
import 'package:sales_tracker/src/pages/login_page.dart';

class SalesTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalBloc(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        title: 'Sales Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.data == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
            }
          },
        ),
      ),
    );
  }
}
