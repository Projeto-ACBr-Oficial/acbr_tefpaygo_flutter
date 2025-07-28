import 'package:flutter/material.dart';
/// Configura um menu dropdown para as configurações.
/// Este widget é genérico e pode ser usado para diferentes tipos de valores.
class ConfiguracoesDropdowmMenu<T> extends StatelessWidget {
  final String label;
  final String? subtitle;
  final List<T> values;
  final T value;
  final void Function(T?) onChanged;
  final String Function(T) getLabel;
  final IconData? icon;

  /// [_getLabel] é uma função que recebe um valor do tipo [T] e retorna uma string que será exibida no menu.
  /// [T] é o tipo genérico que representa os valores do menu dropdown.
  /// [ConfiguracoesDropdowmMenu] é um widget genérico que pode ser usado para qualquer tipo de configuração que precise de um menu dropdown.
  /// [onChanged] é uma função que será chamada quando o valor selecionado for alterado.
  /// [icon] é um ícone opcional que será exibido ao lado da label.
  /// [subtitle] é um subtítulo opcional que será exibido abaixo da label.
  ///
  const ConfiguracoesDropdowmMenu({
    super.key,
    required this.label,
    this.subtitle,
    required this.values,
    required this.value,
    required this.onChanged,
    required this.getLabel,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        DropdownButton<T>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          items: values.map((T v) {
            return DropdownMenuItem<T>(
              value: v,
              child: Text(
                getLabel(v),
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Extensão para a classe String que adiciona um método `capitalize`.
/// Exemplo de uso: "exemplo".capitalize() retorna "Exemplo".
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}