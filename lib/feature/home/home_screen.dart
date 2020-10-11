import 'package:flutter/material.dart';
import 'package:trocado_flutter/feature/home/ads_tab.dart';
import 'package:trocado_flutter/feature/home/groups_tab.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:trocado_flutter/widget/trocado_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Trocado"),
      drawer: TrocadoDrawer(),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Anúncios"),
                Tab(text: "Grupos"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AdsTab(),
                  GroupsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
