import 'dart:io';

import 'package:antrian_wiradadi/src/repositories/responseApi/api_exception.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class DioHelper {
  late Dio dio;
  String url = 'http://103.164.115.10:89';

  DioHelper() {
    BaseOptions options = BaseOptions(
      baseUrl: '$url/webservice/registrasionline/plugins/',
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: 60000,
      receiveTimeout: 60000,
    );
    dio = Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<dynamic> get(String url, String token) async {
    dynamic responseJson;
    try {
      dio.options.headers['x-token'] = token;
      final response = await dio.get(url);
      responseJson = response.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioErrorType.response) {
        _returnResponse(e.response);
      }
      throw ErrorNoCodeException("Server unreachable");
    }

    return responseJson;
  }

  Future<dynamic> post(
      String url, String request, bool type, String token) async {
    dynamic responseJson;
    try {
      if (type) {
        dio.options.headers['x-token'] = token;
      }
      dio.options.headers['Content-Type'] = 'application/json';
      final response = await dio.post(url, data: request);
      responseJson = response.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioErrorType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioErrorType.response) {
        _returnResponse(e.response);
      }
      throw ErrorNoCodeException("Server unreachable");
    }
    return responseJson;
  }

  dynamic _returnResponse(Response<dynamic>? response) {
    switch (response?.statusCode) {
      case 400:
        throw BadRequestException('${response?.statusCode}\nBad Request');
      case 401:
      case 403:
        throw UnauthorisedException(
            '${response?.statusCode}\nUnauthorized user');
      case 404:
        throw BadRequestException(
            '${response?.statusCode}\nAlamat tidak ditemukan');
      case 500:
      default:
        throw FetchDataException(
          'Code: ${response?.statusCode}\nSaat ini server tidak dapat terhubung.\nSilahkan coba beberapa saat lagi',
        );
    }
  }
}

DioHelper dio = DioHelper();
