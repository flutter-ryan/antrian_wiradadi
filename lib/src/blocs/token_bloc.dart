import 'dart:async';

import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/responseApi/api_response.dart';
import 'package:antrian_wiradadi/src/repositories/token_repo.dart';

class TokenBloc {
  final TokenRepo _repo = TokenRepo();
  StreamController<ApiResponse<TokenResponseModel>>? _streamToken;

  StreamSink<ApiResponse<TokenResponseModel>> get tokenSink =>
      _streamToken!.sink;
  Stream<ApiResponse<TokenResponseModel>> get tokenStream =>
      _streamToken!.stream;

  Future<void> getToken() async {
    _streamToken = StreamController();
    tokenSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.token("0");
      if (_streamToken!.isClosed) return;
      tokenSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamToken!.isClosed) return;
      tokenSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamToken?.close();
  }
}
