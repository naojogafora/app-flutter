import 'package:flutter/material.dart';
import 'package:trocado_flutter/config/style.dart';

class TrocadoDrawer extends StatefulWidget {
  @override
  _TrocadoDrawerState createState() => _TrocadoDrawerState();
}

class _TrocadoDrawerState extends State<TrocadoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              DrawerHeader(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Icon(Icons.person, size: 52,),
                      minRadius: 48,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: Text("Nome de Pessoa Muito Grande", style: TextStyle(fontSize: 18),)),
                          Padding(padding: EdgeInsets.all(2)),
                          Flexible(child: Text("Membro desde 20/20/2020", style: TextStyle(color: Colors.black54))),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(color: Style.primaryColorDark),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Login/Cadastro"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed("/login");
                },
              ),
              Divider(),
            ],
          ),
        )
      ]),
    );
  }
}
