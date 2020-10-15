import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/response/transaction_list.dart';

class TransactionsProvider extends ChangeNotifier {

  static const String ORDERS_LIST = "transaction/purchases";
  static const String DONATIONS_LIST = "transaction/donations";

  ApiHelper apiHelper = ApiHelper();

  TransactionListResponse ordersList;
  TransactionListResponse donationsList;

  Future<void> loadOrdersList(BuildContext context) async {
    var jsonResponse = await apiHelper.get(context, ORDERS_LIST);
    ordersList = TransactionListResponse.fromJson(jsonResponse);
    notifyListeners();
  }

  Future<void> loadDonationsList(BuildContext context) async {
    var jsonResponse = await apiHelper.get(context, DONATIONS_LIST);
    donationsList = TransactionListResponse.fromJson(jsonResponse);
    notifyListeners();
  }
}