import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/ad.dart';

class AdsProvider extends ChangeNotifier {
  static const ADS_PUBLIC_URL = "ad/public_list";

  ApiHelper apiHelper = ApiHelper();
  List<Ad> publicAds;

  AdsProvider(){
    loadPublicAds();
  }

  /// Returns true if successfully loaded groups, otherwise throws an exception.
  Future<void> loadPublicAds({bool forceLoad=false}) async {
    if(publicAds != null && !forceLoad) {
      return;
    }

    try {
      var responseJson = await apiHelper.get(null, ADS_PUBLIC_URL);
      publicAds = _parseAds(responseJson);
    } finally {
      notifyListeners();
    }
  }

  List<Ad> _parseAds(dynamic jsonData){
    List<dynamic> jsonList = jsonData['data'];
    List<Ad> objList = [];
    for (dynamic obj in jsonList) {
      try {
        objList.add(Ad.fromJson(obj));
      } catch (e) {}
    }
    return objList;
  }
}
