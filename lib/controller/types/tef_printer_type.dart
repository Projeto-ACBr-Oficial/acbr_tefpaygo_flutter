enum TefPrinterType {
  NONE,
  SUNMI_LEGACY_PRINTER,
  SUNMI_PRINTER_X
}

extension TefPrinterTypeExtension on TefPrinterType {
  String toValue() {
    switch (this) {
      case TefPrinterType.NONE:
        return "SEM IMPRESSORA";
      case TefPrinterType.SUNMI_LEGACY_PRINTER:
        return "SunmiPrinter";

      case TefPrinterType.SUNMI_PRINTER_X:
        return "SunmiPrinterX";

      default:
        return "SunmiPrinter";
    }
  }
}