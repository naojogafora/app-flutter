import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/request/ads_list.dart';

class AdsProvider extends ChangeNotifier {
  static const ADS_PUBLIC_URL = "ad/public_list";
  static const ADS_LIST_BY_GROUP = "ad/list_by_group/{GROUP_ID}";

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

  Future<AdsListRequest> loadAdsForGroup(context, int id) async{
    String listByGroupURL = ADS_LIST_BY_GROUP.replaceAll("{GROUP_ID}", id.toString());
    var responseJson = await apiHelper.get(context, listByGroupURL);
    return AdsListRequest.fromJson(responseJson);
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
