import 'package:trocado_flutter/exception/app_exception.dart';

class FetchDataException implements AppException {
  final String msg;

  const FetchDataException(this.msg);

  String toString() => 'Erro ao Obter Dados: $msg';
}