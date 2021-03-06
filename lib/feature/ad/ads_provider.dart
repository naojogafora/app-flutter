import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/transactions/transactions_provider.dart';
import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/model/question.dart';
import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/response/ads_list.dart';

class AdsProvider extends ChangeNotifier {
  static const ADS_PUBLIC_URL = "ad/public_list";
  static const ADS_USER_URL = "ad/list_self";
  static const ADS_USER_GROUPS_URL = "ad/list_for_user_groups";
  static const ADS_LIST_BY_GROUP = "ad/list_by_group/{GROUP_ID}";
  static const CREATE_AD_URL = "ad";
  static const PURCHASE_AD_URL = "ad/{AD_ID}/purchase";
  static const DELETE_URL = "ad/{AD_ID}";
  // QUESTIONS //
  static const CREATE_QUESTION_URL = "ad/{AD_ID}/question";
  static const ANSWER_QUESTION_URL = "ad/{AD_ID}/question/{QUESTION_ID}";

  ApiHelper apiHelper = ApiHelper();
  AdsListResponse publicAds;
  AdsListResponse groupsAds;
  AdsListResponse userAds;
  List<Ad> get availableAds => groupsAds?.data ?? publicAds?.data;

  /// Returns true if successfully loaded groups, otherwise throws an exception.
  Future<AdsListResponse> loadPublicAds(
      {bool forceLoad = false, String query}) async {
    if (publicAds != null && !forceLoad && (query == null || query.isEmpty)) {
      return publicAds;
    }

    String url = ADS_PUBLIC_URL;
    if (query != null && query.isNotEmpty) {
      url = url + "?query=" + query;
    }

    AdsListResponse result;

    try {
      var responseJson = await apiHelper.get(null, url);
      result = _parseAdsResponse(responseJson);
      result.data = sortByDistance(result.data);

      if (query == null || query.isEmpty) {
        publicAds = result;
      }
    } finally {
      notifyListeners();
    }

    return result;
  }

  Future<AdsListResponse> loadAvailableAds(BuildContext context,
      {bool forceLoad = false, String query}) async {
    if (context == null ||
        !Provider.of<AuthenticationProvider>(context, listen: false)
            .isUserLogged) {
      return await loadPublicAds(forceLoad: forceLoad, query: query);
    }

    if (groupsAds != null && !forceLoad && (query == null || query.isEmpty)) {
      return groupsAds;
    }

    String _url = ADS_USER_GROUPS_URL;
    if (query != null && query.isNotEmpty) {
      _url = _url + "?query=" + query;
    }

    AdsListResponse result;
    try {
      var responseJson = await apiHelper.get(context, _url);
      result = AdsListResponse.fromJson(responseJson);
      result.data = sortByDistance(result.data);
      if (query == null || query.isEmpty) {
        groupsAds = result;
      }
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
      result = AdsListResponse();
      groupsAds = result;
    } finally {
      notifyListeners();
    }

    return result;
  }

  Future<AdsListResponse> loadUserAds(BuildContext context,
      {bool forceLoad = false}) async {
    if (userAds != null && !forceLoad) {
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
    String listByGroupURL =
        ADS_LIST_BY_GROUP.replaceAll("{GROUP_ID}", id.toString());
    var responseJson = await apiHelper.get(context, listByGroupURL);
    AdsListResponse result = AdsListResponse.fromJson(responseJson);
    result.data = sortByDistance(result.data);
    return result;
  }

  Future<bool> createAd(BuildContext context, Ad ad) async {
    var responseJson = await apiHelper.multipartRequest(context, CREATE_AD_URL,
        body: ad.toJson(), files: ad.photoFiles);
    print("createAd Response:");
    print(responseJson);
    print("Converted anuncioL");
    Ad adCreated = Ad.fromJson(responseJson);
    userAds.data.insert(0, adCreated);
    notifyListeners();
    return true;
  }

  AdsListResponse _parseAdsResponse(dynamic jsonData) {
    return AdsListResponse.fromJson(jsonData);
  }

  Future<bool> deleteAd(BuildContext context, Ad ad) async {
    await apiHelper.delete(
        context, DELETE_URL.replaceAll("{AD_ID}", ad.id.toString()));
    userAds.data.remove(ad);
    notifyListeners();
    return true;
  }

  Future<Transaction> purchaseAd(BuildContext context, Ad ad) async {
    var response = await apiHelper.post(
        context, PURCHASE_AD_URL.replaceAll("{AD_ID}", ad.id.toString()));
    unawaited(Provider.of<TransactionsProvider>(context, listen: false)
        .loadOrdersList(context, forceLoad: true));
    unawaited(loadAvailableAds(context, forceLoad: true));
    return Transaction.fromJson(response);
  }

  /// The
  Future<Question> answerQuestion(
      BuildContext context, int adId, Question question, String answer) async {
    String _url = ANSWER_QUESTION_URL.replaceAll("{AD_ID}", adId.toString());
    _url = _url.replaceAll("{QUESTION_ID}", question.id.toString());
    var response =
        await apiHelper.post(context, _url, body: {'answer': answer});
    Question nQuestion = Question.fromJson(response);
    replaceQuestionOnAd(adId, nQuestion);
    return nQuestion;
  }

  Future<Question> submitQuestion(
      BuildContext context, int adId, String question) async {
    var response = await apiHelper.post(
      context,
      CREATE_QUESTION_URL.replaceAll("{AD_ID", adId.toString()),
      body: {"question": question},
    );

    Question questionCreated = Question.fromJson(response);
    _addQuestionToAd(questionCreated);
    return questionCreated;
  }

  void _addQuestionToAd(Question question) {
    if (groupsAds != null && groupsAds.data.isNotEmpty) {
      for (int i = 0; i < groupsAds.data.length; i++) {
        Ad ad = groupsAds.data[i];
        if (ad.id == question.advertisementId) {
          groupsAds.data.removeAt(i);
          ad.questions.add(question);
          groupsAds.data.insert(i, ad);
          return;
        }
      }
    }

    if (publicAds != null && publicAds.data.isNotEmpty) {
      for (int i = 0; i < publicAds.data.length; i++) {
        Ad ad = publicAds.data[i];
        if (ad.id == question.advertisementId) {
          publicAds.data.removeAt(i);
          ad.questions.add(question);
          publicAds.data.insert(i, ad);
          return;
        }
      }
    }
  }

  void replaceQuestionOnAd(int adId, Question question) {
    for (int i = 0; i < userAds.data.length; i++) {
      if (userAds.data[i].id == adId) {
        Ad ad = userAds.data[i];
        for (int j = 0; j < ad.questions.length; j++) {
          if (ad.questions[j].id == question.id) {
            ad.questions.removeAt(j);
            ad.questions.insert(j, question);
            userAds.data.removeAt(i);
            userAds.data.insert(i, ad);
            return;
          }
        }
      }
    }
  }

  List<Ad> sortByDistance(List<Ad> ads){
    ads.sort((a1, a2) => a1.distance != null && a2.distance != null && a1.distance > a2.distance ? 1 : -1);
    return ads;
  }
}
