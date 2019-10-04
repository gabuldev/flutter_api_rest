

import 'package:dio/dio.dart';
import 'package:tratar_erros_dio/src/shared/constants.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/interceptor_cache.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/interceptors.dart';

import 'interceptor_auth.dart';

class CustomDio {

  final Dio client;


  CustomDio(this.client){
    client.options.baseUrl = BASE_URL;
    client.interceptors.add(CacheIntercetors());
    client.interceptors.add(CustomIntercetors());
    client.interceptors.add(AuthIntercetors());
    client.options.connectTimeout = 5000;
  }

}