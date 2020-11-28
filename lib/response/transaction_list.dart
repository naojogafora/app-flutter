import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/response/paginated_list.dart';

class TransactionListResponse {
  PaginatedList paginatedList;
  List<Transaction> data;

  TransactionListResponse.fromJson(Map<String, dynamic> json) {
    this.paginatedList = PaginatedList.fromJson(json);

    this.data = [];
    for (dynamic objFields in json["data"]) {
      this.data.add(Transaction.fromJson(objFields));
    }
  }
}
