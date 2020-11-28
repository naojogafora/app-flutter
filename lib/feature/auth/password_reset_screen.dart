import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/response/basic_message_response.dart';
import 'package:trocado_flutter/widget/standard_button.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordResetScreen> {
  bool hasCode = false, busy = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Style.clearWhite,
      appBar: AppBar(title: const Text("Redefinir Senha")),
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
                ]..addAll(!hasCode ? step1() : step2()),
              ),
            )
          ],
        ),
      ),
    );
  }

  void requestCode(bool alreadyHasCode) {
    String email = emailController.text;
    if (email.isEmpty || email.length < 8) {
      handleError("Preencha corretamente o email");
      return;
    }

    if (alreadyHasCode) {
      nextStep();
      return;
    }

    Provider.of<AuthenticationProvider>(context, listen: false)
        .requestPasswordReset(context, email)
        .then((BasicMessageResponse response) {
      handleSuccess(response.message ?? "Código enviado - verifique seu email");
      nextStep();
    }).catchError(handleError);
  }

  void resetPassword() {
    if(busy) return;

    String email = emailController.text;
    String code = codeController.text;
    String password = newPasswordController.text;

    if (code.isEmpty || password.isEmpty) {
      busy = false;
      handleError("Preencha todos os campos");
      return;
    }

    if (password.length < 6) {
      busy = false;
      handleError("A senha deve 6 ou mais caracteres");
      return;
    }

    Provider.of<AuthenticationProvider>(context, listen: false)
        .resetPassword(context, email, code, password)
        .then((BasicMessageResponse response) {
      handleSuccess(response.message ?? "Senha Alterada");
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    }).catchError(handleError);
  }

  void nextStep() {
    setState(() {
      busy = false;
      hasCode = true;
    });
  }

  void handleSuccess(String message) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(message)));
  }

  void handleError(e) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(e.toString())));
    setState(() {busy = false;});
  }

  List<Widget> step1() {
    return [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "Digite seu email abaixo e nós lhe enviaremos um código de segurança que você deverá usar na próxima página.\nCaso já tenha um código, digite seu email e clique no segundo botão.",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      TextField(
        decoration: const InputDecoration(hintText: "Email"),
        textInputAction: TextInputAction.done,
        controller: emailController,
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
      StandardButton(
          "Enviar Código", () => requestCode(false), Style.primaryColorDark, Style.clearWhite),
      StandardButton("Já tem um código? Clique aqui!", () => requestCode(true), Style.accentColor,
          Style.clearWhite),
    ];
  }

  List<Widget> step2() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          emailController.text,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Text(
          "Se o email estiver cadastrado, você receberá um código de segurança dentro de alguns minutos. Digite-o abaixo e, em seguida, sua senha.",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
      TextField(
        decoration: const InputDecoration(hintText: "Código de Segurança"),
        textInputAction: TextInputAction.done,
        controller: codeController,
      ),
      TextField(
        decoration: const InputDecoration(hintText: "Nova Senha"),
        textInputAction: TextInputAction.done,
        controller: newPasswordController,
      ),
      const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
      StandardButton("Redefinir Senha", resetPassword, Style.primaryColorDark, Style.clearWhite),
    ];
  }
}
