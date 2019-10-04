import 'package:dio/dio.dart';
import 'package:tratar_erros_dio/src/app/app_module.dart';
import 'package:tratar_erros_dio/src/shared/auth/auth_bloc.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/custom_dio.dart';

class AuthIntercetors extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    AuthBloc auth = AppModule.to.getBloc<AuthBloc>();
    CustomDio dio = AppModule.to.getDependency<CustomDio>();
    await auth.getToken();
    var jwt = auth.jwt;

    if (jwt == null) {
      dio.client.lock();

      jwt = await auth.login();
      options.headers.addAll({"Authorization": jwt + "12"});

      dio.client.unlock();

      return options;
    } else {
      options.headers.addAll({"Authorization": jwt});
      return options;
    }
  }

  @override
  onResponse(Response response) {
    print("RESPONSE[${response.statusCode}] => PATH: ${response.request.path}");

  }

  @override
  onError(DioError error) {
    //Exception
    if (error.response?.statusCode == 401) {
      CustomDio dio = AppModule.to.getDependency<CustomDio>();
      AuthBloc auth = AppModule.to.getBloc<AuthBloc>();

      RequestOptions options = error.response.request;

      if (auth.jwt != options.headers["Authorization"]) {
        options.headers["Authorization"] = auth.jwt;
        return dio.client.request(options.path, options: options);
      }

      dio.client.lock();
      dio.client.interceptors.responseLock.lock();
      dio.client.interceptors.errorLock.lock();
      
      return auth.login().then((d) {
        //update csrfToken
        options.headers["Authorization"] = d;
      }).whenComplete(() {
        dio.client.unlock();
        dio.client.interceptors.responseLock.unlock();
        dio.client.interceptors.errorLock.unlock();
      }).then((e) {
        //repeat
        return dio.client.request(options.path, options: options);
      });
    }
  }
}
