import 'package:dio/dio.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/custom_dio.dart';
import 'package:tratar_erros_dio/src/shared/models/post_model.dart';

class HomeRepository {
  final CustomDio _client;

  HomeRepository(this._client);

  Future<List<PostModel>> getPosts() async {
    try {
      var response = await _client.get("/posts");
      return (response.data as List)
          .map((item) => PostModel.fromJson(item))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> createPost(Map<String, dynamic> data) async {
    try {
      var response = await _client.post("/posts", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> updatePost(Map<String, dynamic> data,int id) async {
    try {
      var response = await _client.patch("/posts/$id", data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}

//CREATE -> POST
//READ  -> GET
//UPDATE
//DELE
