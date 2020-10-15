import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/response/transaction_list.dart';

class TransactionsProvider extends ChangeNotifier {

  static const String ORDERS_LIST = "transaction/purchases";
  static const String DONATIONS_LIST = "transaction/donations";

  ApiHelper apiHelper = ApiHelper();

  TransactionListResponse ordersList;
  TransactionListResponse donationsList;

  Future<TransactionListResponse> loadOrdersList(BuildContext context, {forceLoad = false}) async {
    if(!forceLoad && ordersList != null){
      return ordersList;
    }

    var jsonResponse = await apiHelper.get(context, ORDERS_LIST);
    ordersList = TransactionListResponse.fromJson(jsonResponse);
    notifyListeners();
    return ordersList;
  }

  Future<TransactionListResponse> loadDonationsList(BuildContext context, {forceLoad = false}) async {
    if(!forceLoad && donationsList != null){
      return donationsList;
    }

    var jsonResponse = await apiHelper.get(context, DONATIONS_LIST);
    donationsList = TransactionListResponse.fromJson(jsonResponse);
    notifyListeners();
    return donationsList;
  }
}