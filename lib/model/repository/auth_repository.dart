import 'package:firebase_auth/firebase_auth.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';
import 'package:trello_clone/view_model/base/base_controller.dart';
import 'package:trello_clone/model/repository/base/base_repository.dart';

class AuthRepository extends BaseRepository{
  AuthRepository(BaseController baseController): super(baseController);

  Future<UserCredential> attemptLoginWithPassword(String username, String password)async{
    return await auth.signInWithEmailAndPassword(email: username, password: password);
  }

  Future<UserCredential> attemptCreateLoginWithEmailAndPassword(String username, String password)async{
    return await auth.createUserWithEmailAndPassword(email: username, password: password);
  }

}