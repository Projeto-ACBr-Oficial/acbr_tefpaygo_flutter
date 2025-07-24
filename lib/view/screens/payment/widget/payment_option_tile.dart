import 'package:flutter/material.dart';

/// Widget personalizado para opções de pagamento.
/// 
/// Este componente fornece uma opção de pagamento estilizada que se adapta
/// automaticamente ao tema atual da aplicação.
/// 
/// Características:
/// - Ícone colorido em container
/// - Título e subtítulo informativos
/// - Feedback visual ao toque
/// - Seta indicativa de ação
/// - Cores adaptativas ao tema
/// 
/// Exemplo de uso:
/// ```dart
/// PaymentOptionTile(
///   icon: Icons.credit_card,
///   title: "Débito",
///   subtitle: "Cartão de débito",
///   color: Colors.blue,
///   onPressed: () => print('Débito selecionado'),
/// )
/// ```
class PaymentOptionTile extends StatelessWidget {
  /// Ícone a ser exibido na opção
  final IconData icon;
  
  /// Título principal da opção
  final String title;
  
  /// Subtítulo descritivo da opção
  final String subtitle;
  
  /// Cor do ícone e container
  final Color color;
  
  /// Callback executado quando a opção é pressionada
  final VoidCallback onPressed;

  /// Construtor do PaymentOptionTile
  /// 
  /// [icon] - Ícone a ser exibido na opção
  /// [title] - Título principal da opção
  /// [subtitle] - Subtítulo descritivo da opção
  /// [color] - Cor do ícone e container
  /// [onPressed] - Callback executado quando a opção é pressionada
  const PaymentOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
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
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 