import 'dart:convert';

import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class TokenRepo {
  Future<TokenResponseModel> token(String token) async {
    final res = await dio.post(
      'getToken',
      jsonEncode({
        "username": "8888",
        "password": "6RIVNP8U5A",
      }),
      false,
      token,
    );
    print(res);
    return tokenResponseModelFromJson(res);
  }
}
