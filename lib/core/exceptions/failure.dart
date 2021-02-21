import 'package:notebook/core/exceptions/exception_code.dart';

class Failure {
  final ExceptionCodeType code;

  Failure(this.code);

  @override
  String toString() => '$code';
}