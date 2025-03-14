import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/PayGoTefController.dart';
import '../../widget/text_button.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TefController _tefController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Confirmação Automática'),
                trailing: Switch(
                  value: _tefController.configuracoes.isAutoConfirm,
                  onChanged: (value) {
                    setState(() {
                      _tefController.configuracoes.setIsAutoConfirm(value);
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: Icon(Icons.print),
                title: Text('Configurações de Impressão'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.receipt),
                    title: Text('Imprimir via do Cliente'),
                    trailing: Switch(
                      value:
                          _tefController.configuracoes.isPrintcardholderReceipt,
                      onChanged: (value) {
                        setState(() {
                          _tefController.configuracoes
                              .setIsPrintcardholderReceipt(value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text('Imprimir via do Estabelecimento'),
                    trailing: Switch(
                      value:
                          _tefController.configuracoes.isPrintMerchantReceipt,
                      onChanged: (value) {
                        setState(() {
                          _tefController.configuracoes
                              .setIsPrintMerchantReceipt(value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.report),
                    title: Text('Imprimir Relatório'),
                    trailing: Switch(
                      value: _tefController.configuracoes.isPrintReport,
                      onChanged: (value) {
                        setState(() {
                          _tefController.configuracoes.setIsPrintReport(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: CustomButton(
                  onPressed: onclickButtonInstalacao,
                  text: 'Instalação',
                  icon: Icon(
                    Icons.build,
                  )),
            ),
            Card(
              child: CustomButton(
                  onPressed: onclickButtonManutencao,
                  text: 'Manutenção',
                  icon: Icon(Icons.settings)),
            ),
            Card(
              child: CustomButton(
                  onPressed: onclickButtonPainelAdministrativo,
                  text: 'Administrativo',
                  icon: Icon(Icons.admin_panel_settings)),
            ),
            Card(
              child: CustomButton(
                onPressed: onclickButtonExibePDC,
                text: 'Exibe PDC',
                icon: Icon(Icons.visibility),
              ),
            ),
            Card(
              child: CustomButton(
                onPressed: onClickButtonRelatorioDetalhado,
                text: 'Relatório Detalhado',
                icon: Icon(Icons.description),
              ),
            ),
            Card(
              child: CustomButton(
                onPressed: onclickButtonRelatorioResumido,
                text: 'Relatório Resumido',
                icon: Icon(Icons.summarize),
              ),
            ),
            Card(
              child: CustomButton(
                onPressed: onclickButtonSelectProvider,
                text: 'Selecionar Provedor',
                icon: Icon(Icons.select_all),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onclickButtonInstalacao() async {
    await _tefController.payGORequestHandler.instalacao();
  }

  void onclickButtonManutencao() async {
    await _tefController.payGORequestHandler.manutencao();
  }

  void onclickButtonPainelAdministrativo() async {
    await _tefController.payGORequestHandler.painelAdministrativo();
    Navigator.canPop(context);
  }

  void onclickButtonExibePDC() async {
    await _tefController.payGORequestHandler.exibePDC();
    Navigator.canPop(context);
  }

  void onClickButtonRelatorioDetalhado() async {
    await _tefController.payGORequestHandler.relatorioDetalhado();
    Navigator.canPop(context);
  }

  void onclickButtonRelatorioResumido() async {
    await _tefController.payGORequestHandler.relatorioResumido();

    Navigator.canPop(context);
  }

  void onclickButtonSelectProvider() {
    var providers = {"DEMO", "REDE", "PIX C6 BANK"};
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedProvider = _tefController.payGORequestHandler.provider;
        return AlertDialog(
          title: Text("Selecione o provedor"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: providers
                .map((e) => RadioListTile<String>(
                      title: Text(e),
                      value: e,
                      groupValue: selectedProvider,
                      onChanged: (String? value) {
                        setState(() {
                          selectedProvider = value;
                          _tefController.payGORequestHandler
                              .setProvider(value!);
                        });
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint("dispose config");
    super.dispose();
  }
}
