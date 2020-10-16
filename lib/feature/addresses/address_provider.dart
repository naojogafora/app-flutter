import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/address.dart';

class AddressProvider extends ChangeNotifier {
  static const String MY_ADDRESSES_URL = "address"; //GET route
  static const String NEW_ADDRESS_URL = "address"; //POST route
  static const String DELETE_ADDRESS_URL = "address/{ADDRESS_ID}"; //DELETE route

  ApiHelper apiHelper = ApiHelper();
  List<Address> userAddresses;

  Future<List<Address>> loadUserAddresses(BuildContext context, { forceLoad = false }) async {
    if(userAddresses != null && !forceLoad)
      return userAddresses;

    var jsonList = await apiHelper.get(context, MY_ADDRESSES_URL);
    userAddresses = [];
    for(dynamic jsonObj in jsonList){
      try{
        userAddresses.add(Address.fromJson(jsonObj));
      } catch(e){}
    }

    return userAddresses;
  }

  /// Returns true if the address was saved, Exception otherwise.
  Future<bool> saveNewAddress(BuildContext context, Address address) async {
    var jsonResponse = await apiHelper.post(context, NEW_ADDRESS_URL, body: address.toJson());
    userAddresses.add(address);
    notifyListeners();
    return true; // If theres no exception, it means all went well.
  }

  Future<bool> deleteAddress(BuildContext context, Address address) async {
    String deleteUrl = DELETE_ADDRESS_URL.replaceAll("{ADDRESS_ID}", address.id.toString());
    var jsonResponse = await apiHelper.delete(context, deleteUrl);
    userAddresses.remove(address);
    notifyListeners();
    return true;
  }
}