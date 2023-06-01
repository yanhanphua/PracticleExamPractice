import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_practice_two/ui/add.dart';
import 'package:test_practice_two/ui/edit.dart';

import '../ui/home.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  

  final _routes = [
    GoRoute(path: "/", builder: (context,state) => const Home()),
    GoRoute(path:"/add",builder:(context,state) => const AddProduct()),
    GoRoute(path:"/edit/:id",name: "id",builder: (context,state) => EditProduct(id:state.pathParameters["id"] ?? ""))
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MaterialApp.router(
        routerConfig: GoRouter(routes: _routes,),
      ),
    );
  }
}
