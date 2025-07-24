import 'package:flutter/material.dart';

/// Widget personalizado para campos de texto com ícone prefixado.
/// 
/// Este componente fornece um campo de texto estilizado que se adapta
/// automaticamente ao tema atual da aplicação (claro/escuro).
/// 
/// Características:
/// - Ícone prefixado personalizável
/// - Design responsivo com bordas arredondadas
/// - Fundo adaptativo ao tema
/// - Padding interno otimizado
/// 
/// Exemplo de uso:
/// ```dart
/// CustomTextField(
///   icon: Icons.person,
///   label: 'Nome do usuário',
///   controller: _nameController,
///   onChanged: (value) => print('Nome: $value'),
/// )
/// ```
class CustomTextField extends StatelessWidget {
  /// Ícone a ser exibido como prefixo do campo
  final IconData icon;
  
  /// Texto do label do campo
  final String label;
  
  /// Controlador do campo de texto
  final TextEditingController controller;
  
  /// Callback executado quando o valor do campo muda
  final Function(String) onChanged;

  /// Construtor do CustomTextField
  /// 
  /// [icon] - Ícone a ser exibido como prefixo
  /// [label] - Texto do label do campo
  /// [controller] - Controlador do campo de texto
  /// [onChanged] - Callback executado quando o valor muda
  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
} 