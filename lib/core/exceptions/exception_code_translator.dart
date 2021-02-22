import 'package:notebook/core/exceptions/exception_code.dart';

abstract class ExceptionCodeTranslator {
  String call(ExceptionCodeType code);
}


class ExceptionCodeTranslatorImpl implements ExceptionCodeTranslator {
  final Map<ExceptionCodeType, String> _mapExceptionCodeToMessage = {
    ExceptionCodeType.invalidDataException: 'Book name must be between 1 and 30 characters!',
    ExceptionCodeType.itemAlreadyExists: 'The book with the entered name currently exists',

    ExceptionCodeType.unknownError: 'Validate the data or restart the application'
  };

  @override
  String call(ExceptionCodeType code) => _mapExceptionCodeToMessage[code];
}