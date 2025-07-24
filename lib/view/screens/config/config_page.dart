import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../controller/paygo_tefcontroller.dart';
import '../../../controller/types/pending_transaction_actions.dart';
import '../../widget/generic_dialog.dart';
import '../../widget/text_button.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final TefController _tefController = Get.find();
  late TextEditingController _posNameController;
  late TextEditingController _posVersionController;
  late TextEditingController _posDeveloperController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _buildAutomationSection(),
            const SizedBox(height: 16),
            _buildTransactionSection(),
            const SizedBox(height: 16),
            _buildPrintSection(),
            const SizedBox(height: 16),
            _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.settings, color: Colors.blue),
        ),
        title: const Text(
          'Configurações de Automação',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildTextField(
                  icon: Icons.label,
                  label: 'Nome da Automação',
                  controller: _posNameController,
                  onChanged: _onPosNameChanged,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  icon: Icons.info,
                  label: 'Versão da Automação',
                  controller: _posVersionController,
                  onChanged: _onPosVersionChanged,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  icon: Icons.business,
                  label: 'Software House',
                  controller: _posDeveloperController,
                  onChanged: _onPosDeveloperChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.payment, color: Colors.green),
            ),
            title: const Text(
              'Configurações de Transação',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.receipt, color: Colors.orange),
            title: const Text('Permitir Recibos com via diferenciadas'),
            subtitle: const Text('Habilita recibos com vias diferentes'),
            value: _tefController.payGORequestHandler.dadosAutomacao.allowDifferentReceipts,
            onChanged: _onAllowDifferentReceiptsChanged,
            activeColor: Colors.orange,
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.discount, color: Colors.purple),
            title: const Text('Permitir Desconto'),
            subtitle: const Text('Habilita aplicação de descontos'),
            value: _tefController.payGORequestHandler.dadosAutomacao.allowDiscount,
            onChanged: _onAllowDiscountChanged,
            activeColor: Colors.purple,
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.card_giftcard, color: Colors.teal),
            title: const Text('Permitir Voucher para Desconto'),
            subtitle: const Text('Habilita uso de vouchers'),
            value: _tefController.payGORequestHandler.dadosAutomacao.allowDueAmount,
            onChanged: _onAllowDueAmountChanged,
            activeColor: Colors.teal,
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.receipt_long, color: Colors.indigo),
            title: const Text('Permitir Via Reduzida'),
            subtitle: const Text('Habilita impressão de via reduzida'),
            value: _tefController.payGORequestHandler.dadosAutomacao.allowShortReceipt,
            onChanged: _onAllowShortReceiptChanged,
            activeColor: Colors.indigo,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.pending_actions, color: Colors.amber),
            title: const Text('Transação Pendente'),
            subtitle: const Text('Ação para transações pendentes'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<PendingTransactionActions>(
                value: _tefController.configuracoes.pendingTransactionActions,
                onChanged: _onPendingTransactionActionsChanged,
                underline: const SizedBox(),
                items: PendingTransactionActions.values
                    .map<DropdownMenuItem<PendingTransactionActions>>(
                        (PendingTransactionActions value) {
                  return DropdownMenuItem<PendingTransactionActions>(
                    value: value,
                    child: Text(
                      value.toValue().replaceAll("_", " "),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.check_circle, color: Colors.green),
            title: const Text('Confirmação Automática de Transação'),
            subtitle: const Text('Confirma transações automaticamente'),
            value: _tefController.configuracoes.isAutoConfirm,
            onChanged: _onIsAutoConfirmChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPrintSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.print, color: Colors.red),
        ),
        title: const Text(
          'Configurações de Impressão',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        children: <Widget>[
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.receipt, color: Colors.blue),
            title: const Text('Imprimir via do Cliente'),
            subtitle: const Text('Imprime recibo para o cliente'),
            value: _tefController.configuracoes.isPrintcardholderReceipt,
            onChanged: _onIsPrintCardholderReceiptChanged,
            activeColor: Colors.blue,
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.store, color: Colors.green),
            title: const Text('Imprimir via do Estabelecimento'),
            subtitle: const Text('Imprime recibo para o estabelecimento'),
            value: _tefController.configuracoes.isPrintMerchantReceipt,
            onChanged: _onIsPrintMerchantReceiptChanged,
            activeColor: Colors.green,
          ),
          const Divider(height: 1),
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.report, color: Colors.orange),
            title: const Text('Imprimir Relatório'),
            subtitle: const Text('Imprime relatórios de transação'),
            value: _tefController.configuracoes.isPrintReport,
            onChanged: _onIsPrintReportChanged,
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.build, color: Colors.indigo),
            ),
            title: const Text(
              'Ações do Sistema',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          _buildActionButton(
            icon: Icons.build,
            text: 'Instalação',
            color: Colors.blue,
            onPressed: onclickButtonInstalacao,
          ),
          _buildActionButton(
            icon: Icons.settings,
            text: 'Manutenção',
            color: Colors.orange,
            onPressed: onclickButtonManutencao,
          ),
          _buildActionButton(
            icon: Icons.admin_panel_settings,
            text: 'Administrativo',
            color: Colors.purple,
            onPressed: onclickButtonPainelAdministrativo,
          ),
          _buildActionButton(
            icon: Icons.visibility,
            text: 'Exibe PDC',
            color: Colors.teal,
            onPressed: onclickButtonExibePDC,
          ),
          _buildActionButton(
            icon: Icons.description,
            text: 'Relatório Detalhado',
            color: Colors.indigo,
            onPressed: onClickButtonRelatorioDetalhado,
          ),
          _buildActionButton(
            icon: Icons.summarize,
            text: 'Relatório Resumido',
            color: Colors.cyan,
            onPressed: onclickButtonRelatorioResumido,
          ),
          _buildActionButton(
            icon: Icons.select_all,
            text: 'Selecionar Provedor',
            color: Colors.deepPurple,
            onPressed: onclickButtonSelectProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onPressed,
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
    setState(() {
      _tefController.payGORequestHandler.dadosAutomacao.posName = value;
    });
  }

  void _onPosVersionChanged(String value) {
    setState(() {
      _tefController.payGORequestHandler.dadosAutomacao.posVersion = value;
    });
  }

  void _onPosDeveloperChanged(String value) {
    setState(() {
      _tefController.payGORequestHandler.dadosAutomacao.posDeveloper = value;
    });
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
