import 'dart:convert';

import 'package:antrian_wiradadi/src/model/token_model.dart';
import 'package:antrian_wiradadi/src/repository/dio_base_helper.dart';

class TokenRepo {
  Future<TokenResponseModel> token(String token) async {
    final res = await dio.post(
        'getToken',
        jsonEncode({
          "username": "8888",
          "password": "6RIVNP8U5A",
        }),
        false,
        token);

    return tokenResponseModelFromJson(res);
  }
}
