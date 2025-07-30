import 'package:flutter/material.dart';

/// Widget personalizado para botões de ação do sistema.
/// 
/// Este componente fornece um botão de ação estilizado que se adapta
/// automaticamente ao tema atual da aplicação e segue as diretrizes
/// do Material Design 3.
/// 
/// Características:
/// - Ícone em container estilizado
/// - Título descritivo
/// - Seta indicativa de ação
/// - Cores adaptativas ao tema
/// - Feedback visual ao toque
/// 
/// Exemplo de uso:
/// ```dart
/// ActionButton(
///   icon: Icons.settings,
///   text: 'Configurações',
///   onPressed: () => Navigator.pushNamed(context, '/settings'),
/// )
/// ```
class ActionButton extends StatelessWidget {
  /// Ícone a ser exibido no botão
  final IconData icon;
  
  /// Texto descritivo da ação
  final String text;
  
  /// Callback executado quando o botão é pressionado
  final VoidCallback onPressed;

  /// Construtor do ActionButton
  /// 
  /// [icon] - Ícone a ser exibido no botão
  /// [text] - Texto descritivo da ação
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
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurfaceVariant),
      onTap: onPressed,
    );
  }
} 