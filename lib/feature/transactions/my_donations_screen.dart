import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/transactions/transaction_list_tile.dart';
import 'package:trocado_flutter/feature/transactions/transactions_provider.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class MyDonationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Minhas Doações"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Consumer<TransactionsProvider>(
              builder: (context, TransactionsProvider provider, _) {
                if(provider.donationsList != null && provider.donationsList.data.length == 0) {
                  return Center(child: Text("Não há doações ainda :)"));
                }

                return ListView.builder(
                  itemCount: provider.donationsList != null? provider.donationsList.data.length : 0,
                  itemBuilder: (context, i) => TransactionListTile(provider.donationsList.data[i], true),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
