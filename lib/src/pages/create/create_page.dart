import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tratar_erros_dio/src/pages/create/create_bloc.dart';
import 'package:tratar_erros_dio/src/pages/home/home_module.dart';
import 'package:tratar_erros_dio/src/shared/models/post_model.dart';

class CreatePage extends StatefulWidget {
  final Function onSuccess;

  const CreatePage({Key key, this.onSuccess}) : super(key: key);
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var bloc = HomeModule.to.getBloc<CreateBloc>();

  Controller controller;

  @override
  void didChangeDependencies() {
    controller = Controller();
  /*  listenResponse = bloc.responseOut.listen((data) {
      if (data == 201) {
        Timer(Duration(seconds: 1), () {
          widget.onSuccess();
          Navigator.pop(context);
        });
      }
    });*/
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        centerTitle: true,
      ),
      body: StreamBuilder<int>(
          stream: bloc.responseOut,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text("${snapshot.error}",style: TextStyle(fontSize: 25)));

            if (snapshot.hasData) {
              if (snapshot.data == 0) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else{
                Timer(Duration(seconds: 1), (){
                   Navigator.pop(context);
                });
                return Center(child: Text("Inserido com sucesso!",style: TextStyle(fontSize: 25),));
              }
            
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) => bloc.title = value,
                            validator: (value) => value.isEmpty
                                ? "O título não pode ser nulo"
                                : null,
                            decoration: InputDecoration(labelText: "Title"),
                          ),
                          TextFormField(
                            onSaved: (value) => bloc.body = value,
                            validator: (value) => value.isEmpty
                                ? "O body não pode ser nulo"
                                : null,
                            maxLines: 3,
                            decoration: InputDecoration(labelText: "Body"),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        "Enviar",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (controller.validate()) {
                          bloc.postIn.add(PostModel(
                              body: bloc.body, title: bloc.title, userId: 1));
                        }
                      },
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}

class Controller {
  var formKey = GlobalKey<FormState>();

  bool validate() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }
}
