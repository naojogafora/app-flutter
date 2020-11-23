import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/group/groups_provider.dart';
import 'package:trocado_flutter/model/group.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/widget/checkbox_form_field.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class GroupConfigurationFormScreen extends StatefulWidget {
  final Group group;

  /// existingGroup is optional. If present, the form will be for editing an existing group.
  /// If not present or null, the form will creat a new group.
  GroupConfigurationFormScreen(this.group);

  @override
  _GroupConfigurationFormScreenState createState() => _GroupConfigurationFormScreenState();
}

class _GroupConfigurationFormScreenState extends State<GroupConfigurationFormScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider provider = Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar("Configurações do Grupo"),
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
                    decoration:
                        InputDecoration(labelText: "Nome do Grupo", icon: Icon(Icons.short_text)),
                    onSaved: (String val) => widget.group.name = val,
                    initialValue: widget.group.name,
                    validator: (val) =>
                        val.isEmpty || val.length < 5 ? "Deve ter no mínimo 5 caracteres" : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Descrição", icon: Icon(Icons.description_outlined)),
                    onSaved: (String val) => widget.group.description = val,
                    initialValue: widget.group.description,
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
                        Text("Grupo Privado?"),
                      ],
                    ),
                    initialValue: widget.group.private,
                    onSaved: (bool val) => widget.group.private = val,
                    onChanged: (bool val) => setState(() => widget.group.private = val),
                  ),
                  widget.group.private
                      ? TextFormField(
                          decoration: InputDecoration(
                              labelText: "Código de Convite", icon: Icon(Icons.vpn_key)),
                          onSaved: (String val) => widget.group.inviteCode = val,
                          initialValue: widget.group.inviteCode,
                          validator: (val) => val.isNotEmpty &&
                                  (val.length < 4 || val.length > 64 || val.contains(" "))
                              ? "Deve ter de 4 a 64 caracteres, sem espaços."
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLines: 1,
                        )
                      : Container(),
                  widget.group.owner.id == provider.user.id
                      ? DropDownFormField(
                          titleText: "Dono do Grupo",
                          dataSource: widget.group.moderators
                              .map((User u) => {"fullname": u.fullName, "id": u.id})
                              .toList(),
                          value: widget.group.owner.id,
                          textField: "fullname",
                          valueField: "id",
                          onSaved: (id) {
                            setState(() {
                              widget.group.owner.id = id;
                            });
                          },
                          onChanged: (id) {
                            setState(() {
                              widget.group.owner.id = id;
                            });
                          },
                        )
                      : Container(),
                  MaterialButton(
                    child: loading
                        ? CircularProgressIndicator()
                        : const Text("Salvar", style: TextStyle(color: Style.clearWhite)),
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

  Future submit() async {
    if (loading) return;
    setState(() => loading = true);

    if (!_formKey.currentState.validate()) {
      showErrorSnack("Preencha os campos corretamente");
      return;
    }

    _formKey.currentState.save();

    Provider.of<GroupsProvider>(context, listen: false)
        .saveGroupConfiguration(context, widget.group)
        .then((Group group) {
      showSuccessSnack("Configurações Atualizadas");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }).catchError((e, st) {
      print(st);
      debugPrintStack(stackTrace: st, maxFrames: 30);
      showErrorSnack(e.toString());
    });
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
