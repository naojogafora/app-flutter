import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/transactions/transaction_list_tile.dart';
import 'package:trocado_flutter/feature/transactions/transactions_provider.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Meus Pedidos"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Consumer<TransactionsProvider>(
              builder: (context, TransactionsProvider provider, _) {
                if(provider.ordersList != null && provider.ordersList.data.length == 0) {
                  return Center(child: Text("Não há pedidos ainda :)"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.ordersList != null ? provider.ordersList.data.length : 0,
                  itemBuilder: (context, i) => TransactionListTile(provider.ordersList.data[i], false),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
