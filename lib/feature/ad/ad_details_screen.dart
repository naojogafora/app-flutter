import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trocado_flutter/config/style.dart';
import 'package:trocado_flutter/feature/ad/ad_overlay_gallery.dart';
import 'package:trocado_flutter/feature/ad/ads_provider.dart';
import 'package:trocado_flutter/feature/auth/authentication_provider.dart';
import 'package:trocado_flutter/feature/helpers.dart';
import 'package:trocado_flutter/feature/transactions/my_orders_screen.dart';
import 'package:trocado_flutter/model/ad.dart';
import 'package:trocado_flutter/model/question.dart';
import 'package:trocado_flutter/model/transaction.dart';
import 'package:trocado_flutter/widget/user_tile.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class AdDetailsScreen extends StatefulWidget {
  final Ad ad;
  AdDetailsScreen(this.ad);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  bool showingGallery = false, loading = false;

  void _onTapImageCount() {
    setState(() {
      showingGallery = true;
    });
  }

  void closeGalleryCallback() {
    setState(() {
      showingGallery = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                title: widget.ad.firstPhoto != null
                    ? null
                    : const Icon(Icons.no_photography_outlined),
                expandedHeight: widget.ad.firstPhoto != null ? 240 : 60,
                flexibleSpace: widget.ad.firstPhoto != null
                    ? GestureDetector(
                        onTap: _onTapImageCount,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    child: Hero(
                                        tag: "ad-image-" +
                                            widget.ad.id.toString(),
                                        child: Image.network(
                                            widget.ad.firstPhoto.url,
                                            fit: BoxFit.cover))),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 6),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14))),
                                    color: Colors.white54),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt,
                                      size: 22,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        widget.ad.photos.length.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                          alignment: Alignment.bottomRight,
                        ),
                      )
                    : Container(),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            widget.ad.title,
                            style: const TextStyle(
                                fontSize: 24, color: Style.accentColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(color: Colors.transparent),
                        const Text(
                          "Descrição:",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.ad.description,
                              style: const TextStyle(fontSize: 18)),
                        ),
                        const Divider(height: 12, color: Colors.transparent),
                        const Text(
                          "Doaçao por: ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        UserTile(
                          context: context,
                          user: widget.ad.user,
                          trailing: widget.ad.distance != null
                              ? Text(
                                  widget.ad.distanceStr,
                                  style: const TextStyle(
                                      color: Colors.black45, fontSize: 12),
                                )
                              : null,
                        ),
                        QuestionsList(widget.ad),
                        const Divider(
                            color: Colors.black26, indent: 8, endIndent: 8),
                        widget.ad.active &&
                                Provider.of<AuthenticationProvider>(context,
                                            listen: false)
                                        .user !=
                                    null &&
                                widget.ad.user.id !=
                                    Provider.of<AuthenticationProvider>(context,
                                            listen: false)
                                        .user
                                        .id
                            ? Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(12),
                                      child: loading
                                          ? const CircularProgressIndicator(
                                              backgroundColor: Style.clearWhite)
                                          : const Text("Eu Quero!",
                                              style: TextStyle(
                                                color: Style.clearWhite,
                                                fontSize: 18,
                                              )),
                                      color: Style.accentColor,
                                      onPressed: purchaseDialog,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          showingGallery
              ? AdOverlayGallery(widget.ad.photos, closeGalleryCallback)
              : Container(),
        ],
      ),
    );
  }

  void purchaseDialog() {
    showDialog(
        context: context,
        builder: (context) {
          bool checked = false;

          return SimpleDialog(
            title: const Text("Confirmação"),
            children: [
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                          "1. Apenas solicite um produto se tiver interesse e certeza de que irá buscá-lo o quanto antes."
                          " O aplicativo é colaborativo, e incentiva a colaboração e o senso de comunidade. Confiamos"
                          " em você e nos demais usuários nessa missão.\n"
                          "2. Vocẽ tem um limite de solicitações por mês. Se tiver dúvidas, use o campo Perguntas. Lembre-se de doar a"
                          " outras pessoas da mesma forma que colaboram com você. :)\n"
                          "3. A desistência da solicitação de produtos pode acarretar em limitações ou, em casos recorrentes,"
                          " exclusão da conta. Escolha bem seus produtos e colabore com os demais membros."),
                    ),
                    CheckboxListTile(
                      onChanged: (val) => setState(() => checked = val),
                      value: checked,
                      title: const Text(
                        "Concordo com as informações acima",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        MaterialButton(
                          child: const Text("Confirmar"),
                          textColor: checked ? Colors.black87 : Colors.black38,
                          enableFeedback: checked,
                          onPressed: () {
                            if (!checked) return;
                            purchase();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void purchase() {
    if (loading) return;
    setState(() {
      loading = true;
    });

    Provider.of<AdsProvider>(context, listen: false)
        .purchaseAd(context, widget.ad)
        .then((Transaction transaction) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyOrdersScreen()));
    }).catchError(handleError);
  }

  void handleError(e, st) {
    debugPrintStack(stackTrace: st);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
    setState(() {
      loading = false;
    });
  }
}

class QuestionsList extends StatefulWidget {
  final Ad ad;
  QuestionsList(this.ad);

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  bool loadingQuestion = false, showQuestionField = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.black26, indent: 8, endIndent: 8),
        const Text("Perguntas",
            style: TextStyle(color: Style.accentColor, fontSize: 16)),
        widget.ad.questions != null && widget.ad.questions.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(child: Text("Não há perguntas ainda")),
              )
            : Container(),
      ]
        ..addAll(List<Widget>.generate(
          widget.ad.questions?.length ?? 0,
          (i) {
            return ListTile(
              visualDensity: VisualDensity.compact,
              title: Text(widget.ad.questions[i].question),
              subtitle: widget.ad.questions[i].answer == null
                  ? Text(widget.ad.questions[i].askDate +
                      (authProvider.user == null || authProvider.user.id != widget.ad.user.id
                          ? " - Aguardando Resposta"
                          : " - Clique para Responder"))
                  : Text(widget.ad.questions[i].answerDate + " - " + widget.ad.questions[i].answer),
              onTap: authProvider.user != null && authProvider.user.id == widget.ad.user.id && widget.ad.questions[i].answer == null
                  ? () => showAnswerDialog(widget.ad.questions[i]) : null,
            );
          },
        ))
        ..add(Provider.of<AuthenticationProvider>(context, listen: false)
                        .user ==
                    null ||
                widget.ad.user.id ==
                    Provider.of<AuthenticationProvider>(context, listen: false)
                        .user
                        .id
            ? Container()
            : (showQuestionField
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: 1,
                          maxLength: 255,
                          controller: controller,
                          decoration: const InputDecoration(
                              labelText: "Digite uma pergunta",
                              contentPadding: EdgeInsets.all(0)),
                        ),
                      ),
                      IconButton(
                          icon: loadingQuestion
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.send),
                          onPressed: submit),
                    ],
                  )
                : GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Text("Escrever pergunta...",
                              style: TextStyle(color: Style.primaryColorDark))),
                    ),
                    onTap: () => setState(() {
                          showQuestionField = true;
                        })))),
    );
  }

  void submit() {
    if (loadingQuestion) return;
    setState(() {
      loadingQuestion = true;
    });

    String question = controller.text;
    if (question.length < 5) {
      return;
    }

    Provider.of<AdsProvider>(context, listen: false)
        .submitQuestion(context, widget.ad.id, question)
        .then((value) {
      setState(() {
        loadingQuestion = false;
        controller.text = "";
      });
      showSuccessSnack(_scaffoldKey, "Pergunta enviada");
    }).catchError((e) {
      showErrorSnack(_scaffoldKey, e.toString());
      setState(() {
        loadingQuestion = false;
      });
    });
  }

  void showAnswerDialog(Question question) {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          bool loading = false;
          return AlertDialog(
            title: const Text("Responder Pergunta"),
            content: StatefulBuilder(
              builder: (context, StateSetter stateSetter) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Pergunta:",
                      style: TextStyle(color: Colors.black54)),
                  Text(question.question),
                  TextFormField(
                    controller: controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) => val.length < 3 || val.length > 255
                        ? "Digite de 3 a 255 caracteres"
                        : null,
                    decoration: const InputDecoration(labelText: "Resposta"),
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        child: const Text("Cancelar"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      MaterialButton(
                          child: loading
                              ? const CircularProgressIndicator()
                              : const Text("Enviar"),
                          onPressed: () {
                            if (loading) return;
                            stateSetter(() {
                              loading = true;
                            });
                            Provider.of<AdsProvider>(context, listen: false)
                                .answerQuestion(context, widget.ad.id, question,
                                    controller.text)
                                .then((value) {
                              Navigator.of(context).pop();
                              showSuccessSnack(
                                  _scaffoldKey, "Mensagem respondida");
                              setState(() {});
                            }).catchError((e) {
                              stateSetter(() {
                                loading = false;
                              });
                              showErrorSnack(_scaffoldKey, e.toString());
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
