import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/addresses/address_provider.dart';
import 'package:trocado_flutter/model/address.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class AddressFormScreen extends StatefulWidget {
  final UserAddress existingAddress;

  AddressFormScreen({this.existingAddress});

  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  UserAddress address;
  bool isEditing, loading = false;
  GlobalKey<FormState> formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    isEditing = widget.existingAddress != null;
    this.address = widget.existingAddress == null ? UserAddress() : widget.existingAddress;
  }

  @override
  Widget build(BuildContext context) {
    AddressProvider provider = Provider.of<AddressProvider>(context, listen: false);

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
                padding: const EdgeInsets.all(8),
                children: [
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.title,
                    onSaved: (val) => address.title = val,
                    validator: (val) => val.isEmpty || val.length < 2
                        ? "O Título deve ter no mínimo 3 caracteres"
                        : null,
                    decoration: const InputDecoration(labelText: "Apelido"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.street,
                    onSaved: (val) => address.street = val,
                    validator: (val) =>
                        val.isEmpty || val.length < 7 ? "Mínimo 8 caracteres" : null,
                    decoration: const InputDecoration(labelText: "Rua e Número"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.city,
                    onSaved: (val) => address.city = val,
                    validator: (val) =>
                        val.isEmpty || val.length < 2 ? "Mínimo 3 caracteres" : null,
                    decoration: const InputDecoration(labelText: "Cidade"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.state,
                    onSaved: (val) => address.state = val,
                    validator: (val) =>
                        val.isEmpty || val.length != 2 ? "Deve ter 2 caracteres" : null,
                    decoration: const InputDecoration(labelText: "Estado (Sigla)"),
                  ),
                  TextFormField(
                    maxLines: 1,
                    initialValue: address.zipCode,
                    onSaved: (val) => address.zipCode = val,
                    validator: (String val) {
                      var intVal = int.tryParse(val);
                      if (val.isEmpty || val.length != 8 || intVal == null) {
                        return "CEP deve conter 8 dígitos numéricos";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(labelText: "CEP"),
                  ),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          child: const Text("Salvar"),
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              if (loading) return;
                              setState((){
                                loading = true;
                              });

                              formKey.currentState.save();

                              if (isEditing) {
                                provider
                                    .updateAddress(context, address)
                                    .then((bool success) => successRoutine(success, context))
                                    .catchError(errorRoutine);
                              } else {
                                provider
                                    .saveNewAddress(context, address)
                                    .then((bool success) => successRoutine(success, context))
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

  void successRoutine(bool success, BuildContext context) {
    setState((){
      loading = false;
    });
    Navigator.of(context).pop();
  }

  void errorRoutine(err, st) {
    print(err);
    setState((){
      loading = false;
    });

    if(err is PlatformException){
      _scaffoldKey.currentState
          .showSnackBar(const SnackBar(content: Text("Verifique o endereço digitado"), backgroundColor: Colors.red));
      return;
    }

    debugPrintStack(stackTrace: st);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(err.toString()), backgroundColor: Colors.red));
  }
}
