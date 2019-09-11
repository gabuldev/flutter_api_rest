import 'package:dio/dio.dart';
import 'package:tratar_erros_dio/src/shared/constants.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/interceptors.dart';


class AuthRepository {
   Dio _client;

  AuthRepository(){
    _client = Dio();
    _client.options.baseUrl = BASE_URL;
    _client.interceptors.add(CustomIntercetors());
  }

 
  Future<Map> login(Map<String, dynamic> data) async {
    try {
      var response = await _client.
      post("/sign_in", 
      data: data);
      return response.data;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

}

//CREATE -> POST
//READ  -> GET
//UPDATE
//DELE
