import 'package:flutter/material.dart';

/// Função auxiliar para montar um diálogo genérico
/// * [context] contexto do widget
/// * [titlte] título do diálogo
/// * [options] lista de opções
/// * [selectedValue] valor selecionado
/// * [displayText] função para exibir o texto
/// * [onSelected] função para selecionar o valor
/// * [onCancel] função para cancelar a operação

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T? selectedValue,
  required String Function(T) displayText,
  required void Function(T) onSelected,
  required VoidCallback onCancel,
}) async {
  return await showDialog<T>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((option) => RadioListTile<T>(
                      title: Text(displayText(option)),
                      value: option,
                      groupValue: selectedValue,
                      onChanged: (T? value) {
                        if (value != null) {
                          onSelected(value);
                          Navigator.pop(context, value);
                        }
                      },
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              onCancel();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
