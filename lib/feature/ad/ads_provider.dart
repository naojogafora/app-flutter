import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/response/ads_list.dart';

class AdsProvider extends ChangeNotifier {
  static const ADS_PUBLIC_URL = "ad/public_list";
  static const ADS_USER_URL = "ad/list_self";
  static const ADS_USER_GROUPS_URL = "ad/list_for_user_groups";
  static const ADS_LIST_BY_GROUP = "ad/list_by_group/{GROUP_ID}";
  static const CREATE_AD_URL = "ad";

  ApiHelper apiHelper = ApiHelper();
  AdsListResponse publicAds;
  AdsListResponse groupsAds;
  AdsListResponse userAds;

  AdsProvider(){
    loadPublicAds();
  }

  /// Returns true if successfully loaded groups, otherwise throws an exception.
  Future<AdsListResponse> loadPublicAds({bool forceLoad=false, String query}) async {
    if(publicAds != null && !forceLoad && (query == null || query.isEmpty)) {
      return publicAds;
    }

    String url = ADS_PUBLIC_URL;
    if(query != null && query.isNotEmpty){
      url = url + "?query=" + query;
    }

    AdsListResponse result;

    try {
      var responseJson = await apiHelper.get(null, url);
      result = _parseAdsResponse(responseJson);

      if(query == null || query.isEmpty){
        publicAds = result;
      }

    } finally {
      notifyListeners();
    }

    return result;
  }

  Future<AdsListResponse> loadAvailableAds(BuildContext context, {bool forceLoad = false, String query}) async {
    if(context == null || !Provider.of<AuthenticationProvider>(context, listen: false).isUserLogged){
      return await loadPublicAds(forceLoad: forceLoad, query: query);
    }

    if(groupsAds != null && !forceLoad && (query == null || query.isEmpty)) {
      return groupsAds;
    }

    String _url = ADS_USER_GROUPS_URL;
    if(query != null && query.isNotEmpty){
      _url = _url + "?query=" + query;
    }

    AdsListResponse result;
    try {
      var responseJson = await apiHelper.get(context, _url);
      result = AdsListResponse.fromJson(responseJson);

      if(query == null || query.isEmpty){
        groupsAds = result;
      }
    } finally {
      notifyListeners();
    }

    return result;
  }

  Future<AdsListResponse> loadUserAds(BuildContext context, {bool forceLoad = false}) async {
    if(userAds != null && !forceLoad){
      return userAds;
    }

    try {
      var responseJson = await apiHelper.get(context, ADS_USER_URL);
      userAds = AdsListResponse.fromJson(responseJson);
    } finally {
      notifyListeners();
    }

    return userAds;
  }

  Future<AdsListResponse> loadAdsForGroup(context, int id) async {
    String listByGroupURL = ADS_LIST_BY_GROUP.replaceAll("{GROUP_ID}", id.toString());
    var responseJson = await apiHelper.get(context, listByGroupURL);
    return AdsListResponse.fromJson(responseJson);
  }

  Future<bool> createAd(BuildContext context, Ad ad) async {
    var responseJson = await apiHelper.multipartRequest(context, CREATE_AD_URL, body: ad.toJson(), files: ad.photoFiles);
    print("createAd Response:");
    print(responseJson);
    print("Converted anuncioL");
    Ad adCreated = Ad.fromJson(responseJson);
    print(adCreated);
    return true;
  }

  AdsListResponse _parseAdsResponse(dynamic jsonData){
    return AdsListResponse.fromJson(jsonData);
  }
}
