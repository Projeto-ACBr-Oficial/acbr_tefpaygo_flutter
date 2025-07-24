import 'package:flutter/material.dart';

/// Widget personalizado para botões de ação do sistema.
/// 
/// Este componente fornece um botão estilizado que se adapta
/// automaticamente ao tema atual da aplicação.
/// 
/// Características:
/// - Ícone e texto centralizados
/// - Feedback visual ao toque
/// - Cores adaptativas ao tema
/// - Design consistente
/// 
/// Exemplo de uso:
/// ```dart
/// ActionButton(
///   icon: Icons.settings,
///   text: "Configurar",
///   onPressed: () => print('Configurar pressionado'),
/// )
/// ```
class ActionButton extends StatelessWidget {
  /// Ícone a ser exibido no botão
  final IconData icon;
  
  /// Texto a ser exibido no botão
  final String text;
  
  /// Callback executado quando o botão é pressionado
  final VoidCallback onPressed;

  /// Construtor do ActionButton
  /// 
  /// [icon] - Ícone a ser exibido no botão
  /// [text] - Texto a ser exibido no botão
  /// [onPressed] - Callback executado quando o botão é pressionado
  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 