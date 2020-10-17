import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/addresses/address_provider.dart';
import 'package:trocado_flutter/model/address.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class AddressFormScreen extends StatefulWidget {
  final Address existingAddress;

  AddressFormScreen({this.existingAddress});

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  Address address;
  bool isEditing, loading = false;
  GlobalKey<FormState> formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    isEditing = widget.existingAddress != null;
    this.address =
        widget.existingAddress == null ? Address() : widget.existingAddress;
  }

  @override
  Widget build(BuildContext context) {
    AddressProvider provider =
        Provider.of<AddressProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar(isEditing ? "Editar Endereço" : "Novo Endereço"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: EdgeInsets.all(8),
                children: [
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.title,
                    onSaved: (val) => address.title = val,
                    validator: (val) => val.isEmpty || val.length < 2
                        ? "O Título deve ter no mínimo 3 caracteres"
                        : null,
                    decoration: InputDecoration(labelText: "Apelido"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.street,
                    onSaved: (val) => address.street = val,
                    validator: (val) => val.isEmpty || val.length < 7
                        ? "Mínimo 8 caracteres"
                        : null,
                    decoration: InputDecoration(labelText: "Rua e Número"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.city,
                    onSaved: (val) => address.city = val,
                    validator: (val) => val.isEmpty || val.length < 2
                        ? "Mínimo 3 caracteres"
                        : null,
                    decoration: InputDecoration(labelText: "Cidade"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.state,
                    onSaved: (val) => address.state = val,
                    validator: (val) => val.isEmpty || val.length < 1
                        ? "Mínimo 2 caracteres"
                        : null,
                    decoration: InputDecoration(labelText: "Estado"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.zipCode,
                    onSaved: (val) => address.zipCode = val,
                    validator: (String val) {
                      var intVal = int.tryParse(val);
                      if (val.isEmpty || val.length != 8 || intVal == null)
                        return "CEP deve conter 8 dígitos numéricos";
                      else
                        return null;
                    },
                    decoration: InputDecoration(labelText: "CEP"),
                  ),
                  loading ? Center(child: CircularProgressIndicator()) : ElevatedButton(
                      child: Text("Salvar"),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          if (loading) return;

                          loading = true;
                          formKey.currentState.save();

                          if (isEditing) {
                            provider
                                .updateAddress(context, address)
                                .then((bool success) =>
                                successRoutine(success, context))
                                .catchError(errorRoutine);
                          } else {
                            provider
                                .saveNewAddress(context, address)
                                .then((bool success) =>
                                successRoutine(success, context))
                                .catchError(errorRoutine);
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void successRoutine(bool success, BuildContext context){
      loading = false;
      setState(() {});
      Navigator.of(context).pop();
  }

  void errorRoutine(err){
    print(err);
    loading = false;
    setState(() {});
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(err.toString()), backgroundColor: Colors.red));
  }
}
