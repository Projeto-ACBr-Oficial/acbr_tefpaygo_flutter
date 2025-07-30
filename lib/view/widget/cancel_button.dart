import 'package:flutter/material.dart';

/// Widget personalizado para botão de cancelamento.
/// 
/// Este componente fornece um botão de cancelamento estilizado que se adapta
/// automaticamente ao tema atual da aplicação.
/// 
/// Características:
/// - Design destacado em vermelho
/// - Ícone e texto centralizados
/// - Feedback visual ao toque
/// - Cores adaptativas ao tema
/// 
/// Exemplo de uso:
/// ```dart
/// CancelButton(
///   onPressed: () => Navigator.pop(context),
/// )
/// ```
class CancelButton extends StatelessWidget {
  /// Callback executado quando o botão é pressionado
  final VoidCallback onPressed;

  /// Construtor do CancelButton
  /// 
  /// [onPressed] - Callback executado quando o botão é pressionado
  const CancelButton({
    super.key,
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
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 