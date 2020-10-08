import 'package:flutter/material.dart';
import 'package:trocado_flutter/feature/auth/login.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/register.dart';
import 'package:trocado_flutter/feature/home/home_screen.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:trocado_flutter/widget/trocado_drawer.dart';

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
      home: HomeScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/registration': (context) => RegistrationScreen(),
      },
    );
  }
}

