import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ad_details_screen.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/transactions/transaction_chat_screen.dart';
import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:trocado_flutter/widget/user_tile.dart';

class TransactionScreen extends StatelessWidget {
  final Transaction transaction;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TransactionScreen(this.transaction);

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    User otherUser =
        authProvider.user.id == transaction.buyer.id ? transaction.seller : transaction.buyer;
    bool isBuyer = authProvider.user.id == transaction.buyer.id;

    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar("Transação"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: Text(transaction.advertisement.title,
                style: const TextStyle(color: Style.accentColor, fontSize: 20)),
            subtitle: Text("Descrição: " + transaction.advertisement.description),
            onTap: () => showAd(context),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Solicitado em " + transaction.creationDate,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          transaction.advertisement.firstPhoto != null ? rowHeader(context) : Container(),
          const Divider(height: 18),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(isBuyer ? "Doador:" : "Receptor:", textAlign: TextAlign.left, style: const TextStyle(color: Style.darkText)),
          ),
          UserTile(context: context, user: otherUser),
          ListTile(
            title: const Text("Ver Mensagens", style: TextStyle(color: Style.clearWhite)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Style.clearWhite),
            tileColor: Style.accentColor,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransactionChatScreen(transaction))),
          )
        ],
      ),
    );
  }

  Widget rowHeader(BuildContext context) => GestureDetector(
    child: Column(
          children: [
            Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(
                child: Image.network(
                  transaction.advertisement.firstPhoto.url,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ]),
          ],
        ),
      onTap: () => showAd(context),
  );

  void showAd(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => AdDetailsScreen(transaction.advertisement)));
}
