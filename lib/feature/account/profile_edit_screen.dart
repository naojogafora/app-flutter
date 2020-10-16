import 'package:flutter/material.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class ProfileEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Editar Perfil"),
    );
  }
}
