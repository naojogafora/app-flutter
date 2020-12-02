import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class TransactionChatScreen extends StatefulWidget {
  final Transaction transaction;
  TransactionChatScreen(this.transaction);

  @override
  _TransactionChatScreenState createState() => _TransactionChatScreenState();
}

class _TransactionChatScreenState extends State<TransactionChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Chat"),
      body: Column(
        children: [
          Text("oiv"),
        ],
      ),
    );
  }
}
