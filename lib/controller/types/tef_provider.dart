
//enumerado com tipos de provedores de TEF suportados pela automação
enum TefProvider {
  DEMO,
  REDE,
  PIX_C6_BANK
}

extension TefProviderExtension on TefProvider {
  String toValue() {
    switch (this) {
      case TefProvider.DEMO:
        return "DEMO";
      case TefProvider.REDE:
        return "REDE";
      case TefProvider.PIX_C6_BANK:
        return "PIX C6 BANK";
    }
  }
}