
///TefProvider é enumerado com tipos de provedores de TEF suportados pela automação
/// /// - NENHUM: roteamento automático
/// ///  - DEMO: Simula uma adquirente de TEF
/// ///  - REDE: Simula uma subadquirente de TEF
/// ///  - PIX_C6_BANK: Simula uma adquirente de TEF para pagamentos via PIX
enum TefProvider {
  NENHUM,
  DEMO,
  REDE,
  PIX_C6_BANK
}

extension TefProviderExtension on TefProvider {
  String toValue() {
    switch (this) {
      case TefProvider.NENHUM:
        return "";
      case TefProvider.DEMO:
        return "DEMO";
      case TefProvider.REDE:
        return "REDE";
      case TefProvider.PIX_C6_BANK:
        return "PIX C6 BANK";
    }
  }
}