class ApiException implements Exception {
  final String? _message;
  final String? _prefix;

  ApiException([
    this._message,
    this._prefix,
  ]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message, "Respon Server Error:\n");
}

class BadRequestException extends ApiException {
  BadRequestException([String? message]) : super(message, "Invalid Request:\n");
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([String? message]) : super(message, "Unauthorised:\n");
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message]) : super(message, "Invalid Input:\n");
}

class ErrorNoCodeException extends ApiException {
  ErrorNoCodeException([String? message])
      : super(message, "Server Unreachable:\n");
}

class DeviceNotRegistered extends ApiException {
  DeviceNotRegistered([String? message])
      : super(message, "Device is not registered. ");
}

class NoServerException extends ApiException {
  NoServerException([String? message]) : super(message, '');
}

class NoInternetException extends ApiException {
  NoInternetException([String? message]) : super(message, '');
}
