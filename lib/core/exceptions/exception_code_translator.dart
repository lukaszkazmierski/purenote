import 'package:notebook/core/exceptions/exception_code.dart';

abstract class ExceptionCodeTranslator {
  String call(ExceptionCode code);
}


class ExceptionCodeTranslatorImpl implements ExceptionCodeTranslator {
  final Map<ExceptionCode, String> _mapExceptionCodeToMessage = {
    ExceptionCode.invalidDataException: 'Invalid data detected'
  };

  @override
  String call(ExceptionCode code) => _mapExceptionCodeToMessage[code];
}