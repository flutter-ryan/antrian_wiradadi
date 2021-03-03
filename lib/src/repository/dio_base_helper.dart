import 'package:antrian_wiradadi/src/repository/responseApi/api_exception.dart';
import 'package:dio/dio.dart';

class DioBaseHelper {
  Dio dio;
  DioBaseHelper() {
    BaseOptions options = new BaseOptions(
      baseUrl: 'http://103.255.241.218:88/webservice/registrasionline/plugins/',
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      },
      connectTimeout: 30000,
      receiveTimeout: 60000,
    );
    dio = new Dio(options);
  }
  Future<dynamic> get(String url, String token) async {
    var responseJson;
    try {
      dio.options.headers['x-token'] = token;
      final response = await dio.get('$url');
      responseJson = response.data;
    } on DioError catch (e) {
      print(e.type);
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.RESPONSE) {
        print(e.response.statusCode);
      }

      throw ErrorNoCodeException("Server unreachable");
    }

    return responseJson;
  }

  Future<dynamic> post(
      String url, String request, bool type, String token) async {
    var responseJson;
    try {
      dio.options.headers['x-token'] = token;
      final response = await dio.post('$url', data: request);
      responseJson = response.data;
    } on DioError catch (e) {
      print(e.type);
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
        throw BadRequestException("Server unreachable");
      } else if (e.type == DioErrorType.RESPONSE) {
        _returnResponse(e.response);
      }
      throw ErrorNoCodeException("Server unreachable");
    }
    return responseJson;
  }

  dynamic _returnResponse(Response<dynamic> response) {
    switch (response.statusCode) {
      case 400:
        throw BadRequestException('${response.statusCode}\nBad Request');
      case 401:
      case 403:
        throw UnauthorisedException(
            '${response.statusCode}\nUnauthorized user');
      case 404:
        throw InvalidInputException(
            '${response.statusCode}\nAlamat tidak ditemukan');
      case 500:
      default:
        throw FetchDataException(
          'Server tidak dapat terhubung dengan status kode: ${response.statusCode}',
        );
    }
  }
}

DioBaseHelper dio = DioBaseHelper();
