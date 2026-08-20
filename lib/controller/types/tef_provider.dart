
///TefProvider é enumerado com tipos de provedores de TEF suportados pela automação
/// /// - NENHUM: roteamento automático
/// ///  - C6_PAY: Simula uma adquirente de TEF
/// ///  - REDE: Simula uma subadquirente de TEF
/// ///  - PIX_C6_BANK: Simula uma adquirente de TEF para pagamentos via PIX
enum TefProvider {
  NENHUM,
  C6_PAY,
  REDE,
  PIX_C6_BANK
}

extension TefProviderExtension on TefProvider {
  String toValue() {
    switch (this) {
      case TefProvider.NENHUM:
        return "";
      case TefProvider.C6_PAY:
        return "C6 PAY";
      case TefProvider.REDE:
        return "REDE";
      case TefProvider.PIX_C6_BANK:
        return "PIX C6 BANK";
    }
  }
}