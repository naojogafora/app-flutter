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
    if(userAddresses != null && !forceLoad) {
      return userAddresses;
    }

    var jsonList = await apiHelper.get(context, MY_ADDRESSES_URL);
    userAddresses = [];
    for(dynamic jsonObj in jsonList){
      try{
        userAddresses.add(Address.fromJson(jsonObj));
      } catch(_){}
    }

    return userAddresses;
  }

  /// Returns true if the address was saved, Exception otherwise.
  Future<bool> saveNewAddress(BuildContext context, Address address) async {
    await apiHelper.post(context, NEW_ADDRESS_URL, body: address.toJson());
    if(userAddresses == null) userAddresses = [];
    userAddresses.add(address);
    notifyListeners();
    return true; // If theres no exception, it means all went well.
  }

  Future<bool> deleteAddress(BuildContext context, Address address) async {
    String deleteUrl = DELETE_ADDRESS_URL.replaceAll("{ADDRESS_ID}", address.id.toString());
    await apiHelper.delete(context, deleteUrl);
    userAddresses.remove(address);
    notifyListeners();
    return true;
  }

  Future<bool> updateAddress(BuildContext context, Address address) async {
    String updateUrl = DELETE_ADDRESS_URL.replaceAll("{ADDRESS_ID}", address.id.toString()) + "?_method=PUT";
    await apiHelper.post(context, updateUrl, body: address.toJson());
    userAddresses.removeWhere((Address element) => element.id == address.id);
    userAddresses.add(address);
    notifyListeners();
    return true;
  }
}