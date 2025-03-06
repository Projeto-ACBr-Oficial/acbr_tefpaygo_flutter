class TefPaygoException implements Exception {
  final String message;

  TefPaygoException(this.message);

  @override
  String toString() {
    return 'TefPaygoException: $message';
  }
}
