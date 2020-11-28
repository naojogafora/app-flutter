import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/addresses/address_form_screen.dart';
import 'package:trocado_flutter/feature/addresses/address_list_tile.dart';
import 'package:trocado_flutter/feature/addresses/address_provider.dart';
import 'package:trocado_flutter/model/address.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class AddressesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = context.watch<AddressProvider>();

    return Scaffold(
      appBar: trocadoAppBar("Meus Endereços"),
      body: RefreshIndicator(
        onRefresh: () => addressProvider.loadUserAddresses(context, forceLoad: true),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Style.clearWhite),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddressFormScreen())),
      ),
    );
  }

  Widget buildList(List<Address> addresses) {
    return Expanded(
      child: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (context, i) => AddressListTile(addresses[i]),
      ),
    );
  }
}
