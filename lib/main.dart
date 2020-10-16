import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/addresses/address_provider.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/auth/authentication_screen.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/registraton_screen.dart';
import 'package:trocado_flutter/feature/home/home_screen.dart';

import 'feature/ad/ads_provider.dart';
import 'feature/group/groups_provider.dart';
import 'feature/transactions/transactions_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(),
          ),
          ChangeNotifierProvider<AdsProvider>(
            create: (_) => AdsProvider(),
          ),
          ChangeNotifierProvider<GroupsProvider>(
            create: (_) => GroupsProvider(),
          ),
          ChangeNotifierProvider<TransactionsProvider>(
            create: (_) => TransactionsProvider(),
          ),
          ChangeNotifierProvider<AddressProvider>(
            create: (_) => AddressProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Trocado',
          theme: Style.main,
          home: HomeScreen(),
          routes: {
            '/home': (context) => HomeScreen(),
            '/login': (context) => AuthenticationScreen(),
            '/registration': (context) => RegistrationScreen(),
          },
        ));
  }
}
