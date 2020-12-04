import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/model/transaction_message.dart';
import 'package:trocado_flutter/response/transaction_list.dart';

class TransactionsProvider extends ChangeNotifier {
  static const String ORDERS_LIST = "transaction/purchases";
  static const String DONATIONS_LIST = "transaction/donations";
  static const String SEND_MESSAGE = "transaction/{TRANSACTION_ID}/messages";

  ApiHelper apiHelper = ApiHelper();

  TransactionListResponse ordersList;
  TransactionListResponse donationsList;

  Future<TransactionListResponse> loadOrdersList(BuildContext context, {forceLoad = false}) async {
    if (!forceLoad && ordersList != null) {
      return ordersList;
    }

    var jsonResponse = await apiHelper.get(context, ORDERS_LIST);
    ordersList = TransactionListResponse.fromJson(jsonResponse);
    notifyListeners();
    return ordersList;
  }

  Future<TransactionListResponse> loadDonationsList(BuildContext context,
      {forceLoad = false}) async {
    if (!forceLoad && donationsList != null) {
      return donationsList;
    }

    var jsonResponse = await apiHelper.get(context, DONATIONS_LIST);
    donationsList = TransactionListResponse.fromJson(jsonResponse);
    notifyListeners();
    return donationsList;
  }

  Future<TransactionMessage> submitMessage(BuildContext context, int transactionId, String message) async {
    var response = await apiHelper.post(
        context, SEND_MESSAGE.replaceAll("{TRANSACTION_ID}", transactionId.toString()),
        body: {"message": message});
    TransactionMessage newMessage = TransactionMessage.fromJson(response);
    _addMessageToTransaction(newMessage);
    notifyListeners();
    return newMessage;
  }

  void _addMessageToTransaction(TransactionMessage message){
    if(ordersList != null && ordersList.data != null) {
      for (int i = 0; i < ordersList.data.length; i++) {
        Transaction t = ordersList.data[i];
        if (t.id == message.transactionId) {
          ordersList.data.remove(t);
          t.messages.insert(0, message);
          ordersList.data.insert(i, t);
          return;
        }
      }
    }

    if(donationsList != null && donationsList.data != null) {
      for (int i = 0; i < donationsList.data.length; i++) {
        Transaction t = donationsList.data[i];
        if (t.id == message.transactionId) {
          donationsList.data.remove(t);
          t.messages.insert(0, message);
          donationsList.data.insert(i, t);
          return;
        }
      }
    }
  }
}
