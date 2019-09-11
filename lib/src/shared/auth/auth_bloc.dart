

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:tratar_erros_dio/src/app/app_module.dart';
import 'package:tratar_erros_dio/src/shared/auth/auth_repository.dart';



class AuthBloc extends BlocBase{

  AuthBloc(){
    repo = AppModule.to.getDependency<AuthRepository>();
  }

  AuthRepository repo;
  String jwt;

  Future<String> login()async{ 

    var res = await repo.login({
      "email":"flutter@gmail.com",
      "password" : "123456789"
    });
    jwt = res['token'];
    return jwt;
  }  

}