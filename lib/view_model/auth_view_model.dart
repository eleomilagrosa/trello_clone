import 'package:firebase_auth/firebase_auth.dart';
import 'package:trello_clone/constants/error_codes.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';
import 'package:trello_clone/view_model/base/base_controller.dart';
import 'package:trello_clone/model/repository/auth_repository.dart';

class AuthViewModel extends BaseController{

  late AuthRepository _authRepository;
  AuthViewModel(AppController appController) :super(appController){
    _authRepository = AuthRepository(this);
  }

  Future<User?> attemptLoginWithPassword(String username,String password)async{
    try{
      UserCredential user = await _authRepository.attemptLoginWithPassword(username, password);
      return user.user;
    }on FirebaseAuthException catch(e,trace){
      if(e.code == ErrorCodes.wrong_password){
        throw ErrorCodes.wrong_password;
      }else if(e.code == ErrorCodes.user_not_found){
        throw ErrorCodes.user_not_found;
      }
      if(auth.currentUser != null){
        auth.signOut();
      }
      rethrow;
    }catch(e,trace){
      rethrow;
    }
  }

  Future<bool> attemptCreateAccountWithPassword(String email,String password)async{
    try{
      await _authRepository.attemptCreateLoginWithEmailAndPassword(email, password);
      auth.signOut();
      return true;
    }on FirebaseAuthException catch(e,trace){
      if(e.code == ErrorCodes.email_already_in_use){
        throw ErrorCodes.email_already_in_use;
      }else if(e.code == ErrorCodes.invalid_email){
        throw ErrorCodes.invalid_email;
      }
      rethrow;
    }catch(e,trace){
      print("Exception" + e.toString() + "\n$trace");
      rethrow;
    }
  }
}