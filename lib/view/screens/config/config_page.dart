import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../controller/PayGoTefController.dart';
import '../../../controller/types/PendingTransactionActions.dart';
import '../../widget/generic_dialog.dart';
import '../../widget/text_button.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TefController _tefController = Get.find();
  late TextEditingController _posNameController;
  late TextEditingController _posVersionController;
  late TextEditingController _posDeveloperController;

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
                      controller: _posNameController,
                      onChanged: _onPosNameChanged,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text('Versão da Automação'),
                    subtitle: TextField(
                      controller: _posVersionController,
                      onChanged: _onPosVersionChanged,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.label),
                    title: Text('Software House'),
                    subtitle: TextField(
                      controller: _posDeveloperController,
                      onChanged: _onPosDeveloperChanged,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.receipt),
                title: Text('Permitir Recibos com via diferenciadas'),
                trailing: Switch(
                  value: _tefController.payGORequestHandler.dadosAutomacao
                      .allowDifferentReceipts,
                  onChanged: _onAllowDifferentReceiptsChanged,
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
                  onChanged: _onAllowDiscountChanged,
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
                  onChanged: _onAllowDueAmountChanged,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.receipt_long),
                title: Text('Permitir Via Reduzida'),
                trailing: Switch(
                  value: _tefController
                      .payGORequestHandler.dadosAutomacao.allowShortReceipt,
                  onChanged: _onAllowShortReceiptChanged,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.pending_actions),
                title: Text('Transação Pendente'),
                trailing: DropdownButton<PendingTransactionActions>(
                  value: _tefController.configuracoes.pendingTransactionActions,
                  onChanged: _onPendingTransactionActionsChanged,
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
                  onChanged: _onIsAutoConfirmChanged,
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
                      onChanged: _onIsPrintCardholderReceiptChanged,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.store),
                    title: Text('Imprimir via do Estabelecimento'),
                    trailing: Switch(
                      value:
                          _tefController.configuracoes.isPrintMerchantReceipt,
                      onChanged: _onIsPrintMerchantReceiptChanged,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.report),
                    title: Text('Imprimir Relatório'),
                    trailing: Switch(
                      value: _tefController.configuracoes.isPrintReport,
                      onChanged: _onIsPrintReportChanged,
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

  void onclickButtonSelectProvider() async {
    var providers = {"DEMO", "REDE", "PIX C6 BANK"};
    await showGenericDialog<String>(
      context: context,
      title: "Selecione o provedor",
      options: providers.toList(),
      selectedValue: _tefController.payGORequestHandler.provider,
      displayText: (e) => e,
      onSelected: (value) {
        setState(() {
          _tefController.payGORequestHandler.setProvider(value);
        });
      },
      onCancel: () {
        Fluttertoast.showToast(
            msg: "Operação cancelada", toastLength: Toast.LENGTH_LONG);
      },
    );
  }

  void _onPosNameChanged(String value) {
    _tefController.payGORequestHandler.dadosAutomacao.posName = value;
  }

  void _onPosVersionChanged(String value) {
    _tefController.payGORequestHandler.dadosAutomacao.posVersion = value;
  }

  void _onPosDeveloperChanged(String value) {
    _tefController.payGORequestHandler.dadosAutomacao.posDeveloper = value;
  }

  void _onAllowDifferentReceiptsChanged(bool value) {
    setState(() {
      _tefController.payGORequestHandler.dadosAutomacao.allowDifferentReceipts =
          value;
    });
  }

  void _onAllowDiscountChanged(bool value) {
    setState(() {
      _tefController.payGORequestHandler.dadosAutomacao.allowDiscount = value;
    });
  }

  void _onAllowDueAmountChanged(bool value) {
    setState(() {
      _tefController.payGORequestHandler.dadosAutomacao.allowDueAmount = value;
    });
  }

  void _onAllowShortReceiptChanged(bool value) {
    setState(() {
      _tefController.payGORequestHandler.dadosAutomacao.allowShortReceipt =
          value;
    });
  }

  void _onPendingTransactionActionsChanged(
      PendingTransactionActions? newValue) {
    setState(() {
      _tefController.configuracoes.setPendingTransactionActions(newValue!);
    });
  }

  void _onIsAutoConfirmChanged(bool value) {
    setState(() {
      _tefController.configuracoes.setIsAutoConfirm(value);
    });
  }

  void _onIsPrintCardholderReceiptChanged(bool value) {
    setState(() {
      _tefController.configuracoes.setIsPrintcardholderReceipt(value);
    });
  }

  void _onIsPrintMerchantReceiptChanged(bool value) {
    setState(() {
      _tefController.configuracoes.setIsPrintMerchantReceipt(value);
    });
  }

  void _onIsPrintReportChanged(bool value) {
    setState(() {
      _tefController.configuracoes.setIsPrintReport(value);
    });
  }

  @override
  void initState() {
    super.initState();

    // Inicialize os controladores com os valores existentes
    _posNameController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posName);
    _posVersionController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posVersion);
    _posDeveloperController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posDeveloper);
  }

  @override
  void dispose() {
    // Libere os controladores
    _posNameController.dispose();
    _posVersionController.dispose();
    _posDeveloperController.dispose();
    super.dispose();
  }
}
