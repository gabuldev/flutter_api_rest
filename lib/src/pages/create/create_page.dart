import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tratar_erros_dio/src/pages/create/create_bloc.dart';
import 'package:tratar_erros_dio/src/pages/home/home_module.dart';


class CreatePage extends StatefulWidget {
  final Function onSuccess;

  const CreatePage({Key key, this.onSuccess}) : super(key: key);
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var bloc = HomeModule.to.getBloc<CreateBloc>();

  Controller controller;

  StreamSubscription listenResponse;

  @override
  void didChangeDependencies() {
    controller = Controller();
    listenResponse = bloc.post.listen((data) {
        if(data == Substate.done){
          Timer(Duration(seconds: 1), (){
            Navigator.pop(context);
          });
        }
    },  
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    listenResponse.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          
          StreamBuilder<Substate>(
              stream: bloc.responseOut,
              builder: (context, snapshot) {
                
                
                if (snapshot.hasError) return Center(child: Text("${snapshot.error}",style: TextStyle(fontSize: 25)));

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return Column(
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
                            print("pressed");
                            if (controller.validate()) {
                             bloc.sendPost();
                            }
                          },
                        ),
                      )
                    ],
                  );
                      break;
                  case ConnectionState.active : 
                  if(snapshot.data == Substate.awaiting)
                  return Container(child: Center(child: CircularProgressIndicator(),));
                  else
                  return Container(child: Center(child: Text("Realizado com sucesso"),));
                        break;
                  default: return Container();
                }
              }),
        ],
      ),
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
