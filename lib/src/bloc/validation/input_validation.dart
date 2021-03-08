import 'dart:async';

mixin InputValidation {
  final namaValidate = StreamTransformer<String, String>.fromHandlers(
    handleData: (nama, sink) {
      (nama.isNotEmpty) ? sink.add(nama) : sink.addError('Field is required');
    },
  );

  final tanggalLahirValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (tanggalLahir, sink) {
    (tanggalLahir.isNotEmpty)
        ? sink.add(tanggalLahir)
        : sink.addError('Field is required');
  });
  final kontakValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (kontak, sink) {
    (kontak.isNotEmpty) ? sink.add(kontak) : sink.addError('Field is required');
  });
  final caraBayarValidate = StreamTransformer<String, String>.fromHandlers(
      handleData: (caraBayar, sink) {
    (caraBayar.isNotEmpty)
        ? sink.add(caraBayar)
        : sink.addError('Field is required');
  });

  final noRmValidate =
      StreamTransformer<String, String>.fromHandlers(handleData: (norm, sink) {
    (norm.isNotEmpty) ? sink.add(norm) : sink.addError('Field is required');
  });
}
