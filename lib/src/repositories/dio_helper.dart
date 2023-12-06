import 'package:antrian_wiradadi/src/repositories/responseApi/api_exception.dart';
import 'package:dio/dio.dart';

class DioHelper {
  late Dio dio;
  String urlProd = 'https://simgos.rsuwiradadihusada.co.id';
  String urlDev = 'http://103.165.58.108';
  bool dev = true;

  DioHelper() {
    var url = dev ? urlDev : urlProd;
    BaseOptions options = BaseOptions(
      baseUrl: '$url/webservice/registrasionline/plugins/',
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(milliseconds: 6000),
      receiveTimeout: const Duration(milliseconds: 6000),
    );
    dio = Dio(options);
  }

  Future<dynamic> get(String url, String token) async {
    dynamic responseJson;
    try {
      dio.options.headers['X-token'] = token;
      final response = await dio.get(url);
      responseJson = response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioExceptionType.badResponse) {
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
        dio.options.headers['X-Token'] = token;
      }
      dio.options.headers['Content-Type'] = 'application/json';
      final response = await dio.post(url, data: request);
      responseJson = response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw BadRequestException("Server unreachable...connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw BadRequestException("Server unreachable...receive timeout");
      } else if (e.type == DioExceptionType.badResponse) {
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
