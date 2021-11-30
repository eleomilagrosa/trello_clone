import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';
import 'package:trello_clone/view_model/base/base_controller.dart';

abstract class BaseRepository{
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final AppController appController;

  BaseRepository(BaseController baseController):
        fireStore = baseController.fireStore,
        auth = baseController.auth,
        appController = baseController.appController;
}