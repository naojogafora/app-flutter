import 'package:trocado_flutter/exception/app_exception.dart';

class FetchDataException implements AppException {
  final String msg;
  final int httpCode;

  const FetchDataException(this.msg, this.httpCode);

  String toString() => 'Erro ao Obter Dados: $msg';
}