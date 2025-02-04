import 'package:demo_tefpaygo_simples/utils/paygo_sdk_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paygo_sdk/paygo_sdk.dart';

import '../../controller/paygo_request_handler.dart';
import '../../utils/tef_paygo_transacoes.dart';
import '../../widget/button.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final PayGoRequestHandler _payGORequestHandler = PayGoRequestHandlerHelper().payGoRequestHandler;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: <Widget>[
            Button(
              onPressed: onclickButtonInstalacao,
              text: 'Abrir menu de instalação',
            ),
            Button(
              onPressed: onclickButtonManutencao,
              text: 'Abrir menu de manutenção',
            ),
            Button(
              onPressed: onclickButtonPainelAdministrativo,
              text: 'Abrir Painel Administrativo',
            ),
            Button( onPressed: onclickButtonExibePDC,
              text: "Exibe PDC",)
            ,
            Button(onPressed: onClickButtonRelatorioDetalhado,
                text: "Relatório Detalhado"),
            Button(onPressed: onclickButtonRelatorioResumido,
                text: "Relatório Resumido")

          ],
        ),
      ),
    );
  }

  void onclickButtonInstalacao() async {
    await _payGORequestHandler.instalacao();
  }

  void onclickButtonManutencao() async {
    await _payGORequestHandler.manutencao();
  }

  void onclickButtonPainelAdministrativo() async {
    await _payGORequestHandler.painelAdministrativo();
    Navigator.pop(context);
  }

  void onclickButtonExibePDC() async {
    await _payGORequestHandler.exibePDC();
    Navigator.pop(context);
  }

  void onClickButtonRelatorioDetalhado() async{
    await _payGORequestHandler.relatorioDetalhado();
    Navigator.pop(context);
  }

  void onclickButtonRelatorioResumido() async {
    await _payGORequestHandler.relatorioResumido();

    Navigator.pop(context);
  }
}
