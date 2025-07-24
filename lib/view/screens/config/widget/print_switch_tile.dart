import 'package:flutter/material.dart';

/// Widget personalizado para switches de configuração de impressão.
/// 
/// Este componente fornece um switch estilizado que se adapta
/// automaticamente ao tema atual da aplicação.
/// 
/// Características:
/// - Ícone descritivo
/// - Título e subtítulo informativos
/// - Switch adaptativo (Material 3)
/// - Cores adaptativas ao tema
/// 
/// Exemplo de uso:
/// ```dart
/// PrintSwitchTile(
///   icon: Icons.print,
///   title: "Imprimir Comprovante",
///   subtitle: "Imprimir automaticamente após transação",
///   value: _printReceipt,
///   onChanged: (value) {
///     setState(() {
///       _printReceipt = value;
///     });
///   },
/// )
/// ```
class PrintSwitchTile extends StatelessWidget {
  /// Ícone a ser exibido no tile
  final IconData icon;
  
  /// Título principal do tile
  final String title;
  
  /// Subtítulo descritivo do tile
  final String subtitle;
  
  /// Valor atual do switch
  final bool value;
  
  /// Callback executado quando o valor do switch muda
  final ValueChanged<bool> onChanged;

  /// Construtor do PrintSwitchTile
  /// 
  /// [icon] - Ícone a ser exibido no tile
  /// [title] - Título principal do tile
  /// [subtitle] - Subtítulo descritivo do tile
  /// [value] - Valor atual do switch
  /// [onChanged] - Callback executado quando o valor do switch muda
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
      secondary: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: theme.colorScheme.primary,
    );
  }
} 