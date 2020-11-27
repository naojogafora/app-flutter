import 'package:flutter/material.dart';
                                                                                              import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/account/profile_edit_screen.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/model/user.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class ProfileViewScreen extends StatelessWidget {
  final User user;
  final bool isSelf;
  ProfileViewScreen(this.user, {this.isSelf = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Perfil"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Hero(
                  tag: "user_" + user.id.toString(),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: user.avatarImage,
                  ),
                ),
                const VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: TextStyle(fontSize: 20),
                    ),
                    const Divider(height: 4),
                    Text(user.email),
                    const Divider(height: 4),
                    Text("Membro desde " + user.creationDate),
                  ],
                )
              ],
            ),
            const Divider(
              color: Colors.black54,
              indent: 30,
              endIndent: 30,
              height: 36,
            ),
          ],
        ),
      ),
      floatingActionButton: !this.isSelf
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.edit, color: Style.clearWhite),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileEditScreen(Provider.of<AuthenticationProvider>(context, listen: false).user)),
              ),
            ),
    );
  }
}
