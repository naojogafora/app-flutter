import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/auth/password_reset_screen.dart';
import 'package:trocado_flutter/feature/helpers.dart';
import 'package:trocado_flutter/widget/standard_button.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode focusPassword = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Style.clearWhite,
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                    decoration: const InputDecoration(hintText: "Email"),
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    onSubmitted: (v) => FocusScope.of(context).requestFocus(focusPassword),
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Senha"),
                    textInputAction: TextInputAction.send,
                    obscureText: true,
                    controller: passwordController,
                    focusNode: focusPassword,
                    onSubmitted: (v) => login(),
                  ),
                  const Divider(height: 6),
                  GestureDetector(
                    child: const Align(
                      child: Text(
                        "Esqueci a senha",
                        style: TextStyle(
                          color: Style.primaryColorDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      alignment: Alignment.centerRight,
                    ),
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => PasswordResetScreen())),
                  ),
                  const Divider(height: 6),
                  MaterialButton(child: loading ? const CircularProgressIndicator() : const Text("Entrar"), onPressed: login, color: Style.primaryColorDark, textColor: Style.clearWhite, padding: const EdgeInsets.all(14),),
                  const Divider(height: 6),
                  Center(
                    child: GestureDetector(
                        child: const Text("Nao tem conta? Crie uma agora!",
                            style: TextStyle(decoration: TextDecoration.underline)),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed("/registration");
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void login() {
    if(loading) return;
    setState(() {
      loading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    Provider.of<AuthenticationProvider>(context, listen: false)
        .login(context, email, password)
        .then((bool success) {
      if (success) {
        Phoenix.rebirth(context);
      }
    }).catchError((e){
      showErrorSnack(_scaffoldKey, e.toString());
      setState(() {
        loading = false;
      });
    });
  }
}
