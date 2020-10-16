import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/address.dart';

class AddressListTile extends StatelessWidget {
  final Address address;
  AddressListTile(this.address);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(address.title),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(address.street),
          Text(address.city + "/" + address.state),
        ],
      )
    );
  }
}
