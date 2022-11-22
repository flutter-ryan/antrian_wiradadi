import 'dart:async';

mixin InputValidation {
  final emptyValidate =
      StreamTransformer<String, String>.fromHandlers(handleData: (empty, sink) {
    empty.isNotEmpty ? sink.add(empty) : sink.addError("Field is required");
  });
  final karakterValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (karakter, sink) {
    karakter.trim().length == 16
        ? sink.add(karakter)
        : sink.addError('Input 16 karakter');
  });
  final karakterBpjsValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (karakter, sink) {
    karakter.trim().length == 13
        ? sink.add(karakter)
        : sink.addError('Input 13 karakter');
  });

  final karakterNoRujukanValidate =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (karakter, sink) {
    karakter.trim().length == 19
        ? sink.add(karakter)
        : sink.addError('Input 19 karakter');
  });
}
