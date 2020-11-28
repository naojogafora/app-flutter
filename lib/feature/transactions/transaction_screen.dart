import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/account/profile_view_screen.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class TransactionScreen extends StatefulWidget {
  final Transaction transaction;
  TransactionScreen(this.transaction);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User otherUser;

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    otherUser = authProvider.user.id == widget.transaction.buyer.id
        ? widget.transaction.seller
        : widget.transaction.buyer;

    return Scaffold(
      key: _scaffoldKey,
      appBar: trocadoAppBar("Doação"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          showUserTile(otherUser),
        ],
      ),
    );
  }

  Widget showUserTile(User user) {
    return ListTile(
      title:
          Text(user.fullName, style: const TextStyle(fontSize: 18, color: Style.primaryColorDark)),
      subtitle: Text("Usuário desde " + user.creationDate),
      leading: CircleAvatar(backgroundImage: user.avatarImage),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfileViewScreen(user))),
    );
  }
}
