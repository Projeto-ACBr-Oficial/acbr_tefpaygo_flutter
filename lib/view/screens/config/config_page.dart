import 'package:demo_tefpaygo_simples/controller/custom_printer.dart';
import 'package:demo_tefpaygo_simples/controller/sunmi_printerx.dart';
import 'package:demo_tefpaygo_simples/controller/types/tef_printer_type.dart';
import 'package:demo_tefpaygo_simples/controller/types/tef_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:paygo_sdk/paygo_integrado_uri/domain/types/transaction_status.dart';

import '../../../controller/paygo_tefcontroller.dart';
import '../../../controller/types/generic_printer.dart';
import '../../../controller/types/pending_transaction_actions.dart';
import '../../widget/widgets.dart';
import '../../widget/dropdown_menu.dart';

/// Seção de configurações de automação.
///
/// Permite configurar informações básicas da automação:
/// - Nome da automação
/// - Versão da automação
/// - Software house
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
    final theme = Theme.of(context);

    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.settings, color: theme.colorScheme.primary),
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

/// Seção de configurações de transação.
/// 
/// Permite configurar comportamentos relacionados a transações:
/// - Recibos com via diferenciada
/// - Aplicação de descontos
/// - Uso de vouchers
/// - Via reduzida
/// - Transação pendente
/// - Confirmação automática
class TransactionSection extends StatefulWidget {
  const TransactionSection({super.key});

  @override
  State<TransactionSection> createState() => _TransactionSectionState();
}

class _TransactionSectionState extends State<TransactionSection> {
  final TefController _tefController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.payment, color: theme.colorScheme.secondary),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConfiguracoesDropdowmMenu<PendingTransactionActions>(
            label: 'Transação Pendente',
            subtitle: 'Ação para transações pendentes',
            values: PendingTransactionActions.values,
            value: _tefController.configuracoes.pendingTransactionActions,
            onChanged: (newValue) {
              setState(() {
                _tefController.configuracoes.setPendingTransactionActions(newValue!);
              });
            },
            getLabel: (value) => value.toValue().replaceAll("_", " "),
            icon: Icons.pending_actions,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConfiguracoesDropdowmMenu<TransactionStatus>(
            label: 'Tipo de confirmação',
            subtitle: 'Tipo de confirmação da transação',
            values: TransactionStatus.values,
            value: _tefController.configuracoes.tipoDeConfirmacao,
            onChanged: (newValue) {
              setState(() {
                _tefController.configuracoes.setTipoDeConfirmacao(newValue!);
              });
            },
            getLabel: (value) => value.requisicaoTransactionStatusString.replaceAll("_", " "),
            icon: Icons.check_circle_outline,
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConfiguracoesDropdowmMenu<TefProvider>(
            label: 'Adquirente',
            subtitle: 'Configura o provider ou adquirente do TEF',
            values: TefProvider.values,
            value: _tefController.configuracoes.provider,
            onChanged: (newValue) {
              setState(() {
                _tefController.configuracoes.provider = newValue!;
              });
            },
            getLabel: (value) =>
                value.toString()
                    .replaceAll("TefProvider.", "")
                    .toUpperCase(),
            icon: Icons.payment_outlined,
          ),
        ),

        //
        
      ],
    );
  }
}

/// Seção de configurações de impressão.
/// 
/// Permite configurar comportamentos de impressão:
/// - Via do cliente
/// - Via do estabelecimento
/// - Relatórios
class PrintSection extends StatefulWidget {
  const PrintSection({super.key});

  @override
  State<PrintSection> createState() => _PrintSectionState();
}

class _PrintSectionState extends State<PrintSection> {


  final TefController _tefController = Get.find();

  void afterPrinterChanged()  async {
    GenericPrinter printer;
    switch(_tefController.configuracoes.tefPrinterType) {

      case TefPrinterType.NONE:
        printer = NonePrinter();
        break;
      case TefPrinterType.SUNMI_LEGACY_PRINTER:
        printer = CustomPrinter();
        break;
      case TefPrinterType.SUNMI_PRINTER_X:
        printer = CustomSunmiPrinterX();
        break;
      default:
        printer = CustomPrinter();
        break;
    }

    _tefController.printer = printer;
    await printer.printerText('hello from ${_tefController.configuracoes.tefPrinterType.toValue()}\n');

  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.print, color: theme.colorScheme.tertiary),
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
        PrintSwitchTile(
          icon: Icons.receipt_long,
          title: 'Imprimir Via Reduzida',
          subtitle: 'Imprime recibo reduzido',
          value: _tefController.configuracoes.isPrintShortReceipt,
          onChanged: (value) {
            setState(() {
              _tefController.configuracoes.isPrintShortReceipt = value;
            });
          },
        ),
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

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ConfiguracoesDropdowmMenu<TefPrinterType>(
            label: 'Impressora TEF',
            subtitle: 'Configura o tipo de impressora TEF',
            values: TefPrinterType.values,
            value: _tefController.configuracoes.tefPrinterType,
            onChanged: (newValue) {
              setState(() {
                _tefController.configuracoes.tefPrinterType = newValue!;
                afterPrinterChanged();
              });

            },
            getLabel: (value) => value.toValue(),
            icon: Icons.print_outlined,
          ),
        ),




      ],
    );
  }
}

/// Seção de ações do sistema.
/// 
/// Fornece acesso a funcionalidades administrativas:
/// - Instalação
/// - Manutenção
/// - Painel administrativo
/// - Exibição PDC
/// - Relatórios detalhados e resumidos
/// - Seleção de provedor
class ActionsSection extends StatelessWidget {
  const ActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.build, color: theme.colorScheme.primary),
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
        )
      ],
    );
  }
}



/// Página de configurações do sistema TEF PayGo.
/// 
/// Esta página permite configurar diversos aspectos do sistema:
/// - Configurações de automação (nome, versão, software house)
/// - Configurações de transação (recibos, descontos, vouchers)
/// - Configurações de impressão (vias do cliente, estabelecimento, relatórios)
/// - Ações do sistema (instalação, manutenção, administrativo)
/// 
/// A página se adapta automaticamente ao tema atual da aplicação
/// e utiliza componentes reutilizáveis para manter consistência visual.
class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
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
          TransactionSection(),
          const SizedBox(height: 16),
          PrintSection(),
          const SizedBox(height: 16),
          AutomationSection(),
          const SizedBox(height: 16),
          ActionsSection(),
        ],
      ),
    );
  }
}

