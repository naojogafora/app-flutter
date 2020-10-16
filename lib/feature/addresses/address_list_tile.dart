import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/addresses/address_form_screen.dart';
import 'package:trocado_flutter/feature/addresses/address_provider.dart';
import 'package:trocado_flutter/model/address.dart';

class AddressListTile extends StatelessWidget {
  final Address address;
  AddressListTile(this.address);

  @override
  Widget build(BuildContext context) {
    AddressProvider provider = Provider.of<AddressProvider>(context, listen: false);
    
    return ExpansionTile(
      title: Text(address.title),
      subtitle: Text(
        address.street,
        overflow: TextOverflow.ellipsis,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.topLeft,
      childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text(address.city + "/" + address.state),
        Text("CEP: " + address.zipCode),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                tooltip: "Editar",
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddressFormScreen(address))),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                tooltip: "Apagar",
                // onPressed: () => provider.deleteAddress(context, address), //todo
                onPressed: () => print("todo"), //todo confirmation dialog
              )
            ],
          ),
        ),
      ],
    );
  }
}
