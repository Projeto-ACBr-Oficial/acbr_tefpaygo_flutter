import 'package:demo_tefpaygo_simples/utils/paygo_sdk_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paygo_sdk/paygo_sdk.dart';

import '../../widget/button.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final PayGOSdk repository = PayGOSdkHelper().paygoSdk;

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
    await repository.integrado.generico(
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.instalacao,
        ),
        intentAction: IntentAction.payment);
  }

  void onclickButtonManutencao() async {
    await repository.integrado.generico(
      requisicao: TransacaoRequisicaoGenerica(
        operation: Operation.manutencao,
      ),
      intentAction: IntentAction.payment,
    );
  }

  void onclickButtonPainelAdministrativo() async {
    await repository.integrado.administrativo();
    Navigator.pop(context);
  }

  void onclickButtonExibePDC() async {
    await repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(operation: Operation.exibePdc));
    //voltar para tela anterior
    Navigator.pop(context);
  }

  void onClickButtonRelatorioDetalhado() async{
    await repository.integrado.generico(intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(
            operation: Operation.relatorioDetalhado
        )
    );
  }

  void onclickButtonRelatorioResumido() async {
    await repository.integrado.generico(
        intentAction: IntentAction.payment,
        requisicao: TransacaoRequisicaoGenerica(
          operation: Operation.relatorioResumido,
        ));
  }
}
