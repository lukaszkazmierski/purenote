enum ExceptionCodeType {
  invalidDataException,

  unknownError
}

abstract class ExceptionCode {
  bool valid(ExceptionCodeType code);
}

class ExceptionCodeImpl implements ExceptionCode {
  @override
  bool valid(ExceptionCodeType code) => (code != null) && (code.index >= 0);
}