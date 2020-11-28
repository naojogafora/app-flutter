import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/transactions/transaction_list_tile.dart';
import 'package:trocado_flutter/feature/transactions/transactions_provider.dart';
import 'package:trocado_flutter/response/transaction_list.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TransactionsProvider provider = Provider.of<TransactionsProvider>(context);

    return Scaffold(
      appBar: trocadoAppBar("Meus Pedidos"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FutureBuilder<TransactionListResponse>(
              future: provider.loadOrdersList(context),
              builder: (context, AsyncSnapshot<TransactionListResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                TransactionListResponse response = snapshot.data;

                if (response.data != null && response.data.isEmpty) {
                  return const Center(child: Text("Não há pedidos ainda :)"));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: provider.ordersList != null ? provider.ordersList.data.length : 0,
                    itemBuilder: (context, i) =>
                        TransactionListTile(provider.ordersList.data[i], false),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
