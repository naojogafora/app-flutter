import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/transactions/transaction_list_tile.dart';
import 'package:trocado_flutter/feature/transactions/transactions_provider.dart';
import 'package:trocado_flutter/response/transaction_list.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class MyDonationsScreen extends StatefulWidget {
  @override
  _MyDonationsScreenState createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionsProvider provider =
        Provider.of<TransactionsProvider>(context, listen: false);

    return Scaffold(
      appBar: trocadoAppBar("Minhas Doações"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.loadDonationsList(context, forceLoad: true),
                child: FutureBuilder(
                  initialData: provider.donationsList,
                  future: provider.loadDonationsList(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      TransactionListResponse donationsList = snapshot.data;

                      if (donationsList != null &&
                          donationsList.data.isEmpty) {
                        return ListView(
                          children: [
                            const Center(child: Text("Não há doações ainda :)")),
                          ],
                        );
                      }

                      return ListView.builder(
                        itemCount: provider.donationsList != null
                            ? provider.donationsList.data.length
                            : 0,
                        itemBuilder: (context, i) => TransactionListTile(
                            provider.donationsList.data[i], true),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
