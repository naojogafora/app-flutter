import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/response/basic_message_response.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class ProfileEditScreen extends StatefulWidget {
  final User user;
  ProfileEditScreen(this.user);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController nameController,
      lastNameController,
      oldPasswordController,
      newPasswordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.user.name);
    lastNameController = TextEditingController(text: widget.user.lastName);
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: trocadoAppBar("Editar Perfil"),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      TextFormField(
                        enabled: false,
                        initialValue: widget.user.email,
                        decoration: const InputDecoration(
                          labelText: "Email (não editável)",
                          icon: Icon(Icons.email),
                        ),
                      ),
                      TextFormField(
                        controller: nameController,
                        validator: (val) => val.isEmpty || val.length < 3
                            ? "Nome deve ter pelo menos 3 caracteres"
                            : null,
                        onEditingComplete: () => setState,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Nome",
                        ),
                      ),
                      TextFormField(
                        controller: lastNameController,
                        validator: (val) => val.isEmpty || val.length < 3
                            ? "Sobrenome deve ter pelo menos 3 caracteres"
                            : null,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Sobrenome",
                        ),
                      ),
                      Divider(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () => submitProfile(context),
                              child:
                                  Text("Salvar Perfil", style: TextStyle(color: Style.clearWhite)),
                              color: Style.primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black54,
                        endIndent: 15,
                        indent: 15,
                        height: 32,
                      ),
                      const Text("Trocar Senha",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      TextFormField(
                        controller: oldPasswordController,
                        validator: (val) => val.isEmpty
                            ? null
                            : (val.length < 6 ? "A senha deve ter pelo menos 6 caracteres" : null),
                        decoration: const InputDecoration(
                          labelText: "Senha Atual",
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      TextFormField(
                        controller: newPasswordController,
                        validator: (val) => val.isEmpty
                            ? null
                            : (val.length < 6 ? "A senha deve ter pelo menos 6 caracteres" : null),
                        decoration: const InputDecoration(
                          labelText: "Nova Senha",
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () => submitPassword(context),
                              child:
                                  Text("Salvar Senha", style: TextStyle(color: Style.clearWhite)),
                              color: Style.primaryColorDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void submitProfile(BuildContext context) async {
    if (nameController.text == null ||
        nameController.text.length < 3 ||
        lastNameController.text == null ||
        lastNameController.text.length < 3) {
      handleError("Preencha corretamente nome e sobrenome");
      return;
    }

    widget.user.name = nameController.text;
    widget.user.lastName = lastNameController.text;

    Provider.of<AuthenticationProvider>(context, listen: false)
        .updateProfile(context, widget.user)
        .then((BasicMessageResponse result) {
      handleSuccess(result.message ?? "Perfil Atualizado");
    }).catchError(handleError);
  }

  void submitPassword(BuildContext context) {
    if (oldPasswordController.text == null ||
        oldPasswordController.text.length < 6 ||
        newPasswordController.text == null ||
        newPasswordController.text.length < 6) {
      handleError("Preencha corretamente as duas senhas");
      return;
    }

    Provider.of<AuthenticationProvider>(context, listen: false)
        .changePassword(context, oldPasswordController.text, newPasswordController.text)
        .then((BasicMessageResponse result) {
      handleSuccess(result.message ?? "Senha alterada");
    }).catchError(handleError);
  }

  void handleSuccess(String message) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(message)));
  }

  void handleError(e) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(e.toString())));
  }
}
