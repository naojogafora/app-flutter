import 'package:flutter/material.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Sobre"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                const ListTile(
                  isThreeLine: true,
                  title: Text("O que é o Não Joga Fora?"),
                  subtitle: Text("O Não Joga Fora é um aplicativo que permite doação de objetos entre pessoas de forma prática e sem custos."),
                  leading: Icon(Icons.help_outline)
                ),
                const Divider(),
                const ListTile(
                  isThreeLine: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  trailing: Icon(Icons.help_outline),
                  title: Text("O que posso doar?"),
                  subtitle: Text("Qualquer coisa que você não queira mais, e que esteja em condições mínimas de reuso ou com partes funcionais, de qualquer categoria: roupas, plantas, potes, móveis, tudo!")
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text("Como posso doar ou receber itens?"),
                  subtitle: Text("Você precisa de uma conta, e precisa estar em algum grupo, ou escolher itens públicos que aparecem na sua tela inicial."),
                  isThreeLine: true,
                ),
                const Divider(),
                const ListTile(
                  trailing: Icon(Icons.help_outline),
                  title: Text("Como funcionam os grupos?"),
                  subtitle: Text("Um anúncio sempre deve ser publicado em um ou mais grupos. Você pode procurar um grupo próximo usando a busca, ou criar um grupo e compartilhar com pessoas nas proximidades, amigos ou familiares."),
                  isThreeLine: true,
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text("Como funcionam grupos privados?"),
                  subtitle: Text("Grupos privados são indicados para grupos de amigos, conhecidos ou familiares que querem trocar objetos entre si primeiro. O criador e moderadores do grupo poderão ver e alterar a chave secreta de entrada, além de aceitar membros novos que encontrem seu grupo pela busca."),
                  isThreeLine: true,
                ),
                const Divider(),
                const ListTile(
                  trailing: Icon(Icons.help_outline),
                  title: Text("Como funciona uma transação?"),
                  subtitle: Text("Após escolher um anúncio e concordar com os termos do app, será criada uma transação entre doador e tomador. A partir daí, vocês devem usar o chat para tirar dúvidas e combinar a retirada no endereço mais prático pros dois!"),
                  isThreeLine: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
