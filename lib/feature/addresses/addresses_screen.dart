import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/addresses/address_form_screen.dart';
import 'package:trocado_flutter/feature/addresses/address_list_tile.dart';
import 'package:trocado_flutter/feature/addresses/address_provider.dart';
import 'package:trocado_flutter/model/address.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  int nAddresses;

  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = context.watch<AddressProvider>();

    return Scaffold(
      appBar: trocadoAppBar("Meus Endereços"),
      body: RefreshIndicator(
        onRefresh: () =>
            addressProvider.loadUserAddresses(context, forceLoad: true),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                  "Você pode cadastrar até 3 endereços. Endereços são usados"
                  " para estimar a distância entre doador e receptor, e"
                  " não são exibidos para ninguém.", textAlign: TextAlign.center),
            ),
            const Divider(),
            FutureBuilder(
              future: addressProvider.loadUserAddresses(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data != null
                      ? buildList(snapshot.data)
                      : const Text("Nada aqui por enquanto :)");
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: nAddresses != null && nAddresses >= 3
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add, color: Style.clearWhite),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddressFormScreen())),
            ),
    );
  }

  Widget buildList(List<UserAddress> addresses) {
    nAddresses = addresses.length;

    return Expanded(
      child: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, i) => AddressListTile(addresses[i]),
      ),
    );
  }
}
