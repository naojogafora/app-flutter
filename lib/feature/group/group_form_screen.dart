import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/widget/checkbox_form_field.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class GroupFormScreen extends StatefulWidget {
  final Group existingGroup;

  /// existingGroup is optional. If present, the form will be for editing an existing group.
  /// If not present or null, the form will creat a new group.
  GroupFormScreen({this.existingGroup});

  @override
  _GroupFormScreenState createState() => _GroupFormScreenState();
}

class _GroupFormScreenState extends State<GroupFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Group group;
  bool editing = false, loading = false;

  @override
  void initState() {
    super.initState();
    group = widget.existingGroup ?? Group();

    if (widget.existingGroup != null) {
      editing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar(editing ? "Editar Grupo" : "Novo Grupo"),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Nome do Grupo", icon: Icon(Icons.short_text)),
                    onSaved: (String val) => group.name = val,
                    validator: (val) =>
                        val.isEmpty || val.length < 5 ? "Deve ter no mínimo 5 caracteres" : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Descrição", icon: Icon(Icons.description_outlined)),
                    onSaved: (String val) => group.description = val,
                    validator: (val) =>
                        val.isEmpty || val.length < 20 ? "Deve ter no mínimo 20 caracteres" : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    minLines: 3,
                    maxLines: 6,
                  ),
                  CheckboxFormField(
                    title: Row(
                      children: [
                        const Icon(Icons.lock_outline, color: Colors.black54),
                        const VerticalDivider(),
                        const Text("Grupo Privado?"),
                      ],
                    ),
                    initialValue: false,
                    onSaved: (bool val) => group.private = val,
                  ),
                  Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text("(Atenção: Título e Descrição são sempre públicos e podem ser encontrados na busca. Os anúncios serão privados, e os usuários deverão solicitar entrada)", textAlign: TextAlign.center,)),
                  MaterialButton(
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Criar Grupo", style: TextStyle(color: Style.clearWhite)),
                    onPressed: submit,
                    color: Style.primaryColorDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    if (loading) return;
    setState(() => loading = true);

    GroupsProvider provider = Provider.of<GroupsProvider>(context, listen: false);

    if (!_formKey.currentState.validate()) {
      showErrorSnack("Preencha os campos corretamente");
      return;
    }

    _formKey.currentState.save();
    if (editing) {
      //TODO Salvar edição do grupo
    } else {
      provider.createGroup(context, group).then((Group group) {
        showSuccessSnack("Grupo criado");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      }).catchError((e) => showErrorSnack(e.toString()));
    }
  }

  void showErrorSnack(String message) {
    setState(() {
      loading = false;
    });
    print(message);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void showSuccessSnack(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }
}
