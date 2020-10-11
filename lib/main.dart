import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/auth/login.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/register.dart';
import 'package:trocado_flutter/feature/home/home_screen.dart';

import 'feature/home/groups_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GroupsProvider>(
            create: (_) => GroupsProvider(),
          ),
          ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Trocado',
          theme: Style.main,
          home: HomeScreen(),
          routes: {
            '/home': (context) => HomeScreen(),
            '/login': (context) => LoginScreen(),
            '/registration': (context) => RegistrationScreen(),
          },
        ));
  }
}
