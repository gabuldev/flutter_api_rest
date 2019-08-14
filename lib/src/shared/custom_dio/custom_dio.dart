

import 'package:dio/dio.dart';
import 'package:tratar_erros_dio/src/shared/constants.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/interceptors.dart';

class CustomDio extends Dio{


  CustomDio(){
    options.baseUrl = BASE_URL;
    interceptors.add(CustomIntercetors());
    options.connectTimeout = 5000;
  }

}