import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/home/ads_tab.dart';
import 'package:trocado_flutter/feature/home/groups_tab.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:trocado_flutter/widget/trocado_drawer.dart';

import 'groups_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tabCount;
  List<Tab> tabHeaders;
  List<Widget> tabViews;

  void setTabsLists(bool isLogged) {
    tabHeaders = [];
    tabViews = [];
    tabCount = 2;

    tabHeaders.add(Tab(text: "Anúncios"));
    tabViews.add(AdsTab());

    if(isLogged){
      Provider.of<GroupsProvider>(context, listen: false).loadUserGroups(context);
      tabCount = 3;
      tabHeaders.add(Tab(text: "Meus Grupos"));
      tabViews.add(
          Consumer<GroupsProvider>(
            builder: (BuildContext context, groupsService, _) => GroupsTab(groupsService.userGroups),
          )
      );
    }

    tabHeaders.add(Tab(text: "Grupos Públicos"));
    tabViews.add(
      Consumer<GroupsProvider>(
        builder: (BuildContext context, groupsService, _) => GroupsTab(groupsService.publicGroups),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    setTabsLists(Provider.of<AuthenticationProvider>(context).isUserLogged);

    return Scaffold(
      appBar: trocadoAppBar("Trocado"),
      drawer: TrocadoDrawer(),
      body: DefaultTabController(
        length: tabCount,
        initialIndex: 0,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              unselectedLabelColor: Colors.black54,
              tabs: tabHeaders,
            ),
            Expanded(
              child: TabBarView(
                children: tabViews
              ),
            ),
          ],
        ),
      ),
    );
  }
}
