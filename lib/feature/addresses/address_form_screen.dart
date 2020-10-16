import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/address.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class AddressFormScreen extends StatefulWidget {
  final Address address;

  AddressFormScreen(this.address);

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.address != null;

    return Scaffold(
      appBar: trocadoAppBar(isEditing ? "Editar Endereço" : "Novo Endereço"),
      body: Text("Is editing? " + isEditing.toString()),
    );
  }
}
