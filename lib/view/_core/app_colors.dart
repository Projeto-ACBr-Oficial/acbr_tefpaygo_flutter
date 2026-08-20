import 'package:flutter/material.dart';

/// Classe que concentra as cores utilizadas pelo App.
abstract class AppColors {
  /// Cor primária da identidade visual.
  static const Color primary = Color(0xFF161616);

  /// Cor secundária da identidade visual.
  static const Color secondary = Color(0xFF363636);

  /// Cor de destaque (amarelo) da identidade visual.
  static const Color accent = Color(0xFFFDD502);

  /// Branco da identidade visual.
  static const Color white = Colors.white;

  /// Vermelho usado em ações de cancelamento/limpeza.
  static const Color danger = Colors.red;
  static final Color dangerLight = Colors.red.shade400;

  /// Âmbar usado na tecla de apagar (backspace) do teclado numérico.
  static final Color warning = Colors.amber.shade600;

  /// Verde usado em ações de confirmação/pagamento.
  static final Color success = Colors.green.shade600;
  static final Color successDark = Colors.green.shade700;

  // Cores das categorias de forma de pagamento.
  static const Color debito = Colors.blue;
  static const Color credito = Colors.green;
  static const Color voucher = Colors.orange;
  static const Color frota = Colors.purple;
  static const Color privateLabel = Colors.teal;
  static const Color carteiraDigital = Colors.indigo;
}
