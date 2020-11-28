import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ad_search_delegate.dart';
import 'package:trocado_flutter/feature/ad/ads_provider.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/ad/ads_tab.dart';
import 'package:trocado_flutter/feature/group/group_search_delegate.dart';
import 'package:trocado_flutter/feature/group/groups_tab.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:trocado_flutter/feature/home/trocado_drawer.dart';

import '../group/groups_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final int tabCount = 2;
  List<Widget> tabViews;
  TabController _tabController;
  int currentIndex = 0;

  void setTabsLists(bool isLogged) {
    tabViews = [];

    tabViews.add(Consumer<AdsProvider>(
      builder: (BuildContext context, provider, _) {
        provider.loadAvailableAds(context);

        return AdsTab(
          provider.availableAds,
          () => provider.loadAvailableAds(context, forceLoad: true)
        );
      },
    ));

    if (!isLogged) {
      tabViews.add(Consumer<GroupsProvider>(
        builder: (BuildContext context, GroupsProvider provider, _) =>
            GroupsTab(provider.publicGroups,
                () => provider.loadPublicGroups(forceLoad: true)),
      ));
    } else {
      Provider.of<GroupsProvider>(context, listen: false)
          .loadUserGroups(context);
      tabViews.add(Consumer<GroupsProvider>(
        builder: (BuildContext context, GroupsProvider provider, _) =>
            GroupsTab(provider.userGroups,
                () => provider.loadUserGroups(context, forceLoad: true)),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabCount);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setTabsLists(Provider.of<AuthenticationProvider>(context).isUserLogged);

    return Scaffold(
      appBar: trocadoAppBar("Trocado"),
      drawer: TrocadoDrawer(),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            unselectedLabelColor: Colors.black54,
            indicatorColor: currentIndex == 0 ? Style.accentColor : Style.primaryColorDark,
            tabs: [
              const Tab(text: "Anúncios Disponíveis"),
              const Tab(text: "Meus Grupos"),
            ],
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: tabViews),
          ),
        ],
      ),
      floatingActionButton: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            color: currentIndex == 0 ? Style.accentColor : Style.primaryColorDark,
          ),
          child: FloatingActionButton(
            child: const Icon(Icons.search, color: Style.clearWhite),
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              showSearch(
                context: context,
                delegate: _tabController.index == 0
                    ? AdSearchDelegate()
                    : GroupSearchDelegate(),
              );
            },
          ),
        ),
      ),
    );
  }
}
