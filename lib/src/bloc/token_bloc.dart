import 'dart:async';

import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/responseApi/api_response.dart';
import 'package:antrian_wiradadi/src/repository/token_repo.dart';
import 'package:rxdart/rxdart.dart';

class TokenBloc {
  TokenRepo _repo = TokenRepo();
  StreamController _streamToken;

  BehaviorSubject<String> _tokenCon = BehaviorSubject<String>();
  StreamSink<String> get tokenConSink => _tokenCon.sink;
  StreamSink<ApiResponse<TokenResponseModel>> get tokenSink =>
      _streamToken.sink;
  Stream<ApiResponse<TokenResponseModel>> get tokenStream =>
      _streamToken.stream;

  getToken() {
    _streamToken = StreamController<ApiResponse<TokenResponseModel>>();
    final token = _tokenCon.value;
    fetchToken(token);
  }

  fetchToken(String token) async {
    tokenSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.token(token);
      tokenSink.add(ApiResponse.completed(res));
    } catch (e) {
      tokenSink.add(
        ApiResponse.error(e.toString()),
      );
    }
  }

  dispose() {
    _tokenCon?.close();
    _streamToken?.close();
  }
}
