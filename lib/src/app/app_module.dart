import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:tratar_erros_dio/src/shared/auth/auth_bloc.dart';
import 'package:tratar_erros_dio/src/shared/auth/auth_repository.dart';
import 'package:tratar_erros_dio/src/shared/custom_dio/custom_dio.dart';

import 'app_bloc.dart';
import 'app_widget.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => AppBloc()),
        Bloc((i) => AuthBloc())
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => CustomDio()),
    Dependency((i) => AuthRepository())
  ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
