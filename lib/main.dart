import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/employees.dart';
import './pages/detail_employee_page.dart';
import './pages/add_employee_page.dart';
import './pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Employees(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          AddEmployee.routeName: (context) => AddEmployee(),
          DetailEmployee.routeName: (context) => DetailEmployee(),
        },
      ),
    );
  }
}
