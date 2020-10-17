import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/registration_provider.dart';
import 'package:trocado_flutter/widget/dialog.dart';
import 'package:trocado_flutter/widget/standard_button.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationProvider registerService = RegistrationProvider();

  FocusNode focusLastName = FocusNode();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Image.asset("assets/recycling.png", height: 160, fit: BoxFit.fitHeight),
                  TextField(
                    decoration: InputDecoration(hintText: "Nome"),
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    onSubmitted: (v) =>
                        FocusScope.of(context).requestFocus(focusLastName),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Sobrenome"),
                    textInputAction: TextInputAction.next,
                    controller: lastNameController,
                    focusNode: focusLastName,
                    onSubmitted: (v) =>
                        FocusScope.of(context).requestFocus(focusEmail),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Email"),
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    focusNode: focusEmail,
                    onSubmitted: (v) =>
                        FocusScope.of(context).requestFocus(focusPassword),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Senha", fillColor: Style.primaryColorDark),
                    textInputAction: TextInputAction.send,
                    obscureText: true,
                    controller: passwordController,
                    focusNode: focusPassword,
                    onSubmitted: (v) => register(),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  loading ? Center(child: CircularProgressIndicator()) : StandardButton(
                    "Criar Conta",
                    register,
                    Style.primaryColorDark,
                    Style.clearWhite,
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                  Center(
                    child: GestureDetector(
                        child: Text("Já tem conta? Faça Login!",
                            style: TextStyle(
                                decoration: TextDecoration.underline)),
                        onTap: () => Navigator.of(context).pushReplacementNamed("/login")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void register() {
    loading = true;
    setState(() {});
    String name = nameController.text;
    String lastName = lastNameController.text;
    String email = emailController.value.text;
    String password = passwordController.text;

    registerService.register(context, name, lastName, email, password).then((value) {
      loading = false;
      setState(() {});
      DefaultDialog.show(context, title: "Sucesso!", message: value.toString(), okCallback: () => Navigator.of(context).pop());
    }).catchError((error) {
      loading = false;
      setState(() {});
      DefaultDialog.show(context, title: "Erro!", message: error.toString());
    });
  }
}
