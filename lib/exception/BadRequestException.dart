import 'package:trocado_flutter/exception/app_exception.dart';

class BadRequestException implements AppException {
  final String msg;

  const BadRequestException(this.msg);

  String toString() => 'Erro na solicitação: $msg';
}
