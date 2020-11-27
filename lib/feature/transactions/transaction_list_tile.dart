import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/transaction.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;
  final bool isSeller;

  TransactionListTile(this.transaction, this.isSeller);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: transaction.advertisement.firstPhoto != null ? Image.network(transaction.advertisement.firstPhoto.url, height: 80, width: 80, fit: BoxFit.cover,) : Icon(Icons.no_photography_sharp, size: 80),
      title: Text(transaction.advertisement.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text((isSeller ? "Doado para: " + transaction.buyer.name : "Doador por: " + transaction.seller.name)),
          Text("Data: " + transaction.createdAt.day.toString() + "/" + transaction.createdAt.month.toString() + "/" + transaction.createdAt.year.toString())
        ]
      )
    );
  }
}
