import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pa3/checkProvider.dart';
import 'login.dart';

void main() =>
  runApp(MultiProvider(
      providers:[
        ChangeNotifierProvider(create:(_)=>check_Provider()),
      ],
      child:MyApp()));


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2018313531 OKSEAONE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
    );
  }
}
