

import 'package:dio/dio.dart';


class CustomIntercetors extends InterceptorsWrapper{

  @override
  onRequest(RequestOptions options){
    print("REQUEST[${options.method}] => PATH: ${options.path}");

    }

  @override  
    onResponse(Response response) {
      //200
      //201
      print("RESPONSE[${response.statusCode}] => PATH: ${response.request.path}");
 
    }

   @override 
    onError(DioError e) {
      //Exception
      print("ERROR[${e.response?.statusCode}] => PATH: ${e.request.path}");
    }

}