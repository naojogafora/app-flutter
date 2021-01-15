import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/address.dart';
import 'package:trocado_flutter/model/trocado_coordinates.dart';

class AddressProvider extends ChangeNotifier {
  static const String MY_ADDRESSES_URL = "address"; //GET route
  static const String NEW_ADDRESS_URL = "address"; //POST route
  static const String DELETE_ADDRESS_URL = "address/{ADDRESS_ID}"; //DELETE route

  ApiHelper apiHelper = ApiHelper();
  List<UserAddress> userAddresses;

  Future<List<UserAddress>> loadUserAddresses(BuildContext context, {forceLoad = false}) async {
    if (userAddresses != null && !forceLoad) {
      return userAddresses;
    }

    var jsonList = await apiHelper.get(context, MY_ADDRESSES_URL);
    userAddresses = [];
    for (dynamic jsonObj in jsonList) {
      try {
        userAddresses.add(UserAddress.fromJson(jsonObj));
      } catch (_) {}
    }

    return userAddresses;
  }

  /// Returns true if the address was saved, Exception otherwise.
  Future<bool> saveNewAddress(BuildContext context, UserAddress address) async {
    //Get coordinates for the address
    final query = address.street + " - " + address.city;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    address.coordinates = TrocadoCoordinates(lat: first.coordinates.latitude, lng: first.coordinates.longitude);

    dynamic response = await apiHelper.post(context, NEW_ADDRESS_URL, body: address.toJson());
    if (userAddresses == null){
      userAddresses = [];
    }
    userAddresses.add(UserAddress.fromJson(response));
    notifyListeners();
    return true; // If theres no exception, it means all went well.
  }

  Future<bool> deleteAddress(BuildContext context, UserAddress address) async {
    String deleteUrl = DELETE_ADDRESS_URL.replaceAll("{ADDRESS_ID}", address.id.toString());
    await apiHelper.delete(context, deleteUrl);
    userAddresses.remove(address);
    notifyListeners();
    return true;
  }

  Future<bool> updateAddress(BuildContext context, UserAddress address) async {
    // String updateUrl =
    //     DELETE_ADDRESS_URL.replaceAll("{ADDRESS_ID}", address.id.toString()) + "?_method=PUT";
    // await apiHelper.post(context, updateUrl, body: address.toJson());
    // userAddresses.removeWhere((Address element) => element.id == address.id);
    // userAddresses.add(address);
    // notifyListeners();
    // return true;
    // NOT IMPLEMENTEND ON THE SERVER
    return false;
  }
}
