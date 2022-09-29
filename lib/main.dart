import 'package:crudsqlite/debt.dart';
import 'package:crudsqlite/debtors.dart';
import 'package:crudsqlite/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home':(context) => Home(),
      '/debtors':(context) => Debtors(),
      '/debt':(context) => Debts(),
    },
  ));
}

