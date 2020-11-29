import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/account/profile_view_screen.dart';
import 'package:trocado_flutter/model/user.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    Key key,
    @required this.context,
    @required this.user,
  }) : super(key: key);

  final BuildContext context;
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
      Text(user.fullName, style: const TextStyle(fontSize: 18, color: Style.primaryColorDark)),
      subtitle: Text("Usuário desde " + user.creationDate),
      leading: Hero(
          child: CircleAvatar(backgroundImage: user.avatarImage),
          tag: "user_" + user.id.toString()),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfileViewScreen(user))),
    );
  }
}