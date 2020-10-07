import 'package:trocado_flutter/exception/app_exception.dart';

class UnauthorizedException implements AppException {
  final String msg;

  const UnauthorizedException(this.msg);

  String toString() => 'Não Autorizado: $msg';
}