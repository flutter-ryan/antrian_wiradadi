import 'dart:convert';

import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/models/token_model.dart';
import 'package:antrian_wiradadi/src/repositories/dio_helper.dart';

class TokenRepo {
  Future<TokenResponseModel> token(String token) async {
    final res = await dio.post(
      'getToken',
      jsonEncode({
        "username": tokenUser,
        "password": tokenPass,
      }),
      false,
      token,
    );

    return tokenResponseModelFromJson(res);
  }
}
