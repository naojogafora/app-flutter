import 'package:flutter/material.dart';
import 'package:trocado_flutter/feature/auth/login.dart';
import 'package:trocado_flutter/config/base_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trocado',
      theme: Style.main,
      home: Login(),
    );
  }
}
