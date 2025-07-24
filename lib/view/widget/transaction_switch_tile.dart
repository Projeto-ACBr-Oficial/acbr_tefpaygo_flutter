import 'package:flutter/material.dart';

/// Widget personalizado para switches de configuração de transação.
/// 
/// Este componente fornece um SwitchListTile adaptativo que se ajusta
/// automaticamente ao tema atual da aplicação e segue as diretrizes
/// do Material Design 3.
/// 
/// Características:
/// - Switch adaptativo (iOS/Android)
/// - Ícone secundário personalizável
/// - Título e subtítulo informativos
/// - Cores adaptativas ao tema
/// 
/// Exemplo de uso:
/// ```dart
/// TransactionSwitchTile(
///   icon: Icons.receipt,
///   title: 'Permitir Recibos',
///   subtitle: 'Habilita impressão de recibos',
///   value: _allowReceipts,
///   onChanged: (value) => setState(() => _allowReceipts = value),
/// )
/// ```
class TransactionSwitchTile extends StatelessWidget {
  /// Ícone a ser exibido como elemento secundário
  final IconData icon;
  
  /// Título principal do switch
  final String title;
  
  /// Subtítulo descritivo do switch
  final String subtitle;
  
  /// Valor atual do switch (true/false)
  final bool value;
  
  /// Callback executado quando o valor do switch muda
  final Function(bool) onChanged;

  /// Construtor do TransactionSwitchTile
  /// 
  /// [icon] - Ícone a ser exibido como elemento secundário
  /// [title] - Título principal do switch
  /// [subtitle] - Subtítulo descritivo
  /// [value] - Valor atual do switch
  /// [onChanged] - Callback executado quando o valor muda
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
    final theme = Theme.of(context);
    
    return SwitchListTile.adaptive(
      secondary: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
} 