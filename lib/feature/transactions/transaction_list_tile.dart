import 'package:flutter/material.dart';
import 'package:trocado_flutter/model/transaction.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;
  final bool isSeller;

  TransactionListTile(this.transaction, this.isSeller);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: transaction.advertisement.firstPhoto != null ? Image.network(transaction.advertisement.firstPhoto, height: 120) : Icon(Icons.photo, size: 120),
      title: Text(transaction.advertisement.title),
      subtitle: Column(
        children: [
          Text((isSeller ? "Doado para: " + transaction.buyer.name : "Doador por: " + transaction.seller.name)),
          Text(transaction.createdAt.day.toString() + "/" + transaction.createdAt.month.toString() + "/" + transaction.createdAt.year.toString())
        ]
      )
    );
  }
}
