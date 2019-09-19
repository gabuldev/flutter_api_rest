import 'package:dio/dio.dart';
import 'package:tratar_erros_dio/src/shared/constants.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/interceptors.dart';

class CustomDio {
  createDio() {
    Dio dio = Dio();

    dio.options.baseUrl = BASE_URL;
    dio.interceptors.add(CustomIntercetors());
    dio.options.connectTimeout = 5000;

    return dio;
  }
}
