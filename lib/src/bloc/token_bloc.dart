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

  getToken() {
    _streamToken = StreamController();
    fetchToken();
  }

  fetchToken() async {
    tokenSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.token("0");
      Future.delayed(const Duration(milliseconds: 500), () {
        tokenSink.add(ApiResponse.completed(res));
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 500), () {
        tokenSink.add(
          ApiResponse.error(e.toString()),
        );
      });
    }
  }

  dispose() {
    _streamToken?.close();
  }
}
