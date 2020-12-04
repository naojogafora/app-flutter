import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/helpers.dart';
import 'package:trocado_flutter/feature/transactions/transactions_provider.dart';
import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/model/transaction_message.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class TransactionChatScreen extends StatefulWidget {
  final Transaction transaction;
  TransactionChatScreen(this.transaction);

  @override
  _TransactionChatScreenState createState() => _TransactionChatScreenState();
}

class _TransactionChatScreenState extends State<TransactionChatScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController messageController = TextEditingController();
  bool loading = false;
  int selfId;

  @override
  Widget build(BuildContext context) {
    if (selfId == null) {
      selfId = Provider.of<AuthenticationProvider>(context, listen: false).user.id;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar("Chat"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.transaction.messages.length,
              itemBuilder: (context, i) {
                TransactionMessage message = widget.transaction.messages[i];
                return ListTile(
                  leading: message.userId == selfId ? null : getUserAvatar(message.userId),
                  trailing: message.userId != selfId ? null : getUserAvatar(message.userId),
                  title: Text(message.message, textAlign: message.userId == selfId ? TextAlign.right : TextAlign.left),
                  contentPadding: message.userId == selfId
                      ? const EdgeInsets.only(left: 40, right: 8)
                      : const EdgeInsets.only(right: 40, left: 8),
                );
              },
            ),
          ),
          Container(
            color: Style.accentColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 6, bottom: 4, top: 1),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(color: Style.clearWhite),
                      decoration: const InputDecoration(
                        hintText: "Mensagem",
                        hintStyle: TextStyle(color: Style.clearWhite),
                      ),
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  IconButton(
                    icon: loading
                        ? const CircularProgressIndicator(backgroundColor: Style.clearWhite)
                        : const Icon(Icons.send),
                    onPressed: submitMessage,
                    color: Style.clearWhite,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  CircleAvatar getUserAvatar(int messageUserId) {
    if (messageUserId == widget.transaction.seller.id) {
      return CircleAvatar(backgroundImage: widget.transaction.seller.avatarImage);
    } else {
      return CircleAvatar(backgroundImage: widget.transaction.buyer.avatarImage);
    }
  }

  void submitMessage() {
    if (loading) return;
    setState(() => loading = true);

    String message = messageController.text;
    if (message.isEmpty) {
      setState(() => loading = false);
      return;
    }

    Provider.of<TransactionsProvider>(context, listen: false)
        .submitMessage(context, widget.transaction.id, message)
        .then((TransactionMessage sentMessage) {
      setState(() {
        messageController.text = "";
        loading = false;
      });
    }).catchError(handleError);
  }

  void handleError(e) {
    setState(() => loading = false);
    showErrorSnack(_scaffoldKey, e.toString());
  }
}
