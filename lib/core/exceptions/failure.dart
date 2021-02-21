import 'package:notebook/core/exceptions/exception_code.dart';

class Failure {
  final ExceptionCode code;

  Failure(this.code);

  @override
  String toString() => '$code';
}