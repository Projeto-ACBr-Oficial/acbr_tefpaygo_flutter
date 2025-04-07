import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/models/transacao/transacao_requisicao_dados_automacao.dart';

import '../../../controller/PayGoTefController.dart';
import '../../../controller/types/PendingTransactionActions.dart';
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
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
              child: ExpansionTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações de Automação'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text('Nome da Automação'),
                    subtitle: TextField(
                      controller: TextEditingController(
                          text: _tefController
                              .payGORequestHandler.dadosAutomacao.posName),
                      onChanged: (value) {
                        _tefController
                            .payGORequestHandler.dadosAutomacao.posName = value;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text('Versão da Automação'),
                    subtitle: TextField(
                      controller: TextEditingController(
                          text: _tefController
                              .payGORequestHandler.dadosAutomacao.posVersion),
                      onChanged: (value) {
                        _tefController.payGORequestHandler.dadosAutomacao
                            .posVersion = value;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text('Software House'),
                    subtitle: TextField(
                      controller: TextEditingController(
                          text: _tefController
                              .payGORequestHandler.dadosAutomacao.posDeveloper),
                      onChanged: (value) {
                        setState(() {
                          _tefController.payGORequestHandler.dadosAutomacao
                              .posDeveloper = value;
                        });
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.receipt),
                      title: Text('Permitir Recibos com via diferenciadas'),
                      trailing: Switch(
                        value: _tefController.payGORequestHandler.dadosAutomacao
                            .allowDifferentReceipts,
                        onChanged: (value) {
                          setState(() {
                            _tefController.payGORequestHandler.dadosAutomacao
                                .allowDifferentReceipts = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.discount),
                      title: Text('Permitir Desconto'),
                      trailing: Switch(
                        value: _tefController
                            .payGORequestHandler.dadosAutomacao.allowDiscount,
                        onChanged: (value) {
                          setState(() {
                            _tefController.payGORequestHandler.dadosAutomacao
                                .allowDiscount = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.card_giftcard),
                      title: Text('Permitir Voucher para Desconto'),
                      trailing: Switch(
                        value: _tefController
                            .payGORequestHandler.dadosAutomacao.allowDueAmount,
                        onChanged: (value) {
                          setState(() {
                            _tefController.payGORequestHandler.dadosAutomacao
                                .allowDueAmount = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.receipt_long),
                      title: Text('Permitir Via Reduzida'),
                      trailing: Switch(
                        value: _tefController.payGORequestHandler.dadosAutomacao
                            .allowShortReceipt,
                        onChanged: (value) {
                          setState(() {
                            _tefController.payGORequestHandler.dadosAutomacao
                                .allowShortReceipt = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.pending_actions),
                      title: Text('Transação Pendente'),
                      trailing: DropdownButton<PendingTransactionActions>(
                        value: _tefController
                            .configuracoes.pendingTransactionActions,
                        onChanged: (PendingTransactionActions? newValue) {
                          setState(() {
                            _tefController.configuracoes
                                .setPendingTransactionActions(newValue!);
                          });
                        },
                        items: PendingTransactionActions.values
                            .map<DropdownMenuItem<PendingTransactionActions>>(
                                (PendingTransactionActions value) {
                          return DropdownMenuItem<PendingTransactionActions>(
                            value: value,
                            child: Text(value.toValue().replaceAll("_", " ")),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.check_circle),
                      title: Text('Confirmação Automática de Transação'),
                      trailing: Switch(
                        value: _tefController.configuracoes.isAutoConfirm,
                        onChanged: (value) {
                          setState(() {
                            _tefController.configuracoes
                                .setIsAutoConfirm(value);
                          });
                        },
                      ),
                    ),
                  )
                ],
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
    ));
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
