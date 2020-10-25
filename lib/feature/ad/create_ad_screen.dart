import 'package:flutter/material.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class CreateAdScreen extends StatefulWidget {
  @override
  _CreateAdScreenState createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Novo Anúncio"),
      body: Text("Novo anuncio form"),
    );
  }
}
