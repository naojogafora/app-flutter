import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/about.dart';
import 'package:trocado_flutter/feature/account/profile_view_screen.dart';
import 'package:trocado_flutter/feature/ad/my_ads_screen.dart';
import 'package:trocado_flutter/feature/addresses/addresses_screen.dart';
import 'package:trocado_flutter/feature/account/profile_edit_screen.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/blog/blog_list_screen.dart';
import 'package:trocado_flutter/feature/transactions/my_donations_screen.dart';
import 'package:trocado_flutter/feature/transactions/my_orders_screen.dart';
import 'package:trocado_flutter/model/user.dart';

class TrocadoDrawer extends StatefulWidget {
  @override
  _TrocadoDrawerState createState() => _TrocadoDrawerState();
}

class _TrocadoDrawerState extends State<TrocadoDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider = context.watch<AuthenticationProvider>();

    return Drawer(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              DrawerHeader(
                child: GestureDetector(
                  onTap: () => authProvider.isUserLogged
                      ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileViewScreen(authProvider.user, isSelf: true)))
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "user_" + authProvider.user?.id.toString(),
                        child: CircleAvatar(
                          backgroundImage:
                              authProvider.user?.avatarImage ?? User.profileImagePlaceholder,
                          minRadius: 48,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Text(
                              authProvider.isUserLogged
                                  ? "${authProvider.user.name} ${authProvider.user.lastName}"
                                  : "Visitante",
                              style: const TextStyle(fontSize: 18),
                            )),
                            const Padding(padding: EdgeInsets.all(2)),
                            Flexible(
                                child: Text(
                                    authProvider.isUserLogged ? authProvider.user.email : "",
                                    style: const TextStyle(color: Colors.black54))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                decoration: const BoxDecoration(color: Style.primaryColor),
              ),
              authProvider.isUserLogged
                  ? Container()
                  : ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Login/Cadastro"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/login");
                      },
                    ),
              authProvider.isUserLogged
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ListTile(
                            title: Text("Transações"), visualDensity: VisualDensity.compact),
                        ListTile(
                          leading: const Icon(Icons.list_alt_outlined),
                          title: const Text("Meus Anúncios"),
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => MyAdsScreen())),
                        ),
                        ListTile(
                          leading: const Icon(Icons.unarchive_outlined),
                          title: const Text("Minhas Doações"),
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => MyDonationsScreen())),
                        ),
                        ListTile(
                          leading: const Icon(Icons.archive_outlined),
                          title: const Text("Meus Pedidos"),
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => MyOrdersScreen())),
                        ),
                        const ListTile(title: Text("Conta"), visualDensity: VisualDensity.compact),
                        ListTile(
                          leading: const Icon(Icons.directions),
                          title: const Text("Endereços"),
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => AddressesScreen())),
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_box),
                          title: const Text("Editar Perfil"),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileEditScreen(
                                  Provider.of<AuthenticationProvider>(context, listen: false)
                                      .user))),
                        ),
                        const ListTile(
                            title: Text("Utilidades"), visualDensity: VisualDensity.compact),
                        ListTile(
                          leading: const Icon(Icons.article_outlined),
                          title: const Text("Blog"),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlogListScreen())),
                        ),
                        ListTile(
                          leading: const Icon(Icons.help_center_outlined),
                          title: const Text("Sobre"),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AboutScreen())),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        const Divider(height: 0),
        authProvider.isUserLogged
            ? ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Sair"),
                onTap: () {
                  authProvider.logout();
                  Phoenix.rebirth(context);
                },
              )
            : Container(),
      ]),
    );
  }
}
