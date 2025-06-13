import 'dart:core';
class TefPaygoException implements Exception {

  final String message;
  TefPaygoException(this.message);

  @override
  toString() => 'TefPaygoException: $message';
}
