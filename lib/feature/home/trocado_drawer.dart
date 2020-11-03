import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/my_ads_screen.dart';
import 'package:trocado_flutter/feature/addresses/addresses_screen.dart';
import 'package:trocado_flutter/feature/account/profile_edit_screen.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/group/groups_find_screen.dart';
import 'package:trocado_flutter/feature/transactions/my_donations_screen.dart';
import 'package:trocado_flutter/feature/transactions/my_orders_screen.dart';

class TrocadoDrawer extends StatefulWidget {
  @override
  _TrocadoDrawerState createState() => _TrocadoDrawerState();
}

class _TrocadoDrawerState extends State<TrocadoDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider =
        context.watch<AuthenticationProvider>();

    return Drawer(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              DrawerHeader(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 52,
                      ),
                      minRadius: 48,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
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
                            style: TextStyle(fontSize: 18),
                          )),
                          Padding(padding: EdgeInsets.all(2)),
                          Flexible(
                              child: Text(
                                  authProvider.isUserLogged
                                      ? authProvider.user.email
                                      : "",
                                  style: TextStyle(color: Colors.black54))),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(color: Style.primaryColorDark),
              ),
              ListTile(
                leading: Icon(Icons.search),
                title: Text("Encontrar Grupos"),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => GroupsFindScreen())),
              ),
              authProvider.isUserLogged
                  ? Container()
                  : ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Login/Cadastro"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed("/login");
                      },
                    ),
              authProvider.isUserLogged
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                            title: Text("Transações"),
                            visualDensity: VisualDensity.compact
                        ),
                        ListTile(
                          leading: Icon(Icons.list_alt_outlined),
                          title: Text("Meus Anúncios"),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => MyAdsScreen())),
                        ),
                        ListTile(
                          leading: Icon(Icons.unarchive_outlined),
                          title: Text("Minhas Doações"),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => MyDonationsScreen())),
                        ),
                        ListTile(
                          leading: Icon(Icons.archive_outlined),
                          title: Text("Pedidos"),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyOrdersScreen())),
                        ),
                        ListTile(
                          title: Text("Conta"),
                          visualDensity: VisualDensity.compact
                        ),
                        ListTile(
                          leading: Icon(Icons.directions),
                          title: Text("Endereços"),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddressesScreen())),
                        ),
                        ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text("Editar Perfil"),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileEditScreen())),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        authProvider.isUserLogged
            ? ListTile(
                leading: Icon(Icons.logout),
                title: Text("Sair da Conta"),
                onTap: () {
                  Navigator.of(context).pop();
                  authProvider.logout(context);
                },
              )
            : Container(),
      ]),
    );
  }
}
