import 'package:flutter/material.dart';

/// Widget personalizado para campos de texto com ícone prefixado.
/// 
/// Este componente fornece um campo de texto estilizado que se adapta
/// automaticamente ao tema atual da aplicação.
/// 
/// Características:
/// - Ícone prefixado colorido
/// - Label descritivo
/// - Controller para gerenciamento de estado
/// - Validação de entrada
/// - Cores adaptativas ao tema
/// 
/// Exemplo de uso:
/// ```dart
/// CustomTextField(
///   icon: Icons.point_of_sale,
///   label: "Nome do POS",
///   controller: _posNameController,
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return 'Por favor, insira o nome do POS';
///     }
///     return null;
///   },
/// )
/// ```
class CustomTextField extends StatelessWidget {
  /// Ícone a ser exibido no prefixo do campo
  final IconData icon;
  
  /// Label descritivo do campo
  final String label;
  
  /// Controller para gerenciar o estado do campo
  final TextEditingController controller;
  
  /// Função de validação do campo (opcional)
  final String? Function(String?)? validator;
  
  /// Callback executado quando o texto muda (opcional)
  final ValueChanged<String>? onChanged;
  
  /// Tipo de teclado a ser exibido (opcional)
  final TextInputType? keyboardType;
  
  /// Número máximo de linhas (opcional)
  final int? maxLines;

  /// Construtor do CustomTextField
  /// 
  /// [icon] - Ícone a ser exibido no prefixo do campo
  /// [label] - Label descritivo do campo
  /// [controller] - Controller para gerenciar o estado do campo
  /// [validator] - Função de validação do campo (opcional)
  /// [onChanged] - Callback executado quando o texto muda (opcional)
  /// [keyboardType] - Tipo de teclado a ser exibido (opcional)
  /// [maxLines] - Número máximo de linhas (opcional)
  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      ),
    );
  }
} 