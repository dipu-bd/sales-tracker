import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_tracker/src/blocs/repository.dart';
import 'package:sales_tracker/src/pages/home_page.dart';
import 'package:sales_tracker/src/pages/login_page.dart';

class SalesTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      title: 'Sales Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.idTokenChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget.withDetails(
              message: 'Authentication Failed',
              error: snapshot.error as FlutterError,
            );
          }
          if (snapshot.connectionState != ConnectionState.active) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return LoginPage();
          } else {
            return Repository(
              user: snapshot.data!,
              child: HomePage(),
            );
          }
        },
      ),
    );
  }
}
