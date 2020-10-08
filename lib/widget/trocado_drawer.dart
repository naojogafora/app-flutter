import 'package:flutter/material.dart';

class TrocadoDrawer extends StatefulWidget {
  @override
  _TrocadoDrawerState createState() => _TrocadoDrawerState();
}

class _TrocadoDrawerState extends State<TrocadoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(child: Text("Drawer Headerrr")),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Login/Cadastro"),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/login");
                  },
                ),
                Divider(),
              ],
            ),
          )
        ]
      ),
    );
  }
}
