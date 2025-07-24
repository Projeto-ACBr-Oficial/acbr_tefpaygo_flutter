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
    
    return Container(
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
          AutomationSection(),
          const SizedBox(height: 16),
          TransactionSection(),
          const SizedBox(height: 16),
          PrintSection(),
          const SizedBox(height: 16),
          ActionsSection(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _posNameController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posName);
    _posVersionController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posVersion);
    _posDeveloperController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posDeveloper);
  }

  @override
  void dispose() {
    _posNameController.dispose();
    _posVersionController.dispose();
    _posDeveloperController.dispose();
    super.dispose();
  }
}

class AutomationSection extends StatefulWidget {
  const AutomationSection({super.key});

  @override
  State<AutomationSection> createState() => _AutomationSectionState();
}

class _AutomationSectionState extends State<AutomationSection> {
  final TefController _tefController = Get.find();
  late TextEditingController _posNameController;
  late TextEditingController _posVersionController;
  late TextEditingController _posDeveloperController;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.settings, color: Colors.grey[700]),
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
              CustomTextField(
                icon: Icons.label,
                label: 'Nome da Automação',
                controller: _posNameController,
                onChanged: _onPosNameChanged,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                icon: Icons.info,
                label: 'Versão da Automação',
                controller: _posVersionController,
                onChanged: _onPosVersionChanged,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                icon: Icons.business,
                label: 'Software House',
                controller: _posDeveloperController,
                onChanged: _onPosDeveloperChanged,
              ),
            ],
          ),
        ),
      ],
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

  @override
  void initState() {
    super.initState();
    _posNameController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posName);
    _posVersionController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posVersion);
    _posDeveloperController = TextEditingController(
        text: _tefController.payGORequestHandler.dadosAutomacao.posDeveloper);
  }

  @override
  void dispose() {
    _posNameController.dispose();
    _posVersionController.dispose();
    _posDeveloperController.dispose();
    super.dispose();
  }
}

class TransactionSection extends StatefulWidget {
  const TransactionSection({super.key});

  @override
  State<TransactionSection> createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<TransactionSection> {
  final TefController _tefController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.payment, color: Colors.grey[700]),
          ),
          title: const Text(
            'Configurações de Transação',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        TransactionSwitchTile(
          icon: Icons.receipt,
          title: 'Permitir Recibos com via diferenciadas',
          subtitle: 'Habilita recibos com vias diferentes',
          value: _tefController.payGORequestHandler.dadosAutomacao.allowDifferentReceipts,
          onChanged: (value) {
            setState(() {
              _tefController.payGORequestHandler.dadosAutomacao.allowDifferentReceipts = value;
            });
          },
        ),
        const Divider(height: 1),
        TransactionSwitchTile(
          icon: Icons.discount,
          title: 'Permitir Desconto',
          subtitle: 'Habilita aplicação de descontos',
          value: _tefController.payGORequestHandler.dadosAutomacao.allowDiscount,
          onChanged: (value) {
            setState(() {
              _tefController.payGORequestHandler.dadosAutomacao.allowDiscount = value;
            });
          },
        ),
        const Divider(height: 1),
        TransactionSwitchTile(
          icon: Icons.card_giftcard,
          title: 'Permitir Voucher para Desconto',
          subtitle: 'Habilita uso de vouchers',
          value: _tefController.payGORequestHandler.dadosAutomacao.allowDueAmount,
          onChanged: (value) {
            setState(() {
              _tefController.payGORequestHandler.dadosAutomacao.allowDueAmount = value;
            });
          },
        ),
        const Divider(height: 1),
        TransactionSwitchTile(
          icon: Icons.receipt_long,
          title: 'Permitir Via Reduzida',
          subtitle: 'Habilita impressão de via reduzida',
          value: _tefController.payGORequestHandler.dadosAutomacao.allowShortReceipt,
          onChanged: (value) {
            setState(() {
              _tefController.payGORequestHandler.dadosAutomacao.allowShortReceipt = value;
            });
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: Icon(Icons.pending_actions, color: Colors.grey[600]),
          title: const Text('Transação Pendente'),
          subtitle: const Text('Ação para transações pendentes'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<PendingTransactionActions>(
              value: _tefController.configuracoes.pendingTransactionActions,
              onChanged: (newValue) {
                setState(() {
                  _tefController.configuracoes.setPendingTransactionActions(newValue!);
                });
              },
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
        TransactionSwitchTile(
          icon: Icons.check_circle,
          title: 'Confirmação Automática de Transação',
          subtitle: 'Confirma transações automaticamente',
          value: _tefController.configuracoes.isAutoConfirm,
          onChanged: (value) {
            setState(() {
              _tefController.configuracoes.setIsAutoConfirm(value);
            });
          },
        ),
      ],
    );
  }
}

class PrintSection extends StatefulWidget {
  const PrintSection({super.key});

  @override
  State<PrintSection> createState() => _PrintSectionState();
}

class _PrintSectionState extends State<PrintSection> {
  final TefController _tefController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.print, color: Colors.grey[700]),
      ),
      title: const Text(
        'Configurações de Impressão',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      children: <Widget>[
        PrintSwitchTile(
          icon: Icons.receipt,
          title: 'Imprimir via do Cliente',
          subtitle: 'Imprime recibo para o cliente',
          value: _tefController.configuracoes.isPrintcardholderReceipt,
          onChanged: (value) {
            setState(() {
              _tefController.configuracoes.setIsPrintcardholderReceipt(value);
            });
          },
        ),
        const Divider(height: 1),
        PrintSwitchTile(
          icon: Icons.store,
          title: 'Imprimir via do Estabelecimento',
          subtitle: 'Imprime recibo para o estabelecimento',
          value: _tefController.configuracoes.isPrintMerchantReceipt,
          onChanged: (value) {
            setState(() {
              _tefController.configuracoes.setIsPrintMerchantReceipt(value);
            });
          },
        ),
        const Divider(height: 1),
        PrintSwitchTile(
          icon: Icons.report,
          title: 'Imprimir Relatório',
          subtitle: 'Imprime relatórios de transação',
          value: _tefController.configuracoes.isPrintReport,
          onChanged: (value) {
            setState(() {
              _tefController.configuracoes.setIsPrintReport(value);
            });
          },
        ),
      ],
    );
  }
}

class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.build, color: Colors.grey[700]),
          ),
          title: const Text(
            'Ações do Sistema',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ActionButton(
          icon: Icons.build,
          text: 'Instalação',
          onPressed: () async {
            final TefController _tefController = Get.find();
            await _tefController.payGORequestHandler.instalacao();
          },
        ),
        ActionButton(
          icon: Icons.settings,
          text: 'Manutenção',
          onPressed: () async {
            final TefController _tefController = Get.find();
            await _tefController.payGORequestHandler.manutencao();
          },
        ),
        ActionButton(
          icon: Icons.admin_panel_settings,
          text: 'Administrativo',
          onPressed: () async {
            final TefController _tefController = Get.find();
            await _tefController.payGORequestHandler.painelAdministrativo();
            Navigator.canPop(context);
          },
        ),
        ActionButton(
          icon: Icons.visibility,
          text: 'Exibe PDC',
          onPressed: () async {
            final TefController _tefController = Get.find();
            await _tefController.payGORequestHandler.exibePDC();
            Navigator.canPop(context);
          },
        ),
        ActionButton(
          icon: Icons.description,
          text: 'Relatório Detalhado',
          onPressed: () async {
            final TefController _tefController = Get.find();
            await _tefController.payGORequestHandler.relatorioDetalhado();
            Navigator.canPop(context);
          },
        ),
        ActionButton(
          icon: Icons.summarize,
          text: 'Relatório Resumido',
          onPressed: () async {
            final TefController _tefController = Get.find();
            await _tefController.payGORequestHandler.relatorioResumido();
            Navigator.canPop(context);
          },
        ),
        ActionButton(
          icon: Icons.select_all,
          text: 'Selecionar Provedor',
          onPressed: () async {
            final TefController _tefController = Get.find();
            var providers = {"DEMO", "REDE", "PIX C6 BANK"};
            await showGenericDialog<String>(
              context: context,
              title: "Selecione o provedor",
              options: providers.toList(),
              selectedValue: _tefController.payGORequestHandler.provider,
              displayText: (e) => e,
              onSelected: (value) {
                _tefController.payGORequestHandler.setProvider(value);
              },
              onCancel: () {
                Fluttertoast.showToast(
                    msg: "Operação cancelada", toastLength: Toast.LENGTH_LONG);
              },
            );
          },
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
}

class TransactionSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const TransactionSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      secondary: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

class PrintSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const PrintSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      secondary: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey[700], size: 20),
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onPressed,
    );
  }
}
