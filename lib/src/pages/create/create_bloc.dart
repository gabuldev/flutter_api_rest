import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:tratar_erros_dio/src/pages/home/home_repository.dart';
import 'package:tratar_erros_dio/src/shared/models/post_model.dart';

enum Substate { active, awaiting, done }

class CreateBloc extends BlocBase {
  final HomeRepository repo;

  CreateBloc(this.repo);

  String title;
  String body;

  var post = PublishSubject<Substate>();

  void change() {
    post.add(Substate.active);
  }

  Observable<Substate> get responseOut => post.stream;
  Sink<Substate> get postIn => post.sink;
  void sendPost() async{
     postIn.add(Substate.awaiting); 
     var response = await repo
          .createPost(PostModel(userId: 0, title: title, body: body).toJson());
     if(response == 201)     
     postIn.add(Substate.done);
     else
     post.addError("Não foi possível concluir a solicitação");      
  
  }


  @override
  void dispose() {
    post.close();
    postIn.close();
    super.dispose();
  }
}
