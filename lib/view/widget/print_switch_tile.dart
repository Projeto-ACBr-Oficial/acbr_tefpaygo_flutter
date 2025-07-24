import 'package:flutter/material.dart';

/// Widget personalizado para switches de configuração de impressão.
/// 
/// Este componente fornece um SwitchListTile adaptativo específico para
/// configurações de impressão, seguindo as diretrizes do Material Design 3
/// e adaptando-se automaticamente ao tema atual da aplicação.
/// 
/// Características:
/// - Switch adaptativo (iOS/Android)
/// - Ícone secundário personalizável
/// - Título e subtítulo informativos
/// - Cores adaptativas ao tema
/// - Específico para configurações de impressão
/// 
/// Exemplo de uso:
/// ```dart
/// PrintSwitchTile(
///   icon: Icons.receipt,
///   title: 'Imprimir via do Cliente',
///   subtitle: 'Imprime recibo para o cliente',
///   value: _printClientReceipt,
///   onChanged: (value) => setState(() => _printClientReceipt = value),
/// )
/// ```
class PrintSwitchTile extends StatelessWidget {
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

  /// Construtor do PrintSwitchTile
  /// 
  /// [icon] - Ícone a ser exibido como elemento secundário
  /// [title] - Título principal do switch
  /// [subtitle] - Subtítulo descritivo
  /// [value] - Valor atual do switch
  /// [onChanged] - Callback executado quando o valor muda
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